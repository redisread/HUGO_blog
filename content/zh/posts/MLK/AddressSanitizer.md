---
title: AddressSanitizer Tool
date: 2021-01-07T10:09:40+08:00
description: A Fast Address Sanity Checker
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/01/07/p8frJDq2YzFPIbu.png
libraries:
- katex
- mathjax
tags:
- MLK
series:
- MLK
categories:
-
---



# AddressSanitizer



## 基本介绍

官网：[http://clang.llvm.org/docs/AddressSanitizer.html](http://clang.llvm.org/docs/AddressSanitizer.html)

源码：[https://github.com/google/sanitizers](https://github.com/google/sanitizers)

文档：[https://github.com/google/sanitizers/wiki/AddressSanitizer](https://github.com/google/sanitizers/wiki/AddressSanitizer)

## 支持

|               |      |        |      |       |      |        |         |           |
| ------------- | ---- | ------ | ---- | ----- | ---- | ------ | ------- | --------- |
| OS            | x86  | x86_64 | ARM  | ARM64 | MIPS | MIPS64 | PowerPC | PowerPC64 |
| Linux         | yes  | yes    |      |       | yes  | yes    | yes     | yes       |
| OS X          | yes  | yes    |      |       |      |        |         |           |
| iOS Simulator | yes  | yes    |      |       |      |        |         |           |
| FreeBSD       | yes  | yes    |      |       |      |        |         |           |
| Android       | yes  | yes    | yes  | yes   |      |        |         |           |

## 安装

```
llvm==3.4.2，yum -y install clang && yum -y install gcc gcc-c++ 
```

## 使用

### 基本要求

1. llvm>3.1，clang编译
2. 编译时不允许使用-static参数（不支持静态链接）
3. 尽量不加-O2和-O1（实测检测会失效，具体项待验证）
4. Clang与gcc不能混用编译或链接

### 基本使用方法

#### 选项

* 用-fsanitize=address选项编译和链接你的程序;
* 用-fno-omit-frame-pointer编译，以在错误消息中添加更好的堆栈跟踪。
* 增加-O1以获得更好的性能。
* 避免使用 -Wl,-z,defs，因为可能会造成链接错误 
* 要获得完美的堆栈跟踪，您可能需要禁用内联(只使用-O1)和尾部调用消除(-fno-optimize-sibling-call)

#### 使用

简单内存检查使用(不包括检查内存泄漏)：

```sh
clang -O1 -g -fsanitize=address -fno-omit-frame-pointer {testfile.c} -o {testfile}
```

单独检查内存泄漏：

```shell
clang -O1 -g -fsanitize=leak -fno-omit-frame-pointer {testfile.c} -o {testfile}
```

检查内存错误和内存泄漏：

```shell
clang -fsanitize=address -g {testfile.c} - o {testfile} ; ASAN_OPTIONS=detect_leaks=1 ./testfile
```

最后执行程序

```shell
./testfile
```



### 检查的错误类型

![错误类型](https://i.loli.net/2021/01/07/pa9oYelumxABqrO.png)



## 原理

### 组成

> AddressSanitizer consists of two parts: an instrumentation module and a run-time library.

AddressSanitizer 包括两部分：指令模块和运行时库。

#### 指令模块

作用：修改代码以检查每个内存访问的阴影状态，并且在**栈或者全局对象**周围创建红色区域用来检测上溢或下溢。

基于LLVM编译器指令集。

> 其他工具都不能发现栈溢出的错误。

##### 友商比较

Mudflap使用编译时检测因此能够检查对象的越界访问，但是因为对象之间没有插入红色区域，所以不能检查出所有的栈溢出bug

CCured编译指令使用静态分析(仅C程序)消除多余的检查；它们的指令与非指令库不兼容。

LBC使用源到源的转换和基于CCured去消除多余的检查。(仅限C语言和不能处理use-after-free)

Insure++主要依靠编译时工具，但也使用二进制工具。实施细节尚未公开。

#### 运行时库

作用：替换malloc、free等相关的函数，并且在堆得周围创建红色区域，延迟已释放的堆区的复用和做一些错误报告。



### 阴影内存

很多工具用阴影内存存储应用程序相应的元数据。典型的是一个程序的地址被映射到一个阴影地址通过直接缩放或者地址偏移。

整个应用程序的地址空间被映射到简单的阴影内存空间，或者使用一个额外的表进行查找。

#### 比较

典型的直接映射的方法包括**TraintTrace**和**LIFT**

使用多级翻译模式，例如Valgrind和DrMemory。将它们的影子内存分成几部分，并使用表查找来获得影子地址，需要额外的内存加载。

Umbra结合了灵活的布局和高效性，避免了非均匀查表和动态缩放以及偏移模式

Boundless将其某些元数据存储在64位指针的高16位中，但会在慢速路径上回退到更传统的影子内存。

LBC使用存储在应用程序内存中的特殊值执行快速路径检查，并依赖慢速路径上的两级影子内存



### AddressSanitizer算法

与Valgrind-based tool AddrCheck类似



















## 优点和缺点

可以从多个方面看：

- 运行速度
- 内存消耗
- 支持的内存错误类型
- 发现错误的可能性(会不会误报)
- 支持的平台
- 其他的特性



优点：

- 平均速度为越来的73%,内存消耗大约3.4倍。

缺点：









---

**参考链接**：

1. .[AddressSanitizer使用介绍](https://www.bynav.com/cn/resource/bywork/healthy-work/70.html)
2. https://github.com/google/sanitizers/wiki/AddressSanitizerLeakSanitizer#suppressions
3. 论文《AddressSanitizer: A Fast Address Sanity Checker》











