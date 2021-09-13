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

| 产品     | 官网                        | 特点 |
| -------- | --------------------------- | ---- |
| Kafka    | http://kafka.apache.org/    |      |
| RabbitMQ | https://www.rabbitmq.com/   |      |
| ZeroMQ   | http://zeromq.org/          |      |
| RocketMQ | http://rocketmq.apache.org/ |      |
| ActiveMQ | http://activemq.apache.org/ |      |
| Redis    |                             |      |
|          |                             |      |





- https://xie.infoq.cn/article/e9a513931ecb1905ccde9fa8d
- https://segmentfault.com/a/1190000019547121
- https://juejin.cn/post/6844904088438571021



## 架构









---

Ref：

1. [Kafka官网](https://raw.githubusercontent.com/redisread/Image/master/Blog/kafka_logo--simple.png)
2. [medium-kafka](https://betterprogramming.pub/thorough-introduction-to-apache-kafka-6fbf2989bbc1)

