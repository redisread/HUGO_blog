---
title: "C文件读写"
date: 2020-04-04T23:32:40+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200404233552.png
libraries:
- katex
- mathjax
tags:
- C
- 文件读写
series:
- C
categories:
-
---



c文件读写:card_file_box:

<!--more-->

### 打开文件

可以使用 **fopen( )** 函数来创建一个新的文件或者打开一个已有的文件，这个调用会初始化类型 **FILE** 的一个对象，类型 **FILE** 包含了所有用来控制流的必要的信息。下面是这个函数调用的原型：

```C
FILE *fopen( const char * filename, const char * mode );
```

 **mode** 的值可以是r,w,a,,r+,w+,a+:

| r    | 打开一个已有的文本文件，允许读取文件。                       |
| ---- | ------------------------------------------------------------ |
| w    | 打开一个文本文件，允许写入文件。**如果文件不存在，则会创建一个新文件**。在这里，您的程序会从文件的开头写入内容。如果文件存在，则该会被截断为零长度，重新写入。 |
| a    | 打开一个文本文件，以**追加模式**写入文件。如果文件不存在，则会创建一个新文件。在这里，您的程序会在已有的文件内容中追加内容。 |
| r+   | 打开一个文本文件，允许读写文件。                             |
| w+   | 打开一个文本文件，允许读写文件。如果文件已存在，则文件会被截断为零长度，如果文件不存在，则会创建一个新文件。 |
| a+   | 打开一个文本文件，允许读写文件。如果文件不存在，则会创建一个新文件。读取会从文件的开头开始，写入则只能是追加模式。 |

{{< notice warning >}}
如果处理的是二进制文件，则需使用下面的访问模式来取代上面的访问模式：

```c
"rb", "wb", "ab", "rb+", "r+b", "wb+", "w+b", "ab+", "a+b"
```

{{< /notice >}}

### 关闭文件

关闭文件非常简单,只需要调用**fclose()**函数即可,其中参数就是指向文件对象的指针.

```c
 int fclose( FILE *fp );
```

{{< notice info >}}
如果成功关闭文件，**fclose( )** 函数返回零，如果关闭文件时发生错误，函数返回 **EOF**。这个函数实际上，会清空缓冲区中的数据，关闭文件，并释放用于该文件的所有内存。EOF 是一个定义在头文件 **stdio.h** 中的常量。
{{< /notice >}}

### demo

```c
void open_close_file(){
    char fname[10];
    printf("pease input file name: ");
    scanf("%s",fname);
    FILE *p = fopen(fname,"r+");
    if(p == NULL) {
        printf("file open fail!\n");
        return ;
    }
    printf("file %s open sucessful!\n",fname);
    fclose(p);
    printf("file %s had be closed!\n",fname);
}
```

![result](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200404225921263.png)

### 读取文件

读取单个字符的最简单的函数:

```c
int fgetc( FILE * fp );
```

读取多个字符的函数(也可以读取单个字符):

```c
char *fgets( char *buf, int n, FILE *fp );
```

{{< notice warning >}}
**fgetc()** 函数从 fp 所指向的输入文件中读取一个字符。返回值是读取的字符，如果发生错误则返回 **EOF**。

函数 **fgets()** 从 fp 所指向的输入流中读取 n - 1 个字符。它会把读取的字符串复制到缓冲区 **buf**，并在最后追加一个 **null** 字符来终止字符串。

{{< /notice >}}

例子:

```c
void read_file_demo()
{
    char fname[10] = "basic.sql";
    FILE *fp = fopen(fname, "r+");
    if (fp == NULL)
    {
        printf("file open fail!\n");
        return;
    }
    printf("file %s open sucessful!\n", fname);
    char ch;
    int n = 5;
    printf("\nusing fgetc()......\n");
    while (n--)
    {
        ch = fgetc(fp);
        if(ch != EOF)
            printf("char = %c\n", ch);
    }
    char str[20];
    printf("\nusing fgets()......\n");
    fgets(str,20,fp);
    printf("str[20] = %s\n",str);
    fclose(fp);
    printf("file %s had be closed!\n", fname);
}
```

读取二进制输入:

```c
size_t  fread(void *buffer, size_t size, size_t count, FILE * stream);
```

> buffer为接收数据的地址，size为一个单元的大小，count为单元个数，stream为文件流。
>
> 返回实际读取的单元个数。如果小于count，则可能文件结束或读取出错；可以用[ferror()](http://c.biancheng.net/cpp/html/2507.html)检测是否读取出错，用[feof()](http://c.biancheng.net/cpp/html/2514.html)函数检测是否到达文件结尾。如果size或count为0，则返回0。

### 写入文件

写入单个字符的最简单的函数:

```c
int fputc( int c, FILE *fp );
```

写入多个字符的函数(也可以写入单个字符):

```c
int fputs( const char *s, FILE *fp );
```

{{< notice warning >}}
函数 **fputc()** 把参数 c 的字符值写入到 fp 所指向的输出流中。如果写入成功，它会返回写入的字符，如果发生错误，则会返回 **EOF**。

函数 **fputs()** 把字符串 **s** 写入到 fp 所指向的输出流中。如果写入成功，它会返回一个非负值，如果发生错误，则会返回 **EOF**。

{{< /notice >}}

例子:

```c
void write_file_demo()
{
    char fname[10] = "test.txt";
    FILE *fp = fopen(fname, "w+");
    if (fp == NULL)
    {
        printf("file open fail!\n");
        return;
    }
    printf("file %s open sucessful!\n", fname);
    char ch;
    int n = 5;
    printf("\nusing fputc()......\n");
    while (n--)
    {
        ch = (char)(100+n);
        if((ch = fputc(ch,fp)) != EOF)
            printf("char %c write successful!\n",ch);
    }
    char str[30] = "\nIt`s a test for write!";
    printf("\nusing fputs()......\n");
    int r = fputs(str,fp);
    if(r >= 0)
        printf("str[30] = %s write successful!\n",str);
    fclose(fp);
    printf("file %s had be closed!\n", fname);
}
```

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200404232550.png)

![image-20200404232614337](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200404232614337.png)

二进制输出:

```c
size_t fwrite(void * buffer, size_t size, size_t count, FILE * stream);
```

> buffer为数据源地址，size为每个单元的字节数，count为单元个数，stream为文件流指针。
>
> 返回成功写入的单元个数。如果小于count，则说明发生了错误，文件流错误标志位将被设置，随后可以通过[ferror()](http://c.biancheng.net/cpp/html/2507.html)函数判断。

---

参考:

1. https://www.runoob.com/cprogramming/c-file-io.html