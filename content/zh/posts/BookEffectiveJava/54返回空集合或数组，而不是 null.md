---
title: 54返回空集合或数组，而不是 null
date: 2021-11-14T17:57:59+08:00
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





**永远不要用 null 来代替空数组或集合**。它使你的 API 更难以使用，更容易出错，并且没有性能优势。

有时有人认为，空返回值比空集合或数组更可取，因为它避免了分配空容器的开销。这个论点有两点是不成立的。

1. 首先，在这个级别上担心性能是不明智的，除非分析表明这个方法正是造成性能问题的真正源头。

2. 第二，返回空集合和数组而不分配它们是可能的。使用静态的常量并返回即可。

   重复返回相同的不可变空集合来避免分配：

   1. Collections.emptyList
   2. Collections.emptySet
   3. Collections.emptyMap



数组的情况与集合的情况相同。永远不要返回 null，而应该返回零长度的数组。

```java
public Cheese[] getCheeses() {
    return cheesesInStock.toArray(new Cheese[0]);
}
```















---

***Reference***:

