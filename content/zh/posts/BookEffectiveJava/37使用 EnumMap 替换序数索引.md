---
title: 37使用 EnumMap 替换序数索引
date: 2021-11-11T17:13:46+08:00
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
-
series:
-
categories:
-
---



序数索引是指依赖于枚举成员在枚举中的序数（ordinal方法返回值）来进行数组索引。这种方法是不建议的。这种情况下，最好使用EnumMap进行索引。当进行分组的时候，范型和数组不兼容，程序需要进行未受检的转换。



使用枚举元素进行分组的时候，最好使用EnumMap进行分组，而不是使用整型数字进行分组，或者是其他。因为整型数字没有类型检查（int不能提供枚举的类型安全），如果你使用了错误的值，程序将静默执行错误的操作。

EnumMap 在速度上与有序索引数组相当的原因是，EnumMap 在内部使用这样的数组，但是它向程序员隐藏了实现细节，将 Map 的丰富的功能和类型安全性与数组的速度结合起来。



不建议的用法：

```java
// Using ordinal() to index into an array - DON'T DO THIS!
Set<Plant>[] plantsByLifeCycle =(Set<Plant>[]) new Set[Plant.LifeCycle.values().length];

for (int i = 0; i < plantsByLifeCycle.length; i++)
    plantsByLifeCycle[i] = new HashSet<>();

for (Plant p : garden)
    plantsByLifeCycle[p.lifeCycle.ordinal()].add(p);

// Print the results
for (int i = 0; i < plantsByLifeCycle.length; i++) {
    System.out.printf("%s: %s%n",
    Plant.LifeCycle.values()[i], plantsByLifeCycle[i]);
}
```



普通用法：

```java
// Using an EnumMap to associate data with an enum
Map<Plant.LifeCycle, Set<Plant>> plantsByLifeCycle =new EnumMap<>(Plant.LifeCycle.class);

for (Plant.LifeCycle lc : Plant.LifeCycle.values())
    plantsByLifeCycle.put(lc, new HashSet<>());

for (Plant p : garden)
    plantsByLifeCycle.get(p.lifeCycle).add(p);

System.out.println(plantsByLifeCycle);

```



Stream用法：

```java
// Using a stream and an EnumMap to associate data with an enum
System.out.println(
    Arrays.stream(garden).collect(groupingBy(p -> p.lifeCycle,() -> new EnumMap<>(LifeCycle.class), toSet()))
);
```

Stream用法更加简洁。

---

***Reference***:

1. [Item 37: Use EnumMap instead of ordinal indexing（使用 EnumMap 替换序数索引）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-6/Chapter-6-Item-37-Use-EnumMap-instead-of-ordinal-indexing.md)
2. [第33条：用EnumMap代替序数索引 - 代码先锋网](https://codeleading.com/article/3311609909/)
