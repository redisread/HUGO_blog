---
title: Java并发原理和探索
date: 2022-03-22T16:00:36+08:00
description: Java并发模块，Java的利器之一。待补充
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







缓存一致性







happens-beforeg规则：

1. 程序顺序规则：一个线程中的每个操作，happens-before于该线程的任意后续操作。
2. 监视器锁规则：对一个锁的解锁，happens-before于随后对这个锁的加锁。
3. volatile变量规则：对一个volatile域的写，happens-before于任意后续对这个volitile域的读。
4. 传递性：􏰋􏰂A happens-before B􏰚􏲘B happens-before C􏰚􏰅􏱂A happens-before C􏰕















---

***Reference***:

1. 《Java并发编程的艺术》
