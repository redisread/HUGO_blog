---
title: "Java装箱拆箱"
date: 2021-08-12T21:21:00+08:00
description: 在Java 5中，引入了自动装箱和自动拆箱功能（boxing/unboxing），Java可以根据上下文，自动进行转换，极大地简化了相关编程。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://raw.githubusercontent.com/redisread/Image/master/Java/java.png
libraries:
- katex
- mathjax
tags:
- Java
series:
-
categories:
- Java
---



**Java语言虽然号称一切都是对象，但原始数据类型是例外。** 

> 在Java 5中，引入了自动装箱和自动拆箱功能（boxing/unboxing），Java可以根据上下文，自动进行转换，极大地简化了相关编程。


自动装箱实际上算是一种**语法糖** 。就是保证不同的写法在运行时是等价的。它们发生在**编译阶段** ，也就是生成的字节码是一致的。

- 装箱表示将原始数据类型进行封装起来，然后添加一些操作例如数学计算和字符串转换等。

- 拆箱表示将一个封装了原始数据类型的对象转回为原始数据类型。

Java的8个原始数据类型（boolean、byte 、short、char、int、float、double、long)分别对应的8个封装对象为Boolean、Byte、Short、Character、Integer、Float、Double、Long。

在Java中，几乎所有的基本类型封装类在进行自动装箱的时候都实现了缓存。

- Integer，缓存了-128到127之间的数值

- Boolean，缓存了true/false对应实例，确切说，只会返回两个常量实例Boolean.TRUE/FALSE。

- Short，同样是缓存了-128到127之间的数值。

- Byte，数值有限，所以全部都被缓存。

- Character，缓存范围’u0000’ 到 ‘u007F’

这在一定程度能够节省内存，提高性能。但是原则上，**建议避免无意中的装箱、拆箱行为** ，尤其是在性能敏感的场合，**创建10万个Java对象和10万个整数的开销可不是一个数量级的** ，不管是内存使用还是处理速度，光是对象头的空间占用就已经是数量级的差距了。一些追求极致性能的产品或者类库，会极力避免创建过多对象。当然，在大多数产品代码里，并没有必要这么做，还是以开发效率优先。需要权衡利弊。


#### Integer例子

javac替我们自动把装箱转换为Integer.valueOf()，把拆箱替换为Integer.intValue()，既然调用的是Integer.valueOf，自然能够得到缓存的好处。

下面的调用了自动装箱和自动拆箱：

```Java
Integer integer = 1;// 自动装箱
int unboxing = integer ++;//自动拆箱
```


反编译得到：

```Java
1: invokestatic  #2                  // Method
java/lang/Integer.valueOf:(I)Ljava/lang/Integer;
8: invokevirtual #3                  // Method
java/lang/Integer.intValue:()I
```


即装箱转换为Integer.valueOf()，把拆箱替换为Integer.intValue()，在Java源码可见这个值默认缓存是-128到127之间。

![](https://raw.githubusercontent.com/redisread/Image/master/Java/image.png)

![](https://raw.githubusercontent.com/redisread/Image/master/Java/image_1.png)

![](https://raw.githubusercontent.com/redisread/Image/master/Java/image_2.png)



