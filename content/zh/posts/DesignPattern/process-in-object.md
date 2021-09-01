---
title: 面向对象中的面向过程代码
date: 2021-09-01T20:26:23+08:00
description: 
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://raw.githubusercontent.com/redisread/Image/master/Blog/xt4G3C.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- 设计模式
series:
-
categories:
-
---

1. 滥用getter和setter方法。
  滥用的话违反面向对象编程的封装性，相当于对象没有了封装。因为setter和getter
  方法都是public的接口暴露给外面，即使定义的属性是private的。

> 面向对象封装的定义是：通过访问权限控制，隐藏内部数据，外部仅能通过类提供的有限的接口访问、修改内部数据。所以，暴露不应该暴露的setter方法，明显违反了面向对象的封装特性。数据没有访问权限控制，任何代码都可以随意修改它，代码就退化成了面向过程编程风格的了。

有时候为了安全考虑，不让其他人改变从类内获取的属性（例如列表），可以使用Java提供的Collections.unmodifiableList()方法，让getter方法返回一个不可被修改的UnmodifiableList集合容器，而这个容器类重写了List容器中跟修改数据相关的方法，比如add()、clear()等方法。
```Java
public class ShoppingCart {
  // ...省略其他代码...
  public List getItems() {
    return Collections.unmodifiableList(this.items);
  }
}
```

<div class="alert alert-warning" role="alert">
上面的方法只是列表不能变，列表里面的元素还是能够改变的。
</div><br>


2. 乱用全局变量和全局方法。

全局变量通常会写在一个类中进行封装，这样的结果是每次需要添加一个变量都需要往这个类中添加字段，
造成很多其他类依赖这个封装全局对象的类（封装静态函数也是一样）。这个类可能会：

- 变得很大很臃肿。
- 每次修改这个类其他依赖于它的类都要重新编译，编译时间加长，降低开发效率。
- 影响代码的复用，每次引入这个大类都包含了很多其他的变量。

全局函数也可以封装在一个类中，全局函数指的就是公有的静态函数。

<div class="notices success">
解决这种过度封装的方法，就是将这些函数或者变量进行解耦。按维度分粒度进行划分成更细粒度或者更细维度的封装类。
</div>

3. 基于贫血模型的开发模式

常见的面向过程的风格是：
- 数据放在一个类中
- 方法定义在另一个类中

基于MVC的三层架构做Web后端开发的代码就是这样的。

传统的MVC结构分为Model层、Controller层、View层这三层。不过，在做前后端分离之后，三层结构在后端开发中，会稍微有些调整，被分为Controller层、Service层、Repository层。Controller层负责暴露接口给前端调用，Service层负责核心业务逻辑，Repository层负责数据读写。而在每一层中，我们又会定义相应的VO（View Object）、BO（Business Object）、Entity。一般情况下，VO、BO、Entity中只会定义数据，不会定义方法，所有操作这些数据的业务逻辑都定义在对应的Controller类、Service类、Repository类中。这就是典型的面向过程的编程风格。


### 总结

<div class="notices info">
面向对象和面向过程两种编程风格，也并不是非黑即白、完全对立的。在用面向对象编程语言开发的软件中，面向过程风格的代码并不少见，甚至在一些标准的开发库（比如JDK、Apache Commons、Google Guava）中，也有很多面向过程风格的代码。
</div>

面向过程的思考方式比较类似人类思考的方式，而面向对象的编程风格更像是一种反向思考过程，需要考虑到很多很细的东西。它不是先去按照执行流程来分解任务，而是将任务翻译成一个一个的小的模块（也就是类）。这样看来，面向过程的开发是比较快的，但是后面维护可能比较难；而面向对象因为考虑了很多东西进行设计，后面的维护成本也会更低。

**不管使用面向过程还是面向对象哪种风格来写代码，我们最终的目的还是写出易维护、易读、易复用、易扩展的高质量代码。**



