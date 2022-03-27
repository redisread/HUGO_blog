---
title: maven目录结构
date: 2021-06-24T12:42:44+08:00
description: Maven相当于一个项目管理的框架，它帮助我们进行简便的依赖包下载和引入，并且能够自动化构建项目，避免繁琐的步骤。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://raw.githubusercontent.com/redisread/Image/master/Java_Maven/img-maven.png
libraries:
tags:
- Java
- Maven
series:
- Java
categories:
-
---





## 基本运作流程

Maven工具在本地有一个存储库，然后当本地存储库没有的情况下会自动的去中央仓库寻找并且下载到本地存储库，然后在执行自动化构建。

![基本Maven](https://raw.githubusercontent.com/redisread/Image/master/Java_Maven/Java_Mavenimage-20210622142638965.png)



## Maven安装目录

![Maven安装目录](https://i.loli.net/2021/06/22/nyo8qfkVv6uNKrx.png)

- `bin/`存放Maven的二进制执行程序，分为Linux和Windows的

  ![bin](https://raw.githubusercontent.com/redisread/Image/master/Java_Maven/image-20210624125905737.png)

- `boot/`存放Maven的类加载器，用于加载jar包和类

  ![boot](https://raw.githubusercontent.com/redisread/Image/master/Java_Maven/boot.png)

- `conf/`存放的是Maven的一些配置文件，例如`settings.xml`

  ![conf](https://raw.githubusercontent.com/redisread/Image/master/Java_Maven/conf.png)

- `lib/`存放Maven工具依赖的jar包

  ![lib](https://raw.githubusercontent.com/redisread/Image/master/Java_Maven/lib.png)

- `usrlibs/`是用户自定义保存项目依赖包的位置，用于作为本地仓库



## Maven项目目录

每次使用Maven生成初始化的项目，项目的基本目录结构如下：

![maven项目目录](https://i.loli.net/2021/06/22/beONWZ4Xzcolywr.png)



- `src/`是源代码保存的位置

  - `main/`业务代码位置
    -  `java/` 具体业务代码 构建包 构建类型
    - `resources/` 资源文件 配置文件 静态文件
    - `webapp/` web项目需要包含此文件夹 包含视图文件
  - `test/` 进行测试的文件夹位置

- `target/`是编译构建之后的目标存放位置

- `pom.xml`是项目的依赖配置文件

  ![pom](https://raw.githubusercontent.com/redisread/Image/master/Java_Maven/pom.png)

