---
title: "分布式搜索和分析的利器：ElasticSearch简介"
date: 2023-02-24T23:26:32+08:00
description: ES是一个功能强大、高效稳定的搜索和分析引擎，具有广泛的应用场景和业界的认可度。无论是企业内部的数据分析，还是面向公众的搜索服务，ES都能够提供高性能和可靠性的支持.
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
image: https://cos.jiahongw.com/uPic/image-20230225105212461.png
tocLevels: ["h2", "h3", "h4"]
libraries:
tags:
- elasticsearch
series:
- ES原理和实践
categories:
- elasticsearch
---



## 什么是Elasticsearch？

ES的全称是ElasticSearch（下面简称ES），是一个**分布式、高扩展、近实时**的搜索与数据分析引擎（底层基于[Apache Lucene](https://lucene.apache.org/)）。Elasticsearch 为各种数据类型提供接**近实时**的搜索和分析，不论你有结构化或非结构化的文本、数字数据，还是地理空间数据，Elasticsearch 都可以支持快速搜索的方式高效地存储和索引它。你可以远超简单数据检索和聚合信息的方式去发现你数据中的趋势和模式。而且，随着你数据和查询量的增长，Elasticsearch 分布式的特性允许你的部署能随着它无缝地增长。（参考：[ES官方文档-ES介绍](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html)）



ES作为一种非关系型数据库，他和传统的关系型数据库有什么区别呢？

- 底层的数据结构不同，ES使用**倒排索引**，而MySQL使用**B+树**
- MySQL**支持事务**，ES**不支持事务**，可以这么认为，**MySQL更加适合OLTP，ES更适合OLAP**
- MYSQL是**单机**的，ES是**分布式**的，支持水平拓展以及高可用的特性
- MySQL支持多表关联，ES多表关联有限
- ES拥有灵活的数据类型，能创建更多的索引（默认都是索引）。



## Elasticsearch的使用场景

ES常见的使用场景如下：

![ES使用场景](https://cos.jiahongw.com/uPic/image-20230225110043810.png)





{{< tabs 搜索 日志处理 BI分析 数据异构 >}}
  {{< tab >}}

</br>
常见的搜索引擎以及电商搜索的场景，多是以模糊查询和多字段查询为主，如：百科搜索（百度百科、维基百科）、论坛博客（CSDN、简书、掘金、Stack Overflow）、电商网站（京东、淘宝、拼多多）

![搜索](https://cos.jiahongw.com/uPic/image-20230225110251025.png)

  {{< /tab >}}

  {{< tab >}}

</br>
在进行服务系统管理的时候，监控日志或者对日志进行分析，这些数据量比较大的处理，也能用ES来进行处理：

![日志监控](https://cos.jiahongw.com/uPic/image-20230225110421718.png)

  {{< /tab >}}
  {{< tab >}}

</br>
BI系统进行数据分析，ES也能作为一种数据分析的工具，尤其是在大数据分析的场景下：

![image-20230225110540712](https://cos.jiahongw.com/uPic/image-20230225110540712.png)


  {{< /tab >}}

   {{< tab >}}
</br>
数据异构和宽表构建主要是利用了ES可以处理很多结构化或者非结构化数据的特性，对一些原来的数据结构进行处理，例如MySQL的多表关联比较慢，可以对多个表进行组合成一张表，写入ES中，然后使用ES中的宽表进行查询，这样查询就能够比较快。并且ES中不会因为字段的个数上升而出现性能问题。

![数据异构](https://cos.jiahongw.com/uPic/image-20230225111223158.png)
   {{< /tab >}}
{{< /tabs >}}



















---

***Reference***:

- [elasticsearch-vs-mysql](https://www.trustradius.com/compare-products/elasticsearch-vs-mysql)
