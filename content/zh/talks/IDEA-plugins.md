---
title: "IDEA实用的插件列表"
date: 2021-12-13T16:50:04+08:00
publishDate: 2020-03-01
description: IDEA实用的插件列表
enableToc: true
tags:
- IDEA
series:
-
categories:
-
---





### 1 SequenceDiagram

序列化图





### 2 JRebel

简介：

**热部署**工具。在我们每次修改代码后，不用重启程序，JRebel 会**自动**将所有的代码变更生效。这样，相当于“跳过”**频繁**的 Java 代码的编译、启动的过程，大大的提升了我们的开发效率。

参考链接：

- https://www.iocoder.cn/Fight/IDEA-JRebel-plug-in-hot-deployment/?self
- https://www.jianshu.com/p/882872a7339d

配置：

1. 激活JRebel
2. 配置信息
3. 快捷键：Commond + shift + F9



### 3 Maven Helper

简介：可以查看 Maven 的依赖**树**和**列表**

使用参考：

> 要想查看maven的依赖树就要使用Maven命令`maven dependency:tree`来查看依赖



当Maven Helper 插件安装成功后，打开项目中的pom文件，下面就会多出一个试图

![img](https://cos.jiahongw.com/uPic/131123_C6YN_136229.png)



### 4 LeetCode Editor 

胖友可以后续看看 LeetCode Editor 插件的作者写的 https://git.io/JLMce 指南。



### 5 Alibaba Java Coding Guidelines

[Alibaba Java Coding Guidelines](https://plugins.jetbrains.com/plugin/10046-alibaba-java-coding-guidelines) 插件，基于 [《阿里巴巴 Java 开发手册》](https://github.com/alibaba/p3c/blob/master/Java开发手册（嵩山版）.pdf) 的**代码规范**的检测工具。



### 6 Translation

简介：[Translation](https://plugins.jetbrains.com/plugin/8579-translation) 插件，翻译神器，支持有道、百度、谷歌三种翻译引擎。

功能：

1. **选中**一个单词，进行翻译

2. 输入一个单词，进行翻译

   > 翻译框的呼出，Windows 使用 ctrl + shift + o 快捷键，MacOS 使用 control + command + i 快捷键。



### 7 GenerateAllSetter

简介：[GenerateAllSetter](https://plugins.jetbrains.com/plugin/9360-generateallsetter) 插件，一键调用一个对象的所有的 setter 方法。

功能：

1. 生成对象，并设置默认值
2. 生成对象，并设置传入参数作为值
3. 生成 List / Set / Map 返回结果

快捷键：Mac：alt + Enter



## More

IDEA多线程调试，参考：

- [Idea debug调试时获取异步调用栈 - 简书](https://www.jianshu.com/p/cd5c9a21ff5d)
- [(1条消息) java高并发实战（十）——并发调试和JDK8新特性_平凡之路无尽路的博客-CSDN博客_jdk8并发新特性](https://blog.csdn.net/gududedabai/article/details/80951005)



> ```
> (!(Thread.currentThread().getName().equals("main")))
> ```

![image-20211217182557004](https://cos.jiahongw.com/uPic/image-20211217182557004.png)

只能使用IDEA自带的Debugger



---

***Reference***:

