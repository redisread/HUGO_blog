---
title: 55明智地的返回 Optional
date: 2021-11-14T18:05:50+08:00
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



Optional主要是在某些情况下无法返回值的情况下使用。以往没有Optional的话，要么返回null，要么抛出异常。

1. 返回null。

   返回null很简单，但是如果外层调用没有对null进行判断的话，就会出现问题。（null可以被赋值给任何元素）

2. 抛出异常。

   抛出异常的代价非常大。（因为在创建异常时捕获整个堆栈跟踪）

`Optional<T>` 类表示一个不可变的容器，它可以包含一个非空的 T 引用，也可以什么都不包含。不包含任何内容的 Optional 被称为空。一个值被认为存在于一个非空的 Optional 中。Optional 的本质上是一个不可变的集合，它最多可以容纳一个元素。

写法样例：

```java
public static <E extends Comparable<E>> Optional<E> max(Collection<E> c) {
    if (c.isEmpty())
        return Optional.empty();
    E result = null;
    for (E e : c)
        if (result == null || e.compareTo(result) > 0)
    result = Objects.requireNonNull(e);
    return Optional.of(result);
}
```

在这个程序中，我们使用了两个静态工厂：`Optional.empty()` 返回一个空的 Optional，`Optional.of(value)` 返回一个包含给定非空值的可选值。将 null 传递给 `Optional.of(value)` 是一个编程错误。如果你这样做，该方法将通过抛出 NullPointerException 来响应。



> 并不是所有的返回类型都能从 Optional 处理中获益。**容器类型，包括集合、Map、流、数组和 Optional，不应该封装在 Optional 中。** 你应该简单的返回一个空的 `List<T>`，而不是一个空的 `Optional<List<T>>`

除了作为返回值之外，你几乎不应该以任何其他方式使用 Optional。





---

***Reference***:

