---
title: Dbgmem
date: 2021-01-12T16:29:16+08:00
description: DBGMEM是用于C和C ++程序的功能丰富的内存调试器。目前仅适用于Linux。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/01/14/J4yIZEVO9pHSN8q.png
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

# Dbgmem

DBGMEM是用于C和C ++程序的功能丰富的内存调试器。目前仅适用于Linux。

## 基本介绍

官网： http://dbgmem.sourceforge.net/
源码： https://sourceforge.net/p/dbgmem/code/HEAD/tree/

> Github: https://github.com/MoserMichael/cstuff

文档： http://dbgmem.sourceforge.net/README.html

## 支持

使用Perl编写，只支持Linux。

## 安装

1. 解压

   ```shell
   tar xvfz DBGMEM.tar.gz .
   cd dbgmem
   ```

2. 构建测试集

   ```sh
   ./make
   ```

3. 也可以构建cpp版本的测试集(尚有问题)

   ```shell
   ./make cpp
   ```

4.  安装到 `/usr/local/dbgmem`

   ```shell
   ./make install
   ```

## 使用

### 基本功能

![基本功能](https://i.loli.net/2021/01/12/zkX3NoTDLnS81gJ.png)

该工具将覆盖GLIBC内存分配功能，内存和字符串处理功能，以添加其功能。

### 基本使用方法

* 仅内存泄漏检测使用参数：-d simple ；内存检测+内存检查使用参数：-d check
* 将内存错误附加到该程序的dbg上添加参数：-a gdb
* 对于内存分配，最多纪录n层栈帧可以使用参数：-s n (例如纪录7层栈帧:-s 7)
* 将分配和释放的内存初始化使用参数：-b

基础要求：

1. 不使用-O选项，或者同时使用-O和-fno-omit-frame-pointer
2. 必须加上-g选项。
3. 不能使用静态链接编译。例如-static-libgcc或-static 链接选项。
4. 停止程序通过信号必须保证信号没有被注册。

基本使用方法：

![基本使用](https://i.loli.net/2021/01/12/wQoTqY4vkBF5PhL.png)



日志文件包括下面三个部分：

1. 返回信息
2. 内存错误报告
3. 内存泄漏报告

![report](https://i.loli.net/2021/01/12/o6PtOYmpv1eukiI.png)



## 选项

### 所有工具共有的选项

#### 报告

在程序退出时或应用程序请求时生成包含分配时**所有内存块**及**栈的分配时间跟踪**；同时检查所有内存块是否溢出。

#### 检查

应用程序可以**调用服务函数来检查所有内存块是否溢出**。或者**打印出所有堆内存块**；或者，该工具允许您为每个任务安装两个信号处理程序。

#### 错误处理

**每当遇到内存错误时，事件都会被记录到日志文件和标准错误流中**；您可以选择下面几种操作进行处理：

- 继续执行
- Dump core
- 将gdb调试器附加到当前正在运行的进程

#### 钩子

该工具hooks以下GLIBC函数，并**跟踪由它们返回的动态分配的内存**

- malloc
- calloc
- realloc
- memalign
- posix_memalign
- valign
- free
- strdup
- strndup
- getcwd
- new/new[]/delete/delete[] (for C++ version only)
- malloc_usable_size returns size of requested block.

#### 填充模式值

(有一个选项`-b`填充)

- 初始化所有分配的堆内存——用0xDD填充
- 所有释放的内存——用0xFF填充

这是一个强大的特性，使用已释放的内存或者或者未出世后的内存将导致程序错误，不开启将导致未被发现。 如果已释放/未初始化内存包含一个指针，则取消引用该指针将导致 core dump.。

#### 信号处理

有一个选项可以安装SIGSEGV/SIGBUS信号处理程序，该**处理程序还可以检查所有堆块是否覆盖/越界写**。

#### 并行调试

您可以运行一个选项`-a dbg`，该选项**将程序与调试程序并行调用**，以便它专门监视调试过程的内存消耗。



### simple工具

> 使用-d simple 选项

1. 在最小开销的实时系统中精确定位和跟踪内存泄漏；？？为什么是最小开销，什么原理呢？
2. 在分配的块之前和分配的块之后，在头中保存额外的内务信息(housekeeping information)，因此堆错误检查并不总是完美的；检查工具更好地支持这些情况
3. 检查双释放和释放未分配的内存。

### check工具

> 使用-d check选项

- 高效地检查堆损坏，精确定位和跟踪活系统中的内存泄漏，跟踪实时系统中的内存泄漏，**在匿名共享内存段中，内务信息被保存在堆之外**，因此堆检查在这里更好，**尽管速度有点慢**

- 检查释放未分配的内存。

- 对于一组标准库函数，还检查以下错误

  - 受保护的一组函数中的堆越界写

  - Reading past allocated heap memory range

  - 栈smash（有限的支持，只有当您粉碎函数返回地址时，检查才触发）被检查的函数集

    检查函数的集合： memcpy、memmove、memset、strncpy、strcat、strncat、strcmp、strncmp

## 原理

### 术语

一个程序的不同阶段：

```
[--- INITIALIZATION ---] 
[--- ACTIVE STAGE ---] 
[--- SHUTDOWN ---] 
[--- EXIT ---]
```

#### INITIALIZATION

程序初始化。通常在这里读取配置，初始化缓存，并创建和初始化整个进一步阶段使用的对象和资源。

#### ACTIVE STAGE

这个过程是服务请求，并做一些有用的事情：

1. 在此阶段，进程完成一个或多个逻辑处理单元。
2. 每个这样的单元可以是处理来自网络的请求或一系列请求、处理批处理数据作业或处理交互式用户请求。

> 通常，在**处理某些资源和内存的每个逻辑单元期间**都会分配然后释放或者直接泄漏。

#### SHUTDOWN

进程已经收到一个信号，然后将退出。这个过程正在清理缓存，并且正在释放资源。

> 这是一个常见但可选的阶段

#### EXIT

程序退出。



### 内存泄漏的原因(Nice)

> 泄漏是是指一种资源它在进程的实际状态中被分配并且没有释放。

下面是几种内存泄漏：

- 简单的内存泄漏：资源被分配然后忘记释放了。

- 坏缓存泄漏：如果对象总是添加到缓存中，并且重用该缓存，则此模式可能导致泄漏。

- 引用计数泄漏：

  参考计数是一种特殊的垃圾收集形式，通常在C/C++程序中实现；存在潜在的问题，如:

  - 计数泄漏：只有在释放所有未完成的引用时，才会释放引用计数对象。 当一个对象的至少一个引用仍然存在时，可能会发生泄漏，因为不知何故，我们忘记清除一个突出的对象引用。 如果根对象引用所有其他对象，但忘记清除其引用，则经常会出现这种情况。

    >  请注意，这类似于坏缓存泄漏。 请注意，这种情况经常发生在其他编程语言中，如Java。

  - 环形引用：对象A引用对象B，B也引用对象A；不管怎样，对象A总是有来自对象B的至少一个引用，所以它永远不会被删除。

### 解决内存泄漏的方法

在不同时间点所作的两份报告：

#### 在完成SHUTDOWN时期

> 在进程正常退出之前，此报告总是由DBGMEM生成，除非进程被SIGKILL信号杀死

本报告列出了大多数泄漏问题的起源；分配泄漏内存块的堆栈跟踪将给您一个强有力的提示，说明如何修复这些问题。

> 对于与引用计数相关的某些类型的泄漏，您需要更多的信息

#### 在SHUTDOWN之前完成ACTIVE STAGE之后

如果您想跟踪引用计数泄漏，此阶段是有用的：

通常，当这些引用的根对象被删除时，这些泄漏的引用在SHUTDOWN阶段被删除。

当许多块发生在SHUTDOWN阶段之前的报告中，但在EXIT之前的报告中没有出现时，这可能表示泄漏。

> 这一分析不是由工具完成的，而是由热心的读者完成的，当他比较这两份报告时；热心的读者也掌握了他的程序的工作原理，并将能够总结正在发生的事情。



两种方法进入下面两个阶段：

1. INITIALIZATION and ACTIVE STAGE
2. ACTIVE STAGE and SHUTDOWN stage



way1：允许dbgmem的命令行选项去设置两个信号处理，每个信号处理程序将执行请求的状态转换

way2：修改已调试的程序，以便它调用调试库来指示这两个事件；如果您希望从单元测试/系统测试中运行DBGMEM，则这是首选的解决方案。



### 组件

该工具由以下组件组成：

- `/usr/mdbg/scripts/run`脚本：该脚本运行调试程序。
- 库`/usr/local/dbgmem/lib/libdmemc.so`和`/usr/mdbg/lib/libdmems.so`：每个共享库都是内存调试工具中的一个陷入。
- 库`/usr/local/dbgmem libdmems.so`实现了在每个分配中添加`arena header`的简单工具
  * 下一个/先前的块指针
  * 何时分配块的堆栈
  * 块大小
  * 生成标签值类 + 一些分配函数(malloc/new/new[])
  * 在信息块之后，在用户分配块结束后，一个size of(void*)保护区域是keps，它由哨兵值初始化，以便我们可以检查内存覆盖/覆盖。
- 库 `/usr/local/dbgmem/lib/libdmems.so`：实现了更复杂的检查工具
- 在被调试的进程退出之后，noteate.pl脚本将由运行脚本启动。 脚本/usr/mdbg/scripts/annotate.pl读取原始报告并创建最终报告



## 优点和缺点

### 优点

1. 使用简单，直接命令行使用。
2. 可以在运行时进行检测。

### 缺点

1. 存在误判，一些内存错误判断成内存泄漏。
2. 仅支持Linux