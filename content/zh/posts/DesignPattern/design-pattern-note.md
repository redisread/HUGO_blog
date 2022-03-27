---
title: 设计模式小记
date: 2022-03-27T19:20:05+08:00
description: 设计模式基于设计原则。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://cos.jiahongw.com/uPic/681662.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- 设计模式
- 设计原则
series:
- 设计模式
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



> 将变化的东西抽离出来并且封装，一方面和原来的逻辑解耦，另一方面，便于后面进行修改。



如何判断单一职责？

- 代码的函数太多，函数或者属性过多
- 依赖其他类过多
- 私有方法过多
- 比较难给类起一个合适名字，很难用一个业务名词概括，或者只能用一些笼统的 Manager、Context 之类的词语来命名
- 类中大量的方法都是集中操作类中的某几个属性



如何理解开闭原则？

只要对原来的代码侵入性不大，不影响主要流水，都是一个合格的拓展代码





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





## 理论





### 是否因该为每一个类都定义接口

> 不应该，应该根据实际的需要。

“基于接口编程而不是基于实现编程”更详细的说法应该是“基于抽象编程而不是基于实现编程”。因为考虑到有一些语言类戏C和C++都没有接口interface这种结构。（设计的时候不要一开始就和具体的编程语言进行挂钩）

做任何事情都不要一板子拍死，不要过度使用原则，每个类都定义接口，接口必定满天飞，后期管理也困难。

从设计初衷来看，如果在我们的业务场景中，某个功能只有一种实现方式，未来也不可能被其他实现方式替换，那我们就没有必要为它设计接口，也没有必要基于接口编程，直接使用实现类就行。（主要看有么有必要进行拓展，要拓展的话使用接口编程会更好）



## 实战

### 基于贫血模型的MVC

业务开发常用的基于贫血模型的MVC框架违背了OOP。

**什么是基于贫血的传统开发模式？**

平时开发Web后端项目的时候，基本上是这么组织代码的：其中Entity和Repository组成了数据访问层，Bo和Service组成了业务逻辑层，Vo和Controller属于接口层。

Bo是一个纯粹的数据结构，只包含数据，不包含任何业务逻辑。业务逻辑集中在Service中。通过Service来操作Bo。像Bo这样，只包含数据，不包含业务逻辑的类，就叫做贫血模型。同理，Entity和Vo也都是基于贫血模型设计的。贫血模型将数据与操作分离，破坏了面向对象的封装性，是一种典型的面相过程的编程风格。



**什么是基于充血模型的DDD开发模式？**

在贫血模型中，数据和操作逻辑被分离到两个类中；充血模型正好相反，数据和对应的业务逻辑被封装到同一个类中。因此，充血模型满足面向对象的封装特性，是典型的面向对象编程风格。

> 什么是领域驱动设计？
>
> 领域驱动设计即DDD，主要是用来指导如何解耦业务系统，划分业务模块，定义业务领域模型及其交互。

实际上，基于充血模型的DDD开发模式实现的代码，也是按照MVC三层架构分层的。Controller还是负责暴露接口，Repository还是负责数据存取，Service层负责核心业务逻辑。它和基于贫血模型的开发模式的区别主要在Service层。

在基于充血模型的DDD开发模式中，Service层包含Service类和Domain类两部分。Domain类相当于贫血模型中的Bo。但是，Domain和Bo的区别在于Domain是基于充血模型开发的，即包含数据，也包含业务逻辑。而Service类变得非常单薄。总结一下：基于贫血的传统开发模式，重Service轻Bo；基于充血模型的DDD开发模式，轻Service重Domain。

区别于Domain的职责，Service类主要有下面的几个职责（为什么没有将Service类去掉）：

1. Service负责和Repository交流。获取数据之后，才转换成领域模型进行操作。或者领域模型计算完成之后，再通过Service调用Repository进行存储。（保证领域模型的独立性）
2. Service类负责跨领域模型的聚合功能。
3. Service类负责一些非功能性及第三方系统交互的工作。比如幂等、事务、发邮件、发消息、记录日志、调用系统服务的RPC接口等。

> Controller层和Repository层还是基于贫血模型，但是没有必要修改成DDD模式，因为这两个层的逻辑本来就比较单一，没必要使用充血模型。



**为什么贫血模型那么受欢迎**

1. 贫血模型简单，业务简单。充血模型难，考虑的地方多。
2. 思维固化，转型有成本。



**什么项目应该考虑使用基于充血模型的DDD开发模式？**

基于贫血模型的传统开发模式适合业务逻辑比较简单的项目，而基于充血模型的DDD开发模式适合业务复杂的系统项目。比如，包含各种利息计算模型、还款模型等复杂业务的金融系统。

> DDD开发模式需要我们前期做大量的业务调研、领域模型设计，所以它更适合复杂系统的开发。



### 接口鉴权功能面向对象分析

> OOA：面向对象分析
>
> OOD：面向对象设计
>
> OOP：面向对象编程

面向对象分析步骤：

1. 基础分析
2. 分析优化
3. 继续分析优化



面向对象设计步骤：

1. 划分职责进而识别出有哪些类
2. 定义类及其属性和方法
3. 定义类与类之间的交互关系
4. 将类组装起来并提供执行入口



---

***Reference：***

1. [创建型模式 — Graphic Design Patterns](https://design-patterns.readthedocs.io/zh_CN/latest/creational_patterns/creational.html)



