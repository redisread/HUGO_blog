---
title: 设计模式原则
date: 2021-10-16T19:07:55+08:00
description: 设计模式原则是我们需要在设计代码结构时需要参考的一些准则，有了它们，我们可以编写更有规范的代码。6大设计原则是设计模式的理论，设计模式是其实践。
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image:
plantuml: true
libraries:
- katex
- mathjax
tags:
- DesignPattern
series:
- DesignPattern
categories:
-
---







设计模式6大原则：

1. 单一职责。
2. 开闭原则。
3. 里氏替换原则。
4. 依赖倒置原则。
5. 接口隔离原则。
6. 迪米特原则。

> 软件的面向对象开发一般提倡遵循**SOLID**原则，这个单词就是我们这里前5个原则的首字母缩写。

## 1 单一职责

Single Responsibility Principle，一个类应该只负责一个职责。



## 2 开闭原则

Open-Closed Principle, OCP，一个软件实体应当对扩展开放，对修改关闭。即软件实体应尽量在不修改原有代码的情况下进行扩展。

> 因为你一旦修改了某个类就有可能破坏系统原来的功能，就需要重新测试。其



## 3 里氏替换原则

Liskov Substitution Principle, LSP，所有引用基类（父类）的地方必须能透明地使用其子类的对象。（其实就是使用多态）

原来的代码：

```java
//基类
public abstract class Shape {
    public abstract void draw();
}
//子类矩形
public class Rectangle extends Shape {
    @Override
    public void draw() {
        System.out.println("绘制矩形");
    }
}
//子类三角形
public class Triangle extends Shape {
    @Override
    public void draw() {
        System.out.println("绘制三角形");
    }
}
```

多态的代码：

```java
public static void main(String[] args) {
    //使用Shape的子类Triangle 的实例来替换Shape的实例，程序工作正常
    drawShape(new Triangle());
}
private static void drawShape(Shape shape){
    System.out.println("开始画图");
    shape.draw();
    System.out.println("结束画图");
}
```



## 4 依赖倒置原则

Dependence Inversion Principle, DIP，抽象不应该依赖于细节，细节应当依赖于抽象。换言之，要针对接口编程，而不是针对实现编程。

关键点为：

1. 高层模块不应该依赖低层模块，两者都应该依赖其抽象
2. 抽象不应该依赖细节
3. 细节应该依赖抽象



Java中的描述为：

- 抽象：java中的抽象类或者接口 （如上面代码中的Shape 抽象类）
- 细节：java中的具体实现类（如上面代码中的Rectangle 和Triangle 实体类）
- 高层模块：java中的调用类（例如上面代码中`drawShape(Shape shape)`函数的类）
- 低层模块：java中的实现类（细节）



倒置前，高层模块直接依赖于底层模块

![倒置前](../../../../../../../Library/Application Support/typora-user-images/image-20211021113845506.png)

倒置后，高层模块和底层模块都依赖于底层模块的抽象，也就是接口。

![倒置后](../../../../../../../Library/Application Support/typora-user-images/image-20211021114059085.png)

> 简单的说，基于接口编程。



## 5 接口隔离原则

Interface Segregation Principle, ISP，使用多个专门的接口，而不使用单一的总接口，即客户端不应该依赖那些它不需要的接口。

> 让调用者依赖的接口尽可能的小。





## 6 迪米特原则

Law of Demeter 又名Least Knowledge Principle, LoD，一个软件实体应当尽可能少地与其他实体发生相互作用。

> 体现了封装的思想。

一个类应该对自己需要调用的类知道得最少，类的内部如何实现、如何复杂都与调用者或者依赖者没关系，调用者或者依赖者只需要知道他需要的方法即可，其他的我一概不关心。



---

***Reference***：

1. [面向对象设计之魂(六大原则) - ShuSheng007](http://shusheng007.top/2020/02/15/%e9%9d%a2%e5%90%91%e5%af%b9%e8%b1%a1%e8%ae%be%e8%ae%a1%e4%b9%8b%e9%ad%82%e7%9a%84%e5%85%ad%e5%a4%a7%e5%8e%9f%e5%88%99/)
2. 
