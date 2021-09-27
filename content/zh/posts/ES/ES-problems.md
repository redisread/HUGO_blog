---
title: ES-problems
date: 2021-09-14T10:36:37+08:00
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





ES集群故障：警惕通配符查询

https://elasticsearch.cn/article/171

ES查询索引未找到解决办法：

https://www.codeleading.com/article/59664719033/

https://www.cnblogs.com/lmsthoughts/articles/7609802.html

API:https://www.tabnine.com/code/java/methods/org.elasticsearch.search.builder.SearchSourceBuilder/sort



ES mapping 排序未初始化问题

https://blog.csdn.net/xaio7biancheng/article/details/82657175

```java
FieldSortBuilder timeSort = SortBuilders.fieldSort(tuple.getField()).order(SortOrder.ASC).unmappedType("long");
						searchSourceBuilder.sort(tuple.getField(), SortOrder.ASC).sort(timeSort);
```



























