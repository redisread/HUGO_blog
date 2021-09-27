---
title: ES-mappings
date: 2021-09-10T14:52:00+08:00
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



## ES Mappings

**ES的Mappings的作用类似mysql中定义表结构的schema**，用来定义一个文档格式，例如包含的字段，是否倒排，是否存储等等。主要功能：

1. 定义索引中字段的名字。
2. 定义字段的数据类型。
3. 字段以及倒排索引的相关配置。

> 在ES早期版本，一个索引是可以有多个Type的，从7.0开始，一个索引只有一个Type（名字唯一定义为_doc)。

一个Mappings的组成部分：

- 动态映射：设置动态映射的行为。
- 元数据域：定义文档的元数据信息如何组织，元数据信息包括_index，_id,_source三个部分。
- 属性

> 无法更新现有字段的映射。

每个文档就是一个属性的集合，而每个属性有每个属性的类型。

### 1. 动态映射-Dynamic mapping

通过用户输入的数据，自动推断出用户自定义的字段以及字段相应的各种属性，称为动态映射。

dynamic模式：

- true：动态添加新字段
- false：禁用，忽略新的字段
- strict：严格模式，遇到新的字段抛出异常

设置语句：

```json
put /indexName
{
  "mappings":{
    "dynamic":true|false|strict
  }
}
```

ES可以进行动态类型推断。

| **JSON格式的数据** | **自动推测的字段类型**                                       |
| :----------------- | :----------------------------------------------------------- |
| null               | 没有字段被添加                                               |
| 数组               | 由数组中第一个非空值决定                                     |
| string             | 有可能是date类型（开启日期检测)、double或long类型、text类型、keyword类型 |
| true or false      | boolean类型                                                  |
| floating类型数字   | floating类型                                                 |
| integer            | long类型                                                     |
| JSON对象           | object类型                                                   |

 动态映射一旦开启，很容易被用户误用，造成索引字段的膨胀/爆炸，最终就是造成OOM(out of memory)以及各种很难恢复的问题，ES内部有做了一定防范性的配置。

> 对字段类型根据数据格式自动识别的映射称之为**动态映射（Dynamic mapping）**，我们创建索引时具体定义字段类型的映射称之为**静态映射**或**显示映射（Explicit mapping）**



### 2. 元数据-Meta Data

ES下一个文档除了有数据之外，还包含了元数据。每创建一条数据时，都会对元数据进行写入等操作。

关闭所有数据的索引：

```json
"_all": {
        "enabled": false
      },
```

ES中元数据类型：

- 身份元数据
  - _index: 文档所属的索引，可以用来指定索引查询。
  - _id: 文档的唯一标识。
  - _type: ~~已移除~~
  
- 索引元数据
  - _field_names: 索引了每个字段的名字，可以包含null值，exists查询或missing查询方法通过该属性来校验特定的字段，未来废弃⚠️
  - _ignore: 存储所有的那些格式不正确的以及字段属性[ignore_malformed](https://www.elastic.co/guide/en/elasticsearch/reference/7.10/ignore-malformed.html)开启的字段，一般不需要特殊定义
  
- 文档元数据

  - _source:  一个doc的原生的json数据，不会被索引，但是会存储，用户获取提取字段值 ，如果启动此字段，索引体积会变大,如果想关闭，可以如下设置：

    ```
    PUT shop
    {
      "mappings": {
        "_source": {
          "enabled": false
        }
      }
    }
    ```

  - _size： 整个_source字段的字节数大小，需要单独安装一个插件(mapper-size)才能展示，一般不使用

- 路由元数据

  - _routing: 一个doc可以被路由到指定的shard上，通过下面的规则： shard_num = hash(_routing) % num_primary_shards ，默认情况下，使用_id字段来参与路由规则，如果此doc有父子关系，则会以父亲的_id作为路由规则，以确保父子数据 必须处于同一个shard上，以提高join效率。

    ```
    GET shop/_doc/1?routing=user1 
    ```

    > 在使用自己的路由规则时注意_id参数的唯一性

- 其他类型元数据

  - _meta：用户可以自定义数据到元数据中，此字段支持查询和更新，其用法如下:

    ```
    PUT shop
    {
      "mappings": {
        "_meta": { 
          "class": "MyApp::User",
          "version": {
            "min": "1.0",
            "max": "1.3"
          }
        }
      }
    }
    ```

    

### 3. 属性

properties是由众多的字段组成，字段由字段名、字段类型、字段属性等组成。

**字段类型**

字段数据类型：

<img src="https://i.loli.net/2021/09/15/8pMdzs6CcEPvmqg.png" alt="字段数据类型" style="zoom:50%;" />

**字段属性**

- **analyzer**：指定分词器(分析器更合理)，对索引和查询都有效。
- **normalizer**：normalizer用于解析前的标准化配置，比如把所有的字符转化为小写等。
- **boost**：boost字段用于设置字段的权重，比如，关键字出现在title字段的权重是出现在content字段中权重的2倍，设置mapping如下，其中content字段的默认权重是1.
- **coerce**：coerce属性用于清除脏数据，coerce的默认值是true。整型数字5有可能会被写成字符串“5”或者浮点数5.0.coerce属性可以用来清除脏数据：
- **copy_to**：copy_to属性用于配置自定义的_all字段。
- **doc_values**：doc_values是为了加快排序、聚合操作，在建立倒排索引的时候，额外增加一个列式存储映射，是一个空间换时间的做法。
- **dynamic**：dynamic属性用于检测新发现的字段，有三个取值：true、flase、strict
- **enabled**：Elasticseaech默认会索引所有的字段，enabled设为false的字段，es会跳过字段内容，该字段只能从_source中获取，但是不可搜。而且字段可以是任意类型。
- **fielddata**：搜索要解决的问题是“包含查询关键词的文档有哪些？”，聚合恰恰相反，聚合要解决的问题是“文档包含哪些词项”，大多数字段再索引时生成doc_values，但是text字段不支持doc_values。
- **format**：format属性主要用于格式化日期





https://km.sankuai.com/page/619492590

---

Ref：

1. [km](https://km.sankuai.com/page/1202860904)

