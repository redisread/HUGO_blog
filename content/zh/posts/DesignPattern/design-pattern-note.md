---
title: design-pattern-note
date: 2021-09-22T19:20:05+08:00
description:
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
-
series:
-
categories:
-
---













## 设计原则

1.单一职责原则
2.开闭原则
3.里氏替换原则
4.依赖注入原则
5.接口分离原则
6.迪米特原则













## 设计模式

简单工厂模式 Simple Factory Pattern

中文	英文

创建型模式：

1.工厂方法模式	Factory Method Pattern
2.抽象工厂模式	Abstract Factory Pattern
3.建造者模式	Builder Pattern
4.原型模式	Prototype Pattern
5.单例模式	Singleton Pattern

结构型模式：

6.适配器模式	Adapter Pattern
7.桥梁模式/桥接模式	Bridge Pattern
8.组合模式	Composite Pattern
9.装饰模式	Decorator Pattern
10.门面模式/外观模式	Facade Pattern
11.享元模式	Flyweight Pattern
12.代理模式	Proxy pattern

行为模式：

13.责任链模式	Chain of Responsibility Pattern
14.命令模式	Command Pattern
15.解释器模式	Interpreter Pattern
16.迭代器模式	Iterator Pattern
17.中介者模式	Mediator Pattern
18.备忘录模式	Memento Pattern
19.观察者模式	Observer Pattern
20状态模式	State Pattern
21.策略模式	Strategy Pattern
22.模板方法模式	Template Method Pattern
23.访问者模式	Visitor Pattern





创建型设计模式

1. 单例模式
2. 







结构型设计模式







行为设计模式





抽象类和接口改如何选择。

抽象类

1. 抽象类不允许被实例化，只能被继承。
2. 抽象类可以包含属性和方法。（以便子类进行复用变量和方法）
3. 子类继承抽象类，必须实现抽象类中的所有抽象方法。（抽象类中非抽象方法可以不实现，直接复用）



抽象类最佳实践：模板方法。



接口：

- 接口不能包含属性（也就是成员变量）。

- 接口只能声明方法，方法不能包含代码实现。（Java8之后有默认方法）

  > Java 8允许在接口内声明􏶁态方法。其二，Java 8引入了一个新功能，叫默认方法，通过默认方 法你可以指定接口方法的默认实现。

- 类实现接口的时候，**必须实现接口中声明的所有方法**。



抽象类更多的是为了代码复用，而接口就更侧重于解耦。接口是对行为的一种抽象，相当于一组协议或者契约，你可以联想类比一下API接口。调用者只需要关注抽象的接口，不需要了解具体的实现，具体的实现代码对调用者透明。接口实现了约定和实现相分离，可以降低代码间的耦合性，提高代码的可扩展性。







---

***Reference：***

1. [创建型模式 — Graphic Design Patterns](https://design-patterns.readthedocs.io/zh_CN/latest/creational_patterns/creational.html)
2. 



