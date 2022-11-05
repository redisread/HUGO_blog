---
title: ES原理分析
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




# 简介


## 什么是ES？


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/09/93/099394aa84353c6d44bee029862d3a3f.png)

ES的全称是ElasticSearch（下面简称ES），是一个分布式、高扩展、近实时的搜索与数据分析引擎（底层基于[Apache Lucene](https://lucene.apache.org/)）。Elasticsearch 为各种数据类型提供接**近实时**的搜索和分析，不论你有结构化或非结构化的文本、数字数据，还是地理空间数据，Elasticsearch 能以支持快速搜索的方式高效地存储和索引它。你可以远超简单数据检索和聚合信息的方式去发现你数据中的趋势和模式。而且，随着你数据和查询量的增长，Elasticsearch 分布式的特性允许你的部署能随着它无缝地增长。（参考：[ES官方文档-ES介绍](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html)）




ES作为一种非关系型数据库，他和传统的关系型数据库有什么区别呢？(参考：[elasticsearch-vs-mysql](https://www.trustradius.com/compare-products/elasticsearch-vs-mysql))

- 底层的数据结构不同，ES使用**倒排索引**，而MySQL使用**B+树**。
- MySQL**支持事务**，ES**不支持事务**，可以这么认为，**MySQL更加适合OLTP，ES更适合OLAP**。
- MYSQL是单机的，ES是分布式的，支持水平拓展以及高可用的特性。
- ES拥有灵活的数据类型，创建更多的索引（默认都是索引）。

## **ES的使用场景**


ES的使用场景都有哪些呢？（参考：[use-cases-of-elasticsearch](https://appscrip.com/blog/use-cases-of-elasticsearch/)）


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/e6/72/e672c09b74a6f1ccd500a374f3ea8d2c.png)


<details>
  <summary>场景列表</summary>

1. 全文检索（模糊查询）

	常见：百科搜索（百度百科、维基百科）、论坛博客（CSDN、简书、掘金、Stack Overflow）、电商网站（京东、淘宝、拼多多）


	![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/1fa18cca-c0e7-4d00-bd0b-5a6079a00233/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221030%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221030T164017Z&X-Amz-Expires=3600&X-Amz-Signature=1892e139280d6e80fae30bbba08e3017c8595c747cdb41b6b80ad8183b400a52&X-Amz-SignedHeaders=host&x-id=GetObject)

2. 日志收集和监控

	![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/f8bf9578-c4f5-427e-9a25-f9b05d23ba4a/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221030%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221030T164017Z&X-Amz-Expires=3600&X-Amz-Signature=688522917228010034138308aefb9572afd8bd2a651e62455f010a7d199e7a43&X-Amz-SignedHeaders=host&x-id=GetObject)

3. BI系统

	![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/03c3b7e5-76f1-4066-8483-b6965bfd383f/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221030%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221030T164018Z&X-Amz-Expires=3600&X-Amz-Signature=73b19ee1798162da0435e144a4a0a1e67745f7fa490d345c36941afd3832f795&X-Amz-SignedHeaders=host&x-id=GetObject)

4. 结构化查询和数据异构


  </details>


# 基本原理


**ES是基于Lucene这个库实现的一个搜索引擎，可以理解为，Lucene主要实现一些底层结构设计和查询、写入的极致优化；而ES是对Lucene进行封装使用，实现分布式、高可用、高可拓展等特性。**


## 聊聊Lucene的底层结构设计


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/c9/f3/c9f3bc6260da39427cde95dfbd647177.png)


[Lucene](https://lucene.apache.org/) 是一个高效的，基于 Java 的全文检索库。主要包括下面的一些核心操作：


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/66/87/668716139d4ffcf4e72fe77c50c6c5b2.png)


### 倒排索引-FST和倒排表


常常说ES(Lucene)的底层结构是[倒排索引](https://zh.m.wikipedia.org/zh/%E5%80%92%E6%8E%92%E7%B4%A2%E5%BC%95)，其实ES的索引构建由**词典**和**倒排表**构成，其中**词典结构**
尤为重要。


---


📗**词典-FST**


> 参考：[Lucene底层原理](https://www.jianshu.com/p/b00079460b29) 和 [关于Lucene的词典FST深入剖析 | 申艳超-博客](https://www.shenyanchao.cn/blog/2018/12/04/lucene-fst/)


各种词典结构的优点和缺点：


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/14/db/14dbdcb181a44b4e0baa56fe25a2fa1c.png)


上面列出的一些词典的结构，最简单如排序数组，可以通过二分查找来检索数据；更快的有在内存直接使用的哈希表；磁盘查找有B树、B+树，其中[MySQL](https://www.mysql.com/)是使用B+树作为词典；而[Redis](https://redis.io/)使用跳跃表和哈希表等。


但一个能支持TB级数据的倒排索引结构需要在时间和空间上有个平衡，主要有如下的三种主要实现方式提供ES进行选择：B+树、跳跃表、FST


| 结构  | 优点                                                                               | 缺点        |
| --- | -------------------------------------------------------------------------------- | --------- |
| B+树 | 外存索引、可更新                                                                         | 空间大、速度不够快 |
| 跳表  | 结构简单、跳跃间隔、级数可控。
（Lucene3.0之前使用的也是跳跃表结构，后换成了FST，但跳跃表在Lucene其他地方还有应用如倒排表合并和文档号索引。） | 模糊查询支持不好  |
| FST | 节省内存，查询快，支持前缀和后缀查询                                                               | 更新难，构建复杂  |


lucene从4.x开始大量使用的数据结构是**FST**（_Finite State Transducer,有限状态转换器_）。FST有两个优点：

1. **空间占用小**。通过对词典中单词前缀和后缀的重复利用，压缩了存储空间。
2. **查询速度快**。O(len(str))的查询时间复杂度。（str是输入的查询字符串长度）

> FST类似一种TRIE树。但是和字典树有什么区别呢？参考：[关于Lucene的词典FST深入剖析](https://www.shenyanchao.cn/blog/2018/12/04/lucene-fst/)


假设我们有一个这样的Set: mon,tues,thurs。FST是这样的：


	![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/7a521058-a827-44d4-b6b2-60de6c13d7bc/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221030%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221030T164018Z&X-Amz-Expires=3600&X-Amz-Signature=a7de14f9d132c4485075d00f50d0997a7151595c44bfce502c206ed813ef49e3&X-Amz-SignedHeaders=host&x-id=GetObject)


	相应的TRIE则是这样的，只共享了前缀。


	![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/84212a63-12c8-424c-89dd-2e386a0d4a81/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221030%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221030T164018Z&X-Amz-Expires=3600&X-Amz-Signature=741ce428a910f569858776bc67493fe30decb1fd3e3c43176e8b9ae1b2e29918&X-Amz-SignedHeaders=host&x-id=GetObject)


---


**♾️ 倒排表**


什么是倒排索引？


首先看下什么是正排索引，例如MySQL中，**根据id可以直接查找到数据行，那么id这个查询条件使用的就是正排索引**；可以理解为，**正排索引就是从文档id到文档内容映射。**


下面是一个倒排索引的例子，ES将所有数据进行**分词**之后，存储到倒排索引中，右图不仅记录了单词所在的文档id，还记录了单词在文档出现的频率和出现在文档的单词次序。可以理解为，**倒排索引就是从字段到文档id的映射**。


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/b1/45/b1453890dd5f3be889d83cd6f967ea5f.png)


以上面图中单词“谷歌”为例子，文档频率为5表示在五个文档都出现了这个单词，对应其中的两个倒排列表为{(1;1;<1>)，(2;1;<1>)},表示在文档1和文档2出现了这个单词，单词频率都为1，都在两个文档中的出现位置都是1。


---


通过结合FST和倒排表，我们可以得到下面这张Lucene对于倒排索引实现的大概结构：


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/42/d4/42d40face869bf9a3f743ac02ec155c0.png)


> FST相当于是倒排索引的一个二级缓存索引树。


这个时候我们分析下“**为什么 Elasticsearch/Lucene 检索可以比 mysql 快**”（注意，这里说的是检索，并不是写入）


Mysql 只有 `term dictionary` 这一层，是以B+树 排序的方式存储在磁盘上的。检索一个 term 需要若干次的 `random access` 的磁盘操作。而 Lucene 在 `term dictionary` 的基础上添加了 `term index` 来加速检索，`term index` 以FST的形式缓存在内存中（并且能够压缩）。从 term index 查到对应的 `term dictionary` 的 block 位置之后，再去磁盘上找 term，大大减少了磁盘的随机访问次数。


（_实际上，ES的写入因为需要构建许多结构化的数据，如倒排表、docValue等，提供后续进行查找，并且还需要考虑分布式同步等操作，写入应该是会比MySQL慢 的，所以ES比较适合OLAP_）


### **FieldCache和DocValue-加速排序和聚合**


我们知道倒排索引能够解决从**词到文档的快速映射**，但当我们需要对检索结果进行**分类、排序、数学计算等聚合操作**时需要**文档号到值**的快速映射，而原先不管是倒排索引还是行式存储的文档都无法满足要求。


假设我要根据 content搜索，然后根据time字段排序，因为倒排索引是一个字段对应一个docId集合的，所以query阶段我只能取回docId，没有更多字段的值，**所以需要有一个地方获取time的值。倒排索引如下：**


| **term** | **docId** |
| -------- | --------- |
| 10       | 2         |
| 13       | 3         |
| 14       | 1、5、8     |
| 16       | 7，9，10    |


这样的结构是没法直接获取到time字段的，所以只有**遍历**看看我这些docId的time值都对应是多少，所以这一步是要**通过docId获取fieldvalue**的，遍历倒排索引效率会很低。因为一般来我们并不需要整个结果集，只需要按一定条件topK。


原先4.0版本之前，Lucene实现这种需求是通过FieldCache，它的原理是通过**按列逆转倒排表将（field value ->doc）映射变成（doc -> field value）映射，也就是构建文档id到字段值的正排索引**。


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/51/70/517043f41c11af77c1761fb9643cf353.png)


FieldCache简单抽象的理解就是一个大数组，数组的下标表示docId，数组中的值表示这个field的value。上面的步骤当我需要按照time排序时，假设过滤出100个docID，就可以拿他们去数组中直接取到time值然后排序，获取排序字段的时间复杂度瞬间变成O(n) (n为doc个数)，效率好多了。


但这种实现方法有着两大显著问题：

1. 构建时间长。
2. 内存占用大，易OutOfMemory，且影响垃圾回收。

因此4.0版本后Lucene推出了**DocValues**来解决这一问题，它和FieldCache一样，都为列式存储，但它有如下优点： 1. 预先构建，写入文件。 2. 基于映射文件来做，脱离JVM堆内存，系统调度缺页。


> DocValues这种实现方法只比内存FieldCache慢大概10~25%，但稳定性却得到了极大提升。


Lucene目前有五种类型的DocValues：NUMERIC、BINARY、SORTED、SORTED_SET、SORTED_NUMERIC，针对每种类型Lucene都有特定的压缩方法。


FieldCache和DocValue的区别：

- FieldCache不会在索引（写入数据）的时候创建，而是在查询运行时动态填充；并且FieldCache是存储在内存中的。
- DocValue会在索引的时候写入磁盘（在索引时与倒排索引同时生成的，并且是不可变的，与倒排表一样，保存在lucene文件中（序列化到磁盘）），在使用字段聚合或者排序的时候可以从磁盘直接加载。

（这样看来，牺牲了部分写入的时间，但是获得了查询的高效）


> ES5之后目前fileldCache默认不开启，需要设置fielddata=true才开启。因为text类型的字段不支持doc_values，对于text类型的需要扫描倒排索引，建立Filedata数据结构。


### **BKD树-对数值类型的范围查询优化**


没有BKD树的时候，Lucene是如何对数值类型进行范围查询？


| **Term** | **Postings List**       |
| -------- | ----------------------- |
| 2        | [doc3, doc5, doc10 ...] |
| 5        | [doc1, doc3, doc9 ... ] |
| ...      | ...                     |
| 90       | [doc2, doc3, doc8 ...]  |
| 99       | [doc3, doc5, doc20 ...] |
| ...      | ...                     |


假设有上面的一个数值类型的倒排表，这种结构对于**精确的数值查询**速度还是比较快的，直接从倒排索引根据查找的term拿到postings list就好了。 但类似range: [50, 100]这样的范围查找就比较麻烦了，Lucene在找到对应的term后，只能将其转换成类似50 OR 51 OR 52 ... OR 100这样的Bool查询。


可想而知，这个多条件OR查询开销很高，执行很慢。所以Lucene在创建索引的时候，会自动产生一些类似**50x75** 这样的特殊Term，指向包含在该范围的文档列表，从而可以将查询优化成类似50x75 OR 76x99 OR 100 这种形式。但是这种优化在字段的不同值很多，查询范围很大的时候，依然很无力。 因此早期版本的Lucene和ES的范围查询性能一直被诟病。


ES5之后使用Lucene6.0，Lucene6.0对数字类型的范围查询优化，使用BKD树优化数值类型的范围查询。


下面看下BKD树是如何提高数字类型的范围查询的：


**b-k-d树（多维树）**


用于多[维度](https://so.csdn.net/so/search?q=%E7%BB%B4%E5%BA%A6&spm=1001.2101.3001.7020)搜索的。例如在二维平面搜一个点，在三维空间搜一个点，在多维空间搜一个点。


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/7b/dc/7bdccfc9df8ec1a55671ed65549c6744.png)


第一级：按照X维度划分，划分点是(7,2)，左子树都要在X维度比(7,2)小，也就是x<7。也就是，左子树都在(7,2)这个点的左边。右子树都在(7,2)这个点的右边


第二级：按照Y维度划分，划分点是(5,4)，他的左子树在Y维度上都要比(5,4)小，也就是y<4


（想要查找年龄在20岁以上并且身高在170到180之间的所有人，用B-K-D树就能很好的解决)


> Lucene实现的这种BKD树在进行一些多数值类型的范围查询性能较好，对于一些大数据量的地理位置查询场景表现的极为出色。


需要注意的是，因为数值型字段在5.x里没有采用倒排表索引， 而是以value为序，将docid切分到不同的block里面。对应的，数值型字段的TermQuery被转换为了PointRangeQuery。这个Query利用Block k-d tree进行范围查找速度非常快，但是满足查询条件的docid集合在磁盘上并非向Postlings list那样按照docid顺序存放，也就无法实现postings list上借助跳表做蛙跳的操作。 要实现对docid集合的快速advance操作，只能将docid集合拿出来，做一些再处理。


**所以对于term查询，不需要进行一些数值计算或者范围计算的字段最好都定义为keyword。**


如果需要对于数值类型的大量term查询是，而原来数值类型定义为long等数值类型而不是keyword，可以使用ES multi-field新增一个子字段定义为keyword，精确查询的时候使用这个keyword字段，数值类型查询的时候使用原来的字段。这样查询可以得到优化。


## ES基本概念和设计


ES和MySQL的关键字对比：


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/1f/c4/1fc4e1ad08f47d799358daf75bde2b1b.png)


（ES7之后类型默认不允许修改，默认为doc，也就是说，index就是table的概念，集群才是数据库的类比）


ES集群基本概念：


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/7a/03/7a03650c6233d0bbc80698b5a5985a2e.png)

- 集群（cluster）：多个部署了ES的机器组成一个集群，可以多集群部署。
- 分片（shard）：一个Lucene的索引由多个分片构成。
- 段（segment）：一个段文件包含倒排索引、元数据等信息。添加新的文档时可以生成新的段，达到阈值（段的个数，段中包含的文件数等）时，不同的段可以合并。 一个索引包含多个分片，一个分片可以包含多个段）

详细可参考：[Elasticsearch 中的一些重要概念: cluster, node, index, document, shards 及 replica_Elastic 中国社区官方博客的博客-CSDN博客](https://blog.csdn.net/UbuntuTouch/article/details/99443042)


节点的角色：

- master：候选主节点：元数据管理，状态同步，索引创建等。
- data：数据节点，存放数据
- master&data：候选主节点兼数据节点，不建议这样设置。
- Coordinate：协调节点，任何节点都可以作为协调节点。

### **索引写入-近实时的由来**


在进行写操作时，ES会根据传入的`routing`参数（或mapping中设置的routing），如果参数和设置中都没有则默认使用`_id`, 按照公式 `shard_num=hash(routing)%num_primary_shards`,计算出文档要分配到的分片，在从集群元数据中找出对应主分片的位置，将请求路由到该分片进行文档写操作。


> 因为这种路由策略，索引一旦定义分片数，就不能修改了，只能通过重建索引进行修改。


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/7e/a1/7ea13e622cd6994425692186f28f0efc.png)


（**新建、索引和删除请求都是write操作，必须在主分片上完成才能复制到相关的复制分片上。副本节点一般不需要设置成太多，1个副本就差不多了，更多的副本会花费更多的同步数据时间）**


如果每次写操作都是直接落盘的话，I/O 效率会比较低。这里ES模仿其他数据库的方法，增加了缓存和日志的功能。数据先到主分片，然后进入buffer中，再写入Translog，如果 ES 出现故障，重启之后可以从 Translog 中恢复数据。


（写到缓存中的数据还不能被检索，必须等缓存刷新到段文件中才能够检索数据)


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/9b/33/9b334e23bc373598072196148b9bd8bd.png)


（因为日志文件只是单纯的做内容追加，没有其他逻辑操作，所以写入速度很快。内存缓冲区每隔一段时间写入磁盘。)


ES 每隔一秒（可以配置）执行一次 **refresh** 操作，会创建一个 Segment 文件，将 buffer 中的数据写入这个 segment，并清空 buffer。


每隔1s才进行一次的refresh操作，这也是为什么ES是一个近实时的搜索引擎的原因，将数据持久化不是马上的，对于刚写入就马上就查询的场景，ES是不适合的。


<details>
  <summary>定时清理Translog 日志</summary>


写入数据不断的增加，日志文件Translog也越来越大，需要及时进行清理。


触发清理有两个条件：


大小触发设定的阈值

- 30分钟
- 任意条件满足即触发一次 commit 提交操作。


  </details>


### **查询索引数据-两段式查询**


两个步骤，第一步，先向所有的shard（分片）发出请求，各分片只返回id和排名相关的信息（注意，不包括文档document)，然后按照各分片返回的分数进行重新排序和排名，取前size个文档。


然后进行第二步，去相关的shard取document。这种方式返回的document与用户要求的size是相等的。

- Query阶段：得到目标结果对应的doc Id和排序信息，并且做聚合
- Fetch阶段：根据doc Id列表查找对应的数据内容

![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/f6/72/f672ef3b12c55a8038869fdb93bf1a62.png)


### **定时合并段文件Flush**


由于自动刷新流程（每秒）每秒会创建一个新的段 ，这样会导致短时间内的段数量暴增。而段数目太多会带来较大的麻烦。 每一个段都会消耗文件句柄、内存和cpu运行周期。更重要的是，每个搜索请求都必须轮流检查每个段然后合并查询结果，所以段越多，搜索也就越慢。


es 有一个后台程序，用于 **merge** 合并这些 segment 文件，把小 segment 整合到一个大的 segment 中，并修改 commit point 的 segment 记录。**merge 过程还会清理被删除的数据。**


**es 接收到删数据请求时，不会真的到 segment 中把数据删了，而是把要删除的数据写到 '.del' 文件中，在读操作时，会根据这个文件进行过滤。**


merge 合并时才真正删除，合并后的 segment 中就没有已经删除的数据了。


> 合并的过程中不会中断索引和搜索。


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/4e/c1/4ec1040fdf0bee65430e50cb8c8bbaeb.png)


具体的流程：段合并在进行索引和搜索时会自动进行，合并进程选择一小部分大小相似的段，并且在后台将它们合并到更大的段中，这些段既可以是未提交的也可以是已提交的。合并结束后老的段会被删除，新的段被 flush 到磁盘，同时写入一个包含新段（已排除旧的被合并的段）的新提交点，新的段被打开可以用来搜索。


### ES是如何实现三高的


**高可用**

- **分片分主分片和副本分片**：在硬件故障时提供数据保护，同时服务于搜索和检索这种只读请求，实现负载均衡。例如如果某个非 master 节点宕机了，此节点上的「主分片」 也就没了。master 节点会让 「主分片」 对应的 「副本分片」（在其他机器上）切换为 「主分片」。（如果宕机的机器修复了，修复后的节点也不再是 主分片，而是 副本分片）
- **持久化日志TransLog**：为了避免丢失数据，事务日志记录了所有还没有持久化到磁盘的数据。可以在之后对数据操作进行重试。保证了一定数据可靠性。

**写入高性能**

- **并发同步副本分片**：对文档的新建、索引和删除请求都是写操作，必须在主分片上面完成之后才能被复制到相关的副本分片，**ES为了提高写入的能力这个过程是并发写的**。所有的副本分片都报告写成功才会向协调节点报告成功，协调节点向客户端报告成功。
- **分段存储**：在底层采用了分段的存储模式，使它在读写时几乎完全避免了锁的出现，大大提升了读写性能。

	索引文档以段的形式存储在磁盘上，索引文件被拆分为多个子文件，每个子文件叫做段，每个段本身就是一个倒排索引，并且段具有不可变性，一旦索引的数据被写入磁盘，就不可以再改变。了解决并发写的过程中数据冲突的问题，ES通过乐观锁的方式控制，每个文档都有一个 _version （版本）号，当文档被修改时版本号递增。

- **存储高性能**：在内存中用FST方式压缩term index，FST以字节的方式存储所有的term，**这种压缩方式可以有效的缩减存储空间，使得term index足以放进内存**。

**高可拓展**

- **支持横向扩展**：比如你数据量是 3T，3 个 shard，每个 shard 就 1T 的数据，若现在数据量增加到 4T，重新建一个有 4 个 shard 的索引，将数据导进去即可。
- **动态扩容**：之前的两个节点继续水平扩容，再增加一个节点，此时集群状态会如下图所示：

	![](https://s3.us-west-2.amazonaws.com/secure.notion-static.com/6287459d-93c7-4448-a50c-3d01ccede2b3/Untitled.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Content-Sha256=UNSIGNED-PAYLOAD&X-Amz-Credential=AKIAT73L2G45EIPT3X45%2F20221030%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20221030T164020Z&X-Amz-Expires=3600&X-Amz-Signature=23e760f30f127706005fcf2ab132ad3f9cfa391c11319dbfbe41c30950f97215&X-Amz-SignedHeaders=host&x-id=GetObject)


	为了分散负载，ES 会对分片进行重新分配。Node 1 和 Node 2 上各有一个分片被迁移到了新的 Node 3 节点，现在每个节点上都拥有2个分片，而不是之前的3个。


# 基本使用


## 索引创建和配置

- 创建索引：参考：[Create index API](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
- 关闭索引：参考：[Close index API | Elasticsearch Guide [8.4] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-close.html)
- 打开索引：参考：[Open index API | Elasticsearch Guide [8.4] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-open-close.html)
- 删除索引：参考：[Delete index API | Elasticsearch Guide [8.4] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-delete-index.html)

其他索引相关api可参考：[Index APIs | Elasticsearch Guide [8.4] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices.html)


## 基本查询

1. 筛选条件，基本有如下几个：
	- must：子条件必须全部满足，相当于”且”
	- must not: 子条件必须全部不满足
	- should: 子条件有一个满足即可相当于“或”
	- filter: 和must类似，但是可以使用缓存 ，不计算相关性分
2. 结果，结果的几个关键字：
	- took：查询消耗的大概时间
	- hits：命中的数据信息：
		- total：总共查询数据总数
		- hits：返回size大小的文档列表

具体可参考：[Search APIs | Elasticsearch Guide [8.4] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html)


## 基本写入


主要包括：

- 创建文档
- 更新文档
- 删除文档

具体可以参考：[Document APIs | Elasticsearch Guide [8.4] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs.html)


# 最佳实践


## 查询最佳实践


### 不打分尽量使用filter查询


查询和过滤器的区别：即**filter不需要计算相关性分数，且可以缓存**。


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/6c/98/6c98ed0a3b1523c86dd7741dc69af331.png)


> 但是需要注意的是，filter缓存还是有一定的条件的，主要满足下面两种条件：

	- 最近的256次查询中有使用到
	- 段的大小不能太小（因为段合并这种操作存在，太小的段可能很快就会被进行合并了）

### **分页查询区分场景**


分页查询主要有下面三种方式：

- From + Size 查询
- Scroll 遍历查询
- Search After 查询

**From + Size 查询**


ES 普通的分页查询有深分页限制，默认是10000条，默认分页方式from+size。


假设在一个有 4 个主分片的索引中搜索，每页返回10条记录。当我们请求第 99 页（结果从 990 到 1000），需要从每个分片中获取满足查询条件的前1000个结果，返回给协调节点， 然后协调节点对全部 4000 个结果排序，获取前10个记录。（有深度分页问题）


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/a9/54/a9543e3de4ccc94a298e2ea00e10c700.png)


> es 目前支持最大的窗口大小 **max_result_window ，默认为 10000** 。也就是当 from + size > max_result_window 时，es 将返回错误。


这种分页查询适合需要点击指定页面跳转的场景，比如针对百度、google这种全文检索的查询，通过From+ size返回Top 10000 条数据完全能满足使用需求，末尾查询评分非常低的结果一般参考意义都不大。


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/ec/73/ec73e367c139fc96ee4e930a695fd6cf.png)


**官方建议：**


避免过度使用 from 和 size 来分页或一次请求太多结果。至少也应该加上限制。


不推荐使用 from + size 做深度分页查询的核心原因：

- 搜索请求通常跨越多个分片，每个分片必须将其请求的命中内容以及任何先前页面的命中内容加载到内存中。
- 对于翻页较深的页面或大量结果，这些操作会显著增加内存和 CPU 使用率，从而导致性能下降或节点故障。

**Scroll查询**


Scroll是先做一次初始化搜索把所有符合搜索条件的结果缓存起来生成一个快照，然后持续地、批量地从快照里拉取数据直到没有数据剩下。而这时对索引数据的插入、删除、更新都不会影响遍历结果，因此scroll 并不适合用来做实时搜索。**适合需要遍历全量数据场景 。**


> 官方已经不再推荐采用Scroll API进行深度分页。如果遇到超过10000的深度分页，推荐采用search_after + PIT。


**search after 查询（推荐使用）**


> SearchAfter是一种动态指针的技术，每次查询都会携带上一次的排序值，这样下次取结果只需要从上次的位点继续扫数据，前提条件也是**该字段是数值类型且设置了 DocValue**。


可以查询到实时数据，性能优秀；不能指定页数，只能一页挨一页问下查。第一次查询时带上sort，返回最后一个文档的id。下一次查询带上search after参数。仅适合需要向后翻页的场景及超过Top 10000 数据需要分页场景。


优点：

- search_after 查询仅支持向后翻页。
- 不严格受制于 max_result_window，可以无限制往后翻页。
- 单次请求值不能超过 max_result_window；但总翻页结果集可以超过。

### **折叠查询（去重查询）**


用于折叠的字段必须是**激活doc_values**的keyword或numeric字段，具体可以参考ES官网对查询的介绍：[collapse-search-results](https://www.elastic.co/guide/en/elasticsearch/reference/current/collapse-search-results.html)


```json
POST /test/
{
    "query":{
        "match_all":{

        }
    },
    "collapse":{
        "field":"uid"
    }
}
```


> 需要注意的是：折叠只会影响搜索结果Hits的数量，但不影响聚合Total 总数，搜索结果的 Total 依旧是所有的命中纪录数，去重的结果数无法取到。具体可以参考：[Elasticsearch Collapsing 字段折叠使用详解_字段折叠后数量结果Total不准确解决方法](https://blog.csdn.net/qq_27559331/article/details/103769385)


**collapse查询可以用于分页查询吗？**


折叠查询不能与scroll查询一起使用。


字段折叠可以与 search_after 参数一起使用。**仅在对同一字段进行排序和折叠时才支持使用 search_after。也不允许二次排序**。例如，我们可以对 user.id 进行折叠和排序，同时使用 search_after 对结果进行分页：


```json
GET /my-index-000001/_search
{
  "query": {
    "match": {
      "message": "GET /search"
    }
  },
  "collapse": {
    "field": "user.id"
  },
  "sort": [ "user.id" ],
  "search_after": ["dd5ce1ad"]
}
```


### **查询语句优化**


参考：[ES查询最佳实践](https://km.sankuai.com/page/1410914956#id-1)

1. 少用from+size，使用scroll查询代替
2. 使用filter过滤器查询，结果果会被缓存在，常用的terms，range过滤器都会被缓存
3. 减少嵌套查询，nested和parent-child查询，尽量打平记录，nested查询性能会查**10**倍以上，parent-child性能会慢**100**倍以上
4. 搜索尽可能少的字段，降低IO的消耗
5. 如果不需要排序，关闭keyword的doc_value
6. 避免使用script脚本，尽量先计算好在存入es，使用脚本会影响性能

### 查询性能分析


Profile API 用于定位查询过程中的异常耗时问题的。可以通过在 query 部分上方提供 “profile: true” 来启用Profile API。（参考：[ES慢查询优化方案 profile API - 掘金](https://juejin.cn/post/6984611941469650957)）


## **写入最佳实践**


参考：[ES写入最佳实践](https://km.sankuai.com/page/235045673)

1. 读少写多请使用SSD磁盘。
2. 分片均匀分配到各个节点，保证流量均衡分布。（但是注意评估分片占用内存，分片太小没必要再增加分片）
3. 无需分词的字段使用keyword。（写入时候不需要分析和分词，加快写入）
4. 无需搜索的字段index设置为false。（将不会对这个字段构建倒排索引，请慎重评估）
5. translog改成异步方式落盘。（配置方式可以参考：[translog同步改异步配置](https://km.sankuai.com/page/235075037#id-6.translog%E5%90%8C%E6%AD%A5%E6%94%B9%E5%BC%82%E6%AD%A5)）
6. 如果不需要聚合，doc_value设置为false。（将不会存储这个字段的docValue数组）
7. 使用bulk，支持批量操作，减少IO开销。（使用可参考：[批量写操作(bulk)](https://km.sankuai.com/page/620526191#id-4.%E6%89%B9%E9%87%8F%E5%86%99%E6%93%8D%E4%BD%9C)）
8. 写入期间可以将副本设置为0，写完后增加副本。

	如果我们需要大批量进行写入操作，可以先禁止 Replica 复制，设置 index.number_of_replicas: 0 关闭副本。在写入完成后，Replica 修改回正常的状态。

9. 尽量使用es自动生成的document id。

## 集群&索引拆分


类似对于MySQL数据库的分库分表，当数据量变大的时候，将原来的单集群拆分为多个集群，通过指定的路由方式进行路由（类似RDS中的分库）；对于数据量巨大的索引，可以进行索引拆分（类似RDS分表），按月创建索引或者按照指定规则创建多个索引，使用别名进行关联，这样通过路由拆分，极大增加ES的查询和写入性能。


> 可以参考：


	[bookmark](https://elasticsearch.cn/article/14113)


## **定时清理无用数据**


定时清理无用数据，并且执行段合并。因为ES写入的时候会生成一个个小段，之后会进行合并段。当无用数据过多的时候，积累成很多无用的段文件，段文件很大的时候，或者很多的时候，影响查询的效率。并且**段合并不会对一些比较大的段进行合并**。所以对于无用的数据，可以定时进行清理，减少ES内部段文件的数量，提高查询的性能和集群健康度。

1. 使用delete_by_query删除无用的数据（注意，需要在低峰期进行）
2. 手动执行ES段合并。

## **配置和索引创建**


经验值：

- 单个分片不超过50G，单个索引分片数不超过50。
- 副本有利于增加数据的可靠性，但同时会增加存储成本。默认和建议的副本数量为1。
- 定期进行段文件合并，段文件越多，遍历次数越多

# 相关问题

- **ES模糊查询导致CPU飙升**

	[[原创] ElasticSearch集群故障案例分析: 警惕通配符查询 - Elastic 中文社区](https://elasticsearch.cn/article/171)

- **分片设置不合理导致ES写入挤压**

---


 参考：

- [去哪儿网 | Lucene 倒排索引原理 - AIQ](https://www.6aiq.com/article/1627091326793)
- [Elasticsearch倒排索引与B+Tree对比_MayMatrix的博客-CSDN博客_倒排索引和b+索引的区别](https://blog.csdn.net/truelove12358/article/details/105577414)
- [b-k-d树 原理 图文解析_stevewongbuaa的博客-CSDN博客_bkd树](https://blog.csdn.net/waltonhuang/article/details/106694326)
- [number?keyword?傻傻分不清楚 - Elastic 中文社区](https://elasticsearch.cn/article/446)
