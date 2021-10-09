---
title: mysql-note
date: 2021-10-09T11:18:52+08:00
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
-
series:
-
categories:
-
---

















## MySQL分页查询

[MySQL的limit用法和分页查询的性能分析及优化 - SegmentFault 思否](https://segmentfault.com/a/1190000008859706)

为了避免SQL慢查询，或者数据量太大，通常使用分页查询。





如何进行分页查询？

1. 使用offset + limit进行分页查询。
2. 使用索引进行分页查询。



方法1:

```mysql
select * from T where condition limit [offset],[rows]
```

offset是偏移值，rows表示需要返回的数据行。mysql执行的时候会读取offset+rows条数据，然后抛弃掉前offset条数据，返回剩余的rows条数据。从这个执行逻辑我们就可以发现前offset条数据实际对结果无任何意义，但是当offset很大时，它会占据绝大部分的查询时间，例如limit 10000,10 mysql会查出前面的10010条数据，再丢掉10000条数据。显然，数据偏移量offset值一大，limit的性能就会急剧下降。



> 关于为什么使用这种方式进行查询，因为MySQL内部进行存储的方式不是一个连续的存储，而是离散的存储，使用B+树进行索引（索引）。



实际的使用中，可以使用explain查看语句是进行了全表扫描还是走索引。explain使用参考：[MySQL 性能优化神器 Explain 使用分析 - SegmentFault 思否](https://segmentfault.com/a/1190000008131735)

[MySQL Explain 使用详解 - 简书](https://www.jianshu.com/p/22f7824e4235)



从图中执行计划的Extra信息，using where表明需要回表查询，using filesort说明需要进行外部排序。













分页查询优化：[MySQL分页查询优化 - 悠悠i - 博客园](https://www.cnblogs.com/youyoui/p/7851007.html)



https://segmentfault.com/a/1190000037776663

























