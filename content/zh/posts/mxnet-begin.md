---
title: "MXNet回顾"
date: 2020-02-23T15:49:10+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/02/23/NASIuoQYPCpW18x.png
libraries:
- katex
- mathjax
tags:
- python
- MXNet
- 深度学习
- liner
series:
- 深度学习
categories:
-
---

使用MXNet的好处你永远想象不到。:accept:

<!--more-->

### **本地环境搭建教程**

> 参考:
>
> https://discuss.gluon.ai/t/topic/13576?u=bigbigwolf-ai



### **范数**

L0范数：指向量中非0元素的个数。（难优化求解）

L1范数：指向量中各个元素的绝对值之和

L2范数：指向量各元素的平方和然后求平方根

设$n$维向量$x$中的元素为$x_1, \ldots, x_n$。向量$x$的$L_{p}$范数为:
$$
\|\boldsymbol{x}\|_p = \left(\sum_{i=1}^n \left|x_i \right|^p \right)^{1/p}.
$$


$L_{1}$范数：
$$
\|\boldsymbol{x}\|_1 = \sum_{i=1}^n \left|x_i \right|.
$$
$L_{2}$范数：
$$
\|\boldsymbol{x}\|_2 = \sqrt{\sum_{i=1}^n x_i^2}.
$$


设$X$是一个$m$行$n$列矩阵。矩阵$X$的Frobenius范数为该矩阵元素平方和的平方根：
$$
\|\boldsymbol{X}\|_F = \sqrt{\sum_{i=1}^m \sum_{j=1}^n x_{ij}^2},
$$

### **查阅文档**


```python
from mxnet import nd
print(dir(nd.random))
```

    ['NDArray', '_Null', '__all__', '__builtins__', '__cached__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__spec__', '_internal', '_random_helper', 'current_context', 'exponential', 'exponential_like', 'gamma', 'gamma_like', 'generalized_negative_binomial', 'generalized_negative_binomial_like', 'multinomial', 'negative_binomial', 'negative_binomial_like', 'normal', 'normal_like', 'numeric_types', 'poisson', 'poisson_like', 'randint', 'randn', 'shuffle', 'uniform', 'uniform_like']

help函数可以查询具体的函数作用及用法

```python
help(nd.ones_like)
```

    Help on function ones_like:
    
    ones_like(data=None, out=None, name=None, **kwargs)
        Return an array of ones with the same shape and type
        as the input array.
        
        Examples::
        
          x = [[ 0.,  0.,  0.],
               [ 0.,  0.,  0.]]
        
          ones_like(x) = [[ 1.,  1.,  1.],
                          [ 1,  1.,  1.]]
                          Parameters
        ----------
        data : NDArray
            The input
        
        out : NDArray, optional
            The output NDArray to hold the result.
        
        Returns
        -------
        out : NDArray or list of NDArrays
            The output of this function.

### **线性回归**

导入必要的库


```python
%matplotlib inline
from IPython import display
from matplotlib import pyplot as plt
from mxnet import autograd, nd
import random
```

生成数据集，其中每个例子输入数据个数为2，有1000个数据


```python
num_inputs = 2
num_examples = 1000
true_w = nd.array([2, -3.4])
true_b = nd.array([4.2])
features = nd.random.normal(scale=1, shape=(num_examples, num_inputs))
labels = nd.dot(true_w,features.T) + true_b
labels += nd.random.normal(scale=0.01, shape=labels.shape)
```

查看数据


```python
features[0], labels[0]
```


    (
     [ 0.28752208 -0.04466231]
     <NDArray 2 @cpu(0)>,
     
     [4.927063]
     <NDArray 1 @cpu(0)>)

定义相关函数


```python
def use_svg_display():
    # 用矢量图显示
    display.set_matplotlib_formats('svg')

def set_figsize(figsize=(3.5, 2.5)):
    use_svg_display()
    # 设置图的尺寸
    plt.rcParams['figure.figsize'] = figsize

set_figsize()
plt.scatter(features[:, 1].asnumpy(), labels.asnumpy(), 1);  # 加分号只显示图
```


![svg](../../../../../google下载/test/output_39_0.svg)


data_iter函数作用:

1. 扰乱读取顺序，使得读取随机
2. 按Batch_size分段取数据，需要判断是否到结尾，使用yield构建生成器节省内存


```python
# 本函数已保存在d2lzh包中方便以后使用
def data_iter(batch_size, features, labels):
    num_examples = len(features)
    indices = list(range(num_examples))
    random.shuffle(indices)  # 样本的读取顺序是随机的
    for i in range(0, num_examples, batch_size):
        j = nd.array(indices[i: min(i + batch_size, num_examples)])
        yield features.take(j), labels.take(j)  # take函数根据索引返回对应元素
```


```python
batch_size = 10

for X, y in data_iter(batch_size, features, labels):
    print(X, y)
    break
```


    [[-0.65439206  0.74410725]
     [ 0.69013244 -0.6483847 ]
     [-0.59409887  0.3589477 ]
     [-0.47491348  0.6438462 ]
     [ 0.5074032   0.42834154]
     [-0.18589513 -0.21707669]
     [ 0.70281196 -1.3320632 ]
     [ 1.2072632   1.6909351 ]
     [-0.17264698 -1.5742793 ]
     [-1.6516455  -0.29966688]]
    <NDArray 10x2 @cpu(0)> 
    [ 0.37379816  7.7938933   1.7758217   1.0414512   3.743439    4.5605783
     10.148926    0.84148276  9.19984     1.9295483 ]
    <NDArray 10 @cpu(0)>


初始化


```python
w = nd.random.normal(scale=0.01, shape=(num_inputs, 1))
b = nd.zeros(shape=(1,))
```

添加保存梯度的空间


```python
w.attach_grad()
b.attach_grad()
```


```python
def linreg(X, w, b):  # 本函数已保存在d2lzh包中方便以后使用
    return nd.dot(X, w) + b
```


```python
def squared_loss(y_hat, y):  # 本函数已保存在d2lzh包中方便以后使用
    return (y_hat - y.reshape(y_hat.shape)) ** 2 / 2
```


```python
def sgd(params, lr, batch_size):  # 本函数已保存在d2lzh包中方便以后使用
    for param in params:
        param[:] = param - lr * param.grad / batch_size
```

开始训练


```python
lr = 0.03
num_epochs = 3
net = linreg
loss = squared_loss

for epoch in range(num_epochs):  # 训练模型一共需要num_epochs个迭代周期
    # 在每一个迭代周期中，会使用训练数据集中所有样本一次（假设样本数能够被批量大小整除）。X
    # 和y分别是小批量样本的特征和标签
    for X, y in data_iter(batch_size, features, labels):
        with autograd.record():
            l = loss(net(X, w, b), y)  # l是有关小批量X和y的损失
        l.backward()  # 小批量的损失对模型参数求梯度
        sgd([w, b], lr, batch_size)  # 使用小批量随机梯度下降迭代模型参数
    train_l = loss(net(features, w, b), labels)
    print('epoch %d, loss %f' % (epoch + 1, train_l.mean().asnumpy()))
```

    epoch 1, loss 0.040809
    epoch 2, loss 0.000157
    epoch 3, loss 0.000051

对比

```python
true_w, w
```


    (
     [ 2.  -3.4]
     <NDArray 2 @cpu(0)>,
     
     [[ 1.9991481]
      [-3.3992586]]
     <NDArray 2x1 @cpu(0)>)


```python
true_b, b
```


    (
     [4.2]
     <NDArray 1 @cpu(0)>,
     
     [4.19921]
     <NDArray 1 @cpu(0)>)
