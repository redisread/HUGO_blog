---
title: 极化码-基本原理
date: 2021-06-29T12:48:45+08:00
description: 介绍关于极化码的一些基本的数学与计算原理，包括如何进行概率的转移的。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://raw.githubusercontent.com/redisread/Image/master/PolarCode/Fundamentals/logo.png
libraries:
- katex
- mathjax
tags:
- 极化码
series:
- 极化码原理
categories:
- 极化码
---




## 基本概念

### 信噪比

信噪比，英文名称叫做SNR（*SIGNAL-NOISE RATIO* )，是指一个电子设备或者电子系统中信号与噪声的比例。信噪比的计算可以为**有用信号功率与噪声功率的比** ：

$$
SNR = \frac {P_{signal}} {P_{noise}}
$$


它的单位一般使用分贝，其值为十倍对数信号与噪声功率比:

$$
SNR(dB) = 10\log_{10}(\frac {P_{sibnal}} {P_{noise}})
$$


其中，$P_{signal}$为信号功率，$P_{noise}$为噪声功率。

### 转移概率

一个二进制输入离散无记忆信道（B-DMC）可表示为$W:X\to Y$，$X$是输入符号集合，$Y$是输出符号集合，转移概率为$W\left( y|x \right),x\in X,y\in Y$。由于信道是二进制输入，集合$X=\left\{ 0,1 \right\}$；$Y$和$W\left( y|x \right)$是任意值。对信道$W$的$N$次使用后的信道可表示为${W^{N}}$，则信道${W^{N}}:{X^{N}}\to {Y^{N}}$的转移概率为：

$$
{W^{N}}\left( y_1^{N}|x_{1}^{N} \right)=\prod\nolimits_{i=1}^{N}{W\left( y|x \right)}
$$


### 对称容量

对称容量是对信道速率的度量，记作$I(W)$，表示信道$W$在等概率输入下的可靠传输时的最大速率,计算公式如下：

$$
I\left( W \right)\triangleq \sum\limits_{y\in Y}{\sum\limits_{x\in X}{\frac{1}{2}}}W\left( y|x \right)\log \frac{W\left( y|x \right)}{\frac{1}{2}W\left( y|0 \right)+\frac{1}{2}W\left( y|1 \right)}
$$


当码长$N$趋近于无穷的时候，信道容量趋近于1的分裂信道比例约为$K=N×I(W)$，这部分是用来传输信息比特的信道数量，而信道容量趋近于0的比例约为$N×(1−I(W))$，这部分表示冻结比特的信道数量。对于信道容量为1的可靠信道，可以直接放置消息比特而不采用任何编码，即相当于编码速率为$R=1$；而对于信道容量为0的不可靠信道，可以放置发送端和接收端都事先已知的冻结比特，即相当于编码速率为$R=0$。那么当码长$N \to\infty$时，极化码的可达编码速率$R= \frac {K}{N}= \frac {N×I(W)}{N}=I(W)$，即在理论上，极化码可以被证明是可达信道容量的。


## 信道极化

信道极化分为信道联合和信道分裂两个阶段。对于长度为$N={2^{n}}$（$n$为任意整数）的极化码，它利用信道$W$的$N$个独立副本，进行信道联合和信道分裂，得到新的$N$个子信道$\left\{ W_{N}^{\left( 1 \right)},W_{N}^{\left( 2 \right)},...,W_{N}^{\left( N \right)} \right\}$。随着码长的增加，分裂之后的信道将向两个极端发展：其中一部分分裂信道会趋近于完美信道，即信道容量趋近于1的无噪声信道；而另一部分分裂信道会趋近于完全噪声信道，即信道容量趋近于0的信道。


我们主要研究二进制离散无记忆信道，将上面的信道模型（包括BEC、BSC、AWGN）进行抽象，我们可以得出下面的信道传输模型：

![基本信道模型](https://raw.githubusercontent.com/redisread/Image/master/PolarCode/Fundamentals/base-channel-model.png)

图中的W可以是BEC信道，也可以是BSC信道或者AWGN信道，其中I(W)为信道容量。


### 信道联合

信道联合是将多个子信道进行蝶形的异或操作的过程。对于码长为N=2的极化码，我们可以通过下面的蝶形异或操作将两个信道进行混合：

![码长N=2信道联合](https://raw.githubusercontent.com/redisread/Image/master/PolarCode/Fundamentals/channel-conbine.png)

由上图可以发现，进行信道联合之后，坐标不同信道的信道容量发生了极化现象，有一个比特的信道信道容量$I(W)$增加了，另外一个比特的信道容量$I(W)$减少了。信道容量小的，我们称为差信道，信道容量大的，我们称为号好信道。因为进行了信道联合之后，因为要求得左边的信道$u1$，必须是在右边的信道$y1$和$y2$同时都收到的情况下才能够得出$u1$，所以$u1$的信道容量就是信道$y1$和$y2$的信道容量乘积；相应的，对于信道$u2$，只有$y1$和$y2$都收不到的情况下，才接收不到信道，所以它的信道容量$I(W)$为$2*0.5 - 0.5^{2}$。

我们也可以使用一个二维表格来计算它们传输的概率：

|y1|y2|u1|u2|
|---|---|---|---|
|√|√|√|√|
|√|x|x|√|
|x|√|x|√|
|x|x|x|x|



由表格1可以发现，对于接收方收到的信号y1和y2，总共有4种情况，X表示该信道发生错误，未收到信道；√表示该信道收到了信道。对于子信道u1，在四种情况中，只有一种情况能够接受得到u1，也就是同时接收到y1和y2的情况,所以信道容量为1/4；而对于u2,只要能够收到y1或y2的任意一个它就能够解出来,根据信道极化理论，我们在进行极化的过程中，就已经知道信道u1的信道容量比较小，我们会把它作为冻结比特，填充为0，不传输信息比特，仅传输冻结比特，所以在没有接收到y2的情况下我们也能够得出u2。

对于N=4的码长，我们可以递归的进行信道联合，如图，只不过相比于N=2的码长的极化码，我们需要增加一次的信道联合过程：

![码长N=4信道联合](https://raw.githubusercontent.com/redisread/Image/master/PolarCode/Fundamentals/channel-conbine2.png)

按照这样不断的递归下去，到n级之后，可以得到递归的一般式：${W_{N/{2}\;}}$的2个独立副本联合产生信道${W_{N}}$，我们可以的到任意码长为$N=2^{n}$的极化码。

### 信道分裂

**信道分裂体现在信道联合之中** ，参考文献中对于信道分裂的解释，其大致过程是将两个信道$W_{N/2}$联合成一个信道$W_N$之后，再将联合的信道$W_N$分裂成两个子信道$W_{N/2}$，此时，这两个子信道的转移概率也改变了，这样极化码就完成了信道分裂。更具体的来说，它存在以下两个递推公式计算子信道的转移概率：

$$
W_{N}^{\left( 2i-1 \right)}\left( y_{1}^{N},u_{1}^{2i-2}|{u_{2i-1}} \right)=\sum\limits_{u_{2i}}{\frac{1}{2}W_{N/{2}\;}^{\left( i \right)}\left( y_{1}^{N/{2}\;},u_{1,o}^{2i-2}\oplus u_{1,e}^{2i-2}|{u_{2i-1}}\oplus {u_{2i}} \right)\cdot W_{N/{2}\;}^{\left( i \right)}\left( y_{N/{2}\;+1}^{N},u_{1,e}^{2i-2}|{u_{2i}} \right)}
$$


$$
W_{N}^{\left( 2i \right)}\left( y_{1}^{N},u_{1}^{2i-1}|{u_{2i}} \right)=\frac{1}{2}W_{N/{2}\;}^{\left( i \right)}\left( y_{1}^{N/{2}\;},u_{1,o}^{2i-2}\oplus u_{1,e}^{2i-2}|{u_{2i-1}}\oplus {u_{2i}} \right)\cdot W_{N/{2}\;}^{\left( i \right)}\left( y_{N/{2}\;+1}^{N},u_{1,e}^{2i-2}|{u_{2i}} \right)
$$




---

参考：

- [《“太极混一”——极化码原理及5G应用》](https://ccpt.cnki.net/kcms/detail/detail.aspx?filename=ZXTX201901005&dbcode=&dbname=CJFDLAST2019&pcode=CRJT&v=MTYwOTJybzlGWVlSK0MzODR6aDRYbkQwTFRnMlgyaHN4RnJDVVI3dWZadWRvRmlEbFdyL09QelhmZHJHNEg5ak0=&uid=WEEvREcwSlJHSldSdmVqMDh6a1dpRDVNamlacXoySjlDT0RFOEFxL1cvWT0=$9A4hF_YAuvQ5obgVAqNKPCYcEjKensW4IQMovwHtwkF4VYPoHbKxJw!!)

