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

### 相同的产品对比

| 产品     | 官网                                                       | 特点                                                         | 优点                                                         |
| -------- | ---------------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Kafka    | [http://kafka.apache.org/](http://kafka.apache.org/)       | 是 Apache 的顶级项目，是一个高性能跨语言分布式 Publish/Subscribe 消息队列系统，以 Pull 的形式消费消息 | 1. 快速持久化，可以在 O(1) 的系统开销下进行消息持久化<br />2. 高吞吐，在一台普通的服务器上既可以达到 10W/s 的吞吐速率<br />3. 完全的分布式系统，Broker、Producer、Consumer 都原生自动支持分布式，自动实现复杂均衡 |
| RabbitMQ | [https://www.rabbitmq.com/](https://www.rabbitmq.com/)     | RabbitMQ 是基于 Erlang 语言编写的开源消息队列，通过 Erlang 的 Actor 模型实现了数据的稳定可靠传输。 |                                                              |
| ZeroMQ   | [http://zeromq.org/](http://zeromq.org/)                   | 一个开源的通用消息传递库，号称是“史上最快的消息队列”，基于 c 语言开发的，可以在任何平台通过任何代码连接。 |                                                              |
| RocketMQ | [http://rocketmq.apache.org/](http://rocketmq.apache.org/) | RocketMQ 是阿里开源的消息中间件，目前在 Apache 孵化，使用纯 Java 开发，具有高吞吐量、高可用性、适合大规模分布式系统应用的特点。 |                                                              |
| ActiveMQ | [http://activemq.apache.org/](http://activemq.apache.org/) | 类似于 ZeroMQ，它可以部署于代理模式和 P2P 模式。类似于 RabbitMQ，它易于实现高级场景，而且只需付出低消耗。被誉为消息中间件的“瑞士军刀”。 |                                                              |
|          |                                                            |                                                              |                                                              |
|          |                                                            |                                                              |                                                              |

- [https://xie.infoq.cn/article/e9a513931ecb1905ccde9fa8d](https://xie.infoq.cn/article/e9a513931ecb1905ccde9fa8d)
- [https://segmentfault.com/a/1190000019547121](https://segmentfault.com/a/1190000019547121)
- [https://juejin.cn/post/6844904088438571021](https://juejin.cn/post/6844904088438571021)

## 架构

Kafka的服务端由称为Broker的服务进程构成，一个Kafka集群由多个Broker组成。

三层信息架构：

<img src="https://i.loli.net/2021/09/14/7qL51DE2uTihnem.png" alt="三层信息架构" style="zoom:50%;" />

主题层：每个主题可以配置M个分区，而每个分区又可以配置N个副本

分区层：每个分区的N个副本只能有一个充当领导者的角色，对外提供服务；其他N-1个副本是追随者副本，只是提供数据冗余之用。

消息层：分区中包含若干条消息，每条消息的位移从0开始，依次递增。



组件架构：

<img src="https://i.loli.net/2021/09/14/XVNBmwnyqtb14Pr.png" alt="Kafka架构和原理1" style="zoom:67%;" />



## 高可用

如何持久化数据？

使用日志，叫做消息日志（Log）来保存数据，一个日志就是磁盘上一个只能追加写消息的物理文件。日志分段。





## 高性能





## 高可拓展

分区机制

Kafka中的分区机制指的是将每个主题划分成多个分区（Partition），每个分区是一组有序的消息日志







为什么Kafka不像MySQL那样允许追随者副本对外提供读服务？

- 因为kafka引入的分区已经考虑了负载均衡。
- 追随者副本跟领导者副本是有延迟的，如果要这样做的话，需要等追随者副本同步，延迟更大；
- 即使满足了2的同步，让追随者副本提供读服务，有可能引入了不均衡，因为领导者副本本身就是尽量均摊到不同的broker上的

---

Ref：

1. [Kafka官网](https://raw.githubusercontent.com/redisread/Image/master/Blog/kafka_logo--simple.png)
2. [medium-kafka](https://betterprogramming.pub/thorough-introduction-to-apache-kafka-6fbf2989bbc1)
