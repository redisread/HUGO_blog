---
title: 36用 EnumSet 替代位字段
date: 2021-11-11T16:39:58+08:00
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





### 位域操作

位域表示一个bit的数据，在C/C++语言比较常用。使用位域通常比较高效，但是可读性差。例如：

```java
public class BitTest {
    public static final int A = 1 << 0; // 1
    public static final int B = 1 << 1; // 2
    public static final int C = 1 << 2; // 4

    public void doSomething(int value){...}
}
```

实际调用的时候可以使用常量进行组合(`A|B = 3`)：

```java
bitTest.doSomething(A | B);
```



### EnumSet代替位域操作

> 在内部具体的实现上，每个EnumSet内容都表示为位矢量。

使用位域晦涩难懂，使用枚举可以增强可读性。

```java
public class BitTest {
    public enum Value {
        A,B,C;
    }
    public void doSomething(Set<Value> values) { ... }
}
```

调用使用EnumSet进行组合即可：

```java
bitTest.doSomething(EnumSet.of(Value.A, Value.B));
```



> EnumSet 的一个真正的缺点是，从 Java 9 开始，它不能创建不可变的 EnumSet，在未来发布的版本中可能会纠正这一点。同时，可以用 `Collections.unmodifiableSet` 包装 EnumSet，但简洁性和性能将受到影响。

---

***Reference***:

1. [EnumSet的最佳实践-码迷移动版-m.mamicode.com](http://m.mamicode.com/info-detail-112324.html)
2. [Item 36: Use EnumSet instead of bit fields（用 EnumSet 替代位字段）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-6/Chapter-6-Item-36-Use-EnumSet-instead-of-bit-fields.md)
3. [Java中EnumSet代替位域的示例分析 - 编程语言 - 亿速云](https://www.yisu.com/zixun/209538.html)
