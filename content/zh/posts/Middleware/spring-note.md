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





### SpringBoot项目配置字段

标准工程的创建方法。

- AppKey：服务的全局唯一标识和通行证
- 项目名称：整个项目的目录。（或者是git仓库目录）
- Group ID：项目组织唯一的标识符，对应为根pom中`<groupId>`标签中的值（所在部门的唯一标志）
- Artifact ID：项目的唯一的标识符，对应为根pom中`<artifactId>`标签中的值
- Version：项目当前版本号，对应为根pom中`<version>`标签中的值
- Package Name：项目中的包名

















## 用法笔记

- 根据类型获取Bean
applicationContext.getBeansOfType(clazz)
applicationContext的类型就是ApplicationContext

<div class="notices info">
在实际的使用过程中，这个可以方法可以进行封装，实现许多方便的功能。例如使用一个Enum类型存储所有相关的类型，再使用这个方法按照Enum的每一个类型进行获取相应的Bean中，最后还可以将Enum的类型和Bean进行映射，构建成一个Map。然后按照类似策略模式进行处理相关的问题。
</div>




[Spring注解@component、@service、@Autowired等作用与区别 - 一颗心的石头 - 博客园](https://www.cnblogs.com/qingpw/p/12867103.html)








































- 





