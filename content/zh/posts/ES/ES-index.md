---
title: ES索引原理
date: 2022-03-27T16:37:50+08:00
description: ES基于Lucene 倒排索引进行构建的结构。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://cos.jiahongw.com/uPic/pluginIcon.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- ES
series:
- ES
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

- **Term index**：在内存中是以 FST（finite state transducers）的形式保存的，其特点是非常节省内存。具体参考：[地址](https://www.lizhaozhong.info/archives/2111)
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

## 高可用

**高可用涉及到ES的集群、节点和分片功能。**

集群：ES集群由若干节点组成，**cluster-name相同**。

节点：一个ES实例，本质上是一个Java进程。一般一台机器运行一个ES实例。

节点有：

- master节点：负责管理集群范畴的变更，例如创建或者删除索引，添加节点到集群或从集群删除节点。
- data节点：保存数据和倒排索引。
- client节点：扮演负载均衡的角色，将到来的请求路由到集群中的各个节点。

分片：同一个索引可以存储在不同的分片中，分片又可以存储在集群的不同节点中。这类似于MySql的分库分表，只不过Mysql分库分表需要借助第三方组件而ES内部自身实现了此功能。

分片分主分片和从分片，分别叫primary shard和replica shard。

1、主分片与从分片关系：从分片只是主分片的一个副本，它用于提供数据的冗余副本 

2、从分片应用：在硬件故障时提供数据保护，同时服务于搜索和检索这种只读请求 

3、是否可变：索引中的主分片的数量在索引创建后就固定下来了，但是从分片的数量可以随时改变

### 副本分片replica shard

> Tips：分片数量设置为3，备份设置为2，那么该索引分片总数为3的平方(9)。

副本分片可以实现高可用，从分片给数据提供备份（replics），备份负责容错、以及请求的负载均衡。

1. **每一个分片为了实现高可用，都会有自己对应的备份，分片对应的备份不能存放同一台服务器上。分片shards可以和其他备份（replics）存放在同一个node节点上**
2. 如果某个非 master 节点宕机了。那么此节点上的 primary shard 没了。那好，master 会让 primary shard 对应的 replica shard（在其他机器上）切换为 primary shard。（如果宕机的机器修复了，修复后的节点也不再是 primary shard，而是 replica shard）

![分片](https://raw.githubusercontent.com/redisread/Image/master/2021-09-10/1162587-20190715193816266-706385173.png)

为了达到高可用，Master节点会避免将主分片和副本分片放在同一个节点上。



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

- 读高可用指的是多个副本情况下，某个副本出问题时不影响整个系统的读。
- 写高可用指的是多个副本情况下，某个副本出问题时不影响整个系统的写，通过translog来确保数据不会丢失。

- 集群状态的改变的高可用包含自动处理节点的加入和离开，自动同步改变的集群状态，当集群发生故障时自动切换主副shard等等来保持集群的高可用。

### 日志

为了避免丢失数据，Elasticsearch添加了**事务日志（Translog）**，事务日志记录了所有还没有持久化到磁盘的数据。可以在之后对数据操作进行重试。保证了数据可靠性。



## 高性能

### 写入高性能

对文档的新建、索引和删除请求都是写操作，必须在主分片上面完成之后才能被复制到相关的副本分片，ES为了提高写入的能力这个过程是并发写的，同时为了解决并发写的过程中数据冲突的问题，ES通过乐观锁的方式控制，每个文档都有一个 _version （版本）号，当文档被修改时版本号递增。一旦所有的副本分片都报告写成功才会向协调节点报告成功，协调节点向客户端报告成功。



#### 分段存储

索引文档以段的形式存储在磁盘上，索引文件被拆分为多个子文件，每个子文件叫做段，每个段本身就是一个倒排索引，并且段具有不可变性，一旦索引的数据被写入磁盘，就不可以再改变。在底层采用了分段的存储模式，使它在读写时几乎完全避免了锁的出现，大大提升了读写性能。

段被写入到磁盘后会生成一个**提交点**，提交点是一个用来记录所有提交后段信息的文件。一个段一旦拥有了提交点，就说明这个段只有读的权限，失去了写的权限。相反，当段在内存中时，就只有写的权限，而不具备读数据的权限，意味着不能被检索。

![img](https://raw.githubusercontent.com/redisread/Image/master/2021-09-10/1162587-20190801143910607-283179615.png)



#### 延迟写策略

写入ES的数据请求不会马上写入到磁盘中，而是先写入一个缓存区中，每隔一段时间写入磁盘。

这里的内存使用的是ES的JVM内存，而文件缓存系统使用的是操作系统的内存。新的数据会继续的被写入内存，但内存中的数据并不是以段的形式存储的，因此不能提供检索功能。由内存刷新到文件缓存系统的时候会生成了新的段，并将段打开以供搜索使用，而不需要等到被刷新到磁盘。



#### 段合并

由于自动刷新流程每秒会创建一个新的段 ，这样会导致短时间内的段数量暴增。而段数目太多会带来较大的麻烦。 每一个段都会消耗文件句柄、内存和cpu运行周期。更重要的是，每个搜索请求都必须轮流检查每个段然后合并查询结果，所以段越多，搜索也就越慢。

Elasticsearch通过在后台定期进行段合并来解决这个问题。小的段被合并到大的段，然后这些大的段再被合并到更大的段。段合并的时候会将那些旧的已删除文档从文件系统中清除。被删除的文档不会被拷贝到新的大段中。合并的过程中不会中断索引和搜索。

![img](https://raw.githubusercontent.com/redisread/Image/master/2021-09-10/1162587-20190717150729375-943330455.png)

段合并在进行索引和搜索时会自动进行，合并进程选择一小部分大小相似的段，并且在后台将它们合并到更大的段中，这些段既可以是未提交的也可以是已提交的。合并结束后老的段会被删除，新的段被 flush 到磁盘，同时写入一个包含新段（已排除旧的被合并的段）的新提交点，新的段被打开可以用来搜索。

### 存储高性能

在内存中用FST方式压缩term index，FST以字节的方式存储所有的term，这种压缩方式可以有效的缩减存储空间，使得term index足以放进内存，但这种方式也会导致查找时需要更多的CPU资源。演示地址：[Build your own FST](http://examples.mikemccandless.com/fst.py?terms=&cmd=Build+it!)



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
- https://www.cnblogs.com/jajian/p/11223992.html

