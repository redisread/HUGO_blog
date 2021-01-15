---
title: Eletric-Fence
date: 2021-01-12T16:52:17+08:00
description: Electric Fence是另一种malloc（）调试器。它使用系统的虚拟内存硬件来检测软件何时超出了malloc（）缓冲区的边界。它还将检测free（）释放的任何内存访问。
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/01/14/rRaLjNvdKhIFxGi.png
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



# Eletric-Fence

Electric Fence是另一种malloc（）调试器。它使用系统的虚拟内存硬件来检测软件何时超出了malloc（）缓冲区的边界。它还将检测free（）释放的任何内存访问。因为它使用VM硬件进行检测，所以Electric Fence会在导致边界违反的第一条指令上停止您的程序。

## 基本介绍

官网、参考文档：
1.https://www.bbsmax.com/A/gVdnRMOadW/
2.https://xsyr.github.io/%E7%BC%96%E7%A8%8B/c/c++/2013/10/13/use-electric-fence-to-detect-heap-overruns-and-underruns.html

源码： https://github.com/kallisti5/ElectricFence

## 支持

支持所有Linux、Unix平台。(Linux kernel version 1.1.83 and above)

![支持](https://i.loli.net/2021/01/13/RIHgOG1msNW9oQS.png)

## 安装

> efence库依赖于pthread(多线程)库

- To compile
  - `scons`
- To clean
  - `scons -c`

## 使用

### 基本使用方法

使用步骤：

1. 在编译的时候添加参数: -lefence -lpthread
   如果没有安装Efence，则需要指定libefence.a的位置：
   gcc –g –o ef ef.c –lefence –L /usr/lib

2. 或者

   - Link the generated static `libefence.a` archive into your application at build.

   - Preload the generated shared library

      

     ```
     libefence.so
     ```

      

     at runtime via the following:

     - Linux / Haiku / Solaris / HP-UX
       - `LD_PRELOAD=./path/to/library/libefence.so /bin/myapplication`
     - AIX 5.3+ (32-bit)
       - `LDR_PRELOAD=./path/to/library/libefence.so /bin/myapplication`
     - AIX 5.3+ (64-bit)
       - `LDR_PRELOAD64=./path/to/library/libefence.so /bin/myapplication`

3. 编译运行，查看运行产生的core文件，如果没有core文件，说明测试通过
   当发生segmentation fault时就会在当前目录下生产一个core文件，在linux下，我们可以使用GDB来调试core：
   Gdb ef core.xxxx
   然后输入where就可以看到程序崩溃时的函数调用堆栈信息了。
4. 可以在执行的时候使用gdb调试，例如gdb -q ./test，然后执行run可以看到执行后的结果

> 只需将应用程序与libefence.a连接起来，就可以检测到malloc缓冲区的大部分（但不是全部）溢出和免费内存的访问。

可以通过配置以下几个全局变量和环境变量来控制Efence的行为：

1. EF_ALIGNMENT：这是Efence malloc分配空间的内存对齐字节数。这个变量的默认值是sizeof(int)，32位字长的CPU对应的该值是4。这个值也是Efence能够检测的内存越界的最小值。
2. EF_PROTECT_BELOW： 默认情况下Efence是把inaccessible的页面置于分配的空间之后，所以检测到的是高地址方向的越界访问。把这个值设为1可以检测到低地址的越界访问。
3. EF_PROTECT_FREE： 通常free后的内存块会被放到内存池，等待重新被申请分配。把这个值设为1后，free后的内存块就不会被重新分配出去，而是也被设置为inaccessible，所以Efence能够发现程序再次访问这块已经free的内存。
4. EF_ALLOW_MALLOC_0： Efence默认会捕捉malloc(0)的情况。把该值设为1后则不会捕捉申请0字节内存的情况。
5. EF_FILL： 分配内存后Efence会将每一byte初始化成这个值(0-255)。当这个值被设成-1时，内存的值不固定。

![image-20210113123956766](https://i.loli.net/2021/01/13/NYrbLHwI2WlPEpy.png)



## 原理、功能

Efence有2个主要的功能：

1. **内存越界读写时抛出segmentation fault**。当程序用malloc申请内存时，Efence会使用虚拟内存技术将分配的内存空间之后的内存页面设置为inaccessible(不可读写和执行)，所以当程序发生越界读写时，OS会发出SIGSEGV信号，生成core文件(core dump)，进程退出。
2. **当访问已经被释放的内存空间时抛出segmentation fault**。当程序把一块空间free之后，Efence同样把这块内存的访问保护级别设置为inaccessible，所以当程序再次访问这块已经释放的内存时也会导致segmentation fault。

## 优点和缺点

优点：
1.不需要您对程序的源代码进行任何更改。您只需要在编译期间将程序与工具的库链接即可。
2.调试工具的实现方式可确保在导致边界冲突的第一条指令上产生分段错误，这总是比在以后阶段发现问题要好。



缺点：
1.每一次分配都是利用一个 semaphore 同步，没有 thread local 的分配
2.malloc 和 free 在 slot 都是线性查找，这也造成了整体性能的落后
3.内存消耗大，这个是显然的，特别对于频繁的小内存分配
4.该工具无法检测到分配给栈的内存溢出，并且不是线程安全的。
5.另一个局限性是它不能明确地指出问题出在程序代码中的什么位置-它所做的只是在检测到与内存相关的错误时就产生分段错误。



---

参考链接：

1. https://www.cnblogs.com/jingzhishen/p/6025702.html?utm_source=itdadao&utm_medium=referral
2. https://blog.csdn.net/chessinge/article/details/6743764
3. https://linux.die.net/man/3/efence
4. http://www.bubuko.com/infodetail-2434473.html
5. https://www.computerworld.com/article/3003957/review-5-memory-debuggers-for-linux-coding.html





