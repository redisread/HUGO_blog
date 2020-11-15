---
title: "机器学习基本算法"
date: 2020-03-08T23:33:24+08:00
description: 机器学习必须掌握的基础算法，学会这些基础，对后面的理解才会透彻
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/03/08/R37TfHmnANqJkB8.png
libraries:
- katex
- mathjax
tags:
- 机器学习
- SVM
- 决策树
- kNN
- PCA
series:
- DL
categories:
-
---

机器学习有这些基本的算法组成，要门机器学习，就需要打个地基:black_nib:

<!--more-->

## K近邻算法-KNN-(k-Nearest-Neighbors)

可以解决的问题:

* 分类问题
* 回归问题

### 预测一个人是天才还是白痴

首先先生成模拟数据，,`x1`和`x2`分别表示两个特征

IQ值低的数据

```python
x1_low = np.random.random(10) + 3
x2_low = np.random.random(10) + 6
x1_low,y2_low
```

```output
(array([3.72183336, 3.16146551, 3.88914234, 3.85673496, 3.1573191 ,
        3.4293751 , 3.96033808, 3.78793864, 3.94939642, 3.57378294]),
 array([6.47227974, 6.49537929, 6.98666118, 6.79440424, 6.99201224,
        6.73386195, 6.63275792, 6.65411763, 6.42891099, 6.49695701]))
```

IQ值高的数据

```python
x1_high = 4 + np.random.random(8)
x2_high = 7 + np.random.random(8)
x1_high,x2_high
```

```output
(array([4.39543051, 4.73302502, 4.02667743, 4.46232039, 4.68128181,
        4.92115752, 4.45267816, 4.84647668]),
 array([7.40538131, 7.3356809 , 7.90412483, 7.45237382, 7.15550294,
        7.3764611 , 7.52492352, 7.67692014]))
```

总的数据和标签

```python
x1 = np.append(x1_low,x1_high)
x2 = np.append(x2_low,x2_high)
x_train = np.c_[x1.T,x2.T]
print(x_train)
y_train = np.append(np.zeros_like(x_low),np.ones_like(x_high))
print(y_train)
```

```output
[[3.72183336 6.47227974]
 [3.16146551 6.49537929]
 [3.88914234 6.98666118]
 [3.85673496 6.79440424]
 [3.1573191  6.99201224]
 [3.4293751  6.73386195]
 [3.96033808 6.63275792]
 [3.78793864 6.65411763]
 [3.94939642 6.42891099]
 [3.57378294 6.49695701]
 [4.28739637 7.71057536]
 [4.31513454 7.70173516]
 [4.10934692 7.38111019]
 [4.35094666 7.33731866]
 [4.01739934 7.41472044]
 [4.98558165 7.72054925]
 [4.80075428 7.12604512]
 [4.48912715 7.08753069]]
[0. 0. 0. 0. 0. 0. 0. 0. 0. 0. 1. 1. 1. 1. 1. 1. 1. 1.]
```

绘制散点图

```python
plt.scatter(x_train[y_train==0,0],x_train[y_train==0,1])
plt.scatter(x_train[y_train==1,0],x_train[y_train==1,1])
plt.xlabel('t')
plt.ylabel('IQ')
plt.show()
```

![](https://i.loli.net/2020/03/08/zevkxsbESRrL3gq.png)

> 上图红色表示天才，蓝色表示白痴

假设输入一个样本的数据为 (4.36,7.465)，判断它天才还是白痴

```python
example = np.array([4.36,7.456])
# 首先再图上画出来观察
plt.scatter(x_train[y_train==0,0],x_train[y_train==0,1])
plt.scatter(x_train[y_train==1,0],x_train[y_train==1,1])
plt.scatter(example[0],example[1],color='black')
plt.xlabel('t')
plt.ylabel('IQ')
plt.show()
```

![image-20200308134311646](C:/Users/Victor/AppData/Roaming/Typora/typora-user-images/image-20200308134311646.png)

> 黑点表示输入的样本

获取距离列表

```python
distance = [sqrt(sum(((x-example)**2))) for x in x_train]
distance
```

```
[1.172587826601725,
 1.5359938425092403,
 0.6648201732802982,
 0.8312548678718089,
 1.2890795094301544,
 1.177941448784469,
 0.9151268590623418,
 0.9850226059672444,
 1.1061225623709607,
 1.2401212526176475,
 0.2647260841097585,
 0.24979727210937175,
 0.26160170347749107,
 0.1190261413334191,
 0.3450785650776031,
 0.6792191910080055,
 0.5505765678982287,
 0.39044007348145965]
```

对于`KNN`，假设k=3，就是求出与样本最近的三个点的数据

```python
result = np.argsort(distance)
result[:k]
```

```
array([13, 11, 12], dtype=int64)
```

> 可以得知，前三个的训练样本的点的下标分别围殴13，11，12

接下来根据这三个训练样本的类别来预测输入的样本是天才还是白痴，假如这三个训练样本是天才的数量多于白痴，就认为它是天才；不然，就认为它是白痴

```python
from collections import Counter
votes = Counter(r)
y_hat = votes.most_common(1)[0][0]
if y_hat == 1:
    print("预测它为天才")
else:
    print("预测它为白痴")
```

```
预测它为天才
```

## 主成分分析法-PCA-(Principal Component Analysis)

> PAC主要用于数据的降维

二维降到一维

![](https://i.loli.net/2020/03/08/1QqVoRthJlinus6.png)

![](https://i.loli.net/2020/03/08/J9zltGkafq3yYwQ.png)

> 由上面两个降维的图来看，第二张图片是一个更好的图，因为图二点和点的距离相对比较大，也就是说，点之间的区分度比较高

更好的降维方案

![](https://i.loli.net/2020/03/08/6KHnRLl9rINE4iS.png)

![](https://i.loli.net/2020/03/08/Zq1SReBNkgDYW6n.png)

> 此时点和点之间的距离最大，区分度更大

**那么如何定义样本之间的间距呢？**

可以使用方差(`Variance`),方差可以表示样本整体分布的疏密程度
$$
Var(x) = \frac{1}{m}\sum_{i = 1}^{m}(x_{i} - \bar x)^2
$$
可以转化成：

​	希望找到一条轴，使得样本投影到该轴上的各点之间的方差最大

**PCA操作步骤：**

1. 将样例的均值归为0(demean)

   这样，就相当于坐标轴变成如下的图：
   ![](https://i.loli.net/2020/03/08/1EURxk682jO3hti.png)

2. 当均值$\bar x = 0$时，原来的方差公式变为
   $$
   Var(x) = \frac{1}{m}\sum_{i = 1}^{m}(x_{i} - \bar x)^2 \Rightarrow Var(x) = \frac{1}{m}\sum_{i = 1}^{m}x_{i}^2
   $$
   假设两个维度的特征为$w1$,$w2$,那么需要求得的直线的方向为$w =（w_{1},w_{2}）$,映射到$w$后，有:
   $$
   Var(X_{project}) = \frac{1}{m} \sum_{1}^{m} (X_{project}^{(i)} - \bar X{project})^2
   $$
   使得上面的公式最大

   其实最后的结果还是向量，因为$X$每一个点都包含两个元素，即应该是

   ![](https://i.loli.net/2020/03/08/K7hrDsfOqX93SRU.png)

   由均值为0，得到

   ![](https://i.loli.net/2020/03/08/qr2h3saKynkXAzZ.png)

   

3. 计算过程

   ![](https://i.loli.net/2020/03/08/VQXLmcHN1UEaldB.png)

   目标即：

   ![](https://i.loli.net/2020/03/11/Y2GEiNjhx6Uzc3r.png)

   

   与线性回归的不同：

   1. `PCA`的两个坐标轴表示的是两个特征，而线性回归的横轴是特征，纵轴是输出标记
   2. `PCA`使得点之间的方差最大，而线性回归则是需要使得输出标记尽量拟合一条直线，是在纵轴上的

   

   ## 决策树

   例子：

   ![](https://i.loli.net/2020/03/08/AysuZO3PpRM1Twd.png)

   数值特征例子：

   ![](https://i.loli.net/2020/03/08/93Am6T1pM5KFtxC.png)

   特点：

   * 非参数学习算法
   * 可以解决分类问题
   * 天然的解决多分类问题
   * 也可以解决回归问题
   * 非常好的可解释性

   问题：

   * 每个节点在哪个维度作划分
   * 某个维度的哪个值作划分





## 支持向量机-SVM-(Support Vector Machine)

主要思想：

![](https://i.loli.net/2020/03/08/vtXZ9fCzhHaRT2g.png)





**SVM分类**:

* Hard Margin SVM	解决的是线性可分问题

* Soft Margin SVM      可解决线性不可分问题



:cowboy_hat_face:未完待续......