---
title: ES API参考
date: 2021-09-10T14:42:03+08:00
description: 使用ES的API
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://raw.githubusercontent.com/redisread/Image/master/2021-09-10/elastic.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- ES
series:
-
categories:
-
---



[TOC]



## ES HTTP API

### 创建索引

创建一个索引的方法很简单，在Kibana中运行下行请求即可创建一个名为“index1”的索引

```Bash
PUT /index1
```

可以增加相关设置和映射：

```JSON
PUT /test
{
  "settings": {
    "number_of_shards": 1
  },
  "mappings": {
    "properties": {
      "field1": { "type": "text" }
    }
  }
}
```

**创建索引并且添加别名**

添加aliases：

```JSON
PUT /test
{
  "aliases": {
    "alias_1": {},
    "alias_2": {
      "filter": {
        "term": { "user.id": "kimchy" }
      },
      "routing": "shard-1"
    }
  }
}
```

ES中索引支持关闭和打开操作，一个关闭的索引除了维护元数据的基本消耗外，几乎没有任何其他开销，在关闭状态下的索引禁止进行IO操作，再次打开后可恢复正常状态。

### 关闭索引

语法：`POST /<index>/_close`

```Bash
POST /index1/_close
```

返回结果：

```JSON
{
  "acknowledged": true,
  "shards_acknowledged": true,
  "indices": {
    "my-index-000001": {
      "closed": true
    }
  }
}
```

支持使用正则表达式进行关闭：

```bash
POST /index*/_close
```

或者直接指定关闭多个索引(索引之间使用 `,` 分隔)：

```bash
POST /index1,index2/_close
```

> ES索引处于open状态，就会占用内存+磁盘；
> 如果将索引close，只会占用磁盘，当索引比较多的时候影响查询速度。



修改索引：

```
PUT localhost:9200/teacher/_settings
{
	"number_of_replicas": 3
}
```



### 打开索引

语法：`POST /<target>/_open`

```Bash
POST /index1/_open
```

返回结果：

```JSON
{
  "acknowledged" : true,
  "shards_acknowledged" : true
}
```

支持使用正则表达式进行批量的打开索引：

```bash
POST /index*/_open
```

或者直接指定关闭多个索引(索引之间使用 `,` 分隔)：

```bash
POST /index1,index2/_open
```

> // 可以使用_all打开或关闭全部索引, 也可使用通配符(*)配合操作
>
> ```bash
> POST _all/_close
> POST _all/_open
> ```

Post请求可以添加相关的请求参数：

```json
{
  	//是否在任何指定的索引不可用时忽略，这包括不存在的索引或关闭的索引。
    "ignore_unavailable": true,
  	// 如果通配符索引表达式导致没有具体索引，则控制是否失败.
  	"allow_no_indices": true,  	
}
```



### 删除索引

删除索引：通过下方接口可以删除一个索引，如果删除成功，将返回acknowledge:true

语法：`DELETE /<index>`

```Bash
DELETE /index3?pretty
```

### 展示索引

列出所有的索引：

```Http
GET _cat/indices?v
GET localhost:9200/_cat/indices?v
```

模糊查询索引名，查找包含单词data的索引名：

```Http
GET _cat/indices/*data*?v
```



> 使用pretty关键字让返回的结果格式化（更加美观）：
>
> ```http
> GET _cat/indices/*data*?v&pretty
> ```
>
> 但是最好仅用于调试



查询索引配置：

```http
GET /{index}/_settings
```



### 读写索引







#### 创建文档

使用语法： `PUT /{index}/_doc/{id}`

例子：

```http
PUT localhost:9200/student/_doc/1
{
    "name" : "victor"
}
```

返回结果：

```json
{
    "_index": "student",
    "_type": "_doc",
    "_id": "1",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 0,
    "_primary_term": 1
}
```

> 假如索引student之前没有创建过，执行这条语句之后也会自动创建这个索引，相关的参数都是默认的参数。如果还没有创建一个动态类型映射，也会自动为特定类型创建一个动态类型映射。（使用动态映射很消耗性能）
>
> 通过设置配置文件中的`action.auto_create_index` 为 `false` 或者通过设置 setting 的 `index.mapper.dynamic` 为 `false`。

自动填充id：

```http
POST twitter/tweet/
{
    "user" : "kimchy",
    "post_date" : "2009-11-15T14:12:12",
    "message" : "trying out Elasticsearch"
}
```



















ES中进行索引的查询是通过分片进行查询的









### 公共参数设置

#### 结果过滤参数filter_path

使用例子：

```http
GET /_search?q=elasticsearch&filter_path=took,hits.hits._id,hits.hits._score
```

输出结果样例：

```json
{
  "took" : 3,
  "hits" : {
    "hits" : [
      {
        "_id" : "0",
        "_score" : 1.6375021
      }
    ]
  }
}
```

也支持使用通配符 `*` 进行匹配：

```http
GET /_cluster/state?filter_path=metadata.indices.*.stat*
```

结果：

```json
{
  "metadata" : {
    "indices" : {
      "twitter": {"state": "open"}
    }
  }
}
```

`**` 可用于在不知道字段的确切路径的情况下包含字段。

```http
GET /_cluster/state?filter_path=metadata.**.stat*
```



#### 铺平参数flat_settings

使用 `flat_settings` 参数，并且设置为 `true` 可以让返回的的Json数据展开，减少花括号。

使用方式：Get方法后面添加 `?flat_settings=true`

原来： `/indexName/_settings`

```json
{
  "grocery_inventory_inventory_transaction_143179120435102_202108": {
        "settings": {
            "index": {
                "refresh_interval": "1s",
                "number_of_shards": "1",
                "provided_name": "grocery_inventory_inventory_transaction_143179120435102_202108",
                "creation_date": "1628582799738",
                "number_of_replicas": "1",
                "uuid": "lm22sPdbSrmGuaqIg03QOg",
                "version": {
                    "created": "5060399"
                }
            }
        }
    }
}
```

使用后： `/indexName/_settings?flat_settings=true`

```json
{
  "grocery_inventory_inventory_transaction_143179120435102_202108": {
        "settings": {
            "index.creation_date": "1628582799738",
            "index.refresh_interval": "1s",
            "index.uuid": "lm22sPdbSrmGuaqIg03QOg",
            "index.version.created": "5060399",
            "index.provided_name": "grocery_inventory_inventory_transaction_143179120435102_202108",
            "index.number_of_replicas": "1",
            "index.number_of_shards": "1"
        }
    }
}
```









































## ES Java API

### 添加依赖包

对于原生的spring工程，则引入以下对应的包:

```xml
				<dependency>
            <groupId>com.sankuai.meituan</groupId>
            <artifactId>eagle-restclient</artifactId>
            <version>1.2.24</version>
        </dependency>

        <dependency>
            <groupId>com.sankuai.octo</groupId>
            <artifactId>idl-common</artifactId>
            <version>1.9.0</version>
        </dependency>

        <dependency>
            <groupId>org.elasticsearch</groupId>
            <artifactId>elasticsearch</artifactId>
            <version>5.6.3</version>
        </dependency>

        <dependency>
            <groupId>org.elasticsearch.client</groupId>
            <artifactId>transport</artifactId>
            <version>5.6.3</version>
        </dependency>

        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-all</artifactId>
            <version>4.1.13.Final</version>
        </dependency>

        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty</artifactId>
            <version>3.10.6.Final</version>
        </dependency>
```



### Rest Client

Java REST客户端有两种风格：

- Java低级别REST客户端（Java Low Level REST Client，以后都简称低级客户端算了，难得码字）：Elasticsearch的官方low-level客户端。 它允许通过http与Elasticsearch集群进行通信。 不会对请求进行编码和响应解码。 它与所有Elasticsearch版本兼容。
- Java高级REST客户端（Java High Level REST Client，以后都简称高级客户端）：Elasticsearch的官方high-level客户端。 基于low-level客户端，它公开了API特定的方法,并负责处理。



### Java Low Level REST Client

新建一个Java Low Level REST Client只需几个参数

初始化：

```java
RestClient restClient = RestClient.builder(
        new HttpHost("localhost", 9200, "http"),
        new HttpHost("localhost", 9201, "http")).build();
```

也可设置相关参数：

```java
RestClientBuilder builder = RestClient.builder(new HttpHost("localhost", 9200, "http"));
// 设置HTTP请求头的键值对
Header[] defaultHeaders = new Header[]{new BasicHeader("header", "value")};
builder.setDefaultHeaders(defaultHeaders); 
// 设置超时时间
builder.setMaxRetryTimeoutMillis(10000);
// 设置失败回调函数
builder.setFailureListener(new RestClient.FailureListener() {
    @Override
    public void onFailure(HttpHost host) {
        
    }
});
```

关闭 `RestClient`：

```java
restClient.close();
```

最好使用高级别API，即Java High Level REST Client。





### Java High Level REST Client

初始化 `RestHighLevelClient`：

```java
RestClient lowLevelRestClient = RestClient.builder(
        new HttpHost("localhost", 9200, "http"),
        new HttpHost("localhost", 9201, "http")).build();
```

```java
RestHighLevelClient client =
    new RestHighLevelClient(lowLevelRestClient);
```

创建请求







执行请求







### Scroll查询

ES Scroll功能又叫做**游标查询**，该功能能够高效的遍历ES查询的结果集，主要用于解决ES普通查询深度翻页时的性能问题。因此，Scroll功能常常用在**非实时**场景下检索大量结果，该功能有以下优缺点：

- 优点：针对深度翻页场景优化，获取数据的性能消耗时固定的，查询性能不会随着页数增多而急剧下降；
- 缺点：Scroll功能是有状态的，ES服务端会根据Scroll ID维持翻页状态，需要根据Scroll ID顺序翻页（类似数据库游标），Scroll翻页过程中，新的数据变更不会体现到返回的结果集中，不适合实时性要求较高的场景；

知道了Scroll的应用场景及优缺点，我们先来分析下常规ES查询深度翻页为什么会出现性能问题。







原理

















## 本地实践

安装ES：

```bash
# 安装es
brew install elasticsearch

# 安装成功后，查看版本信息
elasticsearch --version
```

启动ES：

```java
elasticsearch
```

浏览器输入http://localhost:9200/ 即可进入本地ES

![进入ES](https://cos.jiahongw.com/uPic/image-20211101165704731.png)



安装Kibana

```bash
brew install kibana
```

启动kibana

```bash
kibana
```

![image-20211101170215334](https://cos.jiahongw.com/uPic/image-20211101170215334.png)

添加测试数据进行实践：

![image-20211101170333713](https://cos.jiahongw.com/uPic/image-20211101170333713.png)





















---

***Reference：***

1. [ES5.6官方文档-支持多个索引参数](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/multi-index.html#multi-index)
2. [ES5.6官方文档公共参数设置](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/common-options.html)
3. [RestHighLevelClient-JavaDoc](https://artifacts.elastic.co/javadoc/org/elasticsearch/client/elasticsearch-rest-high-level-client/5.6.16/index.html)

4. [ES5.6-文档读写原理](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/docs-replication.html)
