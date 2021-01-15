---
title: duma
date: 2021-01-12T16:52:41+08:00
description: DUMA是一个开源库(在GNU通用公共许可证下)，用于检测C和C++程序中的缓冲区溢出和运行错误，是一个Red-Zone memory allocator。
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/01/14/GyBm4EuQsfKXVti.png
libraries:
- katex
- mathjax
tags:
- MLK
series:
-
categories:
-
---







# duma

DUMA是一个开源库(在GNU通用公共许可证下)，用于检测C和C++程序中的缓冲区溢出和运行错误，是一个Red-Zone memory allocator。这个库是 Electric Fence库的一个分支，并添加了一些新功能。

> 该库是Buce Perens Electric Fence库的分支，并添加了一些其他功能。

![特性](https://i.loli.net/2021/01/13/gyOSd9jheXor1PU.png)

## 基本介绍

官网： http://duma.sourceforge.net/
源码： https://github.com/fortitudepub/duma
文档： http://duma.sourceforge.net/README.txt

## 支持

- Linux / Unix
- MS Windows NT/2K/XP

## 安装

> 需要gmake工具

```shell
unzip duma-master.zip
cd duma-master
gmake
gmake install
```

（不行的话编辑GNUmakefile，在开头添加OS=linux）

**问题**

1. Centos8或者高版本C++可能会导致与C++98的抛出异常不一

   解决办法：需要进入GNUmakefile中修改添加参数-std=c++98

## 使用

### 基本功能

- 超出动态分配缓冲区的末尾（或开始）。
- 返回到堆后使用动态分配的缓冲区。
- 检测内存泄漏。
- 检测分配/取消分配功能的不匹配：例如，
  使用malloc（）进行分配，但使用运算符delete进行释放。

### 基本使用方法

使用限制：

- 不能和lmalloc、lmallocdebug等malloc-debugger混用
- duma会创建core文件，注意操作系统对core文件的限制
- -lduma需要全局安装，否则就要指定路径，也可以环境变量的形式应用于所有动态可执行文件



1. 假如duma已经安装，可以使用-lduma去链接编译或者在命令行添加链接库的位置进行链接。(静态)

2. 没有显示安装duma也可以使用动态链接，如下(动态)

   ```shell
   (export LD_PRELOAD=/usr/lib/libduma.so; export DYLD_INSERT_LIBRARIES=libduma.dylib; export DYLD_FORCE_FLAT_NAMESPACE=1; exec APP args)
   ```

   或者

   ```bash
   LD_PRELOAD=/usr/lib/libduma.so APP args
   ```

如果你的程序有一个被DUMA检测到的错误，它将得到一个错误指令的<font color="red">segmentation fault</font>(SIGSEGV)。**使用debugger 找到错误的声明，并修复它。**


下面是使用gdb找到错误位置的具体操作：

静态(上面第一种方法编译的程序)：

1. 使用gdb启动程序，例如：

   ```shell
   gdb app
   ```

2. 在gdb里面设置环境变量。

   ```shell
   set environment DUMA_PROTECT_BELOW 1
   ```

3. 在gdb里面设置程序的参数。

   ```shell
   set args ..
   ```

4. 运行程序等待字段错误。

   ```shell
   run
   ```

   

动态(上面第二种方法编译的程序)：

1. 设置“ulimit -c unlimited”获取内核文件。

2. 运行静态链接的程序或者动态链接的程序。

3. 等待字段错误，会在当前文件夹下生成一个内核文件core.pid。可以使用gdb打开：

   ```shell
   gdb <program> -c <core file>
   ```

## 原理

- DUMA使用计算机的虚拟内存硬件，在每次内存分配之后（或之前，选择之前）立即放置一个不可访问的内存页面。读写这个不可访问的也页面会触发段错误，然后使用调试器分析并且解决问题

- “重载”所有标准内存分配函数及释放函数。
  利用CPU的MMU（内存管理单元）分配并保护一个额外的内存页，以检测超出缓冲区顶部（或底部，由用户选择）之外的任何非法访问。
- 以free()方式释放的内存也被设置为不可访问，任何试图接触它的代码都会得到一个segmentation fault。
- 初始化的内存可以自定义1-255的初始值，默认不设置
- 使用0xAA填充申请页块中未使用但是可以使用的内存



## 内存使用和执行速度

由于DUMA的每个分配至少使用两个虚拟内存页面，这是一个可怕的内存占用。 我有时发现有必要使用swapon（8）添加一个交换文件，这样系统就有足够的虚拟内存来调试我的程序。 此外，我们操作内存的方式导致各种缓存和转换缓冲区条目被刷新，每次调用malloc或免费。 最终的结果是，您的程序将慢得多，并且在使用DUMA调试时使用更多的资源。



不要用于生产环境！

## 优点和缺点

### 优点

1. 安装方便
2. 预加载库形式，无需修改代码重新编译
3. 支持C++



### 缺点

1. 性能比较差
   - 执行效率：我们操作内存的方式导致各种缓存和转换缓冲区条目被刷新，每次调用malloc或free。 最终的结果是，您的程序将慢得多
   - 内存开销：每个分配使用至少两个虚拟内存页面