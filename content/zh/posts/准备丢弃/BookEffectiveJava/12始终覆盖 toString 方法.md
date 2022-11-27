---
title: 12始终覆盖 toString 方法
date: 2021-10-30T21:51:20+08:00
description: Always override toString.
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

### toString方法有什么用？

虽然 Object 提供 toString 方法的实现，但它返回的字符串通常不是类的用户希望看到的。它由后跟「at」符号（@）的类名和 hash 代码的无符号十六进制表示（例如 PhoneNumber@163b91）组成。

![toString方法](https://cos.jiahongw.com/uPic/image-20211030215411392.png)

这其实并不能表示类内部的具体信息，它的信息量并不大。toString 约定接着描述，「建议所有子类覆盖此方法。」

> **提供一个好的 toString 实现（能）使类更易于使用，使用该类的系统（也）更易于调试。**

**当实际使用时，toString 方法应该返回对象中包含的所有有趣信息，** 如电话号码示例所示。如果对象很大，或者包含不利于字符串表示的状态，那么这种方法是不切实际的。在这种情况下，toString 应该返回一个摘要，例如曼哈顿住宅电话目录（1487536 号清单）或 Thread[main,5,main]。理想情况下，字符串应该是不言自明的。（线程示例未能通过此测试。）如果没有在字符串表示中包含所有对象的有趣信息，那么一个特别恼人的惩罚就是测试失败报告，如下所示：

```java
Assertion failure: expected {abc, 123}, but was {abc, 123}.
```

假如在toString函数中指定了返回的格式，就应该精确地指定格式，并且添加上详细的注释。

> 另外，使用编译器（例如IDEA）生成的toString方法会比我们手写更加可靠。

在你编写的每个实例化类中覆盖对象的 toString 实现，除非超类已经这样做了。它使类更易于使用，并有助于调试。toString 方法应该以美观的格式返回对象的简明、有用的描述。

---

***Reference***:

1. [Item 12: Always override toString（始终覆盖 toString 方法）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-3/Chapter-3-Item-12-Always-override-toString.md)
