---
title: 89对于实例控制，枚举类型优于 readResolve
date: 2021-11-21T13:56:12+08:00
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





实现序列化的类如何保证单例？（如果单例模式的类加上了implements Serializable, 就多了一种创建实例的途径）

实现readResolve 方法就足以保证其单例属性：

```java
// readResolve for instance control - you can do better!
private Object readResolve() {
    // Return the one true Elvis and let the garbage collector
    // take care of the Elvis impersonator.
    return INSTANCE;
}
```

此方法忽略反序列化对象，返回初始化类时创建的单例。

**如果你依赖 readResolve 进行实例控制，那么所有具有对象引用类型的实例字段都必须声明为 transient。** 否则，有的攻击者有可能在运行反序列化对象的 readResolve 方法之前保护对该对象的引用。



如果有一个对象的引用类型没有声明为transient，那么可以新建一个内部的字段隐藏在其中，用于替换哪个没有声明为transient的字段，最后因为新建的内部字段替换了原来的字段，又包含外部类的引用，所以可以进行攻击。



如果你将可序列化的实例控制类编写为枚举类型, Java 保证除了声明的常量之外不会有任何实例，除非攻击者滥用了特权方法，如 `AccessibleObject.setAccessible`。任何能够做到这一点的攻击者都已经拥有足够的特权来执行任意的本地代码，all bets are off。以下是把 Elvis 写成枚举的例子

```java
// Enum singleton - the preferred approach
public enum Elvis {
    INSTANCE;
    private String[] favoriteSongs ={ "Hound Dog", "Heartbreak Hotel" };
    public void printFavorites() {
        System.out.println(Arrays.toString(favoriteSongs));
    }
}
```



总之，在可能的情况下，使用枚举类型强制实例控制不变量。如果这是不可能的，并且你需要一个既可序列化又实例控制的类，那么你必须提供一个 readResolve 方法，并确保该类的所有实例字段都是基本类型，或使用 transient 修饰。







---

***Reference***:

