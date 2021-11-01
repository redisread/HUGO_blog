---
title: 单例模式
date: 2021-10-21T15:31:40+08:00
description: 单例模式是一种创建型设计模式， 让你能够保证一个类只有一个实例， 并提供一个访问该实例的全局节点。
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://cos.jiahongw.com/uPic/singleton.png
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









#### 饿汉式

饿汉式的实现方式比较简单。在类加载的时候，instance静态实例就已经创建并初始化好了，所以，instance实例的创建过程是线程安全的。不过，这样的实现方式不支持延迟加载（在真正用到IdGenerator的时候，再创建实例），从名字中我们也可以看出这一点。







#### 懒汉式

有饿汉式，对应的，就有懒汉式。懒汉式相对于饿汉式的优势是支持延迟加载。







#### 双重检测

饿汉式不支持延迟加载，懒汉式有性能问题，不支持高并发。那我们再来看一种既支持延迟加载、又支持高并发的单例实现方式，也就是双重检测实现方式。

在这种实现方式中，只要instance被创建之后，即便再调用getInstance()函数也不会再进入到加锁逻辑中了。所以，这种实现方式解决了懒汉式并发度低的问题。







#### 静态内部类





#### 枚举

最简单的实现方式，基于枚举类型的单例实现。这种实现方式通过Java枚举类型本身的特性，保证了实例创建的线程安全性和实例的唯一性。



---

***Reference***:

1. [单例设计模式](https://refactoringguru.cn/design-patterns/singleton)
2. [43 42 | 单例模式（中）：我为什么不推荐使用单例模式？又有何替代方案？](https://km.sankuai.com/page/462615827)

