---
title: linking
date: 2021-01-14T14:55:45+08:00
description: 链接(linking)是将各种代码和数据片段收集并组合成为一个单一文件的过程，这个文件可被加载（复制）到内存并执行。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/01/22/GUJ5qKE16unSr7h.png
libraries:
- katex
- mathjax
tags:
- Linux
series:
-
categories:
-
---



# 链接

链接(linking)是将各种代码和数据片段收集并组合成为一个单一文件的过程，这个文件可被加载（复制）到内存并执行。

链接可以执行于编译时 (compile time) 也就是在源代码被翻译成机器代码时；也可以执行于加栽时（load time)，也就是在程序被加载器（loader)加载到内存并执行时；甚至执行于运行时（runtime)，也就是由应用程序来执行。

## 静态链接

> 像 **Linux** **LD** 程序这样的静态链接器（static linker)以一组可重定位目标文件和命令行参数作为输入，生成一个完全链接的、可以加载和运行的可执行目标文件作为输出。

为了构造可执行文件，链接器必须完成两个主要任务：

1. 符号解析：每个符号对应于一个函数、一个全局变量或一个静态变量
2. 重定位：编译器和汇编器生成从地址 0 开始的代码和数据节。链接器通过把每个符号定义与一个内存位置关联起来，从而重定位这些节，然后修改所有对这些符号的引用，使得它们指向这个内存位置



### 创建静态链接库

![image-20210114154757878](linking.assets/image-20210114154757878.png)

ar 是 Linux 的一个备份压缩命令，它可以将多个文件打包成一个备份文件（也叫归档文件），也可以从备份文件中提取成员文件。ar 命令最常见的用法是将目标文件打包为静态链接库。

对参数的说明：

- 参数 r 用来替换库中已有的目标文件，或者加入新的目标文件。
- 参数 c 表示创建一个库。不管库否存在，都将创建。　
- 参数 s 用来创建目标文件索引，这在创建较大的库时能提高速度。



### 使用静态链接

使用静态链接库时，除了需要库文件本身，还需要对应的头文件：库文件包含了真正的函数代码，也即函数定义部分；头文件包含了函数的调用方法，也即函数声明部分。



## 动态链接





### 生成动态链接库

如果想创建一个动态链接库，可以使用 GCC 的`-shared`选项。输入文件可以是源文件、汇编文件或者目标文件。

另外还得结合`-fPIC`选项。-fPIC 选项作用于编译阶段，告诉编译器产生与位置无关代码（Position-Independent Code）；这样一来，产生的代码中就没有绝对地址了，全部使用相对地址，所以代码可以被加载器加载到内存的任意位置，都可以正确的执行。这正是共享库所要求的，共享库被加载时，在内存的位置不是固定的。

例如，从源文件生成动态链接库：

```bash
$ gcc -fPIC -shared func.c -o libfunc.so
```

从目标文件生成动态链接库：

```bash
$ gcc -fPIC -c func.c -o func.o
$ gcc -shared func.o -o libfunc.so
```

-fPIC 选项作用于编译阶段，在生成目标文件时就得使用该选项，以生成位置无关的代码。



###  链接动态链接库

> GCC 将动态链接库链接到可执行文件

如果希望将一个动态链接库链接到可执行文件，那么需要在命令行中列出动态链接库的名称，具体方式和普通的源文件、目标文件一样。请看下面的例子

```bash
$ gcc main.c libfunc.so -o app.out
```

将 main.c 和 libfunc.so 一起编译成 app.out，当 app.out 运行时，会动态地加载链接库 libfunc.so。

当然，必须要确保程序在运行时可以找到这个动态链接库。你可以将链接库放到标准目录下，例如 /usr/lib，或者设置一个合适的环境变量，例如 LIBRARY_PATH。不同系统，具有不同的加载链接库的方法。





---

参考：

1. [GCC创建和使用静态链接库（.a文件）](http://c.biancheng.net/view/7168.html)
2. [GCC生成动态链接库（.so文件）](http://c.biancheng.net/view/2385.html)
3. [C语言和C++的混合编译](http://c.biancheng.net/view/7494.html)