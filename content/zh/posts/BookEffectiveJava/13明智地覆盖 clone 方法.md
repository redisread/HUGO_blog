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

> mixin 接口很可能是指一种带有全部实现或者部分实现的接口，其主要作用是：
>
> 1. 更好的进行代码复用；
> 2. 间接实现多重继承；
> 3. 扩展功能。与传统接口相比，传统接口中不带实现，而 mixin 接口带有实现。









克隆模式





---

***Reference***:

1. [Item 13: Override clone judiciously（明智地覆盖 clone 方法）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-3/Chapter-3-Item-13-Override-clone-judiciously.md)
