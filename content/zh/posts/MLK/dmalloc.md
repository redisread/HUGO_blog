---
title: dmalloc
date: 2021-01-12T15:27:57+08:00
description: Debug Malloc Library是一种用于检查C/C++内存泄露(leak)的工具，即检查是否存在直到程序运行结束还没有释放的内存，并且能够精确指出在哪个源文件的第几行。
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/01/12/xudlv3iVJ7XRMbZ.jpg
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

# Dmalloc

**Debug Malloc Library**是一种用于检查C/C++内存泄露(leak)的工具，即检查是否存在直到程序运行结束还没有释放的内存，并且能够精确指出在哪个源文件的第几行。

## 基本介绍

官网： https://dmalloc.com/
源码： https://github.com/j256/dmalloc
文档： https://dmalloc.com/docs/

## 支持

支持的平台：AIX, BSD/OS, DG/UX, Free/Net/OpenBSD, GNU/Hurd, HPUX, Irix, Linux, MS-DOG, NeXT, OSF, SCO, Solaris, SunOS, Ultrix, Unixware, Windoze, and even Unicos on a Cray T3E

## 安装

参考地址：https://blog.csdn.net/cjsycyl/article/details/6340571

依次执行以下的命令：
(1) tar -zvxf dmalloc-5.5.2.tgz
(2) cd dmalloc-5.5.2
(3) ./configure --enable-threads
(4) make
(5) make install
______a) install libdmalloc.z到/usr/local/lib/目录下；
______b) install dmalloc.h到/usr/local/include/目录下；（Permission denied, so should sudo make install）
______c) install dmalloc到/usr/local/bin/目录下。

**设置环境变量**

对于 Bash, ksh, and zsh，在 `.bashrc', `.profile', or `.zshrc'文件中加入一行 ( -b 参数表示针对Bash的输出):
function dmalloc { eval `/usr/local/bin/dmalloc -b $*`; } 
然后执行：
source ~/.bashrc 或 source ~/.profile
接下来执行：
dmalloc -l logfile -i 100 low

## 使用

### 基本特性

1.文件和行号信息
2.返回地址信息
3.内存边界检查
4.堆内存一致验证
5.日志统计
6.检查释放的内存

### 基本使用方法

针对需要使用dmalloc的源代码作如下修改：
(1) 在源代码中，添加下面的C代码：

```c
#ifdef DMALLOC
#include "dmalloc.h"
#endif
```

(2) 添加参数或者在Makefile中，添加 `-DDMALLOC -DDMALLOC_FUNC_CHECK`
如： 

```shell
gcc -DDMALLOC -DDMALLOC_FUNC_CHECK dm_hello.c -o dm_hello -ldmalloc 
```

或者:

```sh
cc -DDMALLOC -DDMALLOC_FUNC_CHECK -ggdb -Wall dm_hello.c -o dm_hello -ldmalloc
```

(3) 添加-ldmalloc选项 运行之后，可以在/home/user/mydmalloc.log中查看检测信息。如果不使用绝对路径，则logfile会生成在app所在的目录。

## 原理



## 优点和缺点

### 优点

1. 支持C++与C
2. 支持线程



### 缺点

1. 只能检测堆上的内存，对栈内存和静态内存无效。(不能检测栈内存)
2. 只能检测用malloc申请的内存，而对使用sbrk()或者mmap()分配的内存无能为力。





