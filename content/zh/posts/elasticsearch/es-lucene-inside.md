---
title: "ES原理和实践：底层lucene"
date: 2024-02-24T23:26:32+08:00
description: ES是基于Lucene这个库实现的一个搜索引擎，我的理解是，Lucene主要实现一些底层结构设计和查询、写入的极致优化；而ES是对Lucene进行封装使用，实现分布式、高可用、高可拓展等特性。
draft: true
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
- lucene
series:
- ES原理和实践
categories:
- elasticsearch
---

## ES 和 lucene 的关系

- lucene：lucene 是一个 Java 信息检索程序库。可以类比为封装的底层 API，程序引用这个库之后可以使用其中的一些功能。
- ES：ES 是基于 lucene 这个包基础上进行构建的一个满足高可用、高性能、高可拓展的分布式存储中间件。

![ES和lucene关系](https://cos.jiahongw.com/uPic/POa8qK.png)

## Lucene 的底层数据结构设计

Lucene 是一个高效的，基于 Java 的全文检索库。主要包括下面的一些核心操作：
![lucene核心操作](https://cos.jiahongw.com/uPic/aefxFy.png)


### 倒排索引

什么是倒排索引？






