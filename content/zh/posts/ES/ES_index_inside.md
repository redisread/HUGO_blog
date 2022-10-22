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




# 简介


## 什么是ES？


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/09/93/099394aa84353c6d44bee029862d3a3f.png)


ES的全称是ElasticSearch（下面简称ES），是一个分布式、高扩展、近实时的搜索与数据分析引擎（底层基于[Apache Lucene](https://lucene.apache.org/)）。Elasticsearch 为各种数据类型提供接**近实时**的搜索和分析，不论你有结构化或非结构化的文本、数字数据，还是地理空间数据，Elasticsearch 能以支持快速搜索的方式高效地存储和索引它。你可以远超简单数据检索和聚合信息的方式去发现你数据中的趋势和模式。而且，随着你数据和查询量的增长，Elasticsearch 分布式的特性允许你的部署能随着它无缝地增长。（参考：[ES官方文档-ES介绍](https://www.elastic.co/guide/en/elasticsearch/reference/current/elasticsearch-intro.html)）


ES作为一种非关系型数据库，他和传统的关系型数据库有什么区别呢？(参考：[https://www.trustradius.com/compare-products/elasticsearch-vs-mysql](https://www.trustradius.com/compare-products/elasticsearch-vs-mysql))

- 底层的数据结构不同，ES使用倒排索引，而MySQL使用B+树。
- MySQL支持事务，ES不支持事务，可以这么认为，MySQL更加适合OLTP，ES更适合OLAP。
- MYSQL是单机的，ES是分布式的，支持水平拓展以及高可用的特性。
- ES拥有灵活的数据类型，创建更多的索引（默认都是索引）。

## **ES的使用场景**


ES的使用场景都有哪些呢？（参考：[use-cases-of-elasticsearch](https://appscrip.com/blog/use-cases-of-elasticsearch/)）


![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/71/70/71706e75d294438471c47381b5110345.png)


<details>
  <summary>111</summary>

- dasd

![](https://raw.githubusercontent.com/redisread/Image/master/notionimg/a9/d0/a9d010bb0d67778b0d6d79c0f32a3060.png)



  </details>


