---
title: Kfaka笔记
date: 2021-09-13T22:47:12+08:00
description: 记录学习Kafka的笔记以及思考总结
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://raw.githubusercontent.com/redisread/Image/master/Blog/kafka_logo--simple.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- Kafka
series:
-
categories:
-
---









# Kafka笔记

## 简介

Kafka是最初由**Linkedin**公司开发，是一个分布式、分区的、多副本的、多订阅者，基于zookeeper协调的分布式日志系统（也可以当做MQ系统），常见可以用于web/nginx日志、访问日志，消息服务等等，Linkedin于2010年贡献给了Apache基金会并成为顶级开源项目。

> 根据维基百科的定义，消息引擎系统是一组规范。企业利用这组规范在不同系统之间传递语义准确的消息，实现松耦合的异步式数据传递。

Kafka被别人成为消息队列，我第一次听说Kafka也只是知道它是一个叫做消息队列的东西。但是，其实Kafka解释为消息引擎更好，因为Kafka不是实用队列进行实现的，它像引擎一样，具备某种能量转换传输的能力，也就是从生产者到消费者的这种过程。

### 解决什么问题？

**削峰填谷**

所谓的“削峰填谷”就是指缓冲上下游瞬时突发流量，使其更平滑。特别是对于那种发送能力很强的上游系统，如果没有消息引擎的保护，“脆弱”的下游系统可能会直接被压垮导致全链路服务“雪崩”。但是，一旦有了消息引擎，它能够有效地对抗上游的流量冲击，真正做到将上游的“峰”填满到“谷”中，避免了流量的震荡。消息引擎系统的另一大好处在于发送方和接收方的松耦合，这也在一定程度上简化了应用的开发，减少了系统间不必要的交互。

**解耦**

在项目启动之初来预测将来项目会碰到什么需求，是极其困难的。消息系统在处理过程中间插入了一个隐含的、基于数据的接口层，两边的处理过程都要实现这一接口。这允许你独立的扩展或修改两边的处理过程，只要确保它们遵守同样的接口约束。



### 相同的产品对比

| 产品     | 官网                                                       | 特点                                                         | 优点                                                         | 缺点                                                         |
| -------- | ---------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Kafka    | [http://kafka.apache.org/](http://kafka.apache.org/)       | 是 Apache 的顶级项目，是一个高性能跨语言分布式 Publish/Subscribe 消息队列系统，以 Pull 的形式消费消息 | 1. 快速持久化，可以在 O(1) 的系统开销下进行消息持久化<br />2. 高吞吐，在一台普通的服务器上既可以达到 10W/s 的吞吐速率<br />3. 完全的分布式系统，Broker、Producer、Consumer 都原生自动支持分布式，自动实现复杂均衡 |                                                              |
| RabbitMQ | [https://www.rabbitmq.com/](https://www.rabbitmq.com/)     | RabbitMQ 是基于 Erlang 语言编写的开源消息队列，通过 Erlang 的 Actor 模型实现了数据的稳定可靠传输。 |                                                              |                                                              |
| ZeroMQ   | [http://zeromq.org/](http://zeromq.org/)                   | 一个开源的通用消息传递库，号称是“史上最快的消息队列”，基于 c 语言开发的，可以在任何平台通过任何代码连接。 |                                                              |                                                              |
| RocketMQ | [http://rocketmq.apache.org/](http://rocketmq.apache.org/) | RocketMQ 是阿里开源的消息中间件，目前在 Apache 孵化，使用纯 Java 开发，具有高吞吐量、高可用性、适合大规模分布式系统应用的特点。 |                                                              |                                                              |
| ActiveMQ | [http://activemq.apache.org/](http://activemq.apache.org/) | 类似于 ZeroMQ，它可以部署于代理模式和 P2P 模式。类似于 RabbitMQ，它易于实现高级场景，而且只需付出低消耗。被誉为消息中间件的“瑞士军刀”。 | 1. 支持 OpenWire、Stomp、AMQP v1.0、MQTT v3.1、REST、Ajax、Webservice 等多种协议<br />2. 完全支持 JMS1.1 和 J2EE 1.4 规范（事务、持久化、XA 消息）<br />3. 支持持久化到数据库 | 1. 不够轻巧<br />2. 对于队列较多的情况支持不好<br />3. 有丢消息的情况 |
|          |                                                            |                                                              |                                                              |                                                              |

- [https://xie.infoq.cn/article/e9a513931ecb1905ccde9fa8d](https://xie.infoq.cn/article/e9a513931ecb1905ccde9fa8d)
- [https://segmentfault.com/a/1190000019547121](https://segmentfault.com/a/1190000019547121)
- [https://juejin.cn/post/6844904088438571021](https://juejin.cn/post/6844904088438571021)



### kafka的生态

[https://cwiki.apache.org/confluence/display/KAFKA/Ecosystem](https://cwiki.apache.org/confluence/display/KAFKA/Ecosystem)



### 版本演进

早些版本的Kafka是用Scala语言写的，新版的Kafka是使用Java编写的。

Kafka目前总共演进了7个大版本，分别是0.7、0.8、0.9、0.10、0.11、1.0和2.0，其中的小版本和Patch版本很多。

0.7只提供了最基础的消息队列功能 -> 0.8之后正式引入了**副本机制** -> 0.8.2.0版本社区引入了**新版本Producer API** -> 0.9大版本增加了基础的安全认证/权限功能，同时使用Java重写了新版本消费者API，另外还引入了Kafka Connect组件用于实现高性能的数据抽取 -> 0.10.0.0是里程碑式的大版本，因为该版本**引入了Kafka Streams** -> 0.11.0.0 引入了两个重量级的功能变更：一个是提供幂等性Producer API以及事务（Transaction） API；另一个是对Kafka消息格式做了重构

## 架构

Kafka的服务端由称为Broker的服务进程构成，一个Kafka集群由多个Broker组成。

三层信息架构：

<img src="https://i.loli.net/2021/09/14/7qL51DE2uTihnem.png" alt="三层信息架构" style="zoom:50%;" />

主题层：每个主题可以配置M个分区，而每个分区又可以配置N个副本

分区层：每个分区的N个副本只能有一个充当领导者的角色，对外提供服务；其他N-1个副本是追随者副本，只是提供数据冗余之用。

消息层：分区中包含若干条消息，每条消息的位移从0开始，依次递增。

组件架构：

<img src="https://i.loli.net/2021/09/14/XVNBmwnyqtb14Pr.png" alt="Kafka架构和原理1" style="zoom:67%;" />



- **Broker**
  　　Kafka集群包含一个或多个服务器，这种服务器被称为broker

- **Topic**
  　　每条发布到Kafka集群的消息都有一个类别，这个类别被称为Topic。（物理上不同Topic的消息分开存储，逻辑上一个Topic的消息虽然保存于一个或多个broker上但用户只需指定消息的Topic即可生产或消费数据而不必关心数据存于何处）

  > Topic 在逻辑上可以被认为是一个 queue，每条消费都必须指定它的 Topic

- **Partition**
  　　Parition是物理上的概念，每个Topic包含一个或多个Partition.

- **Producer**
  　　负责发布消息到Kafka broker

- **Consumer**
  　　消息消费者，向Kafka broker读取消息的客户端。

- **Consumer Group**
  　　每个Consumer属于一个特定的Consumer Group（可为每个Consumer指定group name，若不指定group name则属于默认的group）。

拓扑结构：

![kafka architecture 架构](https://i.loli.net/2021/09/16/hs9MPTKXyBmkxan.png)

一个典型的Kafka集群中包含若干Producer（可以是web前端产生的Page View，或者是服务器日志，系统CPU、Memory等），若干broker（Kafka支持水平扩展，一般broker数量越多，集群吞吐率越高），若干Consumer Group，以及一个[Zookeeper](http://zookeeper.apache.org/)集群。Kafka通过Zookeeper管理集群配置，选举leader，以及在Consumer Group发生变化时进行rebalance。Producer使用push模式将消息发布到broker，Consumer使用pull模式从broker订阅并消费消息。

[Kafka设计解析（一）- Kafka背景及架构介绍 | 技术世界 | kafka,大数据,集群,消息系统,消息总线,kafka 架构,技术世界,郭俊 Jason,大数据架构,kafka 架构,kafka 介绍](http://www.jasongj.com/2015/03/10/KafkaColumn1/)



## 高可用





### 分区和副本机制

#### 分区

Kafka 的主题被分为多个分区 ，分区是 Kafka 最基本的存储单位。每个分区可以有多个副本 (可以在创建主题时使用 `replication-factor` 参数进行指定)。其中一个副本是首领副本 (Leader replica)，所有的事件都直接发送给首领副本；其他副本是跟随者副本 (Follower replica)，需要通过复制来保持与首领副本数据一致，当首领副本不可用时，其中一个跟随者副本将成为新首领。

> 值得注意的是，不同的分布式系统对分区的叫法也不尽相同。比如在Kafka中叫分区，在MongoDB和Elasticsearch中就叫分片Shard，而在HBase中则叫Region，在Cassandra中又被称作vnode。从表面看起来它们实现原理可能不尽相同，但对底层分区（Partitioning）的整体思想却从未改变。

主题下的每条消息只会保存到一个分区中。而每个分区又有多个副本。

分区索引策略：

1. 轮询
2. 随机
3. 哈希

#### 副本

为了保证高可用，kafka 的分区是多副本的，如果一个副本丢失了，那么还可以从其他副本中获取分区数据。分区下的副本分为领导者副本和跟随者副本，所有的事件都直接发送给首领副本，跟随者副本只能通过复制和领导者副本保持同步，并且跟随者副本不做任何的响应。当首领副本不可用时，其中一个跟随者副本将成为新首领。

大致是下面这个样子的：

<img src="https://i.loli.net/2021/09/16/KmH7k94PCtpqdai.png" alt="分区和副本" style="zoom:50%;" />

#### ISR机制

每个分区都有一个 ISR(in-sync Replica) 列表，用于维护所有同步的、可用的副本。首领副本必然是同步副本，而对于跟随者副本来说，它需要满足以下条件才能被认为是同步副本：

- 与 Zookeeper 之间有一个活跃的会话，即必须定时向 Zookeeper 发送心跳；
- 在规定的时间内从首领副本那里低延迟地获取过消息。

如果副本不满足上面条件的话，就会被从 ISR 列表中移除，直到满足条件才会被再次加入。

> **ISR 不只是追随者副本集合，它必然包括 Leader 副本。甚至在某些情况下，ISR 只有 Leader 这一个副本。**

例子：

<img src="https://i.loli.net/2021/09/16/RUbiDlkICWMt64n.png" alt="image-20210916171924386" style="zoom: 50%;" />

图中有 3 个副本：1 个领导者副本，2 个追随者副本。领导者副本写入了 10 条消息，F1 同步了 6 条，F3 同步了 3 条。那么哪个追随者副本与 Leader 不同步呢？
事实上，这两个副本都有可能与 Leader 副本不同步，但也可能同步。它实际上不是依靠与消息条数来进行判断的。**而是根据 Broker 端参数 replica.lag.time.max.ms 参数值**。这个参数的含义就是 Follower 副本能够落后 Leader 副本的最长时间间隔，当前默认值是 10 秒。
这就是说，只要一个 Follower 副本落后 Leader 副本的时间不连续超过 10 秒，那么 Kafka 就认为该 Follower 副本与 Leader 是同步的，即使此时 Follower 副本中保存的消息明显少于 Leader 副本中的消息。若是同步过程的速度持续慢于 Leadr 副本的写入速度，那么在 replica.lag.time.max.ms 时间后，kafka 就会自动收缩 ISR 集合，将改副本提出集合。



#### Unclean机制

既然 ISR 可以动态调整，那么就会出现 ISR 为空的情况。ISR 为空的情况就代表 Leader 副本也挂掉了。那么 kafka 就需要重新选举新的 Leader。

通常来说，非同步副本落后 Leader 太多，因此，如果选择这些副本为新的 Leader，就可能出现数据的丢失。在 kafka，选举 Leader 这种过程被成为 Unclean。由 Broker 端参数 unclean.leader.election.enable 控制是否允许 Unclean 领导者选举。

开启 Unclean 领导者选举可能会造成数据丢失，但好处是，它使得分区 Leader 副本一直存在，不至于停止对外提供服务，因此提升了高可用性。反之，禁止 Unclean 领导者选举的好处在于维护了数据的一致性，避免了消息丢失，但牺牲了高可用性。

> 并**不建议开启**它，毕竟我们还可以通过其他的方式来提升高可用性。如果为了这点儿高可用性的改善，牺牲了数据一致性，那就非常不值当了。



#### 发送确认

Kafka 在生产者上有一个可选的参数 ack，该参数指定了必须要有多少个分区副本收到消息，生产者才会认为消息写入成功：

- **acks=0** ：消息发送出去就认为已经成功了，不会等待任何来自服务器的响应；
- **acks=1** ： 只要集群的首领节点收到消息，生产者就会收到一个来自服务器成功响应；
- **acks=all** ：只有当所有参与复制的节点全部收到消息时，生产者才会收到一个来自服务器的成功响应。



#### 元数据请求机制

就是请求到了一个没有该领导者副本的Broker上，这个Broker对这个请求进行转发。

而Broker怎么知道转发到哪个有改领导者副本的Broker上呢？

集群中的每个 broker 都会缓存所有主题的分区副本信息，客户端会定期发送发送元数据请求，然后将获取的元数据进行缓存。定时刷新元数据的时间间隔可以通过为客户端配置 `metadata.max.age.ms` 来进行指定。有了元数据信息后，客户端就知道了领导副本所在的 broker，之后直接将读写请求发送给对应的 broker 即可。

如果在定时请求的时间间隔内发生的分区副本的选举，则意味着原来缓存的信息可能已经过时了，此时还有可能会收到 `Not a Leader for Partition` 的错误响应，这种情况下客户端会再次求发出元数据请求，然后刷新本地缓存，之后再去正确的 broker 上执行对应的操作，过程如下图：

![img](https://i.loli.net/2021/09/16/hxsBJpKeodSftWT.png)

写入过程：

![img](https://i.loli.net/2021/09/16/6blTvcfiK5naVjA.png)



优点：

1. 提供数据冗余（主要作用）
2. 提供高伸缩性（负载均衡）
3. 改善数据局部性

[一文读懂Kafka副本机制 - SegmentFault 思否](https://segmentfault.com/a/1190000022814735#:~:text=%E5%9C%A8kafka%E4%B8%AD%EF%BC%8C%E5%89%AF%E6%9C%AC%E5%88%86%E6%88%90,%E9%A2%86%E5%AF%BC%E8%80%85%E5%89%AF%E6%9C%AC%E7%9A%84%E5%90%8C%E6%AD%A5%E3%80%82)

[Kafka 系列（五）—— 深入理解 Kafka 副本机制 - 掘金](https://juejin.cn/post/6844903950009794567)

[Kafka学习之路 （三）Kafka的高可用 - 扎心了，老铁 - 博客园](https://www.cnblogs.com/qingyunzong/p/9004703.html)

### 持久化数据

使用日志，叫做消息日志（Log）来保存数据，一个日志就是磁盘上一个只能追加写消息的物理文件。



日志分段。

[Kafka 的高性能的源头 - Spongecaptain 的个人技术博客](https://spongecaptain.cool/post/kafka/why-kafka-is-high-performance/)

## 高性能



### 吞吐量



#### 使用压缩算法——CPU资源换吞吐量

**Producer端压缩、Broker端保持、Consumer端解压缩**

除了CPU资源充足这一条件，如果你的环境中带宽资源有限，那么我也建议你开启压缩。事实上我见过的很多Kafka生产环境都遭遇过带宽被打满的情况。这年头，带宽可是比CPU和内存还要珍贵的稀缺资源，毕竟万兆网络还不是普通公司的标配，因此千兆网络中Kafka集群带宽资源耗尽这件事情就特别容易出现。如果你的客户端机器CPU资源有很多富余，我强烈建议你开启zstd压缩，这样能极大地节省网络资源消耗。

避免不必要的压缩和解压缩：

1. Broker端指定了和Producer端不同的压缩算法
2. Broker端发生了消息格式转换



#### 网络模型

Kafka客户端底层使用了Java的selector，selector在Linux上的实现机制是epoll，而在Windows平台上的实现机制是select。**因此在这一点上将Kafka部署在Linux上是有优势的，因为能够获得更高效的I/O性能。**



## 高可拓展

分区机制

Kafka中的分区机制指的是将每个主题划分成多个分区（Partition），每个分区是一组有序的消息日志







为什么Kafka不像MySQL那样允许追随者副本对外提供读服务？

- 因为kafka引入的分区已经考虑了负载均衡。
- 追随者副本跟领导者副本是有延迟的，如果要这样做的话，需要等追随者副本同步，延迟更大；
- 即使满足了2的同步，让追随者副本提供读服务，有可能引入了不均衡，因为领导者副本本身就是尽量均摊到不同的broker上的









## 使用

### 重要参数配置









### 无消息丢失配置

看完这两个案例之后，我来分享一下Kafka无消息丢失的配置，每一个其实都能对应上面提到的问题。

1. 不要使用producer.send(msg)，而要使用producer.send(msg, callback)。记住，一定要使用带有回调通知的send方法。
2. 设置acks = all。acks是Producer的一个参数，代表了你对“已提交”消息的定义。如果设置成all，则表明所有副本Broker都要接收到消息，该消息才算是“已提交”。这是最高等级的“已提交”定义。
3. 设置retries为一个较大的值。这里的retries同样是Producer的参数，对应前面提到的Producer自动重试。当出现网络的瞬时抖动时，消息发送可能会失败，此时配置了retries > 0的Producer能够自动重试消息发送，避免消息丢失。
4. 设置unclean.leader.election.enable = false。这是Broker端的参数，它控制的是哪些Broker有资格竞选分区的Leader。如果一个Broker落后原先的Leader太多，那么它一旦成为新的Leader，必然会造成消息的丢失。故一般都要将该参数设置成false，即不允许这种情况的发生。
5. 设置replication.factor >= 3。这也是Broker端的参数。其实这里想表述的是，最好将消息多保存几份，毕竟目前防止消息丢失的主要机制就是冗余。
6. 设置min.insync.replicas > 1。这依然是Broker端参数，控制的是消息至少要被写入到多少个副本才算是“已提交”。设置成大于1可以提升消息持久性。在实际环境中千万不要使用默认值1。
7. 确保replication.factor > min.insync.replicas。如果两者相等，那么只要有一个副本挂机，整个分区就无法正常工作了。我们不仅要改善消息的持久性，防止数据丢失，还要在不降低可用性的基础上完成。推荐设置成replication.factor = min.insync.replicas + 1。
8. 确保消息消费完成再提交。Consumer端有个参数enable.auto.commit，最好把它设置成false，并采用手动提交位移的方式。就像前面说的，这对于单Consumer多线程处理的场景而言是至关重要的。



https://km.sankuai.com/page/468142786









## 方案设计





操作系统



最好使用Linux

磁盘容量计算

我们来计算一下：每天1亿条1KB大小的消息，保存两份且留存两周的时间，那么总的空间大小就等于1亿 * 1KB * 2 / 1000 / 1000 = 200GB。一般情况下Kafka集群除了消息数据还有其他类型的数据，比如索引数据等，故我们再为这些数据预留出10%的磁盘空间，因此总的存储容量就是220GB。既然要保存两周，那么整体容量即为220GB * 14，大约3TB左右。Kafka支持数据的压缩，假设压缩比是0.75，那么最后你需要规划的存储空间就是0.75 * 3 = 2.25TB。

总之在规划磁盘容量时你需要考虑下面这几个元素：

- 新增消息数
- 消息留存时间
- 平均消息大小
- 备份数
- 是否启用压缩



带宽计算

---

Ref：

1. [Kafka官网](https://raw.githubusercontent.com/redisread/Image/master/Blog/kafka_logo--simple.png)
2. [medium-kafka](https://betterprogramming.pub/thorough-introduction-to-apache-kafka-6fbf2989bbc1)

