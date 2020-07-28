---
title: "epoll的水平触发与边缘触发"
date: 2020-07-28T12:00:13+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/07/28/EFsmxfOJ3jI5WlR.png
libraries:
- katex
- mathjax
tags:
- Linux
- epoll
series:
- Linux
categories:
-
---



描述符的就绪状态有两种判断方法: **边沿触发**和**水平触发**。

**水平触发**

我认为这是“拉”模式或“民意调查”模式。为了确定描述符是否就绪，进程尝试执行非阻塞 I/O 操作。一个进程可以多次执行这样的操作。这允许在处理任何后续 I/O 操作方面有更大的灵活性ー例如，如果描述符已经准备好，进程可以选择读取所有可用的数据或者根本不执行任何 I/O 操作，或者选择不读取缓冲区中所有可用的输入数据。让我们通过一个例子来看看它是如何工作的。

在 t0时，进程可以在非阻塞描述符上尝试 I/O 操作。如果 I/O 操作阻塞，系统调用将返回一个错误。

![image-20200727182846553](https://i.loli.net/2020/07/27/CUa3ex4pMAW2DvS.png)

然后在 t1时，进程可以再次尝试在描述符上进行 I/O。假设调用再次阻塞，并返回一个错误。

![image-20200727182857256](https://i.loli.net/2020/07/27/CUa3ex4pMAW2DvS.png)

然后在时间 t2，进程再次尝试描述符上的 I/O。假设调用再次阻塞，并返回一个错误。

![image-20200727182930304](https://i.loli.net/2020/07/27/A8tVzgh73bZaLyY.png)

假设在 t3时，进程轮询描述符的状态，描述符就绪。然后进程可以选择实际执行整个 I/O 操作(例如，读取套接字上的所有可用数据)。

![image-20200727182944880](https://i.loli.net/2020/07/27/csx4YUCXqlzwhA3.png)

让我们假设在 t4时进程轮询描述符的状态，而描述符没有准备好。调用再次阻塞，并且 I/O 操作返回一个错误。

![image-20200727183028720](https://i.loli.net/2020/07/27/qXEAYMI3wn7VRol.png)

假设在 t5时，进程轮询描述符的状态，描述符就绪。进程随后可以选择只执行部分 I/O 操作(例如，只读取所有可用数据的一半)。

![image-20200727183109512](https://i.loli.net/2020/07/27/NKcIVuRaOPwL16r.png)

​	假设在 t6时，进程轮询描述符的状态，描述符就绪。这一次，进程可以选择根本不执行后续的 I/O。

![image-20200727183145744](https://i.loli.net/2020/07/27/xWk4fYchMBAwHIb.png)



### 边缘触发

流程只有在文件描述符“就绪”时才会收到通知(通常是在文件描述符上有任何新活动时，因为它是上次被监视的)。我认为这就是“推送”模型，因为通知被推送到进程中，说明文件描述符的准备就绪情况。此外，对于 push 模型，只通知进程说描述符已经为 I/O 准备好了，而不提供其他信息，例如到达 socket 缓冲区的字节数。

因此，当一个进程试图执行任何后续 I/O 操作时，它只配备了不完整的数据。为了解决这个问题，进程可以在每次获得描述符准备就绪通知时，尝试执行尽可能大的 I/O，因为如果不这样做，就意味着进程必须等待下一个通知到来，即使在下一个通知到来之前，在描述符上可以进行 I/O。

开始：

![image-20200727183341112](https://i.loli.net/2020/07/27/LCtlUHDuNWSp9cA.png)

在 t2时，进程得到一个关于描述符已经准备好的通知。

![image-20200727183356775](https://i.loli.net/2020/07/27/zZVotiCkraIpF8v.png)

可用于 I/O 的字节流存储在缓冲区中。假设当进程在时间 t2获得通知时，有1024个字节可供读取。

![image-20200727205025883](https://i.loli.net/2020/07/27/ulmf1aLqzrovcEP.png)

假设该进程只读取1024个字节中的500个字节。

![image-20200727205043481](https://i.loli.net/2020/07/27/pNcZubqK5i8kED7.png)

这意味着在 t3、 t4和 t5时，缓冲区中仍然有524个字节可供进程读取而不会阻塞。但是，由于进程只能在获得下一个通知后执行 I/O，因此在这段时间内，这524个字节将保留在缓冲区中。

![image-20200727205106297](https://i.loli.net/2020/07/27/6B8jJWFsKNDiLao.png)



假设进程在时间 t6获得下一个通知，当额外的1024个字节到达缓冲区时。缓冲区上可用的数据总量现在是1548字节ー524字节，以前没有读过，1024字节是新到的。

![image-20200727205122857](https://i.loli.net/2020/07/27/EPDQuwaIxec37VW.png)

假设进程现在读取1024个字节。

![image-20200727205144138](https://i.loli.net/2020/07/27/v7lmNrg2AhxqIwf.png)

这意味着在第二次 I/O 操作结束时，524个字节仍然保留在缓冲区中，在下一个通知到达之前，进程将无法读取这个缓冲区。

虽然在通知到达后立即执行所有 I/O 可能是临时的，但这样做会产生一些后果。单个描述符上的大型 I/O 操作可能会饿死其他描述符。此外，即使在级别触发通知的情况下，一个非常大的写或发送调用也有可能阻塞。



### Multiplexing I/O on descriptors

有几种在描述符上多路 I/O 的方法:

— non-blocking I/O (the descriptor itself is marked as **non-blocking**, operations may finish partially)
— signal driven I/O (the process owning the descriptor is notified when the I/O state of the descriptor changes)
— polling I/O (with ***select\*** or ***poll\*** system calls, both of which provide **level triggered** notifications about the *readiness* of descriptors)
— BSD specific kernel event polling (with the ***kevent\*** system call).





---

参考：

* [https://medium.com/@copyconstruct/the-method-to-epolls-madness-d9d2d6378642](https://medium.com/@copyconstruct/the-method-to-epolls-madness-d9d2d6378642)





