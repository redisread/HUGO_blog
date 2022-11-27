---
title: 58for-each 循环优于传统的 for 循环
date: 2021-11-18T17:18:43+08:00
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



for循环：

```java
// Not the best way to iterate over an array!
for (int i = 0; i < a.length; i++) {
    ... // Do something with a[i]
}
// Not the best way to iterate over a collection!
for (Iterator<Element> i = c.iterator(); i.hasNext(); ) {
    Element e = i.next();
    ... // Do something with e
}
```

For-each循环：

```java
// The preferred idiom for iterating over collections and arrays
for (Element e : elements) {
    ... // Do something with e
}
```

> 使用 for-each 循环不会降低性能，对于数组也是如此：它们生成的代码本质上与你手工编写的 for 循环代码相同

使用for-each循环的好处：

for-each 循环在清晰度、灵活性和 bug 预防方面比传统的 for 循环更有优势，并且没有性能损失

什么时候不应该使用for-each循环？

1. 破坏性过滤。（例如remove）
2. 转换。（替换其中部分或者全部元素）
3. 并行迭代。

---

***Reference***:
