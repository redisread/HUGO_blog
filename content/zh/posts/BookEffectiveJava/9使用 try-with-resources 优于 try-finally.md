---
title: 9-使用 try-with-resources 优于 try-finally
date: 2021-10-27T17:35:21+08:00
description: Prefer try-with-resources to try-finally。
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



<!--第二章：创建和销毁对象-->

Java 库包含许多必须通过调用 close 方法手动关闭的资源。常见的有 InputStream、OutputStream 和 java.sql.Connection。关闭资源常常会被客户端忽略，这会导致可怕的性能后果。



原来的try-finally是这样编写的：

```java
// try-finally - No longer the best way to close resources!
static String firstLineOfFile(String path) throws IOException {
    BufferedReader br = new BufferedReader(new FileReader(path));
    try {
        return br.readLine();
    } finally {
        br.close();
    }
}
```

即使在try语句里面出现异常了，BufferedReader也能关闭。



当添加新的第二个资源的时候，代码会变得更加复杂：

```java
// try-finally is ugly when used with more than one resource!
static void copy(String src, String dst) throws IOException {
    InputStream in = new FileInputStream(src);
    try {
        OutputStream out = new FileOutputStream(dst);
    try {
        byte[] buf = new byte[BUFFER_SIZE];
        int n;
        while ((n = in.read(buf)) >= 0)
            out.write(buf, 0, n);
    } finally {
        out.close();
        }
    }
    finally {
        in.close();
    }
}
```



使用 try-finally 语句关闭资源的正确代码（如前两个代码示例所示）也有一个细微的缺陷。**try 块和 finally 块中的代码都能够抛出异常**。第二个异常将可能会完全覆盖第一个异常。异常堆栈跟踪中没有第一个异常的记录，这可能会使实际系统中的调试变得非常复杂（而这可能是希望出现的第一个异常，以便诊断问题）。



使用Java 7 引入 `try-with-resources` 语句可以让代码更加简洁清晰，前提是资源必须实现AutoCloseable 接口，它由一个单独的 void-return close 方法组成。

> Java 库和第三方库中的许多类和接口现在都实现或扩展了 AutoCloseable。如果你编写的类存在必须关闭的资源，那么也应该实现 AutoCloseable。



try-with-resources 的例子：

单个资源：

```java
// try-with-resources - the the best way to close resources!
static String firstLineOfFile(String path) throws IOException {
    try (BufferedReader br = new BufferedReader(new FileReader(path))) {
        return br.readLine();
    }
}
```

多个资源：

```java
// try-with-resources on multiple resources - short and sweet
static void copy(String src, String dst) throws IOException {
    try (InputStream in = new FileInputStream(src);OutputStream out = new FileOutputStream(dst)) {
        byte[] buf = new byte[BUFFER_SIZE];
        int n;
        while ((n = in.read(buf)) >= 0)
            out.write(buf, 0, n);
    }
}
```

除此之外，和 try-finally 的原版代码相比，**try-with-resources 为开发者提供了更好的诊断方式**。考虑 firstLineOfFile 方法。如果异常是由 readLine 调用和不可见的 close 抛出的，则后一个异常将被抑制，以支持前一个异常。实际上，还可能会抑制多个异常，以保留实际希望看到的异常。这些被抑制的异常不会仅仅被抛弃；它们会被打印在堆栈跟踪中，并标记它们被抑制。可以通过编程方式使用 getSuppressed 方法访问到它们，该方法是在 Java 7 中添加到 Throwable 中的。



总结：

在使用必须关闭的资源时，总是优先使用 try-with-resources，而不是 try-finally。前者的代码更短、更清晰，生成的异常更有用。使用 try-with-resources 语句可以很容易地为必须关闭的资源编写正确的代码，而使用 try-finally 几乎是不可能的。



---

***Reference***:

1. [Item 9: Prefer try-with-resources to try-finally（使用 try-with-resources 优于 try-finally）](https://github.com/clxering/Effective-Java-3rd-edition-Chinese-English-bilingual/blob/dev/Chapter-2/Chapter-2-Item-9-Prefer-try-with-resources-to-try-finally.md)

