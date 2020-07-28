---
title: "interview"
date: 2020-07-28T00:04:50+09:00
publishDate: 2020-07-28
description:
enableToc: false
tags:
-
series:
-
categories:
-
---

# Interview

* C++空类产生哪些成员函数？

  构造、拷贝构造、取地址、、取地址const，赋值、析构

  [C++ 空类默认产生的类成员函数](https://blog.csdn.net/makuiyu/article/details/8047340)

* TCP三次握手和四次挥手，何时进入CLOSE-WAIT状态？

  ![TCP状态机](https://i.loli.net/2020/07/21/xNgXnsR4lh6BOSQ.jpg)

  https://zhuanlan.zhihu.com/p/86426969

* 智能指针，具体实现？

  [自己动手实现一个C++智能指针](https://blog.csdn.net/u013140542/article/details/37971929)

* 构造析构函数调用顺序（包括类里面的虚函数调用顺序）

  [C++构造函数和析构函数的调用顺序](https://blog.csdn.net/kenden23/article/details/15500485)

* 第三方库动态链接后存在程序内存空间的哪个位置？

  ![clipboard.png](https://i.loli.net/2020/07/22/MlQtT6F72qVZdhH.png)

  dynamic段中保存了可执行文件依赖哪些动态库,动态链接符号表的位置以及重定位表的位置等信息。当加载可执行文件时,操作系统根据dynamic段中的信息即可找到使用的动态库,从而完成动态链接。

  静态链接与动态链接：

  ![图 2. 静态链接与动态链接](https://i.loli.net/2020/07/22/tqnRs96FwYXL1DK.gif)

  https://segmentfault.com/a/1190000016433897

  [Linux 动态库剖析](https://www.ibm.com/developerworks/cn/linux/l-dynamic-libraries/index.html)

* 进程/线程 区别 （线程共享进程的什么资源）？

  ![1030344-20170226222710585-1109874075](https://i.loli.net/2020/07/28/gJ1leGd9tb3rf4u.png)

  https://blog.csdn.net/WangQYoho/article/details/52598859

* 用户态和核心态的区别？

  - 内核态（Kernel Mode）：运行操作系统程序
  - 用户态（User Mode）：运行用户程序

  

  1. 当一个任务（进程）执行系统调用而陷入内核代码中执行时，我们就称进程处于内核运行态（或简称为内核态）。此时处理器处于特权级最高的（0级）内核代码中执行。当进程处于内核态时，执行的内核代码会使用当前进程的内核栈。每个进程都有自己的内核栈。
  2. 当进程在执行用户自己的代码时，则称其处于用户运行态（用户态）。即此时处理器在特权级最低的（3级）用户代码中运行。当正在执行用户程序而突然被中断程序中断时，此时用户程序也可以象征性地称为处于进程的内核态。因为中断处理程序将使用当前进程的内核栈。这与处于内核态的进程的状态有些类似。

  https://blog.csdn.net/justlpf/article/details/99447462  用户态和核心态的区别

* 调度策略

  - **先来先服务调度算法：**先来先服务(FCFS)调度算法是一种最简单的调度算法，该算法既可用于作业调度，也可用于进程调度。当在作业调度中采用该算法时，每次调度都是从后备作业队列中选择一个或多个最先进入该队列的作业，将它们调入内存，为它们分配资源、创建进程，然后放入就绪队列。在进程调度中采用FCFS算法时，则每次调度是从就绪队列中选择一个最先进入该队列的进程，为之分配处理机，使之投入运行。该进程一直运行到完成或发生某事件而阻塞后才放弃处理机。
  - **短作业(进程)优先调度算法：**短作业(进程)优先调度算法SJ(P)F，是指对短作业或短进程优先调度的算法。它们可以分别用于作业调度和进程调度。短作业优先(SJF)的调度算法是从后备队列中选择一个或若干个估计运行时间最短的作业，将它们调入内存运行。而短进程优先(SPF)调度算法则是从就绪队列中选出一个估计运行时间最短的进程，将处理机分配给它，使它立即执行并一直执行到完成，或发生某事件而被阻塞放弃处理机时再重新调度。
  - **高优先权优先调度算法**：为了照顾紧迫型作业，使之在进入系统后便获得优先处理，引入了最高优先权优先(FPF)调度算法。此算法常被用于批处理系统中，作为作业调度算法，也作为多种操作系统中的进程调度算法，还可用于实时系统中。当把该算法用于作业调度时，系统将从后备队列中选择若干个优先权最高的作业装入内存
  - **高响应比优先调度算法：**在批处理系统中，短作业优先算法是一种比较好的算法，其主要的不足之处是长作业的运行得不到保证。如果我们能为每个作业引入前面所述的动态优先权，并使作业的优先级随着等待时间的增加而以速率a 提高，则长作业在等待一定的时间后，必然有机会分配到处理机。
  - **时间片轮转法：**在早期的时间片轮转法中，系统将所有的就绪进程按先来先服务的原则排成一个队列，每次调度时，把CPU 分配给队首进程，并令其执行一个时间片。时间片的大小从几ms 到几百ms。当执行的时间片用完时，由一个计时器发出时钟中断请求，调度程序便据此信号来停止该进程的执行，并将它送往就绪队列的末尾；然后，再把处理机分配给就绪队列中新的队首进程，同时也让它执行一个时间片。
  - **多级反馈队列调度算法：**前面介绍的各种用作进程调度的算法都有一定的局限性。如短进程优先的调度算法，仅照顾了短进程而忽略了长进程，而且如果并未指明进程的长度，则短进程优先和基于进程长度的抢占式调度算法都将无法使用。而多级反馈队列调度算法则不必事先知道各种进程所需的执行时间，而且还可以满足各种类型进程的需要，因而它是目前被公认的一种较好的进程调度算法。

* 分页和分段有什么区别？

  - 段是信息的逻辑单位，它是根据用户的需要划分的，因此段对用户是可见的 ；页是信息的物理单位，是为了管理主存的方便而划分的，对用户是透明的。
  - 段的大小不固定，有它所完成的功能决定；页大大小固定，由系统决定
  - 段向用户提供二维地址空间；页向用户提供的是一维地址空间
  - 段是信息的逻辑单位，便于存储保护和信息的共享，页的保护和共享受到限制。

  

* 关于重载、重写、隐藏（总是不记得）的区别

  ```
  Overload(重载)：在C++程序中，可以将语义、功能相似的几个函数用同一个名字表示，但参数或返回值不同（包括类型、顺序不同），即函数重载。
  （1）相同的范围（在同一个类中）；
  （2）函数名字相同；
  （3）参数不同；
  （4）virtual 关键字可有可无。
  Override(重写)：是指派生类函数覆盖基类函数，特征是：
  （1）不同的范围（分别位于派生类与基类）；
  （2）函数名字相同；
  （3）参数相同；
  （4）基类函数必须有virtual 关键字。注：重写基类虚函数的时候，会自动转换这个函数为virtual函数，不管有没有加virtual，因此重写的时候不加virtual也是可以的，不过为了易读性，还是加上比较好。
  Overwrite(隐藏)：隐藏，是指派生类的函数屏蔽了与其同名的基类函数，规则如下：
  （1）如果派生类的函数与基类的函数同名，但是参数不同。此时，不论有无virtual关键字，基类的函数将被隐藏（注意别与重载混淆）。
  （2）如果派生类的函数与基类的函数同名，并且参数也相同，但是基类函数没有virtual关键字。此时，基类的函数被隐藏（注意别与覆盖混淆）。
  
  ```

* 排序算法

  ![364303-20160815165252312-182869324](https://i.loli.net/2020/07/28/TUqAaEnGj8PV4vu.png)

* STL容器的特点

  ![364303-20160815190552968-787753341](https://i.loli.net/2020/07/28/wbsEWAT1dZNytOQ.png)

[分段和分页](https://blog.csdn.net/wangrunmin/article/details/7967293)

* 基本分页储存管理方式?
* 基本分段储存管理方式?
* 几种页面置换算法，会算所需换页数?
* 虚拟内存的定义及实现方式?



* 函数调用和系统调用的区别？

  系统调用 （[常见Linux及其分类表](http://www.cnblogs.com/LUO77/p/5823241.html)）

  ![image-20200728155419044](https://i.loli.net/2020/07/28/5KBXNwWCgRyOImE.png)

  

* TLB的作用及工作过程

* 什么是虚拟内存？

  虚拟内存 使得应用程序认为它拥有连续的可用的内存（一个连续完整的地址空间），而实际上，它通常是被分隔成多个物理内存碎片，还有部分暂时存储在外部磁盘存储器上，在需要时进行数据交换。与没有使用虚拟内存技术的系统相比，使用这种技术的系统使得大型程序的编写变得更容易，对真正的物理内存（例如RAM）的使用也更有效率。

  

  通过虚拟地址访问内存有以下优势：

  - 程序可以使用一系列相邻的虚拟地址来访问物理内存中不相邻的大内存缓冲区。
  - 程序可以使用一系列虚拟地址来访问大于可用物理内存的内存缓冲区。当物理内存的供应量变小时，内存管理器会将物理内存页（通常大小为 4 KB）保存到磁盘文件。数据或代码页会根据需要在物理内存与磁盘之间移动。
  - 不同进程使用的虚拟地址彼此隔离。一个进程中的代码无法更改正在由另一进程或操作系统使用的物理内存。









## 描述符

Unix 中所有 I/O 的基本构建块是一个字节序列。大多数程序使用更简单的抽象——字节流或 I/O 流。

流程通过描述符(也称为文件描述符)引用 I/O 流。管道、文件、 FIFOs、 POSIX IPC (消息队列、信号量、共享内存)、事件队列都是由描述符引用的 I/O 流的例子。

### close-on-exec

当一个进程进行fork时，所有的描述符在子进程中被“复制”。如果任何一个描述符在 exec 上标记为 close，那么在父进程fork之后但在子进程执行之前，子进程中标记为“ close-on-exec”的描述符将被关闭，不再可用于子进程。

![image-20200727180519912](https://i.loli.net/2020/07/27/pianoTCHwXFEmNO.png)



```c++
#include <unistd.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
int main(char *argv[]) {
    int fd = open("abc.txt", O_WRONLY | O_CREAT | O_TRUNC, 0666);
    fork();
    write(fd, "xyz", 3);
    printf("%ld\n", lseek(fd, 0, SEEK_CUR));
    close(fd);
    return 0;
}
```





### 文件接口

![image-20200727181741691](https://i.loli.net/2020/07/27/VqwAj3GCBWOmoR9.png)



### Socket文件描述符

大多数网络是使用套接字完成的。套接字由描述符引用，并充当通信的端点。两个进程可以创建两个套接字，并通过连接这两个端点建立一个可靠位元组流。一旦建立了连接，就可以使用上面描述的文件偏移量读取描述符或写入描述符。内核可以将一个进程的输出重定向到另一台机器上的另一个进程的输入。相同的读写系统调用用于字节流类型的连接，但不同的系统调用处理像网络数据报这样的寻址消息。



大多数网络是使用套接字完成的。套接字由描述符引用，并充当通信的端点。两个进程可以创建两个套接字，并通过连接这两个端点建立一个可靠位元组流。一旦建立了连接，就可以使用上面描述的文件偏移量读取描述符或写入描述符。内核可以将一个进程的输出重定向到另一台机器上的另一个进程的输入。相同的读写系统调用用于字节流类型的连接，但不同的系统调用处理像网络数据报这样的寻址消息。



### 非阻塞

大多数网络是使用套接字完成的。套接字由描述符引用，并充当通信的端点。两个进程可以创建两个套接字，并通过连接这两个端点建立一个可靠位元组流。一旦建立了连接，就可以使用上面描述的文件偏移量读取描述符或写入描述符。内核可以将一个进程的输出重定向到另一台机器上的另一个进程的输入。相同的读写系统调用用于字节流类型的连接，但不同的系统调用处理像网络数据报这样的寻址消息。



当 I/O 事件发生时，比如新输入的到达或者套接字连接的完成，或者当 TCP 传输排队数据到套接字对等点之后，之前满的套接字发送缓冲区上有空间时，描述符就会变成就绪状态。





## 数据库

http://blog.codinglabs.org/articles/theory-of-mysql-index.html

* 说一下聚簇索引 & 非聚簇索引？

  https://juejin.im/post/5cdd701ee51d453a36384939

* 数据库事务的四大特性以及事务的隔离级别？

  https://www.cnblogs.com/fjdingsd/p/5273008.html

* 



---

参考连接 ：

1. https://wdxtub.com/interview/14520847747820.html 操作系统
2. [Linux下缓冲区溢出攻击的原理及对策](https://www.ibm.com/developerworks/cn/linux/l-overflow/index.html)
3. https://www.cnblogs.com/lesleysbw/p/6438941.html
4. [《后端架构师技术图谱》](https://github.com/xingshaocheng/architect-awesome/blob/master/README.md#%E7%BA%A2%E9%BB%91%E6%A0%91)  




