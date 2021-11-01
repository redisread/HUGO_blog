---
title: Java虚拟机原理
date: 2021-10-26T16:26:58+08:00
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





### Why JVM？

1. Java虚拟机提供了许多配置参数，用于满足不同应用场景下，对程序性能的需求。

   在不同的业务场景使用不同的参数。查看本机上的Java参数使用：

   ```java
   java -XX:+PrintFlagsFinal -XX:+UnlockDiagnosticVMOptions -version | wc -l
   ```

   ![JVM参数](https://cos.jiahongw.com/uPic/image-20211028152016639.png)

2. 学习Java虚拟机，可以更好地规避它在使用中的Bug，也可以更快地识别出Java虚拟机中的错误。

3. Java虚拟机发展到了今天，已经脱离Java语言，形成了一套相对独立的、高性能的执行方案。

   除了Java外，Scala、Clojure、Groovy，以及时下热门的Kotlin，这些语言都可以运行在Java虚拟机之上。学习Java虚拟机，便可以了解这些语言的通用机制，甚至于让这些语言共享生态系统。甚至有一些还将C/C++代码编译成中间代码，再使用JVM进行运行。

4. 













概念

- JVM：Java Virtual Machine Java虚拟机
- JRE：Java Run Environment  java运行时环境
- JDK：Java Develop Kit Java开发套件







### 自动内存管理



#### JVM内存分区







#### 垃圾回收算法

引用计数法



可达性分析算法











#### HotSpotGC算法细节





#### HotSpot垃圾回收器































---

***Reference***:

