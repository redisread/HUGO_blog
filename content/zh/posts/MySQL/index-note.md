---
title: index-note
date: 2021-11-24T14:19:48+08:00
description:
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 🪶
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



MySQL如何创建索引



建表时添加

```
PRIMARY KEY (`id`),
 UNIQUE KEY `uniq_verification_id` (`column1`，`column2`),
 KEY `idx_c1_c2_c3_id` (`column1`,`column2`,`column3`)
```

建表后

添加主键索引（PRIMARY KEY）

```mysql
ALTER TABLE `table_name` ADD PRIMARY KEY ( `column` ) 
```

添加唯一索引（UNIQUE KEY）

```mysql
ALTER TABLE `table_name` ADD UNIQUE ( `column` )
```

添加普通索引（INDEX）

 ```mysql
 ALTER TABLE `table_name` ADD INDEX index_name ( `column` ) 
 ```

添加全文索引（FULLTEXT）

```mysql
ALTER TABLE `table_name` ADD FULLTEXT ( `column`) 
```

添加多列索引 

```mysql
mysql>ALTER TABLE `table_name` ADD INDEX index_name ( `column1`, `column2`, `column3` )
```





explain使用方法：

输出格式：

```
mysql> explain select * from user_info where id = 2\G
*************************** 1. row ***************************
           id: 1
  select_type: SIMPLE
        table: user_info
   partitions: NULL
         type: const
possible_keys: PRIMARY
          key: PRIMARY
      key_len: 8
          ref: const
         rows: 1
     filtered: 100.00
        Extra: NULL
1 row in set, 1 warning (0.00 sec)
```

各列的含义如下:

- id: SELECT 查询的标识符. 每个 SELECT 都会自动分配一个唯一的标识符.

- select_type: SELECT 查询的类型.
  - SIMPLE, 表示此查询不包含 UNION 查询或子查询
  - PRIMARY, 表示此查询是最外层的查询
  - UNION, 表示此查询是 UNION 的第二或随后的查询
  - DEPENDENT UNION, UNION 中的第二个或后面的查询语句, 取决于外面的查询
  - UNION RESULT, UNION 的结果
  - SUBQUERY, 子查询中的第一个 SELECT
  - DEPENDENT SUBQUERY: 子查询中的第一个 SELECT, 取决于外面的查询. 即子查询依赖于外层查询的结果.
  
- table: 查询的是哪个表

- partitions: 匹配的分区

- type: join 类型

  ![clip_image001](https://cos.jiahongw.com/uPic/73542-20181105144840730-1498105541.png)

  由左至右，性能由最差到最好

  - ALL：Full Table Scan， MySQL将遍历全表以找到匹配的行
  - index：Full Index Scan，index与ALL区别为index类型只遍历索引树
  - range：索引范围扫描，对索引的扫描开始于某一点，返回匹配值域的行，常见于between、<、>等的查询
  - ref：非唯一性索引扫描，返回匹配某个单独值的所有行。常见于使用非唯一索引即唯一索引的非唯一前缀进行的查找
  - eq_ref：唯一性索引扫描，对于每个索引键，表中只有一条记录与之匹配。常见于主键或唯一索引扫描
  - const、system：当MySQL对查询某部分进行优化，并转换为一个常量时，使用这些类型访问。如将主键置于where列表中，MySQL就能将该查询转换为一个常量
  - NULL：MySQL在优化过程中分解语句，执行时甚至不用访问表或索引

- possible_keys: 此次查询中可能选用的索引

- key: 此次查询中确切使用到的索引.

- ref: 哪个字段或常数与 key 一起被使用

- rows: 显示此查询一共扫描了多少行. 这个是一个估计值.

- filtered: 表示此查询条件所过滤的数据的百分比

- extra: 额外的信息

  - Using index：当查询的列是单个索引的部分的列时, 可以使用此策略。（使用索引来直接获取列的数据，而不需回表）
  - Using where：在存储引擎检索行后在做过滤，是一个全表扫描。
  - Using index condition： ICP优化（使用索引过滤数据）。
  - using temporary：使用了临时表。
  - impossible where ：谓词不成立。
  - Using filesort：MySQL中无法利用索引完成的排序操作称为“文件排序”。









---

***Reference***:

1. [MYSQL 添加索引](https://blog.csdn.net/u012116169/article/details/48519719)
1. [MySQL 执行计划中Extra(Using where,Using index,Using index condition,Using index,Using where)的浅析 - 潇湘隐者 - 博客园](https://www.cnblogs.com/kerrycode/p/9909093.html#:~:text=Extra%E4%B8%AD%E5%87%BA%E7%8E%B0%E2%80%9CUsing%20where,%E8%8E%B7%E5%8F%96%E6%89%80%E9%9C%80%E7%9A%84%E6%95%B0%E6%8D%AE%E3%80%82)
