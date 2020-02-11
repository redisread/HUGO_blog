---
title: "windows下gcc的安装和使用"
date: 2020-02-04T16:41:18+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: http://gcc.gnu.org/img/gccegg-65.png
tags:
- gcc
- MinGW
series:
- 配置
categories:
-
---

写在源文件中的源代码是人类可读的源。它需要"编译"，转为机器语言，这样 CPU 可以按给定指令执行程序。C 语言编译器用于把源代码编译成最终的可执行程序。<span><code>:baby_chick:</code></span>

<!--more-->

### 安装

首先,到：https://sourceforge.net/projects/mingw-w64/files/latest/download，下载最新版本的 MinGW 安装程

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200204164527145.png)

然后，运行 Download mingw-get-setup.exe ,点击"运行"，continue等，注意记住安装的目录，之后需要配置环境变量，例如`D:\MinGW\bin`



{{< notice info >}}假如网速不好，可以通过下面的链接进行离线下载，下载完成之后使用7Zip解压，然后把解压的文件移动到安装路径即可。

https://pan.baidu.com/s/1W4fHsUeaw1C9vp1lvRygbw

注：使用这种方式下面的步骤不需要执行了，已经在离线包中集成了。可直接输入`gcc -v`查看gcc版本。{{< /notice >}}

验证安装：

在开始菜单中，点击"运行"，输入 cmd,打开命令行:输入 mingw-get,如果弹出 MinGw installation manager 窗口，说明安装正常，然后关闭窗口。



### 安装GCC等编译器

在cmd中输入如下命令进行安装：

安装gcc

```bash
mingw-get install gcc
```

安装g++

```bash
mingw-get install g++ 
```

安装gdb

```bash
mingw-get install gdb
```

### 使用

在桌面创建一个hello.c的程序

```C++
#include <iostream>
using namespace std;
int main()
{

    cout << "Hello!" << endl;

    return 0;
}
```

在 cmd 中输入命令

```bash
gcc hello.c
```

在**当前目录下**(记住是命令的当前目录)会生成 a.exe 的可执行文件，在 cmd 中输入 a.exe 就可以执行程序了。