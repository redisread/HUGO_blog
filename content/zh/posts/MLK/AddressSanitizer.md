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

#### 运行时库

作用：替换malloc、free等相关的函数，并且在堆得周围创建红色区域，延迟已释放的堆区的复用和做一些错误报告。



### 阴影内存





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











