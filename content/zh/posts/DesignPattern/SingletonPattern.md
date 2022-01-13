---
title: 单例模式
date: 2021-10-21T15:31:40+08:00
description: 单例模式是一种创建型设计模式， 让你能够保证一个类只有一个实例， 并提供一个访问该实例的全局节点。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://cos.jiahongw.com/uPic/singleton.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- 设计模式
- 单例模式
series:
- 设计模式
categories:
-
---



### 什么是单例

**单例设计模式**（Singleton Design Pattern）理解起来非常简单。一个类只允许创建一个对象（或者实例），那这个类就是一个单例类，这种设计模式就叫作单例设计模式，简称单例模式。



### 为什么使用单例

同一个类创建了多个对象，然后干的事情是一样的，在多线程环境下还需要考虑线程同步。而单例模式：

1. 不用创建那么多Logger对象，一方面节省内存空间。
2. 另一方面节省系统文件句柄。

单例加锁的时候只需要添加对象锁即可，不用像之前使用类锁。



> 从业务概念上，如果有些数据在系统中只应保存一份，那就比较适合设计为单例类。

另外一种使用场景是需要一个全局唯一类，比如配置信息类，唯一递增ID号码生成器。



### 单例的实现

各种单例模式的实现如下：

1. 饿汉单例

   instance的创建过程是线程安全的。但是不支持延迟加载，因为在类创建的时候就将单例创建了。

2. 懒汉单例（支持延迟加载）

3. 静态阻塞初始化单例

4. 线程安全单例（并发度低）

5. 双重检测单例（支持高并发和延迟加载）

6. 内部静态类单例（既保证了线程安全，又能做到延迟加载）

7. Enum 单例

8. 序列化单例

Code：

```java
package com.sankuai.stafftraining.wujiahong.demo.springdemo.designpattern.creational;

import java.io.Serializable;

/**
 * 单例模式
 */
public class SingletonPattern {

    public static void main(String[] args) {
        // Enum 单例模式使用
        String myField = "Singleton";
        EnumSingleton.INSTANCE.setField(myField);
        System.out.println(EnumSingleton.INSTANCE.getField());
    }

    /**
     * 1.饿汉单例模式 这样的实现方式不支持延迟加载（在真正用到IdGenerator的时候，再创建实例）
     */
    static class SingletonV1 {

        private static SingletonV1 instance = new SingletonV1();

        private SingletonV1() {
        }

        public static SingletonV1 getInstance() {
            return instance;
        }
    }

    /**
     * 2.懒汉单例模式
     */
    static class SingletonV2 {

        private static SingletonV2 instance;

        private SingletonV2() {
        }

        public static SingletonV2 getInstance() {
            if (instance == null) {
                instance = new SingletonV2();
            }
            return instance;
        }
    }

    /**
     * 3.静态阻塞初始化
     */
    static class SingletonV3 {

        private static SingletonV3 instance;

        private SingletonV3() {
        }

        static {
            try {
                instance = new SingletonV3();
            } catch (Exception e) {
                throw new RuntimeException("Exception occured in creating singleton instance");
            }
        }

        public static SingletonV3 getInstance() {
            return instance;
        }
    }

    /**
     * 线程安全单例
     */
    static class SingletonV4 {

        private static SingletonV4 instance;

        private SingletonV4() {
        }

        public static synchronized SingletonV4 getInstance() {
            if (instance == null) {
                instance = new SingletonV4();
            }
            return instance;
        }
    }

    /**
     * 双重检查并且加锁避免额外的开销
     */
    static class SingletonV5 {

        private static SingletonV5 instance;

        private SingletonV5() {

        }

        public static SingletonV5 getInstance() {
            if (instance == null) {
              // 只有在第一次创建对象的时候才会进行同步锁定，其他情况不需要，提高了性能
                synchronized (SingletonV5.class) {
                    if (instance == null) {
                        instance = new SingletonV5();
                    }
                }
            }
            return instance;
        }
    }

    /**
     * 内部静态类单例模式,不需要同步
     */

    static class SingletonV6 {

        private SingletonV6() {

        }

        private static class SingletonHelper {

            private static final SingletonV6 INSTANCE = new SingletonV6();
        }

        public SingletonV6 getInstance() {
            return SingletonHelper.INSTANCE;
        }

    }

    /**
     * Enum 单例模式
     */
    public enum EnumSingleton {

        INSTANCE;
        private String field;

        public String getField() {
            return field;
        }

        public void setField(String field) {
            this.field = field;
        }
    }

    /**
     * 序列化单例模式
     */
    static class SerializedSingleton implements Serializable {

        private static final long serialVersionUID = -7604766932017737115L;

        private SerializedSingleton() {
        }

        private static class SingletonHelper {

            private static final SerializedSingleton instance = new SerializedSingleton();
        }

        public static SerializedSingleton getInstance() {
            return SingletonHelper.instance;
        }

        protected Object readResolve() {
            return getInstance();
        }

    }

}
```



> question :question:
>
> 1. 为什么使用双检锁？
>
>    避免额外的开销。在两次判断instance是否为null的中间加入synchronized关键字，将synchronize的返回从整个方法降到判断里面。
>
> 2. 







### 单例的问题

1. 对OOP对象不友好

   封装、继承、多态、抽象这些面向对象的的特性，单例这种设计模式对于其中的抽象、继承、多态都支持得不好。

2. 隐藏子类之间的依赖关系

   构造函数是private的，因为不能够显示的在外部调用构造函数，所以我们不知道单例道到底需要依赖那些东西。如果代码比较复杂，这种调用关系就会非常隐蔽。

3. 对拓展不好

   单例只有一个对象，如果后面需要创建多个实例，就需要对代码有较大的改动。（常常在多线程并发的情况下有这种需求）

4. 可测试性不好

5. 不支持带参数的构造函数

   1. 使用辅助函数进行set
   2. 将参数上放至getInstance
   3. 使用全局变量Config



### 单例的替代方法

1. 静态方法。
2. 工厂模式、IOC容器（比如Spring IOC容器）来保证
3. 程序员自己保证



### 理解单例的唯一性

唯一的维度：
- 同一线程唯一

- 同一进程唯一

- 分布式系统唯一

  进程内唯一，进程间也唯一。

  具体来说，我们需要把这个单例对象序列化并存储到外部共享存储区（比如文件）。进程在使用这个单例对象的时候，需要先从外部共享存储区中将它读取到内存，并反序列化成对象，然后再使用，使用完成之后还需要再存储回外部共享存储区。

  为了保证任何时刻，在进程间都只有一份对象存在，一个进程在获取到对象之后，需要对对象加锁，避免其他进程再将其获取。在进程使用完这个对象之后，还需要显式地将对象从内存中删除，并且释放对对象的加锁。

### 使用场景

- 线程池
- 缓存
- 对话框
- 注册表对象
- 日志对象



---

***Reference***:

1. [单例设计模式](https://refactoringguru.cn/design-patterns/singleton)
2. [43 42 | 单例模式（中）：我为什么不推荐使用单例模式？又有何替代方案？](https://km.sankuai.com/page/462615827)
3. [Java Singleton Design Pattern Example Best Practices - JournalDev](https://www.journaldev.com/1377/java-singleton-design-pattern-best-practices-examples)
4. [Design Patterns for Humans](https://roadmap.sh/guides/design-patterns-for-humans)

