---
title: 34用枚举类型代替 int 常量
date: 2021-11-05T16:49:42+08:00
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



### 枚举的好处

1. 封装，不易混乱
2. 类型检查。

Java 的枚举类型是成熟的类，比其他语言中的枚举类型功能强大得多，在其他语言中的枚举本质上是 int 值。

Java枚举背后的原理：通过 public static final 修饰的字段为每个枚举常量导出一个实例的类。单例本质上是单元素的枚举。

一般来说，枚举在性能上可与 int 常量相比。枚举在性能上有一个小缺点，加载和初始化枚举类型需要花费空间和时间，但是在实际应用中这一点可能不太明显。

### 什么时候应该使用枚举？

**在需要一组常量时使用枚举，这些常量的成员在编译时是已知的。** 当然，这包括「自然枚举类型」，如行星、星期几和棋子。但是它还包括其他在编译时已知所有可能值的集合，例如菜单上的选项、操作代码和命令行标志。**枚举类型中的常量集没有必要一直保持固定。** 枚举的特性是专门为枚举类型的二进制兼容进化而设计的。

> 在分布式领域，微服务场景下，或者前后端领域，因为需要不同语言进行通信，所以枚举中的常量的值应该在前端和后端保持一致，这点需要考虑。

---

***Reference***:

1. [Item 34: Use enums instead of int constants（用枚举类型代替 int 常量）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-6/Chapter-6-Item-34-Use-enums-instead-of-int-constants.md)
