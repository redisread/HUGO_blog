---
title: "Pytorch Begin"
date: 2020-02-22T22:49:28+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/02/22/mW367ipBfFEyecD.png
tags:
- PyTorch
- python
- Tensor
series:
- 深度学习
categories:
-
---



重新学习一下DL，这次使用PyTorch框架:flashlight:

<!--more-->

> 参考资料：
>
> https://github.com/dsgiitr/d2l-pytorch
>
> ![](https://i.loli.net/2020/02/22/QhYs29c7nNEumP3.png)

### 导入PyTorch库


```python
import torch
import numpy as np
```

### 创建Tensor

5x3的未初始化的张量


```python
x = torch.empty(5,3)
x
```




    tensor([[1.0286e-38, 9.0919e-39, 8.9082e-39],
            [9.2755e-39, 8.4490e-39, 1.0194e-38],
            [9.0919e-39, 8.4490e-39, 8.7245e-39],
            [1.0102e-38, 1.0653e-38, 8.7245e-39],
            [1.0286e-38, 9.6429e-39, 4.2244e-39]])



5x3随机初始化的张量


```python
x = torch.rand(5,3)
x
```




    tensor([[0.2518, 0.0419, 0.3233],
            [0.1493, 0.1408, 0.8559],
            [0.5145, 0.4648, 0.4605],
            [0.2555, 0.2502, 0.4506],
            [0.9798, 0.5056, 0.2726]])



5x3全0的张量


```python
x = torch.zeros(5,3) # 可以指定类型 x = torch.zeros(5,3,dtype=torch.long)
x
```




    tensor([[0., 0., 0.],
            [0., 0., 0.],
            [0., 0., 0.],
            [0., 0., 0.],
            [0., 0., 0.]])



数据张量


```python
x = torch.tensor([5.5,3])
x
```




    tensor([5.5000, 3.0000])



默认创建和原来的张量一样的dtype和device的张量，也可以另外设置


```python
x = x.new_ones(5,3,dtype=torch.double)
print(x)
x = torch.randn_like(x,dtype=torch.float)
print(x)
```

    tensor([[1., 1., 1.],
            [1., 1., 1.],
            [1., 1., 1.],
            [1., 1., 1.],
            [1., 1., 1.]], dtype=torch.float64)
    tensor([[-0.7829, -0.4010,  0.3230],
            [ 0.2660,  0.4766,  0.3186],
            [ 0.6096,  1.1226, -1.7942],
            [ 1.3255,  0.1835, -0.9078],
            [ 1.7743, -0.0944, -0.1704]])


获取Tensor的形状


```python
x.shape,x.size()
```




    (torch.Size([5, 3]), torch.Size([5, 3]))



其他创建Tensor的函数:

| 函数                              | 功能                      |
| --------------------------------- | ------------------------- |
| Tensor(*sizes)                    | 基础构造函数              |
| tensor(data,)                     | 类似np.array的构造函数    |
| ones(*sizes)                      | 全1Tensor                 |
| zeros(*sizes)                     | 全0Tensor                 |
| eye(*sizes)                       | 对角线为1，其他为0        |
| arange(s,e,step)                  | 从s到e，步长为step        |
| linspace(s,e,steps)               | 从s到e，均匀切分成steps份 |
| rand/randn(*sizes)                | 均匀/标准分布             |
| normal(mean,std)/uniform(from,to) | 正态分布/均匀分布         |
| randperm(m)                       | 随机排列                  |

> 这些创建方法都可以在创建的时候指定数据类型dtype和存放device(cpu/gpu)


### 操作


```python
x = torch.rand(5,3)
y = torch.rand(5,3)
x,y
```




    (tensor([[0.7706, 0.7674, 0.0476],
             [0.3675, 0.3652, 0.1215],
             [0.2842, 0.4927, 0.0903],
             [0.1202, 0.7635, 0.1862],
             [0.1391, 0.5023, 0.0580]]),
     tensor([[0.2149, 0.4744, 0.6664],
             [0.5948, 0.3451, 0.6485],
             [0.2303, 0.6660, 0.3796],
             [0.7194, 0.3815, 0.7536],
             [0.7886, 0.0630, 0.2459]]))



加法，三种方法


```python
z1 = torch.add(x,y)
z2 = x.add_(y)  # x会改变
z3 = x + y
z1,z2,z3
```




    (tensor([[0.9855, 1.2418, 0.7140],
             [0.9623, 0.7103, 0.7700],
             [0.5145, 1.1588, 0.4699],
             [0.8396, 1.1450, 0.9397],
             [0.9276, 0.5653, 0.3040]]),
     tensor([[0.9855, 1.2418, 0.7140],
             [0.9623, 0.7103, 0.7700],
             [0.5145, 1.1588, 0.4699],
             [0.8396, 1.1450, 0.9397],
             [0.9276, 0.5653, 0.3040]]),
     tensor([[1.2004, 1.7163, 1.3804],
             [1.5571, 1.0554, 1.4185],
             [0.7448, 1.8248, 0.8495],
             [1.5590, 1.5265, 1.6933],
             [1.7162, 0.6283, 0.5499]]))



索引


```python
y = x[0, :]
y
```




    tensor([0.9855, 1.2418, 0.7140])



修改y会修改原来的数据，因为共享内存


```python
y+=1
print(y)
print(x[0,:])
```

    tensor([1.9855, 2.2418, 1.7140])
    tensor([1.9855, 2.2418, 1.7140])


PyTorch还提供了一些高级的选择函数:

| 函数                            | 功能                                                  |
| ------------------------------- | ----------------------------------------------------- |
| index_select(input, dim, index) | 在指定维度dim上选取，比如选取某些行、某些列           |
| masked_select(input, mask)      | 例子如上，a[a>0]，使用ByteTensor进行选取              |
| nonzero(input)                  | 非0元素的下标                                         |
| gather(input, dim, index)       | 根据index，在dim维度上选取数据，输出的size与index一样 |

### 改变形状

用view()来改变Tensor的形状：


```python
y = x.view(15)
z = x.view(-1,5)    # -1为自动计算维度
print(x.size(),y.size(),z.size())
```

    torch.Size([5, 3]) torch.Size([15]) torch.Size([3, 5])


> 注意view()返回的新Tensor与源Tensor虽然可能有不同的size，但是是共享data的，也即更改其中的一个，另外一个也会跟着改变。(顾名思义，view仅仅是改变了对这个张量的观察角度，内部数据并未改变)


```python
x += 1
x,y
```




    (tensor([[4.9855, 5.2418, 4.7140],
             [3.9623, 3.7103, 3.7700],
             [3.5145, 4.1588, 3.4699],
             [3.8396, 4.1450, 3.9397],
             [3.9276, 3.5653, 3.3040]]),
     tensor([4.9855, 5.2418, 4.7140, 3.9623, 3.7103, 3.7700, 3.5145, 4.1588, 3.4699,
             3.8396, 4.1450, 3.9397, 3.9276, 3.5653, 3.3040]))



使用reshape()函数会拷贝一份


```python
y = x.reshape(15)
y
```




    tensor([4.9855, 5.2418, 4.7140, 3.9623, 3.7103, 3.7700, 3.5145, 4.1588, 3.4699,
            3.8396, 4.1450, 3.9397, 3.9276, 3.5653, 3.3040])



也可以使用克隆后view

> 使用clone还有一个好处是会被记录在计算图中，即梯度回传到副本时也会传到源Tensor。


```python
y = x.clone().view(15)
y
```




    tensor([4.9855, 5.2418, 4.7140, 3.9623, 3.7103, 3.7700, 3.5145, 4.1588, 3.4699,
            3.8396, 4.1450, 3.9397, 3.9276, 3.5653, 3.3040])



item(), 它可以将一个标量Tensor转换成一个Python number：


```python
x = torch.randn(1)
print(x)
print(x.item())
```

    tensor([0.3816])
    0.3816383183002472


### 线性代数API

| 函数                              | 功能                              |
| --------------------------------- | --------------------------------- |
| trace                             | 对角线元素之和(矩阵的迹)          |
| diag                              | 对角线元素                        |
| triu/tril                         | 矩阵的上三角/下三角，可指定偏移量 |
| mm/bmm                            | 矩阵乘法，batch的矩阵乘法         |
| addmm/addbmm/addmv/addr/baddbmm.. | 矩阵运算                          |
| t                                 | 转置                              |
| dot/cross                         | 内积/外积                         |
| inverse                           | 求逆矩阵                          |
| svd                               | 奇异值分解                        |

### 广播机制

什么是广播机制？简单的说就是形状不同的运算会自动变换为适合的运算


```python
x = torch.arange(3).view(1,3)
print(x)
y = torch.arange(2).view(2,1)
print(y)
print(x + y)
```

    tensor([[0, 1, 2]])
    tensor([[0],
            [1]])
    tensor([[0, 1, 2],
            [1, 2, 3]])

