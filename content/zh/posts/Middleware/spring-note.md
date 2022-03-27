---
title: SpringBoot笔记
date: 2021-09-06T10:53:10+08:00
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

# SpringBoot项目配置字段

标准工程的创建方法。

- AppKey：服务的全局唯一标识和通行证
- 项目名称：整个项目的目录。（或者是git仓库目录）
- Group ID：项目组织唯一的标识符，对应为根pom中`<groupId>`标签中的值（所在部门的唯一标志）
- Artifact ID：项目的唯一的标识符，对应为根pom中`<artifactId>`标签中的值
- Version：项目当前版本号，对应为根pom中`<version>`标签中的值
- Package Name：项目中的包名



**Spring bean默认名称规则**

1.在使用@Component、@Repository、@Service、@Controller等注解创建bean时，如果指定bean名称，
则是指定的名称.

2.如果不指定bean名称，bean名称的默认规则是类名的首字母小写，如SysConfig - sysConfig，Tools - tools。

3.如果类名前两个或以上个字母都是大写，那么bean名称与类名一样，如RBACUserLog - RBACUserLog，RBACUser - RBACUser，RBACRole - RBACRole。



**Spring中的@Resource是怎么进行匹配Bean的？**

@Resource的作用相当于@Autowired，只不过@Autowired按byType自动注入，而@Resource默认按 byName自动注入罢了。

1. 如果同时指定了name和type，则从Spring上下文中找到唯一匹配的bean进行装配，找不到则抛出异常
　　2. 如果指定了name，则从上下文中查找名称（id）匹配的bean进行装配，找不到则抛出异常
　　3. 如果指定了type，则从上下文中找到类型匹配的唯一bean进行装配，找不到或者找到多个，都会抛出异常
　　4. 如果既没有指定name，又没有指定type，则自动按照byName方式进行装配；如果没有匹配，则回退为一个原始类型进行匹配，如果匹配则自动装配；



**Spring Bean自动注入是如何处理子类和继承关系的类的**

假如我是用接口开发，使用接口定义一个类型，运行时候会自动判断吗？

# IOC











# AOP

### AOP基本概念













# 用法笔记

- 根据类型获取Bean
applicationContext.getBeansOfType(clazz)
applicationContext的类型就是ApplicationContext

<div class="notices info">
在实际的使用过程中，这个可以方法可以进行封装，实现许多方便的功能。例如使用一个Enum类型存储所有相关的类型，再使用这个方法按照Enum的每一个类型进行获取相应的Bean中，最后还可以将Enum的类型和Bean进行映射，构建成一个Map。然后按照类似策略模式进行处理相关的问题。
</div>




[Spring注解@component、@service、@Autowired等作用与区别 - 一颗心的石头 - 博客园](https://www.cnblogs.com/qingpw/p/12867103.html)

## Spring AOP

如果要重用通用功能的话，最常见的面向对象技术是继承(inheritance)或委托(delegation)。但是，如果在整个应用中都使用相同的基类， 继承往往会导致一个脆弱的对象体系;而使用委托可能需要对委托对象进行复杂的调用.s

### advice ——通知

通知（when），切面的动作被称为通知。

**通知定义了切面是什么以及何时使用。除了描述切面要完成的工作，通知还解决了何时执行这个工作的问题。它应该应用在某个方法被调用之前？之后？之前和之后都调用？还是只在方法抛出异常时调用？**

Spring切面可以应用5种类型的通知:

1. 前置通知(Before):在目标方法被调用之前调用通知功能; 
2. 后置通知(After):在目标方法完成之后调用通知，此时不会关心方法的输出是什么; 
3. 返回通知(After-returning):在目标方法成功执行之后调用通知;
4.  异常通知(After-throwing):在目标方法抛出异常后调用通知; 
5. 环绕通知(Around):通知包裹了被通知的方法，在被通知的方法调用之前和调用之后执行自定义的行为。



### join point——连接点

连接点 （how）。我们的应用可能有数以千计的时机应用通知。这些时机被称为连接点。**连接点是在应用执行过程中能够插入切面的一个点。这个点可以是调用方法时、抛出异常时、甚至修改一个字段时。**切面代码可以利用这些点插入到应用的正常流程之中，并添加新的行为。

<img src="https://cos.jiahongw.com/uPic/image-20211220112909370.png" alt="image-20211220112909370" style="zoom:50%;" />



### pointcut——切点

切点（where）。一个切面并不需要通知应用的所有连接点。切点有助于缩小切面所通知的连接点的范围。

> 如果说通知定义了切面的“什么”和“何时”的话，那么切点就定义了“何处”。切点的定义会匹配通知所要织入的一个或多个连接点。我们通常使用明确的类和方法名称，或是利用正则表达式定义所匹配的类和方法名称来指定这些切点。

<img src="https://cos.jiahongw.com/uPic/image-20211220112909370.png" alt="image-20211220112909370" style="zoom:50%;" />



### Aspect——切面

切面是通知和切点的结合。通知和切点共同定义了切面的全部内容——它是什么，在何时和何处完成其功能。

<img src="https://cos.jiahongw.com/uPic/image-20211220112909370.png" alt="image-20211220112909370" style="zoom:50%;" />





### Introduction——引 入

引入允许我们向现有的类添加**新方法或属性**。

> 例如，可以创建一个Auditable通知类，该类记录了对象最后一次修改的状态。这很简单，只需一个方法，setLastModified(Date)，和一个实例变量来保存这个状态。然后，这个新方法和实例变量就可以被引入到现有的类中，从而可以在无需修改这些现有的类的情况下，让它们具 有新的行为和状态。



### Weaving——织 入 

织入是把切面应用到目标对象并创建新的代理对象的过程。三个时间点织入：编译期、类加载期、运行期。

- 编译期：切面在目标类编译时被织入。这种方式需要特殊的编译器。AspectJ 的织入编译器就是以这种方式织入切面的。
- 类加载期：切面在目标类加载到 JVM 时被织入。这种方式需要特殊的类加载器（ClassLoader），它可以在目标类被引入应用之前增强该目标类的字节码。AspectJ 5 的加载时织入（load-time weaving，LTW）就支持以这种方式织入切面。
- 运行期：切面在应用运行的某个时刻被织入。一般情况下，在织入切面时，AOP 容器会为目标对象动态地创建一个代理对象。Spring AOP 就是以这种方式织入切面的。











## AOP使用场景

1. AOP旨在避免重复的操作，减少代码量。
2. 常见的使用场景是：在两个没有继承关系的实例上添加相同的操作，此时可以使用AOP。AOP不是面向对象的，而是面向某一个方面的。
3. AOP适合用来做一些**比较通用的、与业务关系不大的**事情。比较常见的就是调用日志、权限控制、调用时间和性能统计、参数校验等等。
4. 异常控制的AOP
5. 鉴权AOP



[Springboot使用@Valid 和AOP做参数校验以及日志输出 - SegmentFault 思否](https://segmentfault.com/a/1190000021082382)

[(21条消息) SpringAOP中的JointPoint和ProceedingJoinPoint使用详解（附带详细示例）_kouryoushine的博客-CSDN博客_proceedingjoinpoint有什么用](https://blog.csdn.net/kouryoushine/article/details/105299956)





## 使用AOP

建议使用注解驱动的AOP，使用更加简单。



Spring 提供了 4 种类型的 AOP 支持：

- 基于代理的经典 Spring AOP；
- 纯 POJO 切面；
- @AspectJ 注解驱动的切面；
- 注入式 AspectJ 切面（适用于 Spring 各版本）。



> 定义通知所应用的切点通常会使用注解或在 Spring 配置文件里采用 XML 来编写，这两种语法对于 Java 开发者来说都是相当熟悉的。



## AOP实现原理

1 JDK动态代理

**Spring默认使用JDK的动态代理实现AOP，类如果实现了接口，Spring就会使用这种方式实现动态代理**。

**优点**

1. `JDK`动态代理是`JDK`原生的，不需要任何依赖即可使用；
2. 通过反射机制生成代理类的速度要比`CGLib`操作字节码生成代理类的速度更快；

**缺点**

1. 如果要使用`JDK`动态代理，被代理的类必须实现了接口，否则无法代理；
2. `JDK`动态代理无法为没有在接口中定义的方法实现代理，假设我们有一个实现了接口的类，我们为它的一个不属于接口中的方法配置了切面，`Spring`仍然会使用`JDK`的动态代理，但是由于配置了切面的方法不属于接口，为这个方法配置的切面将不会被织入。
3. `JDK`动态代理执行代理方法时，需要通过反射机制进行回调，此时方法执行的效率比较低；



2 CGLib动态代理

基于继承的方式。

**优点**

1. 使用`CGLib`代理的类，不需要实现接口，因为`CGLib`生成的代理类是直接继承自需要被代理的类；
2. `CGLib`生成的代理类是原来那个类的子类，这就意味着这个代理类可以为原来那个类中，所有能够被子类重写的方法进行代理；
3. `CGLib`生成的代理类，和我们自己编写并编译的类没有太大区别，对方法的调用和直接调用普通类的方式一致，所以`CGLib`执行代理方法的效率要高于`JDK`的动态代理；

**缺点**

1. 由于`CGLib`的代理类使用的是继承，这也就意味着如果需要被代理的类是一个`final`类，则无法使用`CGLib`代理；
2. 由于`CGLib`实现代理方法的方式是重写父类的方法，所以**无法对`final`方法，或者`private`方法进行代理**，因为子类无法重写这些方法；
3. `CGLib`生成代理类的方式是通过操作字节码，这种方式生成代理类的速度要比`JDK`通过反射生成代理类的速度更慢；



### AOP如何通知对象？

通过在代理类中包裹切面，Spring 在运行期把切面织入到 Spring 管理的 bean 中。

![image-20220305120525540](https://cos.jiahongw.com/uPic/image-20220305120525540.png)

直到应用需要被代理的 bean 时，Spring 才创建代理对象。如果使用的是 ApplicationContext 的话，在 ApplicationContext 从 BeanFactory 中加载所有 bean 的时候，Spring 才会创建被代理的对象。因为 Spring 运行时才创建代理对象，所以我们不需要特殊的编译器来织入 Spring AOP 的切面。

> 使用的是ApplicationContext的话，在ApplicationContext从BeanFactory中加载所有bean的时候，Spring才会创建被代理的对象。因为Spring运行时才创建代理对象，所以我们不需要特殊的编译器来织入SpringAOP的切面。

问腿：

- Spring在什么时候创建代理对象，在服务启动的时候吗，还是在实际运行之后有调用被代理的Bean的时候？
- **假如是在运行之后有调用被代理的Bean，那么代理对象创建并且代理完成之后，会删除吗？**

答案：

- 使用的是ApplicationContext的话，在ApplicationContext从BeanFactory中加载所有bean的时候，Spring才会创建被代理的对象，其他情况是使用Bean的时候才创建。



### 通过切点选择连接点

关于 Spring AOP 的 AspectJ 切点，最重要的一点就是 Spring 仅支持 AspectJ 切点指示器（pointcut designator）的一个子集。

 Spring AOP 所支持的 AspectJ 切点指示器：

![image-20220305122719479](https://cos.jiahongw.com/uPic/image-20220305122719479.png)



### AOP错误用法

- 使用this关键字或者类内调用函数不能使用AOP。（this调用的当前类方法无法被拦截）

- 在同一个切面配置中，如果存在多个不同类型的增强，那么其执行优先级是按照增强类型的特定顺序排列，依次的增强类型为 Around.class, Before.class, After.class, AfterReturning.class, AfterThrowing.class；
- 在同一个切面配置中，如果存在多个相同类型的增强，那么其执行优先级是按照该增强的方法名排序，排序方式依次为比较方法名的每一个字母，直到发现第一个不相同且 ASCII 码较小的字母。

## Spring事务

什么情况下能够使用事务？操作redis或者es可以使用Spring的事务吗？



- 编程式事务
- 声明式事务（XML文件配置或者注解配置）









Spring的事务基于数据库的事事务。







---

***Reference:***

- 《Spring实战》第四版
- Spring官方文档
- [4.1.2　Spring 对 AOP 的支持 - Spring 实战(第四版)](https://potoyang.gitbook.io/spring-in-action-v4/untitled/untitled-5/untitled-1)
- [浅析Spring中AOP的实现原理——动态代理 - 特务依昂 - 博客园](https://www.cnblogs.com/tuyang1129/p/12878549.html#:~:text=Spring%20%E7%9A%84%20AOP%20%E5%AE%9E%E7%8E%B0%E5%8E%9F%E7%90%86,%E9%87%8D%E5%86%99%E7%9A%84%E4%BB%A3%E7%90%86%E6%96%B9%E6%B3%95%E3%80%82)

