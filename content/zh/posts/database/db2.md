---
title: "数据库知识(2)"
date: 2020-08-15T21:45:25+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/08/14/xOgLU8QBvctDpHV.png
libraries:
- katex
- mathjax
tags:
- Database
series:
- Database
categories:
-
---



### mysql的MVCC机制

MVCC的维基百科解释：**多版本并发控制**(Multiversion concurrency control， **MCC** 或 **MVCC**)，是[数据库管理系统](https://zh.wikipedia.org/wiki/数据库管理系统)常用的一种[并发控制](https://zh.wikipedia.org/wiki/并发控制)，也用于程序设计语言实现[事务内存](https://zh.wikipedia.org/wiki/事务内存)。

> MVCC是一种多版本并发控制机制，是MySQL的InnoDB存储引擎实现隔离级别的一种具体方式，用于实现提交读和可重复读这两种隔离级别

**MVCC作用**

MVCC意图解决[读写锁](https://zh.wikipedia.org/wiki/读写锁)造成的多个、长时间的读操作饿死写操作问题。所以MVCC通过保存某个时间点的快照来实现该机制，每个事务读到的数据项都是一个历史快照（snapshot)并依赖于实现的[隔离级别](https://zh.wikipedia.org/wiki/事務隔離)。写操作不覆盖已有数据项，而是创建一个新的版本，直至所在操作提交时才变为可见。[快照隔离](https://zh.wikipedia.org/wiki/快照隔离)使得事物看到它启动时的数据状态。

> MVCC可以[无锁](https://zh.wikipedia.org/w/index.php?title=无锁并发控制&action=edit&redlink=1)实现。



### 常见的数据库优化方法

> 或者索引相关的点你全部都知道么？聚簇索引，非聚簇索引，普通索引，唯一索引，change buffer，表锁、行锁、间隙锁以及行锁并发情况下的最大TPS是多少？还有索引为啥会选择错误？这些大家知道嘛？

![数据库优化](https://i.loli.net/2020/08/15/xfOzeKNY3u4ADMP.jpg)

数据库的组成结构图：

![数据库组成结构](https://i.loli.net/2020/08/15/SuNtAWIwH214aOZ.png)

**我们所谓的调优也就是在，执行器执行之前的分析器，优化器阶段完成的**。

1. **先跑sql explain**

   MySQL 提供了一个 EXPLAIN 命令, 它可以对 `SELECT` 语句进行分析, 并输出 `SELECT` 执行的详细信息, 以供开发人员针对性优化.
   EXPLAIN 命令用法十分简单, 在 SELECT 语句前加上 Explain 就可以了, 例如:

   ```mysql
   EXPLAIN SELECT * from user_info WHERE id < 300;
   ```

   EXPLAIN 命令的输出内容大致如下:

   ```mysql
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

   ![explain优化](https://i.loli.net/2020/08/15/pwQrN5kgTIjqCbn.png)

   各列的含义如下:

   - id: SELECT 查询的标识符. 每个 SELECT 都会自动分配一个唯一的标识符.

   - select_type: SELECT 查询的类型.

     它的常用取值有:

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

     `type` 字段比较重要, 它提供了判断查询是否高效的重要依据依据. 通过 `type` 字段, 我们判断此次查询是 `全表扫描` 还是 `索引扫描` 等.

     type 常用的取值有:

     - `system`: 表中只有一条数据. 这个类型是特殊的 `const` 类型.
     - `const`: 针对主键或唯一索引的等值查询扫描, 最多只返回一行数据. const 查询速度非常快, 因为它仅仅读取一次即可.

   - possible_keys: 此次查询中可能选用的索引

     `possible_keys` 表示 MySQL 在查询时, 能够使用到的索引. 注意, 即使有些索引在 `possible_keys` 中出现, 但是并不表示此索引会真正地被 MySQL 使用到. MySQL 在查询时具体使用了哪些索引, 由 `key` 字段决定.

   - key: 此次查询中确切使用到的索引.

   - ref: 哪个字段或常数与 key 一起被使用

   - rows: 显示此查询一共扫描了多少行. 这个是一个估计值.

     rows 也是一个重要的字段. MySQL 查询优化器根据统计信息, 估算 SQL 要查找到结果集需要扫描读取的数据行数.
     这个值非常直观显示 SQL 的效率好坏, 原则上 rows 越少越好.

   - filtered: 表示此查询条件所过滤的数据的百分比

   - extra: 额外的信息

2. **排除缓存干扰(Mysql8.0之前需要需要排除)**

   我们在执行SQL的时候，记得加上SQL NoCache去跑SQL，这样跑出来的时间就是真实的查询时间了。

   > 为什么缓存会失效，而且是经常失效？
   >
   > 缓存失效比较频繁的原因就是，只要我们一对表进行更新，那这个表所有的缓存都会被清空，其实我们很少存在不更新的表。

3. **覆盖索引**

   我们在数据库查询的操作中，可能有回表的操作，我们希望不进行回表操作，在自己的索引上就查到自己想要的，不进行主键索引查找。

   如果在我们建立的索引上就已经有我们需要的字段，就不需要回表了，在电商里面也是很常见的，我们需要去商品表通过各种信息查询到商品id，id一般都是主键，可能sql类似这样：

   ```mysql
   select itemId from itemCenter where size between 1 and 6
   ```

   ![覆盖索引](https://i.loli.net/2020/08/15/OPlBqsvk7ZGMifo.jpg)

   因为商品id itemId一般都是主键，在size索引上肯定会有我们这个值，这个时候就不需要回主键表去查询id信息了。

   由于覆盖索引可以减少树的搜索次数，显著提升查询性能，所以使用覆盖索引是一个常用的性能优化手段。

   

4. **联合索引——构建两个属性之间的快速查询**

   还是商品表举例，我们需要根据他的名称，去查他的库存，假设这是一个很高频的查询请求，你会怎么建立索引呢？

   > 思考回表的消耗对SQL进行优化。

   建立一个，名称和库存的联合索引，这样名称查出来就可以看到库存了，不需要查出id之后去回表再查询库存了，联合索引在我们开发过程中也是常见的，但是并不是可以一直建立的，大家要思考索引占据的空间。

   ![联合索引](https://i.loli.net/2020/08/15/y3IZQ2RdzhpvaLj.jpg)

   

5. **最左匹配原则**

   如果利用一个模糊查询 itemname like ’敖丙%‘，这样还是能利用到这个索引的，而且如果有这样的联合索引，大家也没必要去新建一个商品名称单独的索引了。

   > 很多时候我们索引可能没建对，那你调整一下顺序，可能就可以优化到整个SQL了。

6. **索引下推**

   知道了前缀索引规则，那我就说一个官方帮我们优化的东西，索引下推。

   ```mysql
   select * from itemcenter where name like '敖%' and size=22 and age = 20;
   ```

   所以这个语句在搜索索引树的时候，只能用 “敖”，找到第一个满足条件的记录ID1，当然，这还不错，总比全表扫描要好。

   然后我们还可以使用**索引下推**进行优化：

   在MySQL 5.6之前，只能从ID1开始一个个回表，到主键索引上找出数据行，再对比字段值。

   ![原来](https://i.loli.net/2020/08/15/bX2TiQgR5oVyh9F.png)

   

   而MySQL 5.6 引入的索引下推优化（index condition pushdown)， 可以在索引遍历过程中，对索引中包含的字段先做判断，直接过滤掉不满足条件的记录，减少回表次数。

   ![之后](https://i.loli.net/2020/08/15/Y4toFwsHmJPfc3N.png)

7. **唯一索引普通索引选择**

   当需要更新一个数据页时，如果数据页在内存中就直接更新，而如果这个数据页还没有在内存中的话，在不影响数据一致性的前提下，InooDB会将这些更新操作缓存在change buffer中，这样就不需要从磁盘中读入这个数据页了。

   在下次查询需要访问这个数据页的时候，将数据页读入内存，然后执行change buffer中与这个页有关的操作，通过这种方式就能保证这个数据逻辑的正确性。

   > 将change buffer中的操作应用到原数据页，得到最新结果的过程称为merge。除了访问这个数据页会触发merge外，系统有后台线程会定期merge。在数据库正常关闭（shutdown）的过程中，也会执行merge操作。

   ![更新数据页](https://i.loli.net/2020/08/15/na32b8VxPzD1fHQ.jpg)

   那么，**什么条件下可以使用change buffer呢？**

   对于唯一索引来说，所有的更新操作都要先判断这个操作是否违反唯一性约束。

   要判断表中是否存在这个数据，而这必须要将数据页读入内存才能判断，如果都已经读入到内存了，那直接更新内存会更快，就没必要使用change buffer了。

   因此，唯一索引的更新就不能使用change buffer，实际上也只有普通索引可以使用。

   change buffer用的是buffer pool里的内存，因此不能无限增大，change buffer的大小，可以通过参数innodb_change_buffer_max_size来动态设置，这个参数设置为50的时候，表示change buffer的大小最多只能占用buffer pool的50%。

   将数据从磁盘读入内存涉及随机IO的访问，是数据库里面成本最高的操作之一，change buffer因为减少了随机磁盘访问，所以对更新性能的提升是会很明显的。

   

8. **前缀索引**

   我们存在邮箱作为用户名的情况，每个人的邮箱都是不一样的，那我们是不是可以在邮箱上建立索引，但是邮箱这么长，我们怎么去建立索引呢？

   MySQL是支持前缀索引的，也就是说，你可以定义字符串的一部分作为索引。默认地，如果你创建索引的语句不指定前缀长度，那么索引就会包含整个字符串。



### Mysql各种引擎和区别

> MySQL中的数据用各种不同的技术存储在文件（或者内存）中。这些技术中的每一种技术都使用不同的存储机制、索引技巧、锁定水平并且最终提供广泛的不同的功能和能力。通过选择不同的技术，你能够获得额外的速度或者功能，从而改善你的应用的整体功能。

MySQL存储引擎主要有： MyIsam、InnoDB、Memory、Blackhole、CSV、Performance_Schema、Archive、Federated、Mrg_Myisam。

但是最常用的是InnoDB和Mylsam。

**InnoDB**

InnoDB是一个事务型的存储引擎，有行级锁定和外键约束。

Innodb引擎提供了对数据库ACID事务的支持，并且实现了SQL标准的四种隔离级别，关于数据库事务与其隔离级别的内容请见数据库事务与其隔离级别这类型的文章。该引擎还提供了行级锁和外键约束，它的设计目标是处理大容量数据库系统，它本身其实就是基于MySQL后台的完整数据库系统，MySQL运行时Innodb会在内存中建立缓冲池，用于缓冲数据和索引。但是该引擎不支持FULLTEXT类型的索引，而且它没有保存表的行数，当SELECT COUNT(*) FROM TABLE时需要扫描全表。当需要使用数据库事务时，该引擎当然是首选。由于锁的粒度更小，写操作不会锁定全表，所以在并发较高时，使用Innodb引擎会提升效率。但是使用行级锁也不是绝对的，如果在执行一个SQL语句时MySQL不能确定要扫描的范围，InnoDB表同样会锁全表。

> 适用场景：
>
> 经常更新的表，适合处理多重并发的更新请求。

索引结构：InnoDB是B+Treee索引结构。并且Innodb的索引文件本身就是数据文件，即B+Tree的数据域存储的就是实际的数据，这种索引就是**聚集索引**。

> InnoDB的辅助索引数据域存储的也是相应记录主键的值而不是地址，所以当以辅助索引查找时，会先根据辅助索引找到主键，再根据主键索引找到实际的数据。所以Innodb不建议使用过长的主键，否则会使辅助索引变得过大。建议使用自增的字段作为主键，这样B+Tree的每一个结点都会被顺序的填满，而不会频繁的分裂调整，会有效的提升插入数据的效率。

**Mylsam**

MyIASM是MySQL默认的引擎，但是它没有提供对数据库事务的支持，也不支持行级锁和外键，因此当INSERT或UPDATE数据时即写操作需要锁定整个表，效率便会低一些。MyIsam 存储引擎独立于操作系统，也就是可以在windows上使用，也可以比较简单的将数据转移到linux操作系统上去。

> 适用场景：
>
> 不支持事务的设计，但是并不代表着有事务操作的项目不能用MyIsam存储引擎，可以在service层进行根据自己的业务需求进行相应的控制。
>
> 不支持外键的表设计。
>
> 查询速度很快，如果数据库insert和update的操作比较多的话比较适用。
>
> 整天对表进行加锁的场景。
>
> MyISAM极度强调快速读取操作。

索引结构：MyISAM索引用的B+ tree来储存数据，MyISAM索引的指针指向的是键值的地址，地址存储的是数据。B+Tree的数据域存储的内容为实际数据的地址，也就是说它的索引和实际的数据是分开的，只不过是用索引指向了实际的数据，这种索引就是所谓的非聚集索引。

**InnoDB和MyISAM的区别**

1. 事务：MyISAM类型不支持事务处理等高级处理，而InnoDB类型支持，提供事务支持已经外部键等高级数据库功能

2. 性能：MyISAM类型的表强调的是性能，其执行数度比InnoDB类型更快。

3. 行数保存：InnoDB 中不保存表的具体行数，也就是说，执行select count() fromtable时，InnoDB要扫描一遍整个表来计算有多少行，但是MyISAM只要简单的读出保存好的行数即可。注意的是，当count()语句包含where条件时，两种表的操作是一样的。

4. 索引存储：对于AUTO_INCREMENT类型的字段，InnoDB中必须包含只有该字段的索引，但是在MyISAM表中，可以和其他字段一起建立联合索引。MyISAM支持全文索引（FULLTEXT）、压缩索引，InnoDB不支持。

   MyISAM的索引和数据是分开的，并且索引是有压缩的，内存使用率就对应提高了不少。能加载更多索引，而Innodb是索引和数据是紧密捆绑的，没有使用压缩从而会造成Innodb比MyISAM体积庞大不小。

   InnoDB存储引擎被完全与MySQL服务器整合，InnoDB存储引擎为在主内存中缓存数据和索引而维持它自己的缓冲池。InnoDB存储它的表＆索引在一个表空间中，表空间可以包含数个文件（或原始磁盘分区）。这与MyISAM表不同，比如在MyISAM表中每个表被存在分离的文件中。InnoDB 表可以是任何尺寸，即使在文件尺寸被限制为2GB的操作系统上。

5. 服务器数据备份：InnoDB必须导出SQL来备份，LOAD TABLE FROM MASTER操作对InnoDB是不起作用的，解决方法是首先把InnoDB表改成MyISAM表，导入数据后再改成InnoDB表，但是对于使用的额外的InnoDB特性(例如外键)的表不适用。

   MyISAM应对错误编码导致的数据恢复速度快。MyISAM的数据是以文件的形式存储，所以在跨平台的数据转移中会很方便。在备份和恢复时可单独针对某个表进行操作。

   InnoDB是拷贝数据文件、备份 binlog，或者用 mysqldump，在数据量达到几十G的时候就相对痛苦了。

6. 锁的支持：MyISAM只支持表锁。InnoDB支持表锁、行锁 行锁大幅度提高了多用户并发操作的新能。但是InnoDB的行锁，只是在WHERE的主键是有效的，非主键的WHERE都会锁全表的。

---

参考链接：

1. [有哪些常见的数据库优化方法？](https://www.zhihu.com/question/36431635)
2. [MySQL 性能优化神器 Explain 使用分析](https://segmentfault.com/a/1190000008131735)