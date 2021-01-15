---
title: Valgrind
date: 2021-01-12T16:53:04+08:00
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







# Valgrind

Valgrind发行版目前包括七个生产质量工具：一个内存错误检测器，两个线程错误检测器，一个缓存和分支预测探查器，一个生成调用图的缓存和分支预测探查器以及两个不同的堆探查器。它还包括一个实验性的SimPoint基本块矢量生成器。

> 在软件开发过程中我们有时需要追踪程序执行、诊断错误、衡量性能等需求。如果有源代码的话可以添加相应代码，没有源代码时这个方法就行不通了。前者可以对源代码分析，后者只能分析二进制了。我的理解是，dynamic Binary Instrumentation (DBI)强调对二进制执行文件的追踪与信息收集，dynamic Binary Analysis (DBA)强调对收集信息的分析，valgrind是一个DBI框架，使用它可以很方便构建一个DBA工具。

Valgrind作者认为当时的DBI框架都把注意力放在了性能检测上，对程序的质量(原文capabilities)并没有太注意。所以设计了一个新的DBI框架，目标是可以使用它开发重型DBA工具。

## 基本介绍

官网： https://valgrind.org/
文档： https://valgrind.org/docs/manual/index.html
源码： https://github.com/groleo/mpatrolhttps://valgrind.org/downloads/repository.html

## 支持

它可在以下平台上运行：
X86 / Linux，AMD64 / Linux，ARM / Linux，ARM64 / Linux，PPC32 / Linux，PPC64 / Linux，PPC64LE / Linux，S390X / Linux，MIPS32 / Linux，MIPS64 / Linux，X86 / Solaris ，AMD64 / Solaris，ARM / Android（2.3.x和更高版本），ARM64 / Android，X86 / Android（4.0和更高版本），MIPS32 / Android，X86 / Darwin和AMD64 / Darwin（Mac OS X 10.12）。

## 安装

1. 解压安装包

   ```shell
   tar -jxvf valgrind-3.15.0.tar.bz2
   cd valgrind-3.15.0/
   ```

2. 创建Makefile

   ```shell
   ./configure
   ```

3. 安装 

  ```shell
  make
  make install
  valgrind --version
  ```





## 使用

### 基本使用方法



## 原理

Valgrind的重点是shadow values技术，该技术要求对所有的寄存器和使用到的内存做shadow（自己维护一份）。因此使用valgrind开发出来的工具一般跑的都比较慢。为了实现shadow values需要框架实现以下4个部分：

- Shadow State
- 提供 shadow registers (例如 integer、FP、SIMD)
- 提供 shadow memory
- 读写操作

9个具体功能:

- instrument read/write instructions
- instrument read/write system calls
- Allocation and deallocation operations
- instrument start-up allocations
- instrument system call (de)allocations
- instrument stack (de)allocations
- instrument heap (de)allocations
- Transparent execution, but with extra output
- extra output

核心思想就是要把寄存器和内存中的东西自己维护一份，并且在任何情况下都可以安全正确地使用，同时记录程序的所有操作，在不影响程序执行结果前提下，输出有用的信息。使用shadow values技术的DBI框架都使用不同方式实现了上述全部功能或部分功能。

valgrind结构上分为core和tool，不同的tool具有不同的功能。比较特别的是，valgrind tool都包含core的静态链接，虽然有点浪费空间，但可以简化某些事情。当我们在调用valgrind时，实际上启动的只是一个解析命令参数的启动器，由这个启动器启动具体的tool。

为了实现上述功能，valgrind会利用dynamic binary re-compilation把测试程序（client程序）的机器码解析到VEX中间语言。VEX IR是valgrind开发者专门设计给DBI使用的中间语言，是一种RISC like的语言。目前VEX IR从valgrind分离出去成libVEX了。libVEX采用execution-driven的方式用just-in-time技术动态地把机器码转换为IR，如果发生了某些tool感兴趣的事件，就会hook tool的函数，tool会插入一些分析代码，再把这些代码转换为机器码，存储到code cache中，以便再需要的时候执行。

```
Machine Code --> IR --> IR --> Machine Code

        ^        ^      ^
        |        |      |
    translate    |      |
                 |      |
            instrument  |
                        |
                     translate  
```

valgrind启动后，core、tool和client都在一个进程中，共用一个地址空间。core首先会初始化必要的组件，然后载入client，建立client的stack，完成后会要求tool初始化自己，tool完成剩余部分的初始化，这样tool就具有了控制权，开始转换client程式。从某种意义上说，valgrind执行的都是加工后的client程序的代码。

DBI framework 有两种基本的方式可以表示code和进行 instrumentation：

- disassemble-and-resynthesise (D&R)。
  Valgrind 使用这种把machine code先转成IR，IR会通过加入更IR来instrument。IR最后转回machine code执行，原本的code对guest state的所有影响都必须明确地转成IR，因为最后执行的是纯粹由IR转成的machine code。
- copy-and-annotate (C&A)。instructions会被逐字地复制(除了一些 control flow 改变)
  每个instruction都加上注解描述其影响(annotate)，利用这些描述来帮助做instrumentation
  通过给每条指令添加一个额外的data structure (DynamoRIO)
  通过提供相应的获取指令相关信息的API (Intel Pin)
  这些添加的注解可以指导进行相应的instrument，并且不影响原来的native code的执行效果。

## 优点和缺点

优点：
1.用valgrind监测内存泄漏，不用重新编译应用程序，不用重新链接应用程序，不用对应用进程做任何修改。如果想查看详细的出错信息，只需要在编译时加上-g选项。

缺点：
1.通常情况下，使用memcheck工具后应用程序的运行时间会比原生代码慢大约10-50倍。
2.对于一些不停机运行的服务器程序的内存问题，valgrind无能为力。不仅仅是因为valgrind无法使之停止，还有可能是因为服务器进程本身就被设计为申请一些生命周期 与进程生命周期一样长的内存，永远不释放，这些内存会被valgrind报泄漏错误。
3.valgrind对多线程程序支持得不够好。在多线程程序执行时，valgrind在同一时刻只让其中一个线程执行，它不会充分利用多核的环境。在用valgrind运行您的多线程程序 时，您的宝贵程序的运行情况可能跟不使用valgrind的运行情况千差万别。

---

参考：

1. https://blog.mengy.org/how-valgrind-work/
2. https://www.valgrind.org/docs/pubs.html
3. https://blog.csdn.net/yinliyinli/article/details/51346431
4. https://blog.csdn.net/u014652595/article/details/23660347