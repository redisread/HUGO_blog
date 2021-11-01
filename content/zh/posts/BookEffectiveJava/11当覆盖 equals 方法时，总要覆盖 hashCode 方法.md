---
title: 11-当覆盖 equals 方法时，总要覆盖 hashCode 方法
date: 2021-10-29T11:36:35+08:00
description: Always override hashCode when you override equals.
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
- EffectiveJava
series:
- EffectiveJava
categories:
-
---



<!--第三章：对象的通用方法-->



### 什么时候会使用hashCode方法

HashMap 和 HashSet 等集合中运行的时候，因为使用到了哈希的原理，所以会使用到hashCode方法进行判断元素或者元素的键是否存在。

HashMap的put方法(hash方法调用hashCode方法)：

![HashMap-put](https://cos.jiahongw.com/uPic/image-20211029115014715.png)



HashMap的get方法：

![HashMap-get](https://cos.jiahongw.com/uPic/image-20211029115112869.png)



### hashCode方法的规范

如果根据 `equals(Object)` 方法判断出两个对象是相等的，那么在两个对象上调用 hashCode 方法必须产生相同的整数结果。如果根据 `equals(Object)` 方法判断出两个对象不相等，则不需要在每个对象上调用 hashCode 方法时必须产生不同的结果。



上面两个说的是equals方法相等表示两个对象相等，那么对相等对象进行hash的到的hashCode也应该是相等的。而如果两个对象不相等，也是可能出现hash之后hashCode的值是一样的。



### 为什么覆盖equals方法时总要覆盖hashcode方法

因为如果不覆盖equals方法的话，相等的对象可能返回的不相同的hash code。





如何设置一个好的散列函数?（如何覆盖hashCode方法，使得更好的散列）

1. 声明一个名为 result 的 int 变量，并将其初始化为对象中第一个重要字段的散列码 c，如步骤 2.a 中计算的那样。

2. 对象中剩余的重要字段 f，执行以下操作：

   a. 为字段计算一个整数散列码 c:

   - 如果字段是基本数据类型，计算 `Type.hashCode(f)`，其中 type 是与 f 类型对应的包装类。
   - 如果字段是对象引用，并且该类的 equals 方法通过递归调用 equals 方法来比较字段，则递归调用字段上的 hashCode 方法。如果需要更复杂的比较，则为该字段计算一个「canonical representation」，并在 canonical representation 上调用 hashCode 方法。如果字段的值为空，则使用 0（或其他常数，但 0 是惯用的）。
   - 如果字段是一个数组，则将其每个重要元素都视为一个单独的字段。也就是说，通过递归地应用这些规则计算每个重要元素的散列码，并将每个步骤 2.b 的值组合起来。如果数组中没有重要元素，则使用常量，最好不是 0。如果所有元素都很重要，那么使用 `Arrays.hashCode`

   b. 将步骤 2.a 中计算的散列码 c 合并到 result 变量：

   ```java
   result = 31 * result + c;
   ```

3. 返回 result 变量。

一个简单的例子，假如对象内部有三个字短，它的hashCode可以写成下面这样：

```java
// Typical hashCode method
@Override
public int hashCode() {
    int result = Short.hashCode(areaCode);
    result = 31 * result + Short.hashCode(prefix);
    result = 31 * result + Short.hashCode(lineNum);
    return result;
}
```



> 虽然上面的方法产生了相当不错的散列算法，但它们并不是最先进的。它们的质量可与 Java 库的值类型中的散列算法相媲美，对于大多数用途来说都是足够的。如果你确实需要不太可能产生冲突的散列算法，请参阅 Guava 的 com.google.common.hash.Hashing [Guava]。



Objects 类有一个静态方法，它接受任意数量的对象并返回它们的散列码。这个名为 `hash` 的方法允许你编写只有一行代码的 hashCode 方法，这些方法的质量可以与本条目中提供的编写方法媲美。不幸的是，它们运行得更慢，因为它们需要创建数组来传递可变数量的参数，如果任何参数是原始类型的，则需要进行装箱和拆箱。推荐只在性能不重要的情况下使用这种散列算法。下面是使用这种技术编写的 PhoneNumber 的散列算法：

```java
// One-line hashCode method - mediocre performance
@Override
public int hashCode() {
    return Objects.hash(lineNum, prefix, areaCode);
}
```



如果一个类是不可变的，并且计算散列码的成本非常高，那么你可以考虑在对象中缓存散列码，而不是在每次请求时重新计算它。

```java
// hashCode method with lazily initialized cached hash code
private int hashCode; // Automatically initialized to 0
@Override
public int hashCode() {
    int result = hashCode;

    if (result == 0) {
        result = Short.hashCode(areaCode);
        result = 31 * result + Short.hashCode(prefix);
        result = 31 * result + Short.hashCode(lineNum);
        hashCode = result;
    }

    return result;
}
```



---

***Reference***:

1. [Item 11: Always override hashCode when you override equals（当覆盖 equals 方法时，总要覆盖 hashCode 方法）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-3/Chapter-3-Item-11-Always-override-hashCode-when-you-override-equals.md)
2. [Java的hashcode()详解 +应用场景_weixin_42956047的博客-CSDN博客](https://blog.csdn.net/weixin_42956047/article/details/103457628)
3. [覆盖equals时总要覆盖hashCode - 简书](https://www.jianshu.com/p/40ee40f155aa)
