---
title: 极化码-编码
date: 2021-06-29T13:01:45+08:00
description: 极化码的编码就是一些简单的线性运算，通过矩阵进行简化多维的运算，归根到底还是基于基本的异或操作。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
image: https://raw.githubusercontent.com/redisread/Image/master/PolarCode/Encode/logo.png
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




极化编码的基本思想是：只在$Z\left( W_{N}^{\left( i \right)} \right)$近于0的坐标信道$W_{N}^{\left( i \right)}$上发送数据比特。极化码具有一般的二元线性分组码的基本编码要素，因而可以通过显示地写出其生成矩阵来完成编码：

$$
x_{1}^{N}=u_{1}^{N}{G_{N}}
$$


其中，编码生成矩阵${G_{N}}\text{=}{B_{N}}{F^{\otimes n}}$，$B_{N}$是排序矩阵，完成比特的反序操作，$F^{\otimes n}$表示矩阵$F$进行$n$次$Kronecker$积操作，有递归公式${F^{\otimes n}}=F\otimes {F^{\otimes \left( n-1 \right)}}$且${F^{\otimes 1}}\text{=}F=\left[ \begin{matrix}
   1 & 0  \\
   1 & 1  \\
\end{matrix} \right]$。

主要的步骤为：

![主要流程](https://raw.githubusercontent.com/redisread/Image/master/PolarCode/Encode/main-flow.png)



## 可靠性估计

可靠性估计就是极化码的构造，这个过程我们选出信道容量高的子信道进行传输，信道容量低的子信道传输冻结比特。

常见的几种可靠性估计的方法（极化码构造方法）有：

1. 巴士参数估计法。

2. 蒙特卡洛法。

3. 密度进化法。

4. 高斯近似法。

## 比特混合

假设通过错误概率进行极化码构造之后得到极化序列为$\left\{ 3,5,6,7,0,1,2,4 \right\}$ ，选择前面K个信道即$A=\left\{ 3,5,6,7\right\}$发送信息比特；另外的信道集合${A^{c}}=\left\{ 0,1,2,4\right\}$作为固定比特传输。设信息比特集合为$\left( {i_{0}},{i_{1}},{i_{2}},{i_{3}} \right)=\left( 1,1,1,1 \right)$，固定比特设置为0，则最终得到待编码的信息比特：

$$
u_{0}^{7}=\left[ 0,0,0,{i_{0}},0,{i_{1}},{i_{2}},{i_{3}} \right]=\left[ 0,0,0,1,0,1,1,1 \right]
$$


经过上面的过程我们就完成了对信息位和冻结位的比特混合。

## 构造生成矩阵

首先我们求出排序矩阵$B_{N}$，其有递归式：

$$
{B_{N}}={R_{N}}\left( {I_{2}}\otimes {B_{N/{2}\;}} \right)
$$


$$
{B_{2}}={I_{2}}
$$


我们得到排序矩阵$B_{N}$，对输入序列完成奇序元素和偶序元素的分离，即先排奇序元素，再排偶序元素，其作为效果如下:

$$
\left( {u_{1}},{u_{2}},{u_{3}},{u_{4}},...,u{}*{N} \right)\times {R* {N}}=\left( {u_{1}},{u_{3}},{u_{5}},...,{u_{N-1}},{u_{2}},{u_{4}},{u_{6}},...,{u_{N}} \right)
$$


$F$矩阵我们可以根据下面的递归式进行求解：

$$
{F^{\otimes n}}=F\otimes {F^{\otimes \left( n-1 \right)}}
$$


$$
F=\left[ \begin{matrix}
   1 & 0  \\
   1 & 1  \\
\end{matrix} \right]
$$


最后，我们将求得的排序矩阵和$F$矩阵相乘，得到生成矩阵$G_{N}$：

$$
{G_{N}}={B_{N}}{F^{\otimes n}}
$$


假设我们求得的生成矩阵是：

![](https://raw.githubusercontent.com/redisread/Image/master/PolarCode/Encode/image_1.png)


## 生成极化码

将信息比特与生成矩阵$G_{N}$相乘得到最终编码后的极化码，例如：

![](https://raw.githubusercontent.com/redisread/Image/master/PolarCode/Encode/image_2.png)

---

参考：

- [Polar Code（2）编码原理 | Marshall - Comm. Tech. Blog](https://marshallcomm.cn/2017/03/04/polar-code-2-encoding-principle/)