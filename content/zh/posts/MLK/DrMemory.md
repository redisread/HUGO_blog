---
title: DrMemory
date: 2021-01-12T16:53:58+08:00
description:
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image:
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



# DrMemory

Dr. Memory 建立在 DynamoRIO 这个动态二进制插桩平台上。动态监测程序的运行，并对内存访问相关的执行代码进行动态修改，记录其行为，并采用先进的算法进行错误检查。

## 基本介绍

官网：
https://drmemory.org/
文档：
https://github.com/DynamoRIO/drmemory
源码：
https://github.com/groleo/mpatrolhttps://dynamorio.org/drmemory_docs/page_options.html

## 支持

可在Linux，Windows，MacOSX，和Android操作系统上使用。能够支持运行在商用的IA-32、AMD64和ARM硬件上。

## 安装

无需安装，直接在源码包中路径调用可执行文件即可：

1. 从https://github.com/DynamoRIO/drmemory/wiki/Downloads下载对应操作系统的Dr. Memory压缩（tar.gz）文件。

2. 保存并解压包到您选择的目录。比如使用命令：
tar -xvzf DrMemory-YourOperatingSystem-VersionXX.tar.gz

3. 从现在起，我们假设DrMemory存在在目录 ~/DrMemory-YourOperatingSystem/。

4.在Dr. Memory中运行你的程序。例如：
~/DrMemory-YourOperatingSystem-VersionXX/bin/drmemory -- foo.out arg1 arg2
使用你的可执行文件和命令行参数替换“foo.out arg1 arg2”。

5.Dr. Memory会在运行过程中将错误打印在屏幕上，同时在程序终止时打印所发现错误摘要。

其他注意：
1.Dr. Memory可以用在32位或64位程序上（只在Linux上），但针对32位程序，Dr. Memory能追踪和报告更多类型的内存错误。所以建议你最好能建立和运行32位应用程序。在64位的Ubuntu操作系统上，你可能会想安装这些额外的软件包：
sudo yum install g++-multilib

2.你可以在你的编译器中使用-m32，从而编译和生成32位程序。请务必使用-g选项生产调试信息。例如：
g++ -g -m32 main.cpp foo_main.cpp foo_other.cpp -o foo.out

问题：
1.libgcc_s.so.1: cannot open shared object file: No such file or directory
https://confluence.atlassian.com/stashkb/libgcc_s-so-1-cannot-open-shared-object-file-no-such-file-or-directory-314446683.html
安装对应的库
yum install libgcc_s.so.1

## 使用

### 基本使用方法

在Dr. Memory中运行你的程序。

例如：

```shell
~/DrMemory-YourOperatingSystem-VersionXX/bin/drmemory -- foo.out arg1 arg2
```

使用你的可执行文件和命令行参数替换“foo.out arg1 arg2”。

## 原理



## 优点和缺点

优点：
1.使用方便。可以直接检查已经编译好的可执行文件。用户不用改写被检查程序的源代码，也无须重新链接第三方库文件，使用起来非常方便。
2.Dr. Memory 建立在 DynamoRIO 这个动态二进制插桩平台上，运行性能高。
3.DrMemory 对内存泄露的监测采用了比较独特的算法，大量减少了”false positive”，即虚假错误。

缺点：https://dynamorio.org/drmemory_docs/page_release_notes.html#sec_limits
1.ARM平台尚不支持未初始化的读取检查。
2.定义性是在字节级别而不是位级别进行跟踪的，使用位域时可能导致误报。

