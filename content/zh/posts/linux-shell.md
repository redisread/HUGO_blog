---
title: "Linux命令与Shell"
date: 2020-04-11T23:24:18+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://gitee.com/wujiahong1998/MyBed/raw/master/img/linux.png
libraries:
- katex
- mathjax
tags:
- Linux
- Shell
- bash
series:
-
categories:
-
---





Linux基本操作。:cowboy_hat_face:

<!--more-->

# Linux

### 目录结构及解释

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/Linux文件目录.png)

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/Linux.svg)

查看命令行执行完位置：

```bash
echo $BASH
```

![bash](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200411215647700.png)



### 命令记录

#### mkdir

**mkdir命令** 用来创建目录。

语法：`mkdir (选项)(参数)`

> **主要选项**：
>
> -m<目标属性>或--mode<目标属性>建立目录的同时设置目录的权限；
>
>  -p或--parents 若所要建立目录的上层目录目前尚未建立，则会一并建立上层目录；
>
> **参数：**
>
> 指定要创建的目录列表，多个目录之间用空格隔开。

创建多层目录：

```bash
mkdir a/b/c/d
```

#### chmod

**chmod命令**用来变更文件或目录的权限。

语法：`chmod(选项)(参数)`

权限范围的表示法如下：

`u` User，即文件或目录的拥有者；
`g` Group，即文件或目录的所属群组；
`o` Other，除了文件或目录拥有者或所属群组之外，其他用户皆属于这个范围；
`a` All，即全部的用户，包含拥有者，所属群组以及其他用户；
`r` 读取权限，数字代号为“4”;
`w` 写入权限，数字代号为“2”；
`x` 执行或切换权限，数字代号为“1”；
`-` 不具任何权限，数字代号为“0”；
`s` 特殊功能说明：变更文件或目录的权限。

例子：

```bash
chmod u+x,g+w f01　　//为文件f01设置自己可以执行，组员可以写入的权限
chmod u=rwx,g=rw,o=r f01
chmod 764 f01
chmod a+x f01　　//对文件f01的u,g,o都设置可执行属性
```

可以输入命令`ll -d 文件名`查看文件的权限：

![权限](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200411223232940.png)

linux文件的用户权限的分析图

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200411221535.png)

例：rwx　rw-　r--

r=读取属性　　//值＝4
w=写入属性　　//值＝2
x=执行属性　　//值＝1

对demo.sh执行`chmod a+x demo.sh`之后，查看其权限，三个组都含`x`，表示所有用户都能执行：

![look](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200411223434051.png)

### Shell脚本

shell脚本一般以`.sh`结尾。如`demo.sh`：

```shell
#!/bin/bash
#This is my First shell
echo "Hello World!"
```

> 第一行表示脚本的位置
>
> 第二行为注释
>
> 第三行为脚本的命令

如何执行？在Linux下需要先赋予权限

```bash
chmod o+x demo.sh
```

执行

```bash
./demo.sh
```

![demo](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200411220829.png)

**常见的变量**
`$0`当前程序的名称
`$n`当前程序的第 n 个参数,n=1,2,…9
`$*` 当前程序的所有参数(不包括程序本身)
`$#` 当前程序的参数个数(不包括程序本身)
`$?` 命令或程序执行完后的状态，一般返回 0 表示执行成功。
`$UID` 当前用户的 ID
`$PWD` 当前所在的目录

#### If 条件判断语句

格式：

```shell
if (表达式) #if ( Variable in Array )
语句 1
else
语句 2
fi
```

例：

```shell
#!/bin/sh
NUM=100
if (( $NUM > 4 )) ;then
echo “this num is $NUM greater 4 !”
fi
```



参考：

1. [https://wangchujiang.com/linux-command/](https://wangchujiang.com/linux-command/)

