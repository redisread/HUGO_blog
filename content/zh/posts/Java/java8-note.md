---
title: java8笔记📒
date: 2021-09-09T11:14:17+08:00
description: 记录Effective Java的一些重点
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 🥊
image: https://raw.githubusercontent.com/redisread/Image/master/2021-09-09/4519129_java_icon.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- Java
- Effective Java
series:
-
categories:
-
---



:v:cxc

《Java实战》笔记



### stream的使用注意

一个 Stream pipeline 中包含一个源 Stream，接着是 0个或者多个中间操作( intermediat巳 operation)和一个终止操作( terminal operation)。 每个中间操作都会通过某种方式对 Stream 进行转换，例如将每个元素映射到该元素的函数，或者过滤掉不满足某些条件的所有元素 。 所有的中间操作都是将一个 Stream 转换成另 一个 Stream，其元素类型可能与输入的 Stream 一样，也可能不同 。 终止操作会在最后 一个中间操作 产生的 Stream 上执行一个最终的计算， 例如将其元素保存到一个集合中，并返回某一个元素，或者打印出所有元素等。

Stream pipeline通常是 lazy 的 : 直到调用终止操作时才会开始计算 ，对于完成终止操作 不需要的数据元素，将永远都不会被计算 。 正是这种 lazy 计算，使无限 Stream 成为可能 。 注意，没有终止操作的 Stream pipeline将是一个静默的无操作指令 ，因此千万不能忘记终止操作。

**滥用Stream会使程序更难以读懂和维护。**最好的方法是，不要过度的使用Stream，适当的使用Stream。

**Stream方法经常会使用Lambda表达式，在对没有类型的变量命名需要更加清晰，增加其可读性。**

在 Streamn pipeline 中使 用 helpe方法（指的是常规的函数方法而不是Lambda表达式）可以增强代码的可读性。

**最好避免使用Stream处理Char值**，因为Char Stream返回的元素是int类型的而不是char类型的。如：

```java
"Hello World!".chars().forEach(System.out::print);
```

Out:

```
72101108108111328711111410810033
```

如果实在不确定用 Stream 还是用迭代比较好，那么就两种都试试，看看哪一种更好用。

**优先选择Stream中无副作用的函数**。（什么是无副作用的函数呢？指其结果只取决于输入的函数 : 它不依赖任何可 变的状态，也不更新任何状态 ）

**终止操作中的 forEach 应该只用来报告由 Stream 执行的计 算结果，而不是让它执行计算。**

**Stream 要优先用 Collection 作为返回类型**。如果返回的序列足够小，容易存储，或许最好返回标准的集合实现，如 ArrayList或者HashSet。 但是千万别在内存中保存巨大的序列，将它作为集合返回。



流只能使用一次，使用完（完成终端操作）就会被销毁：

```java
List<String> title = Arrays.asList("Modern", "Java", "In", "Action");
Stream<String> s = title.stream();
s.forEach(System.out::println);
s.forEach(System.out::println);
```

Out(报错，不能再使用已经使用过的流):

```
Modern
Java
In
Action
Exception in thread "main" java.lang.IllegalStateException: stream has already been operated upon or closed
	at java.util.stream.AbstractPipeline.sourceStageSpliterator(AbstractPipeline.java:279)
	at java.util.stream.ReferencePipeline$Head.forEach(ReferencePipeline.java:580)
	at com.sankuai.stafftraining.wujiahong.demo.springdemo.usages.MainApp.main(MainApp.java:22)
```



#### 中间操作和终端操作

中间操作会返回另一个流，除非流水线上触发一个终端操作，否则中间操作不会执行任何处理。（中间操作一般都可以合并起来，在终端操作时一次性全部处理）。

终端操作会从流的流水线生成结果，其结果是任何不是流的值，比如 List、Integer，甚至void。

中间操作函数：

| 操作     | 参数描述符     | 作用                                                         |
| -------- | -------------- | ------------------------------------------------------------ |
| filter   | T -> boolean   | 保留表达式中为true的元素                                     |
| map      | T -> R         | 转换元素的类型                                               |
| flatMap  |                | 各个数组并不是分别映􏲡成一个流，而是映射成流的内容            |
| limit    |                | 限制返回元素的个数，参数为元素的个数                         |
| sorted   | （T，T）-> int | 对元素进行排序                                               |
| distinct |                | 对所有元素去重，不需要参数.(根据流所生成元素的 hashCode 和 equals 方法实现) |
| skip     |                | 返回扔掉前n个元素的流                                        |
|          |                |                                                              |
|          |                |                                                              |

> skip和limit操作是互补的。



终端操作函数：

| 操作      | 返回类型      | 作用                                             |
| --------- | ------------- | ------------------------------------------------ |
| forEach   | void          | 使用Lambda消费流中的每个元素                     |
| count     | long          | 返回流最后元素的数量                             |
| collect   | generic       | 把流规约成一个集合，比如List、Map，甚至是Integer |
| anyMatch  | boolean       | 检查谓词是否至少匹配一个元素                     |
| allMatch  | boolean       | 检查谓词是否匹配所有元素                         |
| noneMatch | boolean       | 检查谓词是否全都不匹配                           |
| findAny   | Optional 对象 | 返回当前流中的任意元素                           |
| findFirst |               | 查找第一个元素                                   |
| reduce    |               | 归约，将多个元素合成一个                         |
|           |               |                                                  |

flatMap例子：

```java
        List<String> arrayOfWords = Lists.newArrayList("Goodbye", "World");

        List<String> uniqueCharacters =
            arrayOfWords.stream()
                .map(word -> word.split(""))
                .flatMap(Arrays::stream)
                .distinct()
                .collect(Collectors.toList());
        System.out.println(uniqueCharacters);
```

out：

```
[G, o, d, b, y, e, W, r, l]
```



reduce实现循环相加求和：

```java
int sum = numbers.stream().reduce(0, (a, b) -> a + b);
```

更优雅的写法：

```java
int product = nums.stream().reduce(0, Integer::sum);
```

找最大值和最小值：

```java
Optional<Integer> max = numbers.stream().reduce(Integer::max);
Optional<Integer> min = numbers.stream().reduce(Integer::min);
```





#### 消除非受检的警告

用泛型编程时会遇到讲多编译器警告 : 非受检转换警告( unchecked cast warning)、非受检方法调用警告、非受检参数化可变参数类型警告( unchecked parameterized vararg type warning)，以及非受检转换警告( unchecked conversion warning)。 

如果消除了所有警告，就可以确 保代码是类型安全的 这是一件很好的事情。

**应该始终在尽可能小的范围内使用 SuppressWarnings 注解。**

```java
@SuppressWarnings (“unchecked")
```



#### 列表优于数组

列表使用范型，而范型能够在编译时期就检查出类型的额问题。数组类型可能在运行时才报错。







### enum使用



#### 使用enum代替int

Java的枚举类型是功能十分齐全的类，其功能比其他语言中的对应类强大 得多， Java的枚举本质上是Int值

Java枚举类型的基本想法非常简单:这些类通过公有的静态 final域为每个枚举常量导 出一个实例。 枚举类型没有可以访问的构造器，所以它是真正的 final类。 客户端不能创建 枚举类型的实例，也不能对它进行扩展，因此不存在实例，而只存在声明过的枚举常 量 。 换 句话说，枚举类型是实例受控的(详见第 6 页) 。 它们是单例( Singleton) 的泛 型化，本质上是单元素的枚举 。









### 模版使用

如果你需要采用某个算法的框架，同时又希望有一定的灵活度，能对它的某些部分进行改进， 那么采用模板方法设计模式是比较通用的方案。换句话说，模板 方法模式在你**“希望使用这个算法，但是需要对其中的某些行进行改进**，才能达到希望的效果” 时是非常有用的。

> 好的 API 文档应该描述一个给定的方法做了什么工作，而不 是描述它是如何做到的 。 



模版设计方法









### Java并发

[CompletableFuture的原理与实践-记外卖商家端API的异步化](https://km.sankuai.com/page/947271480)

[CompletableFuture功能介绍与原理分析_尘间絮的专栏-CSDN博客](https://blog.csdn.net/dlxi12345/article/details/107767001)

同步模型的问题：

会有阻塞的时间。



异步主要是：**减少线程池的调度开销和阻塞时间**



CompletableFuture的优势：

- 可异步
- 可组合（编排）



应用场景：

[使用CompletableFuture异步执行循环中的任务 | localhost](http://zengyangcloud.com/archives/155/)

现在有一个需求：给你一批商品编号查询出商品的所有相关信息，这些商品信息并不能通过一条sql就直接获取到，需要对**每一件商品调用很多接口**来获取相关，因此查一件商品的耗时较长，如果查询的商品较多使用循环来执行的话，所耗费的时间肯定是特别长的。



CompletableFuture处理工具类：

- FutureUtils
- 



两个或者多个任务的异步执行。













### Useful方法



#### computeifAbsent

Java 8 中新增的 computeifAbsent 方法 。 这个方法会在映射中查找一个键:如果 这个键存在，该方法只会返回与之关联的值

```java
Map<Long, List<Long>> mm = Maps.newHashMap();
mm.computeIfAbsent(1L,key->Lists.newArrayList()).add(2L);
for (Entry<Long,List<Long>> kv:mm.entrySet()) {
  System.out.println(kv.getKey() +"---" +kv.getValue());
}
```

输出：

```
1---[2]
```

> 要是使用原始的方法，类似下面这样：
>
> ```java
> Map<Long, List<Long>> mm = Maps.newHashMap();
> if(CollectionUtils.isEmpty(mm.get(1))) {
> 	mm.put(1L,Lists.newArrayList());
> }
> for (Entry<Long,List<Long>> kv:mm.entrySet()) {
> 	System.out.println(kv.getKey() +"---" +kv.getValue());
> }
> 
> ```
>
> 这样没有使用computeIfAbsent方法简洁。







#### Map.uniqueIndex

根据key对列表创建Map映射。







#### groupby & groupingBy

groupingBy()是Stream API中最强大的收集器Collector之一，提供与SQL的GROUP BY子句类似的功能。

使用形式：

```java
.collect(groupingBy(...));
```

https://blog.csdn.net/daobuxinzi/article/details/100190366

分组：

```java
// 重新分组
Map<String, List<CompareStockVO>> detailMap = afterFilter.stream()
  .collect(Collectors.groupingBy(compareStockVO -> StringUtils
                                 .joinWith("-", compareStockVO.getPoiId(), compareStockVO.getSkuId(),
                                           compareStockVO.getSupplierId())));
```





另外一种聚合的方法：

```java
// 聚合
Map<String, WmsStockSkuLotExpiryPO> poiLot2Expire = lotExpiryPOS.stream().collect(
  Collectors.toMap(
    lotExpiryPO -> expirySyncService
    .getExpiryEsKey(lotExpiryPO.getLotId(), lotExpiryPO.getPoiId()),
    a -> a, (k1, k2) -> k1));
```



聚合：

```
// 重新聚合
        List<CompareStockVO> result = Lists.newArrayList();
        for (List<CompareStockVO> compareStockVOList : detailMap.values()) {
            Optional<CompareStockVO> compareStockVO = compareStockVOList.stream()
                    .reduce((left, right) -> {
                        left.setQuantity(left.getQuantity().add(right.getQuantity()));
                        left.setLockQuantity(left.getLockQuantity().add(right.getLockQuantity()));
                        return left;
                    });
            if (compareStockVO.isPresent()) {
                result.add(compareStockVO.get());
            }
        }
```





#### partition

将一个列表划分成多个列表，参数是每个列表的大小：

```java
List<List<Long>> subLists = Lists.partition(result,20);
List<List<Integer>> subSets = ListUtils.partition(intList, 3);
```



#### flatMap

[Java8 Stream使用flatMap合并List](https://blog.csdn.net/weixin_41835612/article/details/83713891)









#### CompletableFuture

[CompletableFuture的使用](https://km.sankuai.com/page/212004627)









