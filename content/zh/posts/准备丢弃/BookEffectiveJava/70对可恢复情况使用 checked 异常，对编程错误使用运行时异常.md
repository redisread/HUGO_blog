---
title: 70对可恢复情况使用 checked 异常，对编程错误使用运行时异常
date: 2021-11-25T16:08:44+08:00
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



Java包含两种异常：**checked异常**和**unchecked异常**。checked和unchecked异常之间的区别是：

1. Checked异常必须被显式地捕获或者传递，如Basic try-catch-finally Exception Handling一文中所说。而unchecked异常则可以不必捕获或抛出。
2. Checked异常继承java.lang.Exception类。Unchecked异常继承自java.lang.RuntimeException类。

> Checked和unchecked异常从功能的角度来讲是等价的。可以用checked异常实现的功能必然也可以用unchecked异常实现，反之亦然。

决定是使用 checked 异常还是 unchecked 异常的基本规则是：**使用 checked 异常的情况是为了合理地期望调用者能够从中恢复。** **使用运行时异常来指示编程错误。**

> 如果你认为某个条件可能允许恢复，请使用 checked 异常；如果没有，则使用运行时异常。如果不清楚是否可以恢复，最好使用 unchecked 异常。

还有一种可抛出项是Error

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

- 如果你相信一种情况可能允许恢复，就使用受检的异常;如果 不是，则使用运行时异常 。 如果不清楚是否有可能恢复，最好使用未受检的异常。

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

---

***Reference***:
