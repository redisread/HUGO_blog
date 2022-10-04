---
title: ES索引原理
date: '2022-10-01T14:30:00.000Z'
description: ES是基于Lucene的存储应用，核心是倒排索引。
draft: false
hideToc: false
enableToc: true
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://cos.jiahongw.com/uPic/pluginIcon.png
plantuml: true
libraries:
- katex
- mathjax
- chart
- flowchartjs
- mermaid
tags:
- ES
- ES索引
- Lucene
series: ''
categories:
- ES

---



# 从“文档-单词矩阵”说起

ES中的一篇文档相当于MySQL数据库中的一行记录，对应的ES属于NoSQL，每篇文档都是JSON格式的，实际存储的时候，会对JSON里面的内容进行分词，切分成一个个的词项，然后构建倒排索引，用于存储词项到文档ID的映射。

如下面这张图：

![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/49/2f/492f68a81bd74361c17c347bad136f02.png)

> 搜索引擎的索引其实就是实现单词—文档矩阵的具体数据结构。可以有不同的方式来实现上 述概念模型，比如倒排索引、签名文件、后缀树等方式。但是各项实验数据表明，倒排索引 是单词到文档映射关系的最佳实现方式。





# 倒排索引

Lucene 倒排索引，具体的索引层级：



![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/d1/00/d100f9c767c8ece5c6e3663780b1ea01.png)





Lucene的索引细节：

![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/4c/ac/4cac3269816fc53debaaa29da36b7996.png)



Term Index是一个字典树，保存了单词的前缀和其在Term Dictionary中位置的映射，没有保存所有的单词到字典树中是因为单词的数量太多。



Term Dictionary保存了所有的单词和倒排列表的映射，当在term index字典树中找到了前缀的在Term Dictionary中的下标后，在Term Dictionary进行顺序查找得到单词和其对应的倒排列表。



再加上一些压缩技术（搜索 Lucene Finite State Transducers） term index 的尺寸可以只有所有 term 的尺寸的几十分之一，使得用内存缓存整个 term index 变成可能。

关于 Lucene，额外值得一提的两点是：

- **Term index**：在内存中是以 FST（finite state transducers）的形式保存的，其特点是非常节省内存。具体参考：[地址](https://www.lizhaozhong.info/archives/2111)

- **Term dictionary**：在磁盘上是以分 block 的方式保存的，一个 block 内部利用公共前缀压缩，比如都是 Ab 开头的单词就可以把 Ab 省去。这样 term dictionary 可以比 b-tree 更节约磁盘空间。



## 索引数据读取







## 索引数据写入

![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/44/3e/443edb2e10c0c87fcb51ff3923bc0e69.png)

图的示意图要从上往下看。
1、当新的文档写入后，写入 index buffer的同时会写入translog。
2、refresh操作使得写入文档搜索可见；
3、flush操作使得filesystem cache写入磁盘，以达到持久化的目的。

在进行写操作时，ES会根据传入的*routing参数（或mapping中设置的*routing, 如果参数和设置中都没有则默认使用_id), 按照公式 `shard_num=hash(\routing)%num_primary_shards`,计算出文档要分配到的分片，在从集群元数据中找出对应主分片的位置，将请求路由到该分片进行文档写操作。





![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/00/b0/00b0616dba88bec8a237bcd9057d75af.png)



**新建、索引和删除请求都是write操作，必须在主分片上完成才能复制到相关的复制分片上。**

每一个 shard 就是一个 Lucene Index，包含多个 segment 文件，和一个 commit point 文件。segment 文件存储的就是一个个的 Document，commit point 记录着都有哪些 segment 文件。



![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/24/f1/24f1708d0e9e9f84dc55f8546edddc75.png)





**增加Buffer**

如果每次写操作都是直接落盘的话，I/O 效率会比较低。这里ES模仿其他数据库的方法，增加了缓存和日志的功能。

![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/78/82/7882cccc74558f1d3fb7f0ade992a470.png)

添加内存缓冲区Buffer，并且添加了**写操作日志**Translog，数据先到主分片，然后进入buffer中，再写入Translog，如果 ES 出现故障，重启之后可以从 Translog 中恢复数据。

> 因为日志文件只是单纯的做内容追加，没有其他逻辑操作，所以写入速度很快。内存缓冲区每隔一段时间写入磁盘。所以，极端情况下会有5秒数据的丢失，如果要严格保证数据安全，可以调整这个时间。

ES 每隔一秒执行一次 **refresh** 操作，会创建一个 Segment 文件，将 buffer 中的数据写入这个 segment，并清空 buffer。



![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/72/c1/72c10ea139a5a8e822b449adee8864ee.png)



**定时清理Translog 日志**

写入数据不断的增加，日志文件Translog比顿饭也越来越大，需要及时进行清理。

触发清理有两个条件：

1. 大小触发设定的阈值

1. 30分钟

任意条件满足即触发一次 commit 提交操作。

具体的操作流程：

1. 执行 refresh 操作。

1. 把这次提交动作之前所有没有落盘的 segment 强制刷盘，确保写入物理文件。

1. 创建一个提交点，记录这次提交对应的所有 segment，写入 commit point 文件。

1. 清空 Translog，因为 Segment 都已经踏实落地了，之前的 Translog 就不需要了。

![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/88/ee/88eefd6ea4673d0bb33e7904ab8fc745.png)



**定时合并Segment**

segment 文件太多了，一秒就产生一个，这会严重影响搜索性能。

es 有一个后台程序，用于 **merge** 合并这些 segment 文件，把小 segment 整合到一个大的 segment 中，并修改 commit point 的 segment 记录。**merge 过程还会清理被删除的数据**。

**es 接收到删数据请求时，不会真的到 segment 中把数据删了，而是把要删除的数据写到 '.del' 文件中，在读操作时，会根据这个文件进行过滤。**

merge 合并时才真正删除，合并后的 segment 中就没有已经删除的数据了。

具体的流程：

![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/96/14/9614578adae4dc4111acb9ce27e6e948.png)

因为上面这些操作都不是非常快的，所以ES称为近实时的查找。

索引文件分段存储并且不可修改，那么新增、更新和删除如何处理呢？

- 新增，新增很好处理，由于数据是新的，所以只需要对当前文档新增一个段就可以了。

- 删除，由于不可修改，所以对于删除操作，不会把文档从旧的段中移除而是通过新增一个`.del`文件，文件中会列出这些被删除文档的段信息。这个被标记删除的文档仍然可以被查询匹配到， 但它会在最终结果被返回前从结果集中移除。

- 更新，不能修改旧的段来进行反映文档的更新，其实更新相当于是删除和新增这两个动作组成。会将旧的文档在`.del`文件中标记删除，然后文档的新版本被索引到一个新的段中。可能两个版本的文档都会被一个查询匹配到，但被删除的那个旧版本文档在结果集返回前就会被移除。

段被设定为不可修改具有一定的优势也有一定的缺点，优势主要表现在：

- 不需要锁。如果你从来不更新索引，你就不需要担心多进程同时修改数据的问题。

- 一旦索引被读入内核的文件系统缓存，便会留在哪里，由于其不变性。只要文件系统缓存中还有足够的空间，那么大部分读请求会直接请求内存，而不会命中磁盘。这提供了很大的性能提升。

- 其它缓存(像filter缓存)，在索引的生命周期内始终有效。它们不需要在每次数据改变时被重建，因为数据不会变化。

- 写入单个大的倒排索引允许数据被压缩，减少磁盘 I/O 和 需要被缓存到内存的索引的使用量。

段的不变性的缺点如下：

- 当对旧数据进行删除时，旧数据不会马上被删除，而是在`.del`文件中被标记为删除。而旧数据只能等到段更新时才能被移除，这样会造成大量的空间浪费。

- 若有一条数据频繁的更新，每次更新都是新增新的标记旧的，则会有大量的空间浪费。

- 每次新增数据时都需要新增一个段来存储数据。当段的数量太多时，对服务器的资源例如文件句柄的消耗会非常大。

- 在查询的结果中包含所有的结果集，需要排除被标记删除的旧数据，这增加了查询的负担。





# 高可用

**高可用涉及到ES的集群、节点和分片功能。**

集群：ES集群由若干节点组成，**cluster-name相同**。

节点：一个ES实例，本质上是一个Java进程。一般一台机器运行一个ES实例。

节点有：

- master节点：负责管理集群范畴的变更，例如创建或者删除索引，添加节点到集群或从集群删除节点。

- data节点：保存数据和倒排索引。

- client节点：扮演负载均衡的角色，将到来的请求路由到集群中的各个节点。

分片：同一个索引可以存储在不同的分片中，分片又可以存储在集群的不同节点中。这类似于MySql的分库分表，只不过Mysql分库分表需要借助第三方组件而ES内部自身实现了此功能。

分片分主分片和从分片，分别叫primary shard和replica shard。

1. 主分片与从分片关系：从分片只是主分片的一个副本，它用于提供数据的冗余副本

