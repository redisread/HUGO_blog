---
title: "Valgrind"
date: 2021-01-12T16:53:04+08:00
description: 官方首页上这个骑士与恶龙的绘画由伦敦画家 Rupert Lees 创作。灵感来自于神话传说 St George and the Dragon 。某日，圣乔治到利比亚去，当地沼泽中的一只恶龙（一说鳄鱼）在水泉旁边筑巢，这水泉是Silene城唯一的水源，市民为了取水，每天都要把两头绵羊献祭给恶龙。 到后来，绵羊都吃完了，只好用活人来替代，每天抽签决定何人应选派作牺牲。 有一天，国王的女儿被抽中，国王也没有办法，悲痛欲绝。当少女走近，正要被恶龙吞吃时，圣乔治在这时赶到，提起利矛对抗恶龙，并用腰带把它束缚住，牵到城里当众杀死，救出了公主。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/01/22/Y1GSoIZW8jHBAQz.png
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

# Valgrind

Valgrind发行版目前包括七个生产质量工具：一个内存错误检测器，两个线程错误检测器，一个缓存和分支预测探查器，一个生成调用图的缓存和分支预测探查器以及两个不同的堆探查器。它还包括一个实验性的SimPoint基本块矢量生成器。

> 在软件开发过程中我们有时需要追踪程序执行、诊断错误、衡量性能等需求。如果有源代码的话可以添加相应代码，没有源代码时这个方法就行不通了。前者可以对源代码分析，后者只能分析二进制了。我的理解是，dynamic Binary Instrumentation (DBI)强调对二进制执行文件的追踪与信息收集，**dynamic Binary Analysis (DBA)强调对收集信息的分析**，valgrind是一个DBI框架，使用它可以很方便构建一个DBA工具。

Valgrind作者认为当时的DBI框架都把注意力放在了性能检测上，对程序的质量(原文capabilities)并没有太注意。所以设计了一个新的DBI框架，**目标是可以使用它开发重型DBA工具**。

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

### 编译说明

1. 最好使用debug版本（gcc -g），这样打印的信息中会将错误和分析的信息指定出相关的代码行；
2. 如果是C++最好将内联函数以普通函数对待（gcc -fno-inline），这样更容易看到函数调用链，这有助于减少在大型C ++应用程序中导航时的混淆；
3. 不要使用优化（gcc -O2或gcc-O1等），这会导致Memcheck错误地报告未初始化的值错误或丢失未初始化的值错误；
4. 最好编译时能显示所有警告（gcc -Wall）

### 错误报告

当错误检查工具检测到程序中发生了错误时，就会向注释中写入一条错误消息。以下是来自Memcheck的一个例子：
```
==25832== Invalid read of size 4
==25832==    at 0x8048724: BandMatrix::ReSize(int, int, int) (bogon.cpp:45)
==25832==    by 0x80487AF: main (bogon.cpp:66)
==25832==  Address 0xBFFFF74C is not stack'd, malloc'd or free'd
```
这个消息说，程序非法读取了地址0xBFFFF74C的4字节，据Memcheck所知，这不是一个有效的堆栈地址，也不对应于任何当前堆块或最近释放的堆块。发生在bogon.cpp的第45行。从同一文件的第66行调用，等等。对于与已识别的(当前或已释放的)堆块相关的错误，例如读取已释放的内存，Valgrind不仅会报告错误发生的位置，还会报告分配/释放关联堆块的位置。

### 命令行选项

最简单的选项：

```
--tool=<toolname> [default: memcheck]
```

运行名为toolname的Valgrind工具，如memcheck, cachegrind, callgrind, helgrind, drd, massif, dhat, lackey, none, expi -bbv等

### 基本使用方法

假如你的程序原来是这样执行的：myprog arg1 arg2
那么使用valgrind可以在前面添加 valgrind --leak-check=yes 即可使用，例如：

```
valgrind --leak-check=yes myprog arg1 arg2
```

如果我们想用valgrind的内存检测工具，我们就要用如下方法调用：

```
#valgrind --leak-check=full --show-reachable=yes --trace-children= yes   ./a.out (2>logfile加上会好些，程序在执行期间stderr会有一些输出。提示比较多)
```

运行valgrind -h可以查看详细使用方法，命令格式如下：

```
valgrind [valgrind -h中的选项] 待测程序 [待测程序的命令行参数列表]
```

最重要的选项是–tool决定运行哪种Valgrind工具。

```
--tool=<toolname> [default: memcheck]：最常用的选项。运行valgrind中名为toolname的工具。如果省略工具名，默认运行memcheck。
```

例如，使用内存检查工具Memcheck 运行“ls -l”命令 ，执行命令格式如下：

```
valgrind --tool = memcheck ls -l
```

Memcheck是默认设置，因此如果要使用它，则可以省略该–tool选项，如：

```
valgrind  ls -l
```

https://blog.csdn.net/justheretobe/article/details/52986461

## 原理

### 基本架构

Valgrind 的核心花费大部分的时间在制造、寻找、执行 machine code 和 VEX IR 的转换， 而 client program 原本的 machine code 都不会跑到。可以看到 Valgrind 的复杂來自要把 client 和 tool 放在同一個 process， 需要用分享的资源 (例如 registers 和 memory)， 而且 Valgrind 要小心地确保在 system call、signals、threads 参与的狀況下不會對 client 失去掌控。

正常处理的程序有：

- normal executable code
- dynamically linked libraries
- shared libraries
- dynamically generated code

只有 self-modifying code 會有問題， 而執行過程中只有 system calls 裡面的狀況是 Valgrind 不能掌控的， 但是 system call 的 side-effects 還是可以間接觀察到。

```
                                      +--------------------+     +-------------------------+
              +--------------+        |      libVEX        |     | IR instrumentation tool |
              |              |        |                    |     |                         |
              +--------------+        |                    |     |                         |
              |              |        |                    |     |                         |
              +--------------+        |                    |     |                         |
              |              |        |                    |     |                         |
x86/Linux     +--------------+        |      +--------+    |     |                         |
AMD64/Linux   | machine code | ------------> | VEX IR | -------->|                         |
ARM/Linux     +--------------+        |      +--------+    |     |                         |
x86/MacOSX    |              |        |                    |     |                         |
AMD64/MacOSX  +--------------+        |         -----------------|                         |
....          |              |        |         |          |     |                         |
              +--------------+        |         |          |     |                         |
              |              |        +---------|----------+     +-------------------------+
              +--------------+                  |
                                                v
                                         +--------------+
                                         | machine code |
                                         +--------------+
```

Valgrind Core会反汇编应用程序代码，并将代码片段传递给工具插件以进行检测。工具插件会添加分析代码并将其重新组合。因此，Valgrind提供了在Valgrind框架之上编写我们自己的工具的灵活性。 Valgrind使用影子寄存器和影子存储器来检测读/写指令，读/写系统调用，堆栈和堆分配。

valgrind提供了围绕系统调用的包装，并为每个系统调用的前后回调注册，以跟踪作为系统调用一部分访问的内存。因此，Valgrind是Linux操作系统和客户端应用程序之间的OS抽象层。

该图说明了Valgrind的8个阶段：

![8 phases of Valgrind](https://i.loli.net/2021/01/22/ga6d5xoJpjw2lyk.jpg)



### 阴影值

Valgrind 把重点放在 shadow values 这概念上， shadow values 是很强大但相关的研究较少、较难实作的 DBA 技术， 在这概念下需要对所有的 register 和 memory 做 shadow (自己维护一份)， 也因为这 feature 让 Valgrind 做出来的 lightweight 工具跑的相对慢，但是 Valgrind 可以做出更多更有趣、更重量级的工具， 这是其他 frameworks 很难做到的 (例如 Pin 或 DynamoRIO)。

shadow value tools 会维护一份程式的状态， 把原本的程式状态称为 S， 那就会存一份 S’ 里面包含 S 的所有值 (例如 register 和 user-mode address)， 而 shadow values 有九种需求要满足， 九种需求可以依照特性分成四类 (Shadow State、读写操作、Allocation/Deallocation、增加辅助资讯)：

> 阴影值简单来说说就是：在软件中或者寄存器中用另外一个映射值来说明一些内容

阴影值的各个工具的应用

1. memcheck使用阴影值跟踪哪个bit的值是未定义的。
2. TaintCheck跟踪哪些字节被污染(不受信任的源，或来自受污染的值).
3. McCamant and Ernst’s secret-tracking tool跟踪每一个秘密bit的值，并且确定公共的输出中暴露了多少秘密的信息。
4. Hobbes跟踪每一个值得类型，因此可以检测后续操作不适合该类型的值。
5. DynCompB类似地，为程序理解和不变检测目的确定字节值的抽象类型。
6. Annelid跟踪是数组指针的word，可以检测越界错误。
7. Redux创建了一个动态数据流图，是程序的整个计算的可视化，从图中可以看到所有有助于每个值创建的先前操作。

可以是：

- 每bit一个shadow bit
- 每byte一个shadow byte
- 每word一个shadow word



1. 描述阴影值工具
2. 如何在DBI框架中支持阴影值
3. DBI框架并不完全相同



为了实现shadow values需要框架实现以下4个部分：

- Shadow State
- 读写操作
- 分配和释放操作
- 透明执行+额外的输出

9个功能

- instrument read/write instructions
- instrument read/write system calls
- Allocation and deallocation operations
- instrument start-up allocations
- instrument system call (de)allocations
- instrument stack (de)allocations
- instrument heap (de)allocations
- Transparent execution, but with extra output
- extra output

具体来说就是：

- Shadow State

  - R1：提供阴影寄存器(例如 integer、FP、SIMD)。
  - R2：提供阴影内存(并且需要在 multithread 下可以安全地存取 shadow memory)。

- 读写操作

  - R3：插桩读写指令。

    1. 需要知道每個 instruction 存取了哪些 memory 和 registers
    2. 最好能做到跨平台 (跨 ISA)

  - R4：插桩系统读写调用。

    所有的 system call 都会去存取 register 或 memory，还可能从 register 或 stack 读参数，最后写回 register 或 memory，而且还要注意许多 system call 会存取 user-mode 的 memory (pointer)

- 分配和释放操作

  - R5：插桩启动时的分配操作。
    1. 在程序开始执行时，所有 register 都會被 “allocated”，因為是 statically allocated memory locations，所以 shadow value tool 必須也這些做好 (create suitable 会hadow values)
    2. 对于此时还没 allocated 的也要处理，可能在 allocated 之前发生不当的存取
  - R6：插桩系统调用的分配和释放。
    1. 一些 system call 会 allocate memory (e.g. brk, mmap)，一些会 deallocate memory (e.g. munmap)
    2. mremap 會让memory 被 copy，shadow memory 也要 copy 好
  - R7：插桩栈的分配和释放。
    1. 更新 stack pointer
    2. 这部份会比较耗时，因为 stack pointer 时常变动，而且有些程式会在多个 stack 之间切换，shadow value tool 会需要把这些 stack allocations 或 deallocations 区分出来，这对于 binary level 来说不容易
  - R8：插桩堆的分配和释放.
    1. 大部分的程式会利用来自 library 的 heap allocator，heap allocator 会把用 system call (brk、mmap) 取得的 large chuncks 中的一块 heap blocks 传回去给 client，每段 heap block 都有 book-keeping data (例如 block size)，这些是 client program 不应该存取的 (读可能还安全，写的话可能会 crash allocator)，所以有 kernel-level addressability 之上盖了一层 library-level addressability 的概念
    2. 忽略 large chuncks 的 kernel-level allocations
    3. 直到 allocator 把 allocated 的 bytes 转交给 client 之前都不把 memory 当作 active
    4. realloc 也要像 mremap 一样被处理

- 透明执行+额外的输出

  - R9：额外的输出。
    1. 不影响执行，产生有帮助的 output
    2. 另外开个地方來 output，例如沒在用的 stderr 或 file

核心思想就是要把寄存器和内存中的东西自己维护一份，并且在任何情况下都可以安全正确地使用，同时记录程序的所有操作，在不影响程序执行结果前提下，输出有用的信息。使用shadow values技术的DBI框架都使用不同方式实现了上述全部功能或部分功能。



阴影值要求_9个要求

程序执行有三个特性与影子值工具相关：

1. 程序维持时期
2. 程序执行读或写操作
3. 程序执行分配或释放内存操作





> 阴影状态：一个阴影状态S’包括每一个值对应的阴影值S。

- 

- 
- 
- 



阴影值的支持

阴影寄存器是一流的实体：

- 在线程状态下为它们提供空间
- 它们可以像来宿主寄存器一样容易地访问
- 他们可以用同样的方式操纵和操作

其次，IR提供了不受限制的临时资源，可以在其中操纵来宾寄存器，影子寄存器和中间值。这对于易用性非常重要，因为
影子操作会引入许多额外的中间值。

第三，IR的RISC-ness公开了所有隐式中间值，例如由复杂寻址模式计算的中间值，这可以使测试变得更容易，特别是在像x86这样的CISC体系结构上

四，所有代码一视同仁。 阴影操作充分适合Valgrind的后仪器IR优化器和指令选择器。 



提供阴影内存

Valgrind不提供阴影内存的公开支持，例如内置的数据结构，阴影内存从工具到工具的变化足够大。



事件系统

![image-20210201143321958](Valgrind.assets/image-20210201143321958.png)

Valgrind为每个系统调用提供一个包装器，它根据需要调用这些回调。 每个系统调用都有不同的参数，因此有不同的包装器。



### 对于数据的处理

**如何知道那些地址是合法的（内存已分配）？**

`维护一张合法地址表（`Valid-address (A) bits），当前所有可以合法读写（已分配）的地址在其中有对应的表项。该表通过以下措施维护

```
全局数据(data, bss section)--在程序启动的时候标记为合法地址
局部变量--监控sp(stack pointer)的变化，动态维护
动态分配的内存--截获 分配/释放 内存的调用 ：malloc, calloc, realloc, valloc, memalign, free, new, new[], delete and delete[]
系统调用--截获mmap映射的地址
其他--可以显示知会memcheck某地字段是合法的
```

当要读写内存中的某个字节时，首先检查这个字节对应的A bit。如果该A bit显示该位置是无效位置，memcheck则会报告读写错误

**如何知道某内存是否已经被赋值(初始化)？**

维护一张合法值表（Valid-value (V) bits），指示对应的bit是否已经被赋值。**因为虚拟CPU可以捕获所有对内存的写指令**，所以这张表很容易维护。

一旦寄存器中的值，被用来产生内存地址，或者该值能够影响程序输出，则memcheck会检查对应的V bits，如果该值尚未初始化，则会报告使用未初始化内存错误。

**图解**

![img](https://i.loli.net/2021/01/22/Jxol23wasYU9pV8.jpg)



### 组件





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

### 优点

1.用valgrind监测内存泄漏，不用重新编译应用程序，不用重新链接应用程序，不用对应用进程做任何修改。如果想查看详细的出错信息，只需要在编译时加上-g选项。

### 缺点

1. 通常情况下，使用memcheck工具后应用程序的运行时间会比原生代码慢大约10-50倍。
2. -内存占用高，因为要维护两张表格，而这两张表的维度正比于程序的内存
3. -memcheck无法检测global和stack上的内存溢出，因为溢出的地方也在Valid-address (A) bits中。这是由memcheck 的工作原理决定的。
4. 对于一些不停机运行的服务器程序的内存问题，valgrind无能为力。不仅仅是因为valgrind无法使之停止，还有可能是因为服务器进程本身就被设计为申请一些生命周期 与进程生命周期一样长的内存，永远不释放，这些内存会被valgrind报泄漏错误。
5. valgrind对多线程程序支持得不够好。在多线程程序执行时，valgrind在同一时刻只让其中一个线程执行，它不会充分利用多核的环境。在用valgrind运行您的多线程程序 时，您的宝贵程序的运行情况可能跟不使用valgrind的运行情况千差万别。

---

参考：

1. https://blog.mengy.org/how-valgrind-work/
2. https://www.valgrind.org/docs/pubs.html
3. https://blog.csdn.net/yinliyinli/article/details/51346431
4. https://blog.csdn.net/u014652595/article/details/23660347
5. [valgrind如何工作？](https://www.codenong.com/1656227/)
6. http://awhite2008.blog.sohu.com/164824340.html
7. https://wdv4758h-notes.readthedocs.io/zh_TW/latest/valgrind/dynamic-binary-instrumentation.html



