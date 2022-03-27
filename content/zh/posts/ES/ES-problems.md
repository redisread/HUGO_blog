---
title: ES相关问题
date: 2022-03-27T10:36:37+08:00
description: ES相关问题故障和解决
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://cos.jiahongw.com/uPic/pluginIcon.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- ES
series:
- ES
categories:
-
---





ES集群故障：警惕通配符查询

![Cap-Elasticsearch-Client - IntelliJ IDEs Plugin | Marketplace]()

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









### ES的ID

文档唯一标识由四个元数据字段组成：
_id：文档的字符串 ID
_type：文档的类型名
_index：文档所在的索引
_uid：_type 和 _id 连接成的 type#id

默认情况下，_uid 是被保存（可取回）和索引（可搜索）的。_type 字段被索引但是没有保存，_id和 _index 字段则既没有索引也没有储存，它们并不是真实存在的。Elasticsearch 使用 _uid 字段来追溯 _id。

> 每个被索引的文档都与一个_type（见映射类型）和一个_id相关。_id字段没有被索引，因为它的值可以从_uid字段中自动得出。结构是`“_type#_id”`

```json
GET test_log/course/_search
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "_uid": {
        "order": "asc"
      }
    }
  ]
}
```

`_id`字段的值在某些查询中可以访问（term, terms, match, query_string, simple_query_string），但在聚合、脚本或排序时不能访问，这时应该使用`_uid`字段来代替。



使用ES自动生成ID，也会有一些缺陷

1. 文档ID无意义，且自动生成的ID更容易混淆
2. 必须先执行写入操作，写入成功后才能拿到ID



---

1. [TB级别Elasticsearch的存储优化经验（二）如何选择ID | Welcome to SPHIA](https://sphiatower.github.io/2019/03/18/elasticsearch-ID/)
2. [_id field | Elasticsearch Reference [5.6] | Elastic](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/mapping-id-field.html#mapping-id-field)
3. [请问es 有按 _id 排序这个说法么 - Elastic 中文社区](https://elasticsearch.cn/question/2647)
4. [Mysql，elasticsearch 等 按时间排序中的坑 - 星逝流的个人页面 - OSCHINA - 中文开源技术交流社区](https://my.oschina.net/jiangzhixiong/blog/597018)
5. [ES系列-Mapping-Meta_Fields-_id与_uid字段（索引、映射、字段）_Vancl_Wang Blog-程序员宅基地 - 程序员宅基地](https://www.cxyzjd.com/article/Vancl_Wang/84193405)
6. [(5条消息) Elasticsearch聚合学习之五：排序结果不准的问题分析_程序员欣宸的博客-CSDN博客](https://blog.csdn.net/boling_cavalry/article/details/90319399)





