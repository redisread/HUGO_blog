---
title: 打桩机制
date: 2021-01-14T11:26:46+08:00
description: LInux链接器有强大的库打桩机制，它允许你对共享库的代码进行截取，从而执行自己的代码。而为了调试，你通常可以在自己的代码中加入一些调试信息，例如，调用次数，打印信息，调用时间等等。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/01/14/7OgZPEvV8lrw9JR.png
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



# 库打桩机制

LInux链接器有强大的库打桩机制，它允许你对共享库的代码进行截取，从而执行自己的代码。而为了调试，你通常可以在自己的代码中加入一些调试信息，例如，调用次数，打印信息，调用时间等等。



## 基本原理

### 基本思想

给定需要打桩的目标函数，常见一个wrapper函数，其原型和目标函数一致。利用特殊的打桩机制，可以实现让系统调用你的wrapper函数而不是目标函数。wrapper函数中通常会执行自己的逻辑，然后调用目标函数，再将目标函数的返回值传递给调用者。

> 打桩可以发生在编译时、链接时或者程序被加载执行的运行时。不同的阶段都有对应的打桩机制，也有其局限性。



## 打桩时期



创建一个main.c文件，内容：

```c
#include <stdio.h>
#include <malloc.h>
int main()
{
    char *p = malloc(64);
    printf("Hello\n");
    free(p);
    return 0;
}
```

### 编译时打桩

> 使用 C 预处理器在编译时打桩。

定义插桩函数头文件 `malloc.h`

```c
#define malloc(size) mymalloc(size)
#define freeCptr) myfree(ptr) 23

void *mymalloc(size_t size);
void myfree(void *ptr);
```

定义插桩函数的文件 `mymalloc.c`

```c
// mymalloc.c
#ifdef COMPILETIME
#include <stdio.h>
#include <malloc.h>

// malloc wrapper function
void * mymalloc(size_t size) {
    void * ptr = malloc(size);
    printf("malloc %p size %u\n", ptr, size);
    return ptr;
}

// free wrapper function
void myfree(void *ptr) {
    free(ptr);
    printf("free %p\n", ptr);
}
#endif
```



这样编译和链接程序

```bash
gcc -DCOMPILETIME -c mymalloc.c
gcc -I. -o main main.c mymalloc.o
```

执行：

```bash
./main
```

![编译插桩](https://i.loli.net/2021/02/03/tqPXczoxCrm6v2n.png)



### 链接时打桩

> 链接(linking)是将各种代码和数据片段收集并组合成为一个单一文件的过程，这个文件可被加载（复制）到内存并执行。

这个不需要头文件，直接创建一个插桩函数文件 `mymalloc.c`:

```c
#ifdef LINKTIME
#include <stdio.h>
void *__real_malloc(size_t size);
void __real_free(void *ptr);

/* malloc wrapper function */
void *__wrap_malloc(size_t size)
{
    void *p = __real_malloc(size);  // 调用libc的malloc
    printf("malloc(%d) = %p \n",size,p);
    return p;
}

/* free wrapper function */
void *__wrap_free(void *ptr)
{
    __real_free(ptr);
    printf("free(%p)\n",ptr);
}

#endif
```

这样编译和链接程序

```bash
gcc -DLINKTIME -c mymalloc.c
gcc -c main.c
gcc -Wl,--wrap,malloc -Wl,--wrap,free -o main main.o mymalloc.o
```

执行

```bash
./main
```

![链接插桩](https://i.loli.net/2021/02/03/tpgkNJbFv3s8Pl6.png)

### 运行时打桩

创建一个插桩函数文件 `mymalloc.c`:

```c
#ifdef RUNTIME

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>


/* malloc wrapper function */
void *malloc(size_t size)
{
    void  *(*mallocp)(size_t size);
    char *error;
    mallocp = dlsym(RTLD_NEXT,"malloc");    // get the address of libc malloc
    if((error = dlerror()) != NULL)
    {
        fputs(error,stderr);
        exit(1);
    }
    char *ptr = mallocp(size);
    printf("malloc(%d) = %p \n",(int)size,ptr);
    return ptr;
}


/* free wrapper function */
void free(void* ptr)
{
    void (*freep)(void*) = NULL;
    char *error;
    if(!ptr) return;
    freep = dlsym(RTLD_NEXT,"free");
    if((error = dlerror()) != NULL)
    {
        fputs(error,stderr);
        exit(1);
    }
    freep(ptr);
    printf("free(%p)\n",ptr);

}

#endif
```



这样编译链接执行程序

```bash
gcc -DRUNTIME -shared -fpic -o mymalloc.so mymalloc.c -ldl
gcc -o main main.c
LD_PRELOAD="./mymalloc.so" ./main
```

![运行时插桩](https://i.loli.net/2021/02/03/5TuJ76IrwNiyCpH.png)

## GCC相关参数

| 参数    | 功能                                                         |
| ------- | ------------------------------------------------------------ |
| -c      | 只激活预处理,编译,和汇编,也就是他只把程序做成obj文件,将生成 .o 的 obj 文件<br />例子：```gcc -c hello.c``` |
| -S      | 只激活预处理和编译，就是指把文件编译成为汇编代码,将生成 .s 的汇编代码。<br />例子：```gcc -S hello.c ``` |
| -E      | 只激活预处理,这个不生成文件, 你需要把它重定向到一个输出文件里面。<br />例子：```gcc -E hello.c > pianoapan.txt  gcc -E hello.c | more ``` |
| -o      | 指定目标名称                                                 |
| -g      | 只是编译器，在编译的时候，产生调试信息。                     |
| -static | 此选项将禁止使用动态库，所以，编译出来的东西，一般都很大，也不需要什么动态连接库，就可以运行。 |
| -share  | 此选项将尽量使用动态库，所以生成文件比较小，但是需要系统由动态库。 |



我们通过ldd命令查看程序链接的系统库：

![ldd指令](https://i.loli.net/2021/02/03/YOmVR8Qi3zIhkDL.png)



---

参考链接：

1. https://zhuanlan.zhihu.com/p/76036630
2. https://www.cnblogs.com/tocy/p/Linux-library-Interposition.html
3. [GCC 参数详解](https://www.runoob.com/w3cnote/gcc-parameter-detail.html)

