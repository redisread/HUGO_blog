---
title: "Linux编辑利器-Vim"
date: 2020-04-13T23:01:25+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/04/13/IJ9BjeUSnymkaqO.png
libraries:
- katex
- mathjax
tags:
- Linux
- Vim
series:
- Linux
categories:
-
---



在大学时代，Vim 的大名就已如雷贯耳，但由于它陡峭的学习曲线，一直望而却步。等真正开始学习之后，发现并没有想象中的复杂，也没有所谓的瓶颈，只要在实际写代码中强迫自己使用就可以了，无形中就会形成习惯。

​																														——[GeekPlux](https://geekplux.com/)

<!--more-->



## 三种模式

### 正常模式

以 vim 打开一个档案就直接进入一般模式了(这是默认的模式)。正常模式可以使用快捷键。

### 编辑模式

按下i, I, o, O, a, A, r, R等任何一个字母之后才会进入编辑模式, 一般来说按i即可.

### 命令行模式

在这个模式当中， 可以提供你相关指令，完成读取、存盘、替换、离开 vim 、显示行号等的动作则是在此模式中达成的。



> vi 和vim模式的相互切换 
>
> ![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200413231804533.png)

## 常用快捷键

> 使用快捷键在正常模式下输入！

### 复制粘贴

拷贝当前行输入`yy`，然后再按下`p`键的时候就可以粘贴了。

复制多行可以输入`nyy`，其中n为一个数字，例如`5yy`，即复制当前行向下的5行，同样粘贴也是按`p`键。

### 删除

删除当前行输入`dd`

删除多行输入`ndd`，表示删除当前行向下的n行。

### 查找单词

再正常模式下输入`/关键字`即可查找关键字所在的位置，例如`/hello`为查找`hello`这个单词所有的所在位置，输入 n 就是查找下一个。

### 设置文件行号

有时候为了看文档更清楚，想要知道每一行的行数，可以先进入命令模式，在输入`set nu`，即再正常模式下输入`:set nu`,然后回车。

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200413232700.png)

取消行号可以输入`:set nonu`

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200413232801.png)

### 移动到底部到首部

有时候需要直接看文档的末尾，可以输入`G`移动到文件末行。

而移动到首行则是输入`gg`，然后回车即可。

### 撤销

取消上一次做的操作，输入`u`。表示undo。

### 移动到某行

假如我们要移动到第20行，我们可以这样输入：`20 + shift + g`

---

更多快捷键可以参考：[https://zhuanlan.zhihu.com/p/77283813](https://zhuanlan.zhihu.com/p/77283813)

**Vim键盘图**

![Vim键盘图](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200413233349.png)

**思维导图：**

![](https://i.loli.net/2020/04/13/Iq1N3uvcxZP6ObV.png)