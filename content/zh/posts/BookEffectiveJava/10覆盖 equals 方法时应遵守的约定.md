---
title: 10-覆盖 equals 方法时应遵守的约定
date: 2021-10-28T10:06:09+08:00
description:
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



### 什么时候会使用到equal?

`equal` 用于判断两个对象实例的是否相等。而`==`表示判断俩个对象是不是同一个对象(比较的是引用的地址是不是一样的)。

没有重写`equal`方法的时候，类的每个实例都只等于它自己。

例如，`List.contains`方法就使用了equal方法：

![List.contains](https://cos.jiahongw.com/uPic/image-20211029112540381.png)





### 什么时候应该覆盖equal方法

当你想要比较两个对象里面的值是否相等，而不是两个对象是否是同一个的情况。你需要重写一个equal方法来体现你的业务逻辑。

> 覆盖 equals 方法不仅是为了满足程序员的期望，它还使实例能够作为 Map 的键或 Set 元素时，具有可预测的、理想的行为。

例如下面两个例子：

前者equals比较两个对象是否是同一个

```java
public static void main(String[] args) {

    class Status {
        public String status;
    }

    Status s1 = new Status();
    Status s2 = new Status();

    System.out.println(s1==s2); // false
    System.out.println(s1.equals(s2)); // false
}
```

后者比较的是两个对象里面的值是否相等。

```java
public static void main(String[] args) {

    class Status {
        public String status;

        @Override
        public boolean equals(Object o) {
            return Objects.equals(status, ((Status) o).status);
        }
    }

    Status s1 = new Status();
    Status s2 = new Status();

    System.out.println(s1==s2); // false
    System.out.println(s1.equals(s2)); // true
}
```



### 覆盖equal的规定

1. 自反性：对于任何非空的参考值 x，`x.equals(x)` 必须返回 true。
2. 对称性：对于任何非空参考值 x 和 y，`x.equals(y)` 必须在且仅当 `y.equals(x)` 返回 true 时返回 true。
3. 传递性：对于任何非空的引用值 x, y, z，如果 `x.equals(y)` 返回 true，`y.equals(z)` 返回 true，那么 `x.equals(z)` 必须返回 true。
4. 一致性：对于任何非空的引用值 x 和 y, `x.equals(y)` 的多次调用必须一致地返回 true 或一致地返回 false，前提是不修改 equals 中使用的信息。

> 对于任何非空引用值 x，`x.equals(null)` 必须返回 false。



高质量构建 equals 方法的秘诀：

1. 使用 `==` 运算符检查参数是否是对该对象的引用。 
2. 使用 `instanceof` 运算符检查参数是否具有正确的类型。
3. 将参数转换为正确的类型。

4. 对于类中的每个「重要」字段，检查参数的字段是否与该对象的相应字段匹配。 



equals 方法的性能可能会受到字段比较顺序的影响。为了获得最佳性能，你应该首先比较那些更可能不同、比较成本更低的字段，或者理想情况下两者都比较。不能比较不属于对象逻辑状态的字段，例如用于同步操作的锁字段。你不需要比较派生字段（可以从「重要字段」计算），但是这样做可能会提高 equals 方法的性能。



**当你覆盖 equals 时，也覆盖 hashCode。**

IDE 也有生成 equals 和 hashCode 方法的功能，但是生成的源代码比使用 AutoValue 的代码更冗长，可读性更差，不会自动跟踪类中的变化，因此需要进行测试。也就是说，让 IDE 生成 equals（和 hashCode）方法通常比手动实现更可取，因为 IDE 不会出现粗心的错误，而人会。

>IDEA自动生成equal方法：
>
>- 方法1. 输入 equals 或 code 后按回车，最直接的方法；
>- 方法2. 在代码区域按 alt + enter 或 右键 Generate选项，是通常方法；



总之，除非必须，否则不要覆盖 equals 方法：在许多情况下，从 Object 继承而来的实现正是你想要的。如果你确实覆盖了 equals，那么一定要比较类的所有重要字段，并以保留 equals 约定的所有 5 项规定的方式进行比较。

---

***Reference***:

1. [Item 10: Obey the general contract when overriding equals（覆盖 equals 方法时应遵守的约定）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-3/Chapter-3-Item-10-Obey-the-general-contract-when-overriding-equals.md)

