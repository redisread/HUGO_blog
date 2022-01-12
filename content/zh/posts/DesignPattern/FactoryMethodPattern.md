---
title: 工厂方法模式
date: 2021-11-03T16:05:37+08:00
description: 相对于直接new来创建对象，用工厂模式来创建究竟有什么好处呢？
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 🪶
image: https://cos.jiahongw.com/uPic/3992944_factory_chimney_company_smoke_icon.png
plantuml: true
libraries:
- mermaid
tags:
- 设计模式
- 工厂方法
- 抽象工厂
- 简单工厂
series:
- 设计模式
categories:
-
---



> 当我们使用new创建一个对象的时候，需要指定一个具体类，这就是针对实现进行编程。当我们将创建对象的过程封装成一个方法或者接口的时候，就可以避免针对实现编程，变成针对接口编程。

针对接口编程，可以隔离掉以后系统可能发生的一大堆改变。为什么呢？

1. 通过多态，可以让任何实现类实现改接口。
2. 然后替换掉你原来的实现。

> 对拓展开放，对修改关闭。

### 定义

工厂方法模式定义了一个创建对象的接口，但由子类决定要实例化的类是哪一个。工厂方法将实例化推迟到子类。

> 核心在将创建对象的过程解耦出来。

### 架构

```plantuml
@startuml

interface Product
class ConcreteProduct implements Product

abstract class Creator {
  * factoryMethod()
  + anyOperation()
}


class ConcreteCreator extends Creator {
  * factoryMethod()
  + anyOperation()
}

note top of Creator: Creator是一个类，实现所有操作产品的方法，但是不实现工厂方法
note bottom of ConcreteProduct: 所有产品必须实现共同接口
note bottom of ConcreteCreator: 实现工厂方法，以实际制造出产品
ConcreteProduct <-r- ConcreteCreator

@enduml
```



工厂模式体现了一个原则：依赖倒置原则。（Spring叫依赖反转）

> 原来依赖具体类，现在依赖一个抽象的接口。

```plantuml
@startuml

abstract class "抽象接口类" as abstractClass {
}

class "实现类A" extends abstractClass
class "实现类B" extends abstractClass
class "实现类C" extends abstractClass

class "Factory" as factory

factory --> abstractClass


@enduml
```



Key:

- 工厂只有一个功能——创建指定的类。（单一职责）
- 将原来的if-else判断，转换成对象进行处理。
- 抽象成一个方法 -》 抽象成一个类 -〉 抽象成一个接口



### 抽象工厂模式

定义：抽象工厂模式提供一个接口，用于创建相关或者依赖对象的家族，而不需要明确指定具体类。



架构：

```mermaid
classDiagram
class AbstractFactory {
	<<interface>>
	+ createProductA()
	+ createProductB()
}


class ConcreteFactoory1 {
	+ createProductA()
	+ createProductB()
}

class ConcreteFactoory2 {
	+ createProductA()
	+ createProductB()
}


class AbstractProductA {
	<<interface>>
}

class ProducttA1
class ProducttA2


ProducttA1 ..|> AbstractProductA : 实现
ProducttA2 ..|> AbstractProductA : 实现

class AbstractProductB {
	<<interface>>
}

class ProducttB1
class ProducttB2

ProducttB1 ..|> AbstractProductB : 实现
ProducttB2 ..|> AbstractProductB : 实现


AbstractFactory <|.. ConcreteFactoory1 : 实现
AbstractFactory <|.. ConcreteFactoory2 : 实现

ConcreteFactoory1 -->ProducttA1 : 创建
ConcreteFactoory1 -->ProducttB1 : 创建

ConcreteFactoory2 -->ProducttA2 : 创建
ConcreteFactoory2 -->ProducttB2 : 创建

```

抽象工厂模式类似于一个二维的分类，将更加复杂的系统进行整理并且划分。以达到解耦的效果。





一个披萨商店的例子，可以很清晰的解释这种架构：

```mermaid
classDiagram

class PizzaIngredientFactory {
	<<interface>>
	+ createDough()
	+ createSauce()
	+ createCheese()
	+ createVeggies()
	+ createPepperoni()
	+ createCalm()
}

class NYPizzaIngredientFactory {
	+ createDough()
	+ createSauce()
	+ createCheese()
	+ createVeggies()
	+ createPepperoni()
	+ createCalm()
}

class ChicagoPizzaIngredientFactory {
	+ createDough()
	+ createSauce()
	+ createCheese()
	+ createVeggies()
	+ createPepperoni()
	+ createCalm()
}

PizzaIngredientFactory <|.. NYPizzaIngredientFactory
PizzaIngredientFactory <|.. ChicagoPizzaIngredientFactory

class Dough {
	<<interface>>
}

class ThickCrustDough
class ThinCrustDough

ThickCrustDough ..|> Dough
ThinCrustDough ..|> Dough

class Sauce {
	<<interface>>
}

class PlumTomatoSauce
class MarinaraSauce

PlumTomatoSauce ..|> Sauce
MarinaraSauce ..|> Sauce

class Cheese {
	<<interface>>
}

class MozzarellaCheese
class ReggianoCheese

MozzarellaCheese ..|> Cheese
ReggianoCheese ..|> Cheese

class Clams {
	<<interface>>
}

class FrozenClams
class FreshClams

FrozenClams ..|> Clams
FreshClams ..|> Clams


ChicagoPizzaIngredientFactory --> ThickCrustDough
ChicagoPizzaIngredientFactory --> PlumTomatoSauce
ChicagoPizzaIngredientFactory --> MozzarellaCheese
ChicagoPizzaIngredientFactory --> FrozenClams




NYPizzaIngredientFactory --> ThinCrustDough
NYPizzaIngredientFactory --> MarinaraSauce
NYPizzaIngredientFactory --> ReggianoCheese
NYPizzaIngredientFactory --> FreshClams

```

工厂方法就隐含在抽象工厂里面。



### 问题

1. 什么是静态工厂方法，和静态工厂有什么区别？

   静态工厂方法有不需要创建对象就能够调用静态方法的优势，但是缺点是不能通过继承来改变创建的方法。


---

***Reference***:

1. [Factory Design Pattern in Java - JournalDev](https://www.journaldev.com/1392/factory-design-pattern-in-java)
