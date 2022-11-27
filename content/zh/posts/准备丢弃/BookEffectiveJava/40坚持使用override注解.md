---
title: 40坚持使用override注解
date: 2021-11-13T20:50:06+08:00
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





override注解的作用：表示被注解方法声明覆盖了超类的方法声明。坚持使用这个注解，可以防止一大类的非法错误。

例如当我们编写下面的代码：

```java
public class Bigram {
    private final char first;
    private final char second;

    public Bigram(char first, char second) {
        this.first = first;
        this.second = second;
    }

    public boolean equals(Bigram b) {
        return b.first == first && b.second == second;
    }

    public int hashCode() {
        return 31 * first + second;
    }

    public static void main(String[] args) {
        Set<Bigram> s = new HashSet<>();

        for (int i = 0; i < 10; i++)
            for (char ch = 'a'; ch <= 'z'; ch++)
                s.add(new Bigram(ch, ch));

        System.out.println(s.size());
    }
}
```

Bigram类包含两个有序的字幕，我们希望equals能够覆盖父类Object的equals方法，但是父类的equals方法声明是：

```java
public boolean equals(Obeject o);
```

参数是Object，我们实现的Bigram的equals方法只是一个重载方法，并没有覆盖。上面的结果打印的不是 26 而是 260。

正确的做法是在我们需要进行覆盖的函数上面添加`@Override`注解，即：

```java
@Override
public boolean equals(Bigram b) {
  return b.first == first && b.second == second;
}
```

但是，上面的代码并不能编译运行，因为这根本不是一个重写的方法（而是重载的方法），但是编译器可以通过这个注解向我们抛出警告，做出提示，这就足够了。

![image-20211113214157792](../../../../../../../../Library/Application%20Support/typora-user-images/image-20211113214157792.png)

然后我们可以编写正确的重写equals函数：

```java
@Override
public boolean equals(Object o) {
    if (!(o instanceof Bigram))
        return false;
    Bigram b = (Bigram) o;
    return b.first == first && b.second == second;
}
```

总结：

你应该在 **要覆盖超类声明的每个方法声明上使用 @Override 注解。** （虽然覆盖abstract类中的方法可以不加上@Override注解，编译器会自动识别）

`@Override` 注解可用于覆盖接口和类声明的方法声明。随着默认方法的出现，最好对接口方法的具体实现使用 `@Override` 来确保签名是正确的。如果你知道接口没有默认方法，你可以选择忽略接口方法的具体实现上的 `@Override` 注解，以减少混乱。

总之，如果你在每个方法声明上都使用 `@Override` 注解来覆盖超类型声明（只有一个例外），那么编译器可以帮助你减少受到有害错误的影响。

---

***Reference***:
