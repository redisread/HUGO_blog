---
title: Eletric-Fence
date: 2021-01-12T16:52:17+08:00
description: Electric Fence是另一种malloc（）调试器。它使用系统的虚拟内存硬件来检测软件何时超出了malloc（）缓冲区的边界。它还将检测free（）释放的任何内存访问。
draft: false
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
>
> 安装依赖于scons工具：`yum install scons -y`
>
> SCons是一个基于python的软件构建工具，已经移植到大多数平台上，并且可以在大多数Linux发行库中使用。

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

![参数修改](https://i.loli.net/2021/01/13/NYrbLHwI2WlPEpy.png)



### 调试程序方法

1. 链接efence库并且执行自己的程序。
2. 在debugger上运行程序并且修复溢出或者访问已释放内存的错误。
3. 退出debugger工具。
4. 在shell环境变量中Set EF_PROTECT_BELOW = 1 
5. 重复step 2
6. 退出debugger工具。
7.  看是否可以将EF_ALIGNMENT设置为0，重复步骤2。 有时这将是太多的工作，或者在库例程中会有问题，而您没有源，这将阻止您这样做。

## 原理、功能

### 字节对齐和溢出检测

在malloc()操作的对齐限制和Electric Fence使用的调试策略之间存在冲突。

malloc分配是按照字节对齐的，但是Electric Fence的分配至少是两个虚拟页或者更多，并且最后一页被设置为不可读写，即返回的地址为不可读写的的第一个byte地址减去申请的内存大小。因此，任何分配空间的溢出将导致 segmentation fault。

如果Electric Fence malloc()要返回对齐地址，则必须将分配的大小增加到word大小的倍数。 此外，函数memalign()和valloc()必须遵守内存分配对齐的显式规范，这也只能通过增加分配的大小来实现。 因此，在某些情况下，内存分配的末尾包含一些填充空间，并且不会检测到该填充空间的访问，即使它们是超支的。(存在漏判？)

Electric Fence提供了变量EF_ALIGNMENT，以便用户可以控制malloc()、calloc()和realloc()使用的默认对齐方式。

> 若要调试小到单字节的溢出，可以将EF_ALIGNMENT设置为零



Efence有2个主要的功能：

1. **内存越界读写时抛出segmentation fault**。当程序用malloc申请内存时，Efence会使用虚拟内存技术将分配的内存空间之后的内存页面设置为inaccessible(不可读写和执行)，所以当程序发生越界读写时，OS会发出SIGSEGV信号，生成core文件(core dump)，进程退出。
2. **当访问已经被释放的内存空间时抛出segmentation fault**。当程序把一块空间free之后，Efence同样把这块内存的访问保护级别设置为inaccessible，所以当程序再次访问这块已经释放的内存时也会导致segmentation fault。



## 性能

### 内存消耗

**由于Electric Fence在每个分配中至少使用两个虚拟内存页面，所以这是一个可怕的内存占用**。 我有时发现有必要使用swapon（8）添加一个交换文件，这样系统就有足够的虚拟内存来调试我的程序。

### 速度

在对各种缓存和转换缓冲区调用malloc和fredd的操作内存的方式。将导致慢并且用更多的资源。



## 优点和缺点

### 优点

1. 不需要您对程序的源代码进行任何更改。您只需要在编译期间将程序与工具的库链接即可。
2. 调试工具的实现方式可确保在导致边界冲突的第一条指令上产生分段错误，这总是比在以后阶段发现问题要好。

### 缺点

1. 仅支持Linux，非跨平台

2. 每一次分配都是利用一个 semaphore 同步，没有 thread local 的分配

3. malloc 和 free 在 slot 都是线性查找，这也造成了整体性能的落后

4. 内存消耗大，特别对于频繁的小内存分配

   ```
   real_size = user_size + (alignment – (user_size  % alignment )) + page_size
   ```

5. 该工具无法检测到分配给栈的内存溢出

6. 不是线程安全的。

7. 另一个局限性是它不能明确地指出问题出在程序代码中的什么位置-它所做的只是在检测到与内存相关的错误时就产生分段错误。

   只能配合dbug工具进行分析具体位置。

8. 不能检测内存泄漏

---

参考链接：

1. https://www.cnblogs.com/jingzhishen/p/6025702.html?utm_source=itdadao&utm_medium=referral
2. https://blog.csdn.net/chessinge/article/details/6743764
3. https://linux.die.net/man/3/efence
4. http://www.bubuko.com/infodetail-2434473.html
5. https://www.computerworld.com/article/3003957/review-5-memory-debuggers-for-linux-coding.htm