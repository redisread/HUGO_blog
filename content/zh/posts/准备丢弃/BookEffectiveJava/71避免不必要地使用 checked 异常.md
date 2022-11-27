---
title: 71避免不必要地使用 checked 异常
date: 2021-11-25T16:57:40+08:00
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







checked异常会强制程序员处理问题，提高了可靠性。但是，往往在实际编写代码的过程中，如果一个方法抛出 checked 异常，调用它的代码必须在一个或多个 catch 块中处理它们；或者通过声明抛出，让它们向外传播。这样的话，API会变得非常臃肿。

下面的异常处理方法都是糟糕的：

```java
// 1
} catch (TheCheckedException e) {
    throw new AssertionError(); // Can't happen!
}
// 2
} catch (TheCheckedException e) {
    e.printStackTrace(); // Oh well, we lose.
    System.exit(1);
}
```

因为没有对checked异常进行很好的修复，向外抛出异常或者停止程序都不是一个好的方法。

此时，有两种方法

1 消除checked异常

消除 checked 异常的最简单方法是返回所需结果类型的 Optional 对象。该方法只返回一个空的 Optional 对象，而不是抛出一个 checked 异常。这种技术的缺点是，该方法不能返回任何详细说明其无法执行所需计算的附加信息。相反，异常具有描述性类型，并且可以导出方法来提供附加信息。

![image-20211125172206167](https://cos.jiahongw.com/uPic/image-20211125172206167.png)

2 使用unchecked异常

这些是编译时不检查的异常。Unchecked Exception表示一种通常反映程序逻辑中错误的情况，这种情况在运行时无法恢复。

总之，如果谨慎使用，checked 异常可以提高程序的可靠性；当过度使用时，它们会使 API 难以使用。如果调用者不应从失败中恢复，则抛出 unchecked 异常。如果恢复是可能的，并且你希望强制调用者处理异常条件，那么首先考虑返回一个 Optional 对象。只有当在失败的情况下，提供的信息不充分时，你才应该抛出一个 checked 异常。

---

***Reference***:

1. [Effective-Java-3rd-edition-Chinese-English-bilingual/Chapter-10-Item-71-Avoid-unnecessary-use-of-checked-exceptions.md at dev · clxering/Effective-Java-3rd-edition-Chinese-English-bilingual](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-10/Chapter-10-Item-71-Avoid-unnecessary-use-of-checked-exceptions.md)
2. [选中的(checked)和未检查的异常(unchecked exception)的区别 - tl80互动问答网](https://www.tl80.cn/article/196846)
