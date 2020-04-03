---
title: "Udp-Tcp编程"
date: 2020-04-03T21:42:11+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/04/03/FfoM8l2KwXkdIxr.png
typora-copy-images-to: upload
libraries:
- katex
- mathjax
tags:
- tcp
- udp
- 网络
series:
- TCP/IP
categories:
-
---



TCP/IP编程

<!--more-->



{{< expand "目标:" >}}

能进行网络编程

1.如果你说你会select,epoll,iocp模型,那会让对方觉得更靠谱
2.如果你说出你做过im,下载之类那会让对方来兴趣.
3.如果你说设计了通讯协议,会让对方觉得更贴切
4.如果你说做过,熟悉, ftp http snmp smtp 这些简单的老古董协议,会加分,但不大.
5.如果你说熟悉bt,emule,udt等协议,那会对你很有好感.
6.如果你说你破解过某大牌 qq,360内某通讯协议,那会对你加分很大.

阶段:

**1)熟悉TCP/IP协议族的基本原理**
IP地址的分类，定义，获得，大概的管理方法
TCP、UDP等主要协议的特点，主要格式，以及重要字段在协议交互中起到的作用。

2）对于简单的TCP/IP协议导致的问题，有基本的判断
熟悉网络问题的解决方法，一个问题，应该是由上而下（top-button），还是由下而上（button-top）来分析？

**3）基本的编程知识。**
在系统内，构建简单通信。
在系统间，构建简单的通信。
熟悉系统内的API，知道在什么时候，改使用哪些API协调工作。
能够熟练使用这些API，在系统间传递信息，文件。
能够熟练使用这些API，实现自己的简单的私有协议。

**4）进阶编程知识**
知道一两个已经封装好的框架（framwork），它们之间的差别。
使用一个框架，写过能正常工作的程序。
知道网络协议处理也是要讲究性能的，知道性能的瓶颈会在什么地方产生。
能有较好的设计技巧，将私有协议设计得更加具有弹性，优雅。
熟悉系统间协议处理的细微的差异，以及将会对业务造成的影响，时延、状态不一致、自定义字段、、、、、

**5）熟练阶段的知识**
针对业务的需求，快速选型，定框架。
不再认为多线程是万能的。
知道稳定性比性能更加重要。
数据包去了哪儿，不用看代码，也能预估出来。

**6）源代码是最好的老师，永远都是。**

**以上，差不多或者已经达到4）的时候，就是“熟悉”了。**

{{< /expand >}}

## 网络模型

### OSI模型

![](https://i.loli.net/2020/04/03/5JOsFazQ2Xl3V7N.png)

### TCP/IP模型

![](https://i.loli.net/2020/04/03/AXoVFsOk5lrBiJt.png)



### 示例

![](https://i.loli.net/2020/04/03/uL3EYaxQCty9JmP.png)

### 协议对应

![](https://i.loli.net/2020/04/03/OCMKFyAoNvbmDwQ.png)

### 数据封装

![](https://i.loli.net/2020/04/03/8ZFcK6OiEvdejAp.png)



## C++UDP/TCP实例

#### 套接字

为了区分不同应用程序进程和连接，许多计算机操作系统为应用程序与TCP/IP交互提供了称为**嵌套字(Socket)**的接口。

常用的TCP/IP有以下三种类型的嵌套字：

* 流式嵌套字（SOCK_STREAM）

  用于提供面向连接的、可靠的数据传输服务，即使用TCP进行传输。

* 数据报嵌套字（SOCK_DGRAM）

  用于提供无连接的服务，即使用UDP进行传输。

* 原始嵌套字（SOCK_RAW

  可以读写内核没有处理的IP数据报，而流式嵌套字只能读取TCP的数据，数据报嵌套字只能读取UDP的数据.

> 如果要访问其它协议发送的数据必须使用原始嵌套字，它允许对底层协议(如IP或ICMP)直接访问

#### 端口对应进程

单单之后ip地址还不足以辨识通信的两个进程,因为操作系统是并发的,使用**端口**来辨认某个进程.所以套接字必须的两个信息为: ip地址 + 端口,例如: `192.168.1.4 1500`



<span style="font-size:2rem; background:yellow;">**Bigger**</span>



<kbd>Ctrl</kbd>+<kbd>F9</kbd>



