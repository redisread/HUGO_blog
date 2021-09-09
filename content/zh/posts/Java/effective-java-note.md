---
title: effective java 笔记📒
date: 2021-09-09T11:14:17+08:00
description: 记录Effective Java的一些重点
draft: true
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

### 避免创建不必要的对象

一般来说，最好能够重用单个对象。下面是一个极端的例子：

```java
String s = new String("Hello");
```

上面的语句加入存在一个循环中，就会创建很多个String实例。最好这样：

```java
String s = "hello";
```

因为Java内部对这些基本的类型做了很多的优化，字符串一般都是作为常量存储在内存中，当我们执行多个普通的语句，不会创建多个对象，而是都是同一个对象的引用。

相似的还有：

- 静态工厂方法`Boolean.valueOf()`总是返回True或者False的常量
- 整型变量在-127-128也默认在内存中进行了缓存，也就是说，当我们使用普通的装箱语句申明一个变量并且在这个范围内，指向的都是同一个对象的引用。

总结：

**对于基本的数据类型，直接使用Java默认的装箱拆箱机制就可以了，不需要显示的创建一个对象来申明一个变量。**

但是，需要避免频繁的装箱拆箱：

```java
private static long sum() {
  Long sum = 0;
  for (long i = 0; i <= Integer.MAX_VALUE; i++) {
    sum += i;
  }
  return sum;
}
```

上面只是因为变量sum的类型为Long（是一个包装对象类型），而变量i是基本数据类型long，将i加到sum的过程中会频繁的对long进行装箱成Long对象，使得做了很多多余的操作。这种情况下要优先使用基本类型而不是装箱基本类型，当心无意识的装箱和拆箱。



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
| limit    |                | 限制返回元素的个数，参数为元素的个数                         |
| sorted   | （T，T）-> int | 对元素进行排序                                               |
| distinct |                | 对所有元素去重，不需要参数.(根据流所生成元素的 hashCode 和 equals 方法实现) |
|          |                |                                                              |

终端操作函数：

| 操作    | 返回类型 | 作用                                             |
| ------- | -------- | ------------------------------------------------ |
| forEach | void     | 使用Lambda消费流中的每个元素                     |
| count   | long     | 返回流最后元素的数量                             |
| collect | generic  | 把流规约成一个集合，比如List、Map，甚至是Integer |
|         |          |                                                  |
|         |          |                                                  |







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
