---
title: 60若需要精确答案就应避免使用 float 和 double 类型
date: 2021-11-19T11:09:53+08:00
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



float 和 double 类型主要用于科学计算和工程计算。它们执行二进制浮点运算，该算法经过精心设计，能够在很大范围内快速提供精确的近似值。但是，它们不能提供准确的结果，也不应该在需要精确结果的地方使用。**float 和 double 类型特别不适合进行货币计算**，因为不可能将 0.1（或 10 的任意负次幂）精确地表示为 float 或 double。



例如:

```java
System.out.println(1.03 - 0.42);
System.out.println(1.00 - 9 * 0.10);
```

上面的两个输出为：

```
0.6100000000000001
0.09999999999999998
```

反而更加不精确了。



更好的方式是使用Integer、Long等这些整型的类型或者是使用BigDecimal这个类(BigDecimal效率低)。或者可以自己管理小数。



---

***Reference***:

1. [Effective-Java-3rd-edition-Chinese-English-bilingual/Chapter-9-Item-60-Avoid-float-and-double-if-exact-answers-are-required.md at dev · clxering/Effective-Java-3rd-edition-Chinese-English-bilingual](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-9/Chapter-9-Item-60-Avoid-float-and-double-if-exact-answers-are-required.md)
2. 
