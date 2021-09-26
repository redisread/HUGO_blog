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





### 范型使用注意

没有范型之前，从集合中读取的每一个对象都必须进行转换。如果有人不小心插入了类型错误的对象，在运行时的转化处理就会出错。有了范型之后，可以告诉编译器每个集合中接受哪些对象类型。编译器自动为你的插入进行转换，并且会在编译时告知插入了类型错误的对象。这样可 以使程序更加安全，也更加清楚。

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









### 范型使用

什么是泛型？为什么要使用泛型？

**泛型的本质是为了参数化类型（在不创建新的类型的情况下，通过泛型指定的不同类型来控制形参具体限制的类型）**。



#### 范型方法

Java中泛型类的定义也比较简单，例如：

```java
public class Test<T>{}
```

这样就定义了一个泛型类Test，在实例化该类时，必须指明泛型T的具体类型，例如：

```java
Test<Object> t = new Test<Object>();
```

指明泛型T的类型为Object。



#### 范型类

定义范型方法的格式：

<img src="https://cos.jiahongw.com/uPic/09221852-b0d764f4340946baa1a063da5a0d993e.png" alt="范型方法格式" style="zoom: 67%;" />

定义泛型方法时，必须在返回值前边加一个<T>，来声明这是一个泛型方法，持有一个泛型T，然后才可以用泛型T作为方法的返回值。



调用范型方法的格式：



---

Ref：

1. [Java 泛型 | 菜鸟教程](https://www.runoob.com/java/java-generics.html)
2. [Java中的泛型方法 - 杨元 - 博客园](https://www.cnblogs.com/iyangyuan/archive/2013/04/09/3011274.html)











### Java异常的使用

Java包含两种异常：**checked异常**和**unchecked异常**。checked和unchecked异常之间的区别是：

1. Checked异常必须被显式地捕获或者传递，如Basic try-catch-finally Exception Handling一文中所说。而unchecked异常则可以不必捕获或抛出。
2. Checked异常继承java.lang.Exception类。Unchecked异常继承自java.lang.RuntimeException类。

> Checked和unchecked异常从功能的角度来讲是等价的。可以用checked异常实现的功能必然也可以用unchecked异常实现，反之亦然。

![异常层次结构](https://cos.jiahongw.com/uPic/20160326233035366.jpeg)

#### checked异常

如果方法抛出**受检异常**，调用该方法 的代码就必须在一个或者多个 catch块中处理这些异常，或者它必须声明抛出这些异常，并让它们传播出去 。 这种负担在 Java 8 中更重了，因为抛出受检异常的方法不能直接在 Stream 中使用。

<img src="https://cos.jiahongw.com/uPic/image-20210923144219607.png" alt="image-20210923144219607" style="zoom:50%;" />

如果使用 API 的程序员无法做得比这更好那么未受检的异常可能更为合适 。

在谨慎使用的前提之下，受检异常可以提升程序的可读性;如果过度使用， 将会使 API 使用起来非常痛苦 。 如果调用者无法恢复失败，就应该抛出未受检异常 。 如果 可以恢复，并且想要迫使调用者处理异常的条件，首选应该返回一个 optional 值 。 当且仅当 万一失败时，这些无法提供足够的信息，才应该抛出受检异常 。



#### unchecked异常

你实现的所有未受检的抛出结构都应该是 RuntimeException 的子类 。不仅不应该 定义 Error 子类，甚至也不应该抛出 AssertionError 异常 。

> **派生于Error或者RuntimeException的异常称为unchecked异常**

unchecked异常通常都是运行时的异常，一般是由程序员的代码错误导致的。使用unchecked异常可以让代码更加的简洁。可以不需要显式地通过try-catch捕获或者再抛出。

#### 异常的传播

捕获异常：

```java
try {
  ...
} catch (Exception e) {
  e.printStackTrace();
}

```

沿调用栈向上传播异常:

```java
public void storeDataFromUrl(String url) throws BadException{
  ...
}

```

如果在当前方法不知道该如何处理该异常时，则可以使用throws对异常进行抛出给调用者处理或者交给JVM。JVM对异常的处理方式是：打印异常的跟踪栈信息并终止程序运行。

#### 异常使用建议

- 实际上，基于异常的模式比标准模式要慢得多。

- 异常应该只用于异常的情况下;它们永远不应该 用于正常的控制流。

- 设计良好的 API 不应该强迫它的客户端为了正常的 控制流而使用异常。

- 对可恢复的情况使用受检异常，对编程错误使用运行时异常。

-  如果你相信一种情况可能允许恢复，就使用受检的异常;如果 不是，则使用运行时异常 。 如果不清楚是否有可能恢复，最好使用未受检的异常。

- 要在受检异常上提供方法，以便协助恢复。

- 优先使用标准的异常。（代码重用）

- 不要直接重用 Exception、 RuntimeException, Throwable 或者 Error。 对待 这些类要像对待抽象类一样。 你无法可靠地测试这些异常，因为它们是一个方法可能抛出的 其他异常的超类 。

  可重用异常：

  <img src="https://cos.jiahongw.com/uPic/image-20210923144748559.png" alt="image-20210923144748559" style="zoom:50%;" />

- 如果没有可用的参 数值，就抛出工 llegalStateExceptio凡否则就抛出工 llegalArgumentException.

- 异常类型的 toString 方法应该尽可能多地返回有关失败原因的信息，这一点特别重要 。 (或者在日志中体现出来)

---

Ref:

1. [Java异常：选择Checked Exception还是Unchecked Exception?___kingzone__的专栏-CSDN博客_checkedexception](https://blog.csdn.net/kingzone_2008/article/details/8535287)
2. 《Effective Java》



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



#### partition

将一个列表划分成多个列表，参数是每个列表的大小：

```java
List<List<Long>> subLists = Lists.partition(result,20);
List<List<Integer>> subSets = ListUtils.partition(intList, 3);
```





