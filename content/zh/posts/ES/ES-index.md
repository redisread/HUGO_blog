---
title: ES笔记
date: 2021-09-09T16:37:50+08:00
description:
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image:
plantuml: true
libraries:
- katex
- mathjax
tags:
- ES
series:
-
categories:
-
---



## 索引原理

Lucene 倒排索引，具体的索引层级：

###### ![Lucene-index-level](https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/2021-09-09lucene-index-layers.png)



Lucene的索引细节：

![lucene-index-details](https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/lucene-index-details.png)



Term Index是一个字典树，保存了单词的前缀和其在Term Dictionary中位置的映射，没有保存所有的单词到字典树中是因为单词的数量太多。

Term Dictionary保存了所有的单词和倒排列表的映射，当在term index字典树中找到了前缀的在Term Dictionary中的下标后，在Term Dictionary进行顺序查找得到单词和其对应的倒排列表。

再加上一些压缩技术（搜索 Lucene Finite State Transducers） term index 的尺寸可以只有所有 term 的尺寸的几十分之一，使得用内存缓存整个 term index 变成可能。

关于 Lucene，额外值得一提的两点是：

- **Term index**：在内存中是以 FST（finite state transducers）的形式保存的，其特点是非常节省内存。
- **Term dictionary**：在磁盘上是以分 block 的方式保存的，一个 block 内部利用公共前缀压缩，比如都是 Ab 开头的单词就可以把 Ab 省去。这样 term dictionary 可以比 b-tree 更节约磁盘空间。



## 索引写入

在进行写操作时，ES会根据传入的_routing参数（或mapping中设置的_routing, 如果参数和设置中都没有则默认使用_id), 按照公式 `shard_num=hash(\routing)%num_primary_shards`,计算出文档要分配到的分片，在从集群元数据中找出对应主分片的位置，将请求路由到该分片进行文档写操作。

<img src="https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/image-20210909203953219.png" alt="索引写入过程" style="zoom:50%;" />

**新建、索引和删除请求都是write操作，必须在主分片上完成才能复制到相关的复制分片上。**

每一个 shard 就是一个 Lucene Index，包含多个 segment 文件，和一个 commit point 文件。segment 文件存储的就是一个个的 Document，commit point 记录着都有哪些 segment 文件。

<img src="https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/image-20210909204158012.png" alt="image-20210909204158012" style="zoom:50%;" />

### 增加Buffer

如果每次写操作都是直接落盘的话，I/O 效率会比较低。这里ES模仿其他数据库的方法，增加了缓存和日志的功能。

<img src="https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/image-20210909204516076.png" alt="image-20210909204516076" style="zoom:67%;" />

添加内存缓冲区Buffer，并且添加了**写操作日志**Translog，数据先到主分片，然后进入buffer中，再写入Translog，如果 ES 出现故障，重启之后可以从 Translog 中恢复数据。

> 因为日志文件只是单纯的做内容追加，没有其他逻辑操作，所以写入速度很快。内存缓冲区每隔一段时间写入磁盘。所以，极端情况下会有5秒数据的丢失，如果要严格保证数据安全，可以调整这个时间。

ES 每隔一秒执行一次 **refresh** 操作，会创建一个 Segment 文件，将 buffer 中的数据写入这个 segment，并清空 buffer。

<img src="https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/image-20210909205128152.png" alt="写入Segment" style="zoom:50%;" />

### 定时清理Translog 日志

写入数据不断的增加，日志文件Translog比顿饭也越来越大，需要及时进行清理。

触发清理有两个条件：

1. 大小触发设定的阈值
2. 30分钟

任意条件满足即触发一次 commit 提交操作。

具体的操作流程：

1. 执行 refresh 操作。
2. 把这次提交动作之前所有没有落盘的 segment 强制刷盘，确保写入物理文件。
3. 创建一个提交点，记录这次提交对应的所有 segment，写入 commit point 文件。
4. 清空 Translog，因为 Segment 都已经踏实落地了，之前的 Translog 就不需要了。

<img src="https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/image-20210909205626725.png" alt="清理日志文件流程" style="zoom:50%;" />

### 定时合并Segment 

segment 文件太多了，一秒就产生一个，这会严重影响搜索性能。

es 有一个后台程序，用于 **merge** 合并这些 segment 文件，把小 segment 整合到一个大的 segment 中，并修改 commit point 的 segment 记录。**merge 过程还会清理被删除的数据**。

**es 接收到删数据请求时，不会真的到 segment 中把数据删了，而是把要删除的数据写到 '.del' 文件中，在读操作时，会根据这个文件进行过滤。**

merge 合并时才真正删除，合并后的 segment 中就没有已经删除的数据了。

具体的流程：

<img src="https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/image-20210909205928510.png" alt="合并segment" style="zoom:50%;" />

因为上面这些操作都不是非常快的，所以ES称为近实时的查找。

## 高可用

**高可用涉及到ES的集群、节点和分片功能。**

集群：ES集群由若干节点组成，cluster-name相同。

节点：一个ES实例，本质上是一个Java进程。一般一台机器运行一个ES实例。

节点有：

- master节点：负责管理集群范畴的变更，例如创建或者删除索引，添加节点到集群或从集群删除节点。
- data节点：保存数据和倒排索引。
- client节点：扮演负载均衡的角色，将到来的请求路由到集群中的各个节点。

分片：同一个索引可以存储在不同的分片中，分片又可以存储在集群的不同节点中。

分片分主分片和从分片，分别叫primary shard和replica shard。

1、主分片与从分片关系：从分片只是主分片的一个副本，它用于提供数据的冗余副本 

2、从分片应用：在硬件故障时提供数据保护，同时服务于搜索和检索这种只读请求 

3、是否可变：索引中的主分片的数量在索引创建后就固定下来了，但是从分片的数量可以随时改变

### 副本分片replica shard

> Tips：分片数量设置为3，备份设置为2，那么该索引分片总数为3的平方(9)。

可以实现高可用，从分片给数据提供备份（replics），备份负责容错、以及请求的负载均衡。

1. **每一个分片为了实现高可用，都会有自己对应的备份，分片对应的备份不能存放同一台服务器上。分片shards可以和其他备份（replics）存放在同一个node节点上**
2. 如果某个非 master 节点宕机了。那么此节点上的 primary shard 没了。那好，master 会让 primary shard 对应的 replica shard（在其他机器上）切换为 primary shard。（如果宕机的机器修复了，修复后的节点也不再是 primary shard，而是 replica shard）
3. 





### 选择master节点

> es 集群多个节点，会自动选举一个节点为 master 节点，这个 master 节点其实就是干一些管理的工作的，比如维护索引元数据、负责切换 primary shard 和 replica shard 身份等。要是 master 节点宕机了，那么会重新选举一个节点为 master 节点。

选主流程：

1. ping所有节点，并获取PingResponse返回结果（findMaster）
2. 过滤出具有Master资格的节点（filterPingResponses）
3. 选出临时Master。根据PingResponse结果构建两个列表：activeMasters和masterCandidates。

- 如果activeMasters非空，则从activeMasters中选择最合适的作为Master；
- 如果activeMasters为空，则从masterCandidates中选举，结果可能选举成功，也可能选举失败。

![img](https://img-blog.csdnimg.cn/2020042214491429.jpg?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzMzMzMwNjg3,size_16,color_FFFFFF,t_70) 





https://www.jianshu.com/p/4e1154cbf86f



读高可用指的是多个副本情况下，某个副本出问题时不影响整个系统的读。
写高可用指的是多个副本情况下，某个副本出问题时不影响整个系统的写，通过translog来确保数据不会丢失。

集群状态的改变的高可用包含自动处理节点的加入和离开，自动同步改变的集群状态，当集群发生故障时自动切换主副shard等等来保持集群的高可用。

## 高性能







## 高可拓展

拆分多个 shard 是有好处的，一是**支持横向扩展**，比如你数据量是 3T，3 个 shard，每个 shard 就 1T 的数据，若现在数据量增加到 4T，怎么扩展，很简单，重新建一个有 4 个 shard 的索引，将数据导进去；二是**提高性能**，数据分布在多个 shard，即多台服务器上，所有的操作，都会在多台机器上并行分布式执行，提高了吞吐量和性能。

## 经验

- 分区大小不能超过50G
- 按照数据量进行规划，默认是5分去1副本
- 每个索引数据量小的话没必要设置很多的分区，一般单分区大小20G为宜。
- 十万级1分区，千万级3分区，亿万级5分区
- 副本最好设置，一般为1



### 脑裂问题

> 什么是脑裂呢？如果集群中选举出多个Master节点，使得数据更新时出现不一致，这种现象称之为脑裂。

脑裂造成原因：

- 网络问题：集群间的网络延迟导致一些节点访问不到Master，误认为Master节点挂了，从而选举出新的Master节点。
- 节点负载：主节点的角色既为Master又是Data，访问量较大会导致ES停止响应（称为假死状态）造成大面积延迟，此时其他节点访问不了Master节点，误认为Master节点已经挂了。
- 内存回收：主节点的角色既为Master又是Data，当Data节点上的ES进程占用的内存较大，会引发JVM的大规模内存回收，造成ES进程无法响应。

避免脑裂问题：

- 增大响应时间
- 角色分离。（将Master和Data节点分离）
- 设置参与选举的候选主节点的节点数，官方建议(master_eligibel_nodes/2)+1，其中 master_eligibel_nodes 为候选主节点的个数。这样做既能防止脑裂现象的发生，也能最大限度地提升集群的高可用性。



### 写入瓶颈分析

https://segmentfault.com/a/1190000023638634

---

参考：

- https://liqitian.com/articles/2020/03/18/1584525092399.html
- https://segmentfault.com/a/1190000040017672

