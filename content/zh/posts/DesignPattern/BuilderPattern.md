---
title: 建造者模式
date: 2021-10-21T10:47:09+08:00
description: 建造者模式主要是为了解决调用构造函数的时候，参数太多，并且有一些是可选参数不填的情况。这种情况下，使用建造者模式会更加灵活.
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://cos.jiahongw.com/uPic/image-20220327140530127.png
plantuml: true
libraries:
- katex
- mathjax
tags:
- 设计模式
- 建造者模式
series:
- 设计模式
categories:
-
---

> 建造者模式也称为生成器模式或者Builder模式。

建造者模式主要是为了解决调用构造函数的时候，参数太多，并且有一些是可选参数不填的情况。这种情况下，使用建造者模式会更加灵活。

![生成器设计模式](https://cos.jiahongw.com/uPic/builder-zh.png)



最简单的一个比喻就是建房子，一个房子由多个组件组成，可以有墙、门、窗户、屋顶、垃圾桶等等，但是窗和垃圾桶都是可选的，建一个房子不一定需要。此时假如我们要将房子进行分类抽象，子类将会派生出多种，非常复杂。而建造者模式将对象的参数构造从类中抽离，放在一个独立的构建器里面，可以让我们按需构建，最后再返回房子的对象。

![拆解参数构造](https://cos.jiahongw.com/uPic/image-20211021110735422.png)

**不同生成器以不同方式执行相同的任务。**



使用建造者模式的步骤：

1. 在类的内部新建一个静态公有类Builder。
2. Builder类中保存了和原来的类一样的成员变量，并且实习爱你setter方法，返回值是Builder本身。
3. 类仅设置一个私有的构造函数，参数是Builder类的一个实例。
4. 新建一个Builder，使用Builder类中的 `build` 函数调用类的构造函数，返回实例。



> 生成器模式建议将对象构造代码从产品类中抽取出来， 并将其放在一个名为*生成器*的独立对象中。



详细的代码样子

```java
package com.sankuai.stafftraining.wujiahong.demo.springdemo.designpattern.creational;

import java.util.Optional;

/**
 * 建造者模式（生成器模式｜Builder模式）
 */
public class BuilderPattern {

    /**
     * 必要参数
     */
    private Integer number;
    private String name;
    /**
     * 可选参数 使用Optional修饰可选参数，但是一定要设置初始值
     */
    private Optional<Integer> weight;
    private Optional<Integer> height;

    private BuilderPattern(Builder builder) {
        // 外部类可以直接访问内部类的数据
        this.number = builder.number;
        this.name = builder.name;
        this.weight = builder.weight;
        this.height = builder.height;
    }

    @Override
    public String toString() {
        return "number = " + this.number + "\nname = " + this.name + "\nweight = " + (
            this.weight.isPresent() ? weight.get() : "empty") + "\nheight = " +
            (this.height.isPresent() ? height.get() : "empty");
    }

    public static class Builder {

        /**
         * 必要参数
         */
        private Integer number;
        private String name;
        /**
         * 可选参数
         */
        private Optional<Integer> weight;
        private Optional<Integer> height;

        public Builder(Integer number, String name) {
            this.number = number;
            this.name = name;
            this.weight = Optional.empty();
            this.height = Optional.empty();
        }

        public Builder weight(Integer weight) {
            this.weight = Optional.of(weight);
            return this;
        }

        public Builder height(Integer height) {
            this.height = Optional.of(height);
            return this;
        }

        public BuilderPattern build() {
            return new BuilderPattern(this);
        }
    }

    public static void main(String[] args) {
        Integer number = 101;
        String name = "Victor";
        Integer height = 160;
        BuilderPattern builderPattern = new Builder(number,name).height(height).build();
        System.out.println(builderPattern);
    }

}
```



优点：

-  **你可以分步创建对象， 暂缓创建步骤或递归运行创建步骤。**
-  生成不同形式的产品时， 你可以复用相同的制造代码。
-  ***单一职责原则*。 你可以将复杂构造代码从产品的业务逻辑中分离出来。（避免 “重叠构造函数 （telescopic constructor）” 的出现）**

缺点：

- 由于该模式需要新增多个类， 因此代码整体复杂程度会有所增加。



和工厂模式的区别：

*顾客走进一家餐馆点餐，我们利用工厂模式，根据用户不同的选择，来制作不同的食物，比如披萨、汉堡、沙拉。对于披萨来说，用户又有各种配料可以定制，比如奶酪、西红柿、起司，我们通过建造者模式根据用户选择的不同配料来制作披萨。*

> 建造者模式可以进行一些特殊的组合操作，其中一些内部对象可有也可无。

---

***Reference***:

1. [Effective-Java-3rd-edition-Chinese-English-bilingual/Chapter-2-Item-2-Consider-a-builder-when-faced-with-many-constructor-parameters.md at dev · clxering/Effective-Java-3rd-edition-Chinese-English-bilingual](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-2/Chapter-2-Item-2-Consider-a-builder-when-faced-with-many-constructor-parameters.md)
2. [建造者设计模式（生成器模式）](https://refactoringguru.cn/design-patterns/builder)

