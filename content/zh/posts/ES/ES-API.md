---
title: ES API参考
date: 2022-03-27T14:42:03+08:00
description: 使用ES的API
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

## ES HTTP API

使用模板：

![image-20220111174412317](https://cos.jiahongw.com/uPic/image-20220111174412317.png)



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



添加别名：

```http
{
    "actions": [
        {"add": {"index": "grocery_inventory_poi_stock_trans_143239919098404_202202",
         "alias": "grocery_inventory_poi_stock_trans_143239919098404"}
         },
         {
           "add": {"index": "grocery_inventory_shelf_stock_trans_143239919098404_202202",
         "alias": "grocery_inventory_shelf_stock_trans_143239919098404"}
         }
    ]
}
```

删除别名：

```http
{
    "actions": [
        {"remove": {"index": "grocery_inventory_poi_stock_trans_143239919098404_202202",
         "alias": "grocery_inventory_poi_stock_trans_143239919098404"}
         },
         {
           "remove	": {"index": "grocery_inventory_shelf_stock_trans_143239919098404_202202",
         "alias": "grocery_inventory_shelf_stock_trans_143239919098404"}
         }
    ]
}
```

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
POST localhost:9200/student/_doc
{
    "name" : "hong"
}
```

结果自动生成随机的ID：

```json
{
    "_index": "student",
    "_type": "_doc",
    "_id": "obtj3nwBLeSa-n0f2397",
    "_version": 1,
    "result": "created",
    "_shards": {
        "total": 2,
        "successful": 1,
        "failed": 0
    },
    "_seq_no": 0,
    "_primary_term": 2
}
```



#### 更新文档

使用语法：`PUT /{index}/{type}/{id}`

```
source里面的字段映射
```





##### 查询并更新文档

```
POST index/type/_update_by_query
{ 
  "script": {
    "source": "ctx._source['type']='兔子'"
  },
  "query": {
    "term": {
      "petRaceId": {
        "value": "3"
      }
    }
  }
}
```

上面的例子表示将字段petRaceId的value=3的文档的type值改为：兔子。

Java API的使用：

```java
public void updateByQuery(Long routeId, String index, String type, QueryBuilder query,
        String strScript) {
        PorosRestHighLevelClient client = getEagleClient(routeId);
        String endpoint = "/" + index + "/" + type + "/_update_by_query?conflicts=proceed";
        if (query == null) {
            return;
        }
        String queryString = "{"
            + " \"script\": { "
            + " \"source\": " + "\"" + strScript + "\""
            + "},"
            + " \"query\": " + query.toString()
            + "}";

        try {
            lowLevelPerformRequest(client, queryString, endpoint, HttpPost.METHOD_NAME);
        } catch (Exception e) {
            LOGGER.error("updateByQuery 请求失败", e);
        }
 }
```

UpdateByQueryRequest API在ES6以上的版本适用。

> script编写指南：
>
> - 修改多值：
>
>   ```json
>    {
>     "script": {"source":"ctx._source['user_name']='LsiuLi';ctx._source['assignedto_id']='123';"},
>     "query": {"term": {"user_id": 60}} 
>   }
>   ```
>
> - 增加数组元素
>
>   http://localhost:9200/1909_user/user/15670260/_update
>
>   ```json
>   {
>   	"script": {
>   	"lang": "painless",
>   		"source":"ctx._source['field_mult_value_7917'].add(params.hobby)",
>   		"params" : {
>   			"hobby" : "c"
>   		} 
>   	}
>   }
>   ```
>
> - 删除index中的field
>
>   http://localhost:9200/1542_case/case/_update_by_query?wait_for_completion=false&conflicts=proceed
>
>   ```json
>   {
>   "script": {"source":"ctx._source.remove('user_field_email_5613')"}
>   }
>   ```
>
>   



`?conflicts=proceed` 表示什么意思？










### 查询索引

使用语法：`GET {index}/_search`

返回索引的所有信息：

```json
{
    "took": 49,
    "timed_out": false,
    "_shards": {
        "total": 3,
        "successful": 3,
        "skipped": 0,
        "failed": 0
    },
    "hits": {
        "total": {
            "value": 3,
            "relation": "eq"
        },
        "max_score": 1.0,
        "hits": [
            {
                "_index": "student",
                "_type": "_doc",
                "_id": "obtj3nwBLeSa-n0f2397",
                "_score": 1.0,
                "_source": {
                    "name": "hong"
                }
            },
            {
                "_index": "student",
                "_type": "_doc",
                "_id": "ort13nwBLeSa-n0fTn_g",
                "_score": 1.0,
                "_routing": "hong",
                "_source": {
                    "name": "hong",
                    "age": 22
                }
            },
            {
                "_index": "student",
                "_type": "_doc",
                "_id": "1",
                "_score": 1.0,
                "_source": {
                    "name": "victor"
                }
            }
        ]
    }
}
```



### 查询文档

每个文档都有一个 `_id `唯一标识，这个id可以在创建文档的时候手动传入或者由es自己生成。

> `_id` 字段在做聚合、排序、脚本时功能受限，如果说上述操作需要用到 `_id` 字段，需要把 `_id` 的值在 `doc_values` 里也保存一份

##### 1 根据 `get api` 查询

```
GET {my_index}/_doc/{myid}
```

##### 2 根据 `ids query` 查询

```
GET {my_index}/_search
{
    "query":
    {
        "ids":
        {
            "values":[1,2,3]
        }
    }
}
```

##### 3 根据 `term` , `terms` , `match` 查询

```
# term
GET {my_index}/_search
{
  "query": {
      "term": {
        "_id": {
          "value": "1"
        }
      }    
    }
  }
}

# terms
GET {my_index}/_search
{
  "query": {
     "terms": {
       "_id": [
         "1","2"
       ]
     }
    }
  }
}

# match
GET {my_index}/_search
{
  "query": {
      "match": {
        "_id": 1
      }
    }
  }
}
```





组合查询：

```
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "poiId": "142958687180976"
          }
        },
        {
          "term": {
            "skuId": "100176717278999"
          }
        }
      ],
      "must_not": [],
      "should": [
        {
          "term": {
            "shelfCode": "CW-01-01-01-01"
          }
        },
        {
          "term": {
            "newShelfCode": "CW-01-01-01-01"
          }
        }
      ],
      "filter": []
    }
  },
  "from": 0,
  "size": 10,
  "sort": [],
  "profile": false
}
```



### 查询返回指定的字段



不返回文档：

```json
GET /_search
{
    "_source": false,
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
```

返回指定的字段：

```json
GET /_search
{
    "_source": {
        "includes": [ "obj1.*", "obj2.*" ],
        "excludes": [ "*.description" ]
    },
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
```

或者

```json
GET /_search
{
     "_source": ["shelfId"],
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
```

Java:

```java
# source 过滤
String[] includeFields = new String[] {"test1", "test2"};
String[] excludeFields = new String[] {"test1", "test2"};
sourceBuilder.fetchSource(includeFields, excludeFields);
```



### 去重

使用collapse折叠字段

```json
POST /user_onoffline_log/
{
    "query":{
        "match_all":{

        }
    },
    "collapse":{
        "field":"uid"
    }
}
```



Java

```java
searchRequest.source().collapse(new CollapseBuilder("field"));
```





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









### 请求参数查询



根据条件查询索引信息：

```http
GET /twitter/_doc/_search
{
    "query" : {
        "term" : { "user" : "kimchy" }
    }
}
```







### ReIndex

Reindex的目标是把索引数据从一个索引迁移至另一个索引，主要针对于**索引变更**，比如需要**修改字段类型，新增字段**等需求。

基本命令：

```http
POST /_reindex
{
	"source": {
		"index": "old_index"
	},
	"dest": {
		"index": "new_index"
	}
}
```

复杂命令：

```http
POST /_reindex
{
	"source": {
		"remote": {
			"host": "http://$HOST:8080",
			"username": "$APP",
			"password": "$ACCESSKEY"
		},
		"index": "old_index",
		"query": {
			"bool": {
				"must": [{
					"match_all": {}
				}],
				"must_not": [],
				"should": [],
				"filter": []
			}
		}
	},
	"dest": {
		"index": "new_index"
	}
}
```

同步增量数据命令:

```http
POST /_reindex
{
  "conflicts": "proceed",
  "source": {
    "index": "inventory_cost_record",
    "query": {
      "bool": {
        "must": [
          {
            "range": {
              "bizTime": {
                "gt": "2022-01-17 00:00:00",
                "lt": "2022-01-19 00:00:00" 
              }
            }
          }
        ]
      }
    },
    "size": 500
  },
  "dest": {
    "index": "cost_accounting_record",
    "version_type": "external",
    "op_type": "create"
  }
}
```

> version_type字段说明:
>
> - 【默认覆盖】忽略version_type字段，或配置为“internal”（**默认**配置）：将文档完全dump到目的索引，**覆盖**具有相同类型和id的任何文档内容，不会产生冲突问题；
> - 【保留最新】配置为“external”：es从源文件中读取version字段，当遇到相同类型和id的文档时，只保留newer version，即最新的version对应的数据。创建目标索引中缺失的所有文档，并**更新**在目标索引中比原索引中版本更老的所有文档；
> - 【冲突数据无法写入】op_type配为“create”：仅在目标索引中创建缺少的文档。所有存在的文档将导致版本冲突。(在使用了op_type为create的情况下，默认版本冲突将中止“_reindex”进程，但可以通过设置“conflict:proceed”来在冲突时进行计数。即使冲突，仍能够正常进行reindex，但会遗漏有冲突的数据。)









### Mapping

mapping创建之后，还能进行更新吗？

已经定义的字段大多数情况不能被更新，除非 reindex 更新 mapping，下面的情况是例外：

- Object 对象可以添加新的属性
- 已经存在的fields里面可以添加fields，以构成一个字段多种类型
- ignore_above 是可以更新的









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



#### 文档更新

构造文档更新内容：

1. jsonString
2. Map
3. XContentBuilder





















### Scroll查询

ES Scroll功能又叫做**游标查询**，该功能能够高效的遍历ES查询的结果集，主要用于解决ES普通查询深度翻页时的性能问题。因此，Scroll功能常常用在**非实时**场景下检索大量结果，该功能有以下优缺点：

- 优点：针对深度翻页场景优化，获取数据的性能消耗时固定的，查询性能不会随着页数增多而急剧下降；
- 缺点：Scroll功能是有状态的，ES服务端会根据Scroll ID维持翻页状态，需要根据Scroll ID顺序翻页（类似数据库游标），Scroll翻页过程中，新的数据变更不会体现到返回的结果集中，不适合实时性要求较高的场景；

知道了Scroll的应用场景及优缺点，我们先来分析下常规ES查询深度翻页为什么会出现性能问题。







原理

深度翻页最主要的瓶颈在于Query阶段，Query阶段总共需要从Node节点获取nodeNum *（from + size）条数据的doc_id和评分，这些记录在Coordinate Node排序后，绝大部分数据会被丢弃，只使用最后满足条件的size个doc_id。所以，随着页号的增大，性能主要消耗在不需要的数据上，ES Scroll就是解决这个问题的折中方案，在使用Scroll API时，ES会在服务端记录一个游标，每次查询时只获取游标之后的size条数据，这样就避免了Query阶段的时间浪费在不需要的数据上。















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











## 问题



1. ElasticSearch term查询搜索不到指定的数据 https://blog.csdn.net/qq_26531719/article/details/107029198
   - match表示全文搜索，通常用于对text类型字段的查询,会对进行查询的文本先进行分词操作
   - term表示精确搜索，通常用于对keyword和有精确值的字段进行查询,不会对进行查询的文本进行分词操作
2. 













---

***Reference：***

1. [ES5.6官方文档-支持多个索引参数](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/multi-index.html#multi-index)
2. [ES5.6官方文档公共参数设置](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/common-options.html)
3. [RestHighLevelClient-JavaDoc](https://artifacts.elastic.co/javadoc/org/elasticsearch/client/elasticsearch-rest-high-level-client/5.6.16/index.html)
4. [ES5.6-文档读写原理](https://www.elastic.co/guide/en/elasticsearch/reference/5.6/docs-replication.html)
5. [ElasticSearch根据匹配某个条件，局部更新文档_wessiyear的博客-CSDN博客_elasticsearch根据条件更新](https://blog.csdn.net/wessiyear/article/details/78964383)
6. [Elasticsearch教程(29) update by query的Script脚步更新 Java API 支持es5.6 es6.8 es7.8_再也不会玩亚瑟，再也不会走在那对抗路上-CSDN博客](https://blog.csdn.net/winterking3/article/details/114031865)
7. [【ES】【Java High Level REST Client】官方索引和文档操作指导 - 风动静泉 - 博客园](https://www.cnblogs.com/z00377750/p/13300196.html)
8. [关于 ElasticSearch的Update By Query - akamiiya的程序员之路](https://www.laizeh.com/2021/06/13/%E5%85%B3%E4%BA%8E-ElasticSearch%E7%9A%84Update-By-Query.html)
9. [Elasticsearch去重查询_jacklife的博客-CSDN博客_es去重查询](https://blog.csdn.net/wslyk606/article/details/84315862)
10. [ES 15 - Elasticsearch的数据类型 (text、keyword、date、object、geo等) - 瘦风 - 博客园](https://www.cnblogs.com/shoufeng/p/10692113.html)
