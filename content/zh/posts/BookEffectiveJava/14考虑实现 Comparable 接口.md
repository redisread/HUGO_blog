---
title: 14考虑实现 Comparable 接口
date: 2021-11-04T11:11:25+08:00
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



<!--第三章：对象的通用方法-->

### Comparable接口的作用

Comparable方法主要是用于同种对象之间进行比较或者是排序使用的。更常见的是用来排序使用。

Comparable接口声明：

```java
public interface Comparable<T> {
  public int compareTo(T o);
}
```

> java类库中所有值类以及所有枚举类都实现了这个接口，比如按数值大小，字母顺序，字符长度等，都应该考虑实现这个接口。

### compareTo 方法约定

将一个对象与指定的对象进行顺序比较。当该对象小于、等于或大于指定对象时，对应返回一个负整数、零或正整数。如果指定对象的类型阻止它与该对象进行比较，则抛出 ClassCastException。

### 总结

无论何时实现具有排序性质的值类，都应该让类实现 Comparable 接口，这样就可以轻松地对实例进行排序、搜索，并与依赖于此接口的集合实现进行互操作。在 compareTo 方法的实现中比较字段值时，避免使用 < 和 > 操作符，应使用包装类中的静态比较方法或 Comparator 接口中的 comparator 构造方法。



---

***Reference***:

1. [Item 14: Consider implementing Comparable（考虑实现 Comparable 接口）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-3/Chapter-3-Item-14-Consider-implementing-Comparable.md)
2. [考虑实现 Comparable 接口](https://blog.csdn.net/weixin_44130081/article/details/90288926)
