---
title: "堆分配原理"
date: 2021-02-04T14:52:58+08:00
description: 堆分配及其复杂！
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
- Linux
- Heap
series:
-
categories:
-
---









## malloc的底层调用

![malloc底层调用](https://i.loli.net/2021/02/04/XtpNFfYxoPZidJm.png)

上面这张图展示了malloc的底层调用，也就是堆分配的底层调用。分别是brk系统调用和mmap系统调用。

> [ASLR ](https://zh.wikipedia.org/wiki/%E4%BD%8D%E5%9D%80%E7%A9%BA%E9%96%93%E9%85%8D%E7%BD%AE%E9%9A%A8%E6%A9%9F%E8%BC%89%E5%85%A5):地址空间配置随机加载(Address space layout randomization),是一种防范内存损坏漏洞被利用的计算机安全技术。ASLR通过随机放置进程关键数据区域的地址空间来防止攻击者能可靠地跳转到内存的特定位置来利用函数。现代操作系统一般都加设这一机制，以防范恶意程序对已知地址进行Return-to-libc攻击。

![虚拟地址空间布局](https://i.loli.net/2021/02/04/yfbPjRHMSFCL5wB.png)

上图是一个进程的虚拟地址空间布局图。由上图可以看到，brk与mmap申请地址空间的位置是不一样的，brk申请在堆区，往上增长；mmap申请在自由映射区，往下增长。

### brk系统调用

**brk系统调用**：通过增加brk的值，实现从内核中获取内存 —— 用于申请<=128kb的内存，不会被初始化为0，分配的内存在堆区域。

当进程一开始未分配任何堆内存时，start_brk=brk：

- 当ASLR未打开时，start_brk和brk指向data/bss段的结束位置（即end_data）
- 当ASLR打开时，start_brk和brk指向end_data加上一个随机偏移(random brk offset)的位置

brk测试程序：

```c
/* sbrk and brk example */
#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

int main()
{
    void *curr_brk, *tmp_brk = NULL;

    printf("Welcome to sbrk example:%d\n", getpid());

    /* sbrk(0) gives current program break location */
    tmp_brk = curr_brk = sbrk(0);
    printf("Program Break Location1:%p\n", curr_brk);
    getchar();

    /* brk(addr) increments/decrements program break location */
    brk(curr_brk + 4096);

    curr_brk = sbrk(0);
    printf("Program break Location2:%p\n", curr_brk);

    printf("location2 - location1 = %d \n", (curr_brk - tmp_brk));

    getchar();

    brk(tmp_brk);

    curr_brk = sbrk(0);
    printf("Program Break Location3:%p\n", curr_brk);
    getchar();

    return 0;
}
```



初始(没有堆区)：

![init](https://i.loli.net/2021/02/06/Yrv8w2PI7Ki3Xs9.png)

location1(申请了堆区)：

![location1](https://i.loli.net/2021/02/06/JD7pkBYOP9eVKub.png)

location2(再次没有堆区)：

![location2](https://i.loli.net/2021/02/06/u9DKhaMkYdE5e2B.png)



### mmap系统调用

**mmap系统调用**：创建一个私有的匿名映射段（private anonymous mapping segment）供当前进程使用 —— 用于申请>128kb的内存，会被初始化为0，分配的内存在堆和栈的中间区域。 其中，private表示该段仅属于当前进程所有，anonymous表示该段并不映射到任何磁盘文件。

例子程序

```c
/* Private anonymous mapping example using mmap syscall */
#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>

void static inline errExit(const char* msg)
{
        printf("%s failed. Exiting the process\n", msg);
        exit(-1);
}

int main()
{
        int ret = -1;
        printf("Welcome to private anonymous mapping example::PID:%d\n", getpid());
        printf("Before mmap\n");
        getchar();
        char* addr = NULL;
        addr = mmap(NULL, (size_t)132*1024, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (addr == MAP_FAILED)
                errExit("mmap");
        printf("After mmap\n");
        getchar();

        /* Unmap mapped region. */
        ret = munmap(addr, (size_t)132*1024);
        if(ret == -1)
                errExit("munmap");
        printf("After munmap\n");
        getchar();
        return 0;
}
```

before mmap:

![1](https://i.loli.net/2021/02/06/xISjiEdbLOBzZgm.png)

after mmap:

![2](https://i.loli.net/2021/02/06/cYaP4xpQS9igB61.png)

after munmap:

![3](https://i.loli.net/2021/02/04/JBtYUDRuzCmnhIN.png)

mmap的增长是在中间共享映射区中往低地址方向增长。





## glibc malloc实例



> dlmalloc不支持线程，而glibc的ptmalloc支持线程，所以glibc选择了ptmalloc
>

这种为每个线程维单独的堆和自由列表数据结构的行为称为**per thread arena**

例子：

```c
/* Per thread arena example. */
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <sys/types.h>

void *threadFunc(void *arg)
{
    printf("Before malloc in thread 1\n");
    getchar();
    char *addr = (char *)malloc(1000);
    printf("After malloc and before free in thread 1\n");
    getchar();
    free(addr);
    printf("After free in thread 1\n");
    getchar();
}

int main()
{
    pthread_t t1;
    void *s;
    int ret;
    char *addr;

    printf("Welcome to per thread arena example::%d\n", getpid());
    printf("Before malloc in main thread\n");
    getchar();
    addr = (char *)malloc(1000);
    printf("After malloc and before free in main thread\n");
    getchar();
    free(addr);
    printf("After free in main thread\n");
    getchar();
    ret = pthread_create(&t1, NULL, threadFunc, NULL);
    if (ret)
    {
        printf("Thread creation error\n");
        return -1;
    }
    ret = pthread_join(t1, &s);
    if (ret)
    {
        printf("Thread join error\n");
        return -1;
    }
    return 0;
}
```



Before malloc in main thread：

一开始在main函数的malloc之前，可以在下面看到没有堆段也没有每个线程的线程栈，因为此时线程1还有创建

![image-20210204164940195](https://i.loli.net/2021/02/06/3WtdvSeEL6qUzoH.png)

![image-20210204165002379](https://i.loli.net/2021/02/06/EzxMSyjQqGZtTWI.png)



After malloc in main thread：

在主函数线程中的malloc之后，在下面的输出可以看到堆段创建了，位于下面的数据段(352b0000-352e0000),这表示堆内存是通过使用brk系统调用增加程序break位置而创建的。我们也注意到明明分配的是1000bytes的空间，但是实际上却是 40350000-40320000 = 192KB,这个空间区域称为arena(每个arena中含有多个chunk，这些chunk以链表的形式加以组织)。因为这个arena是主线程创建的因此他叫main arena.由于132KB比1000字节大很多，所以主线程后续再声请堆空间的话，就会先从这132KB的剩余部分中申请，直到用完或不够用的时候，再通过增加program break location的方式来增加main arena的大小。同理，当main arena中有过多空闲内存的时候，也会通过减小program break location的方式来缩小main arena的大小。

![image-20210204165019336](https://i.loli.net/2021/02/06/AdgRh9DjbCta7QN.png)

![image-20210204165053906](https://i.loli.net/2021/02/06/ftXAYsxhuc2vzNd.png)



After free in main thread：

在下面的输出中，我们可以看到，当分配的内存区域被释放时，它背后的内存不会立即释放给操作系统。原来调用free函数释放已经分配了的空间并非直接“返还”给系统，而是由glibc 的malloc库函数加以管理。它会将释放的chunk添加到main arenas的bin中。在这里，记录空闲空间的freelist数据结构称之为bins。之后当用户再次调用malloc申请堆空间的时候，glibc malloc会先尝试从bins中找到一个满足要求的chunk，如果没有才会向操作系统申请新的堆空间。

![image-20210204164739232](https://i.loli.net/2021/02/06/loi23dUc1ZTuVSR.png)

![image-20210204165235209](https://i.loli.net/2021/02/06/lQihYeRgs8aIZot.png)



Before malloc in thread1: 

在下面的输出中，我们可以看到没有thread1堆段，但是现在创建了thread1的每个线程堆栈。

![image-20210204170718253](https://i.loli.net/2021/02/06/cZdswIAQjq6L2a9.png)

```diff
00400000-00410000 r-xp 00000000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
00410000-00420000 r--p 00000000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
00420000-00430000 rw-p 00010000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
40320000-40350000 rw-p 00000000 00:00 0                                  [heap]
ffff82dc0000-ffff82dd0000 ---p 00000000 00:00 0 
ffff82dd0000-ffff835e0000 rw-p 00000000 00:00 0 
ffff835e0000-ffff83750000 r-xp 00000000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83750000-ffff83760000 r--p 00160000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83760000-ffff83770000 rw-p 00170000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83770000-ffff83790000 r-xp 00000000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff83790000-ffff837a0000 r--p 00010000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff837a0000-ffff837b0000 rw-p 00020000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff837b0000-ffff837c0000 rw-p 00000000 00:00 0 
ffff837c0000-ffff837d0000 r--p 00000000 00:00 0                          [vvar]
ffff837d0000-ffff837e0000 r-xp 00000000 00:00 0                          [vdso]
ffff837e0000-ffff83800000 r-xp 00000000 fd:02 184054                     /usr/lib64/ld-2.17.so
ffff83800000-ffff83810000 r--p 00010000 fd:02 184054                     /usr/lib64/ld-2.17.so
ffff83810000-ffff83820000 rw-p 00020000 fd:02 184054                     /usr/lib64/ld-2.17.so
+fffffd930000-fffffd960000 rw-p 00000000 00:00 0                          [stack]
```



After malloc in thread1:

在下面的输出中，我们可以看到创建了thread1的堆段。同时从这个区域的起始地址可以看出，它并不是通过brk分配的，而是通过mmap分配，因为它的区域为(ffff7c000000-ffff80000000)共64MB，并不是同程序的data segment相邻。同时，我们还能看出在这64MB中，根据内存属性分为了2部分：ffff7c000000-ffff7c030000共191KB大小的空间是可读可写属性；后面的是不可读写属性。原来，这里只有可读写的132KB空间才是thread1的堆空间，即thread1 arena。

![image-20210204170835006](https://i.loli.net/2021/02/06/NHXCysfpuJIbGza.png)

```diff
00400000-00410000 r-xp 00000000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
00410000-00420000 r--p 00000000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
00420000-00430000 rw-p 00010000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
40320000-40350000 rw-p 00000000 00:00 0                                  [heap]
+ ffff7c000000-ffff7c030000 rw-p 00000000 00:00 0 
+ ffff7c030000-ffff80000000 ---p 00000000 00:00 0 
ffff82dc0000-ffff82dd0000 ---p 00000000 00:00 0 
ffff82dd0000-ffff835e0000 rw-p 00000000 00:00 0 
ffff835e0000-ffff83750000 r-xp 00000000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83750000-ffff83760000 r--p 00160000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83760000-ffff83770000 rw-p 00170000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83770000-ffff83790000 r-xp 00000000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff83790000-ffff837a0000 r--p 00010000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff837a0000-ffff837b0000 rw-p 00020000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff837b0000-ffff837c0000 rw-p 00000000 00:00 0 
ffff837c0000-ffff837d0000 r--p 00000000 00:00 0                          [vvar]
ffff837d0000-ffff837e0000 r-xp 00000000 00:00 0                          [vdso]
ffff837e0000-ffff83800000 r-xp 00000000 fd:02 184054                     /usr/lib64/ld-2.17.so
ffff83800000-ffff83810000 r--p 00010000 fd:02 184054                     /usr/lib64/ld-2.17.so
ffff83810000-ffff83820000 rw-p 00020000 fd:02 184054                     /usr/lib64/ld-2.17.so
fffffd930000-fffffd960000 rw-p 00000000 00:00 0                          [stack]
```



After free in thread1:

在下面的输出中，我们可以看到释放分配的内存区域不会将堆内存释放到操作系统。而是将分配的内存区域（大小为1000字节）释放到``glibc malloc''，这会将释放的块添加到其线程arenas bin中。

![image-20210204170859131](https://i.loli.net/2021/02/06/JZ6L4hcINPEjGOr.png)

```diff
00400000-00410000 r-xp 00000000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
00410000-00420000 r--p 00000000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
00420000-00430000 rw-p 00010000 fd:02 427083                             /mnt/test/heap-allocate/ptmalloc/ptmalloc1
40320000-40350000 rw-p 00000000 00:00 0                                  [heap]
+ffff7c000000-ffff7c030000 rw-p 00000000 00:00 0 
ffff7c030000-ffff80000000 ---p 00000000 00:00 0 
ffff82dc0000-ffff82dd0000 ---p 00000000 00:00 0 
ffff82dd0000-ffff835e0000 rw-p 00000000 00:00 0 
ffff835e0000-ffff83750000 r-xp 00000000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83750000-ffff83760000 r--p 00160000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83760000-ffff83770000 rw-p 00170000 fd:02 133803                     /usr/lib64/libc-2.17.so
ffff83770000-ffff83790000 r-xp 00000000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff83790000-ffff837a0000 r--p 00010000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff837a0000-ffff837b0000 rw-p 00020000 fd:02 133829                     /usr/lib64/libpthread-2.17.so
ffff837b0000-ffff837c0000 rw-p 00000000 00:00 0 
ffff837c0000-ffff837d0000 r--p 00000000 00:00 0                          [vvar]
ffff837d0000-ffff837e0000 r-xp 00000000 00:00 0                          [vdso]
ffff837e0000-ffff83800000 r-xp 00000000 fd:02 184054                     /usr/lib64/ld-2.17.so
ffff83800000-ffff83810000 r--p 00010000 fd:02 184054                     /usr/lib64/ld-2.17.so
ffff83810000-ffff83820000 rw-p 00020000 fd:02 184054                     /usr/lib64/ld-2.17.so
fffffd930000-fffffd960000 rw-p 00000000 00:00 0                          [stack]
```



## glibc malloc总览

glibc堆总览

![glibc堆总览](https://raw.githubusercontent.com/redisread/Image/master/Linux/image-20210206151048130.png)



最上层是Arena，在具体实现中是`malloc_state` 结构体。**Arena本质上是属于一个或多个线程的堆空间；但是每一个Arena也有它自己的内存区域，其中包含了与其关联的线程中的分配和释放的chunk(块)**。

包含在Glibc库中的Arena被称为**main Arena**，因为它被第一个线程或者主线程使用。虽然Arena没有直接链接到每个内存区域或分配的chunk，**但是它有其他的链接例如指向释放chunk的链接、指向下一个Arena的链接以及top chunk(顶部块)的指针**。这个top chunk表示给定Arena的剩余自由空间，用于创建新的chunk并位于Arena的末尾。

第二层在具体的实现中是`heap_info`结构体。尽管它们的名字**没有描述整个进程的堆或与线程关联的堆的部分**，而只描述它们属于的映射内存区域的一部分(由vm_area_struct结构描述。更具体的讲，**属于Arena(除了main Arena)的每个映射的内存区域，至少在内存区域的开头包含heap_info结构的一个实例，该实例保存该内存区域中当前堆部分的大小**。 除了大小之外，每个heap_info结构还保存一个指向关联Arena(malloc_state结构)的指针，以及指向同一竞技场内的前一个heap_info结构的指针。通过这种方式，它们都连接在一起。Arena指针存储在`ar_ptr`成员中，前一个heap_info的引用存储在`prev`成员中。与Arena相比，heap_info结构不是环形连接的的，而是像链表一样连接，第一个heap_info的`prev`只是空指针。

排除在竞技场和heap_info区域之外的是MMAPPED chunk。它是使用mmap API进行调用申请的内存。可以发现，没有从MMAPPED chunk到任何其他结构或从堆结构到它们的链接。这些chunk通常是在分配请求超过给定阈值（通常为128 * 1024bytes)时创建的。在这种情况下，这个chunk不包括主堆或者其他属于另一个Arena的的内存区域。操作系统会提供一个独占内存区域(通过mmapAPI调用)，该块被放置在其中。并且，mmap API调用返回是以页为单位对齐的空间。当释放MMAPPED chunk时，它所分配的整个内存空间将从进程空间中删除并返回到操作系统。

**Arena的数量**

疯狂的应用程序可能包含更多数量的线程（而不是核心数量），在这种情况下，每个线程只有一个竞技场会变得昂贵且无用。因此，由于这个原因，应用程序的竞技场限制取决于系统中存在的内核数

```
For 32 bit systems:
     Number of arena = 2 * number of cores.
For 64 bit systems:
     Number of arena = 8 * number of cores.
```

**多Arena的管理**

假设有如下情境：一台只含有一个处理器核心的PC机安装有32位操作系统，其上运行了一个多线程应用程序，共含有4个线程——主线程和三个用户线程。显然线程个数大于系统能维护的最大arena个数（2*核心数 + 1= 3），那么此时glibc malloc就需要确保这4个线程能够正确地共享这3个arena，那么它是如何实现的呢？

当主线程首次调用malloc的时候，glibc malloc会直接为它分配一个main arena，而不需要任何附加条件。

当用户线程1和用户线程2首次调用malloc的时候，glibc malloc会分别为每个用户线程创建一个新的thread arena。此时，各个线程与arena是一一对应的。但是，当用户线程3调用malloc的时候，就出现问题了。因为此时glibc malloc能维护的arena个数已经达到上限，无法再为线程3分配新的arena了，那么就需要重复使用已经分配好的3个arena中的一个(main arena, arena 1或者arena 2)。那么该选择哪个arena进行重复利用呢？

1)首先，glibc malloc循环遍历所有可用的arenas，在遍历的过程中，它会尝试lock该arena。如果成功lock(该arena当前对应的线程并未使用堆内存则表示可lock)，比如将main arena成功lock住，那么就将main arena返回给用户，即表示该arena被线程3共享使用。

2)而如果没能找到可用的arena，那么就将线程3的malloc操作阻塞，直到有可用的arena为止。

3)现在，如果线程3再次调用malloc的话，glibc malloc就会先尝试使用最近访问的arena(此时为main arena)。如果此时main arena可用的话，就直接使用，否则就将线程3阻塞，直到main arena再次可用为止。

这样线程3与主线程就共享main arena了。至于其他更复杂的情况，以此类推。



### 数据结构

#### heap_info

即Heap Header，因为一个thread arena（注意：不包含main thread）可以包含多个heaps，所以为了便于管理，就给每个heap分配一个heap header。

```c
typedef struct _heap_info
{
  mstate ar_ptr; /* Arena for this heap. */
  struct _heap_info *prev; /* Previous heap. */
  size_t size;   /* Current size in bytes. */
  size_t mprotect_size; /* Size in bytes that has been mprotected
                           PROT_READ|PROT_WRITE.  */
  /* Make sure the following data is properly aligned, particularly
     that sizeof (heap_info) + 2 * SIZE_SZ is a multiple of
     MALLOC_ALIGNMENT. */
  char pad[-6 * SIZE_SZ & MALLOC_ALIGN_MASK];
} heap_info;
 
```



#### malloc_state

Arena管理的数据结构，即Arena Header，每个thread只含有一个Arena Header。Arena Header包含bins的信息、top chunk以及最后一个remainder chunk等。

```c
struct malloc_state
{
  /* Serialize access.  */
  mutex_t mutex;
 
  /* Flags (formerly in max_fast).  */
  int flags;
 
  /* Fastbins */
  mfastbinptr fastbinsY[NFASTBINS];
 
  /* Base of the topmost chunk -- not otherwise kept in a bin */
  mchunkptr top;
 
  /* The remainder from the most recent split of a small request */
  mchunkptr last_remainder;
 
  /* Normal bins packed as described above */
  mchunkptr bins[NBINS * 2 - 2];
 
  /* Bitmap of bins */
  unsigned int binmap[BINMAPSIZE];
 
  /* Linked list */
  struct malloc_state *next;
 
  /* Linked list for free arenas.  */
  struct malloc_state *next_free;
 
  /* Memory allocated from the system in this arena.  */
  INTERNAL_SIZE_T system_mem;
  INTERNAL_SIZE_T max_system_mem;
};

```

malloc_state 和 heap_info结构在空间中的布局：

![malloc_state and heap_info structs in memory](https://raw.githubusercontent.com/redisread/Image/master/Linux/image-20210206160141623.png)



#### malloc_chunk

即Chunk Header，一个heap被分为多个chunk，至于每个chunk的大小，这是根据用户的请求决定的，也就是说用户调用malloc(size)传递的size参数“就是”chunk的大小(这里给“就是”加上引号，说明这种表示并不准确，但是为了方便理解就暂时这么描述了，详细说明见后文)。每个chunk都由一个结构体malloc_chunk表示

```c
struct malloc_chunk {
  /* #define INTERNAL_SIZE_T size_t */
  INTERNAL_SIZE_T      prev_size;  /* Size of previous chunk (if free).  */
  INTERNAL_SIZE_T      size;       /* Size in bytes, including overhead. */
  struct malloc_chunk* fd;         /* double links -- used only if free. 这两个指针只在free chunk中存在*/
  struct malloc_chunk* bk;
 
  /* Only used for large blocks: pointer to next larger size.  */
  struct malloc_chunk* fd_nextsize; /* double links -- used only if free. */
  struct malloc_chunk* bk_nextsize;
};

```

数据结构如下：



![在内存中分配额chunk](https://raw.githubusercontent.com/redisread/Image/master/Linux/image-20210206160108339.png)



NOTE：

1. Main thread不含有多个heaps所以也就不含有heap_info结构体。当需要更多堆空间的时候，就通过扩展sbrk的heap segment来获取更多的空间，直到它碰到内存mapping区域为止。
2. 不同于thread arena，main arena的arena header并不是sbrk heap segment的一部分，而是一个全局变量！因此它属于libc.so的data segment







![img](https://raw.githubusercontent.com/redisread/Image/master/Linux/chunk-allocated-simple-CS.png.pagespeed.ce.4F7IE_9i1S.png)





**Arena:**



**对chunk的理解**

在glibc malloc中将整个堆内存空间分成了连续的、大小不一的chunk，即对于堆内存管理而言chunk就是最小操作单位。chunk分四类：

- allocated chunk
- free chunk
- top chunk
- Last remainder chunk

从本质上来说，所有类型的chunk都是内存中一块连续的区域，只是通过该区域中特定位置的某些标识符加以区分。



简单的allocated chunk和free chunk

![图片描述](https://raw.githubusercontent.com/redisread/Image/master/Linux/bVvDyh.jpg)

![图片描述](https://raw.githubusercontent.com/redisread/Image/master/Linux/bVvDyj.jpg)



带边界标志的allocate chunk和free chunk

![图片描述](https://raw.githubusercontent.com/redisread/Image/master/Linux/bVvDyC.jpg)

![图片描述](https://raw.githubusercontent.com/redisread/Image/master/Linux/bVvDyE.jpg)

支持多线程

首先思考：是否有必要同时保存当前chunk和前一个chunk的已分配/空闲标记位？答案是否定的，因为我们只需要保存前一个chunk的分配标志位就可以了，至于当前chunk的分配标志位，可以通过查询下一个chunk的size字段得到。那么size字段中剩下的两个比特位就可以用于满足多线程的标志需求了：

![图片描述](https://raw.githubusercontent.com/redisread/Image/master/Linux/bVvDyF.jpg)

![图片描述](https://raw.githubusercontent.com/redisread/Image/master/Linux/bVvDyJ.jpg)



这里的 P,M,N 的含义如下：

- `PREV_INUSE(P)`：表示前一个chunk是否为allocated。
- `IS_MMAPPED(M)`：表示当前chunk是否是通过mmap系统调用产生的。
- `NON_MAIN_ARENA(N)`：表示当前chunk是否是thread arena

再进一步，发现没必要保存chunk size的副本，也就是说Footer的作用并不大，但是如果前一个chunk是free的话，在合并的时候我们又需要知道前一个chunk的大小，怎么办呢？将Footer从尾部移到首部，同时其不再保存当前chunk的size，而是前一个free chunk的size不就行了。同样的，为了提高内存利用率，如果前一个chunk是allocated chunk的话，这个Footer就作为allocated chunk的payload或padding的一部分，结构图如下：

![图片描述](https://raw.githubusercontent.com/redisread/Image/master/Linux/bVvDyP.jpg)

![图片描述](https://raw.githubusercontent.com/redisread/Image/master/Linux/bVvDyQ.jpg)





glibc

*Allocated chunk*:：

![img](https://raw.githubusercontent.com/redisread/Image/master/Linux/pub.png)

*Free Chunk*:

![img](https://raw.githubusercontent.com/redisread/Image/master/Linux/pub.jpg)







**Bins**



Bins是用来维护free chunk的链表数据结构，分配chunk从bins选，释放的chunk添加到bins；
 Bins分为了四类：Fast bin、Unsorted bin、Small bin、Large bin；

![img](https://raw.githubusercontent.com/redisread/Image/master/Linux/650075-45e188ded0403d1a.png)



- fast bin

  Chunks of size 16 to 80 bytes is called a fast chunk，一个Fast bin就是一个fast chunk的链表。

  一共10个Fast bin，Fast bin1存储16字节的fast chunk，Fast bin2存储24字节的fast chunk，so on (16-80字节)。

  fast chunk的特点是两个相邻的fast chunk不需要合并，所以free非常快。

  fast chunk的maloc和free都是在对应的fast bin的链表头增加和删除，LIFO；

  

Small bin
 小于512字节的chunk称之为small chunk，small bin就是用于管理small chunk的。就内存的分配和释放速度而言，small bin比larger bin快，但比fast bin慢。

- small bin有62个，每个small bin都是free chunk的双向链表，FIFO；
- 每个small bin中的chunk大小是一样的，不同的small bin从16字节开始，步长为8字节，直到512字节；
- malloc：找到匹配的非空bin，返回最后一个chunk；
   free：当释放small chunk的时候，先检查该chunk相邻的chunk是否为free，如果是的话就进行合并操作：将这些chunks合并成新的chunk，然后将它们从small bin中移除，最后将新的chunk添加到unsorted bin中。

Large bin
 大于512字节的chunk称之为large chunk，large bin就是用于管理这些large chunk的。large chunk最慢，因为一个Large bin中不同的chunk可以不一样大。

- large bin有63个，双向链表，删除和添加的位置不在头尾，可以任意位置；
- 步长不一样，在这63个large bins中，前32个large bin依次以64字节步长为间隔，即第一个large bin中chunk size为512~575字节，第二个large bin中chunk size为576 ~ 639字节。紧随其后的16个large bin依次以512字节步长为间隔；之后的8个bin以步长4096为间隔；再之后的4个bin以32768字节为间隔；之后的2个bin以262144字节为间隔；剩下的chunk就放在最后一个large bin中。
- 一个 large bin中的large chunk按照大小倒序排列。
- malloc(large chunk)操作：初始化完成之前的操作类似于small bin，这里主要讨论large bins初始化完成之后的操作。首先确定用户请求的大小属于哪一个large bin，然后判断该large bin中最大的chunk的size是否大于用户请求的size(只需要对比链表中front end的size即可)。如果大于，就从rear end开始遍历该large bin，找到第一个size相等或接近的chunk，分配给用户。如果该chunk大于用户请求的size的话，**就将该chunk拆分为两个chunk：前者返回给用户，且size等同于用户请求的size；剩余的部分做为一个新的chunk添加到unsorted bin中**。
- Free(large chunk)：类似于small chunk。

![img](https://raw.githubusercontent.com/redisread/Image/master/Linux/650075-74cc313a3cc7530f.png)





显示链表：在数据结构中常用的链表，而链表本质上就是将一些属性相同的“结点”串联起来，方便管理。在glibc malloc中这些链表统称为bin，链表中的“结点”就是各个chunk，结点的共同属性就是：

1) 均为free chunk

2) 同一个链表中各个chunk的大小相等





堆相关漏洞

1.  heap overflow

2. use after free

   应用场景：当某个块被释放后，由于释放仅仅是将其加入bin中，在内存中该块内容仍然存在；若此时再次分配一块与释放块大小一样的内存时，则会将该free块再次分配，也就是说当前块与free块其实指向同一块空间；若此时再去访问被释放的指针时程序并不会报错，而可直接访问那块空间。因此通过在第2次malloc后对这块空间的操作，可实现再次访问free掉的变量时，按照该变量的方式来解释该空间中的数值，从而实现一些程序逻辑方面上的功能。









---

参考地址：

1. [https://sploitfun.wordpress.com/2015/02/11/syscalls-used-by-malloc/](https://sploitfun.wordpress.com/2015/02/11/syscalls-used-by-malloc/)
2. [https://sploitfun.wordpress.com/2015/02/10/understanding-glibc-malloc/](https://sploitfun.wordpress.com/2015/02/10/understanding-glibc-malloc/)
3. [https://joyceqiqi.wordpress.com/2017/05/30/heap%e5%a0%86-%e5%9f%ba%e7%a1%80%e7%9f%a5%e8%af%86/](https://joyceqiqi.wordpress.com/2017/05/30/heap%e5%a0%86-%e5%9f%ba%e7%a1%80%e7%9f%a5%e8%af%86/)
4. [Linux 堆内存管理深入分析（上） - SegmentFault 思否](https://segmentfault.com/a/1190000005118060)
5. [Linux堆内存管理深入分析（下） - FreeBuf网络安全行业门户](https://www.freebuf.com/articles/security-management/105285.html)
6. [理解Linux堆内存管理 - 简书](https://www.jianshu.com/p/da609a494aa0)
7. [堆漏洞挖掘:03---chunk分类（allocated chunk、free chunk、top chunk、last remainder chunk）_江南、董少-CSDN博客](https://blog.csdn.net/qq_41453285/article/details/96851282)
8. [Heap Exploitation Part 1: Understanding the Glibc Heap Implementation | Azeria Labs](https://azeria-labs.com/heap-exploitation-part-1-understanding-the-glibc-heap-implementation/)

