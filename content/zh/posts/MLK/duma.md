---
title: duma
date: 2021-01-12T16:52:41+08:00
description: DUMA是一个开源库(在GNU通用公共许可证下)，用于检测C和C++程序中的缓冲区溢出和运行错误，是一个Red-Zone memory allocator。
draft: false
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

> 该库是Buce Perens Electric Fence库的分支，并添加了一些其他功能，例如内存泄漏报告。

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

方法：

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

## 环境变量

> 支持在gdb里面通过命令'set environment variable value' 设置环境变量

1. DUMA_ALIGNMENT

   这是一个整数，它指定将由malloc()、calloc()和realloc()返回的任何内存分配的对齐大小。因此，值为4将导致内存对齐到32位，除非系统没有8位的char。

   > 默认情况下，DUMA_ALIGNMENT设置为特定于环境的最小所需对齐。 最小所需对齐由createconf检测并存储在文件duma_config.h中。

   因此，分配小于DUMA_ALIGNMENT的块可能会导致更小的对齐-例如，当分配3个字节时，它们将被对齐到2个字节边界。 这可以更好地检测溢出。

   > 出于这个原因，您有时希望将DUMA_ALIGNMENT设置为1（没有对齐），这样您就可以检测到超出CPU单词大小的情况

   如果您只需要对一些特殊缓冲区进行更大的对齐,您不需要更改此设置。 在这种情况下，您可以使用函数

   ```c
   memalign(alignment, userSize).
   ```

2. DUMA_PROTECT_BELOW

   DUMA通常会在每次内存分配后立即放置一个不可访问的页面，这样就会检测到在分配结束后运行的软件。

   > 将DUMA_PROTECT_BELOW设置为1将导致DUMA在分配之前将无法访问的页面放置在地址空间中，这样就会检测到运行不足而不是运行过度

3. DUMA_SKIPCOUNT_INIT

   一般使用第一个分配器分配。在某些系统中，这可能会与pthreads或其他libaries的初始化发生冲突并产生挂起。 为了获得DUMA工作，即使在这些情况下，您也可以控制（使用此环境变量）在完成DUMA的全部内部初始化后的分配数量。 默认为0。

4. DUMA_REPORT_ALL_LEAKS 

   DUMA通常只报告内存泄漏，其中已知分配指令行号的源文件名。并不报错退出。

   默认值为0，以避免从系统/编译器环境报告无关内存泄漏。

5. DUMA_FILL

   当设置为0到255之间的值时，分配内存的每个字节都被初始化为该值。

   > 这可以帮助检测未初始化内存的读取

   当设置为-1时，DUMA不会在分配时初始化内存。 但是一些内存中充满了零（大多数系统默认的操作系统），一些内存将保留在上次使用期间写入的值。每个默认的DUMA将初始化所有分配的字节到255(=0x FF)。

6. DUMA_SLACKFILL

   当DUMA在整个页面中内部分配内存时，就会保留一个未使用和无法保护的内存块：可用但是还没使用的内存区域。 每个默认的DUMA将初始化这个区域到170(=0x AA)，这是10101010在二进制表示。

7. DUMA_CHECK_FREQ

    将此变量设置为1，以便在每个分配和解除分配时允许DUMA检查无人区。每个默认值都使用0，这意味着只在取消分配时检查

8. DUMA_ALLOW_MALLOC_0

   大小为零的内存分配符合ANSI。 但这往往是软件错误的结果。 因此，DUMA可能会将这样的调用捕获到大小为零的malloc()。 默认情况下，我将禁用此选项，但您可以自由地捕获这些调用，将shell环境中的DUMA_ALLOC_MALLOC_0设置为整数值。

9. DUMA_MALLOC_0_STRATEGY

   此环境变量控制DUMA在malloc（0)上的行为）：

   ALLOW_MALLOC_0的值

   0 - abort program with segfault

   1 - 返回空指针

   2 - 返回到某些受保护页面的指针总是相同的

   3 - 返回唯一受保护页的中间地址（=默认）

   > 注意：只有1和3是ANSI符合。 但是值1会破坏大多数程序，导致值3策略大多数系统库使用/实现。 所有返回的指针都可以传递给自由()。

10. DUMA_NEW_0_STRATEGY

    此环境变量控制DUMA在大小为零的C操作符上的行为：

    2 - 返回到某些受保护页面的指针总是相同的

    3 - 返回唯一受保护页的中间地址（=默认）

    > 注意：只有3是标准符合。 价值2可能会打破一些，但将适用于大多数程序。 值2可以减少内存消耗。

等等—

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