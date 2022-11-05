---
title: Java并发原理和探索
date: 2022-03-22T16:00:36+08:00
description: Java并发模块，Java的利器之一。待补充
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 🪶
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







### Java内存模型

> 分析Java内存模型工具：
>
> ```xml
> <dependency>
>     <groupId>org.openjdk.jol</groupId>
>     <artifactId>jol-core</artifactId>
>     <version>0.10</version>
> </dependency>
> ```



查看Java中的基本类型的大小：

```java
System.out.println(VM.current().details());
```

输出：

```
# Running 64-bit HotSpot VM.
# Using compressed oop with 3-bit shift.
# Using compressed klass with 3-bit shift.
# WARNING | Compressed references base/shifts are guessed by the experiment!
# WARNING | Therefore, computed addresses are just guesses, and ARE NOT RELIABLE.
# WARNING | Make sure to attach Serviceability Agent to get the reliable addresses.
# Objects are 8 bytes aligned.
# Field sizes by type: 4, 1, 1, 2, 2, 4, 4, 8, 8 [bytes]
# Array element sizes: 4, 1, 1, 2, 2, 4, 4, 8, 8 [bytes]
```

上面的输出表示：

- 引用的类型占用4byte
- boolean 和 byte类型占用1 byte
- short和char类型占用2byte
- int和float类型占用4byte
- long和double类型占用8byte
- 当作为数组元素的时候，每个元素的大小和上述的各个类型都是一致的



一个不包含任何字段的类

定义一个简单的类型：

```java
public class NoFieldClass {
}
```

使用jol查看类的内存布局：

```java
System.out.println(ClassLayout.parseClass(NoFieldClass.class).toPrintable());
```

输出：

```
com.jiahongw.wantee.learn.models.NoFieldClass object internals:
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0    12        (object header)                           N/A
     12     4        (loss due to the next object alignment)
Instance size: 16 bytes
Space losses: 0 bytes internal + 4 bytes external = 4 bytes total
```

在内存中的实际布局类似下面这样（klass word存储类的类型和继承相关信息）：

![img](https://cos.jiahongw.com/uPic/objectHeader.png)

最少也需要花费16bytes

mark word 源代码：https://github.com/openjdk/jdk15/blob/e208d9aa1f185c11734a07db399bab0be77ef15f/src/hotspot/share/oops/markWord.hpp#L96

klass word源代码：https://github.com/openjdk/jdk15/blob/bf1e6903a2499d0c2ab2f8703a1dc29046e8375d/src/hotspot/share/oops/klass.hpp#L54



查看实例化的NoFieldClass对象：

```java
NoFieldClass noFieldClass = new NoFieldClass();
System.out.println(ClassLayout.parseInstance(noFieldClass).toPrintable());
```

输出：

```
com.jiahongw.wantee.learn.models.NoFieldClass object internals:
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                           01 00 00 00 (00000001 00000000 00000000 00000000) (1)
      4     4        (object header)                           00 00 00 00 (00000000 00000000 00000000 00000000) (0)
      8     4        (object header)                           43 c1 00 f8 (01000011 11000001 00000000 11111000) (-134168253)
     12     4        (loss due to the next object alignment)
Instance size: 16 bytes
Space losses: 0 bytes internal + 4 bytes external = 4 bytes total
```

可以看见对象头现在有值的。



对象头中具体的值如下：

![image-20220404141903508](https://cos.jiahongw.com/uPic/image-20220404141903508.png)

对应排列情况为（因为大端）：

> 大端小端：
>
> ![img](https://cos.jiahongw.com/uPic/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3d3d2x5ajEyMzMyMQ==,size_16,color_FFFFFF,t_70.png)
>
> 总结：
>
> 大端是高字节存放到内存的低地址
>
> 小端是高字节存放到内存的高地址

![image-20220404142354238](https://cos.jiahongw.com/uPic/image-20220404142354238.png)





从上面的图中可以看出，此时的hashCode还是一个空值，这说明了在创建类完成之后，还不会计算hashCode，只有在我们实际进行相关的调用之后才会存储hashCode，执行下面的命令：

```java
NoFieldClass noFieldClass = new NoFieldClass();
System.out.println("The identity hash code is " + System.identityHashCode(noFieldClass));
System.out.println(ClassLayout.parseInstance(noFieldClass).toPrintable());
```

输出：

```
The identity hash code is 225493257
com.jiahongw.wantee.learn.models.NoFieldClass object internals:
 OFFSET  SIZE   TYPE DESCRIPTION                               VALUE
      0     4        (object header)                          01 09 c1 70 (00000001 00001001 11000001 01110000) (1891698945)
      4     4        (object header)                           0d 00 00 00 (00001101 00000000 00000000 00000000) (13)
      8     4        (object header)                           43 c1 00 f8 (01000011 11000001 00000000 11111000) (-134168253)
     12     4        (loss due to the next object alignment)
Instance size: 16 bytes
Space losses: 0 bytes internal + 4 bytes external = 4 bytes total
```

hashCode的值是 09 c1 70  0d



[(31条消息) 偏向锁与hashcode能共存吗？_Saintyyu的博客-CSDN博客_hashcode 偏向锁](https://blog.csdn.net/Saintyyu/article/details/108295657)

[Memory Layout of Objects in Java | Baeldung](https://www.baeldung.com/java-memory-layout#:~:text=The%20mark%20word%20describes%20the,64%2Dbit%20architectures%2C%20respectively.)



缓存一致性







happens-beforeg规则：

1. 程序顺序规则：一个线程中的每个操作，happens-before于该线程的任意后续操作。
2. 监视器锁规则：对一个锁的解锁，happens-before于随后对这个锁的加锁。
3. volatile变量规则：对一个volatile域的写，happens-before于任意后续对这个volitile域的读。
4. 传递性：􏰋􏰂A happens-before B􏰚􏲘B happens-before C􏰚􏰅􏱂A happens-before C􏰕







### 并发包的实现意图

![并发包的实现](https://cos.jiahongw.com/uPic/image-20220405115836498.png)





### 线程

Java线程状态变迁：

![Java线程状态变迁](https://cos.jiahongw.com/uPic/image-20220405131154345.png)


$$
$S=\frac{1}{(1-p)+\frac{p}{n}}$
$$






### 线程池

Executor的结构和操作系统的关系：

![image-20220408170927111](https://cos.jiahongw.com/uPic/image-20220408170927111.png)









---

***Reference***:

1. 《Java并发编程的艺术》
