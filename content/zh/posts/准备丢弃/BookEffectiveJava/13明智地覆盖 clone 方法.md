---
title: 13明智地覆盖 clone 方法
date: 2021-10-30T22:05:03+08:00
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

### clone方法的作用

Cloneable 接口的目的是作为 mixin 接口（[Item-20](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-4/Chapter-4-Item-20-Prefer-interfaces-to-abstract-classes.md)），用于让类来宣称它们允许克隆。

> mixin 接口很可能是指**一种带有全部实现或者部分实现的接口**，其主要作用是：
>
> 1. 更好的进行代码复用；
> 2. 间接实现多重继承；
> 3. 扩展功能。与传统接口相比，传统接口中不带实现，而 mixin 接口带有实现。
>
> 这个特殊的混合接口极其奇怪的是，它并不要求实现一个特定的函数，而只是作为一个标志，允许实现类调用父类上的一个方法。

Cloneable 接口和 clone 方法。

### clone方法的约定

它不包括任何方法，而是作为Object类中受保护的clone方法的一个标志。

如果一个类在Object上调用clone，并且该类实现了Cloneable，那么Object的clone实现将返回一个逐字段的对象副本。如果该类没有实现Cloneable，就会抛出一个CloneNotSupportedException。约定如下：

1. 实现类应该创建一个调用 `super.clone()` 方法的公共克隆类。
2. `(x.clone() != x) == true`。简单地说，clone 应该返回一个新对象，而不仅仅是返回当前对象。
3. `(x.clone().getClass() == x.getClass() == true`。这不是绝对要求，而是预期的。
4. `x.clone.equals(x) == true` 同样，这不是绝对要求。

看看`clone`这个`Stack`类的一个工作方法：

```java
@Override
public class Stack clone() {
  try {
    // this gets us a replica with copied size field
    Stack copy = (Stack) super.clone();
    copy.elements = elements.clone();
    return copy;
  } catch (CloneNotSupportedException impossible) {
    throw new AssertionError();
  }
}
```

现在我们正在有效地克隆我们的`Stack`类。我们`clone`方法中的这种递归调用可以解决 clone 方法的很多问题，但不是全部。还有其他的东西需要考虑：

- 因为`clone`方法类似于构造函数，所以它们不应该调用可覆盖的方法。
- 即使`Object`的`clone`方法抛出`CloneNotSupportedException`，您的覆盖也不应该。
- 在设计继承类时，您有两种选择。使用`clone`与`Object`'s相同的签名实现方法，让实现类可以自由选择是否实现`Cloneable`。另一种选择是实现`clone`并简单地抛出`CloneNotSupportedException`这将阻止克隆。
- 如果您的类需要线程安全，请记住您的`clone`实现也需要同步。`Object`的`clone`方法不同步。

### 使用clone的注意

有这么多的约束，那是不是应该使用clone函数呢。大概率不是。

有很多更加简单的方法可以实现类似的功能：拷贝构造函数或拷贝工厂可以以更直接的方式完成工作。

拷贝构造函数：

```java
public class Address(Address originalAddress) { ... }
```

拷贝工厂：

```java
public static Address newInstance(Address originalAddress) { ... }
```

这些方法的好处：

- 它们不依赖于字段对字段复制的容易出错、不明显的行为。
- 他们不需要遵循非显而易见和无证的约定。（例如不能调用被覆盖的函数）
- 与 final 字段的使用不冲突。
- 不需要我们处理不必要的检查异常。
- 它们允许类实现的接口类型的参数。这就是我们在标准库中看到的集合所做的事情。

### 总结

长话短说，您可能不应该实现 Cloneable 接口。而是使用其他模式，例如拷贝构造函数或拷贝工厂。通过使用这些方法，您应该拥有更好的体验并且代码库的错误更少。

---

***Reference***:

1. [Item 13: Override clone judiciously（明智地覆盖 clone 方法）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-3/Chapter-3-Item-13-Override-clone-judiciously.md)
2. [Effective Java Tuesday! Override `clone` judiciously - DEV Community 👩‍💻👨‍💻](https://dev.to/kylec32/effective-java-tuesday-override-clone-judiciously-4fg)
