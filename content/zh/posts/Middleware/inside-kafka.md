---
title: 深入Kafka
date: 2021-09-30T15:10:56+08:00
description: 深入理解kafka
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



# 深入理解Kafka



### kafka消息格式

kafka中的消息Message，在V1版本中是如下部分组成，主要关系key和value：

（1）key：当需要将消息写入到某个topic下的指定partition分区时，需要给定key的值。

（2）value：实际消息内容保存在这里。

（3）其他均是消息的元数据，一般不用关心，对用户来说是透明的。

![img](https://cos.jiahongw.com/uPic/1486105-20200321234137001-1472708817.png)

为了保存这些消息数据，kafka使用了ByteBuffer来存储，它是紧凑型字节数组，相比使用java对象来保存消息数据到堆内存，它更加的节省空间，提高内存使用率。	







[Kafka-Message、日志和索引文件、消费组、rebalance - 斐波那切 - 博客园](https://www.cnblogs.com/youngchaolin/p/12543436.html)







### 分区segment文件

- .index文件：索引文件，用于检索消息
- .log文件：log文件就实际是存储message的地方
- .timeindex文件：索引文件，用于检索消息



### LEO & HW

​    每个Kafka副本对象都有下面两个重要属性：

- LEO(log end offset) ，即日志末端偏移，指向了副本日志中下一条消息的位移值(即下一条消息的写入位置)
- HW(high watermark)，即已同步消息标识，因其类似于木桶效应中短板决定水位高度，故取名高水位线

Leader的HW值由ISR中的所有备份的LEO最小值决定(Follower在发送FetchRequest时会在PartitionFetchInfo中会携带Follower的LEO)

  Kafka原本使用HW来记录副本的备份进度，HW值的更新通常需要额外一轮FetchRequest才能完成，存在一些边缘案例导致备份数据丢失或导致多个备份间的数据不一致。Kafka新引入了Leader epoch解决HW截断产生的问题：[KIP-279: Fix log divergence between leader and follower after fast leader fail over - Apache Kafka - Apache Software Foundation](https://cwiki.apache.org/confluence/display/KAFKA/KIP-279%3A+Fix+log+divergence+between+leader+and+follower+after+fast+leader+fail+over)









