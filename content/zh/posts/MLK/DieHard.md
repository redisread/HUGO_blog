---
title: DieHard
date: 2021-01-12T16:54:58+08:00
description:
draft: true
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image:
libraries:
- katex
- mathjax
tags:
- MLK
series:
-
categories:
-
---





# DieHard



## 基本介绍


源码：https://github.com/emeryberger/DieHard

## 支持

- Windows
- Linux
- Mac OS X

## 安装

> 需要C++14支持

1. 解压并且进入文件夹

   ```bash
   unzip DieHard.zip
   cd DieHard
   ```

2. 编译

   ```bash
   cd src/
   TARGET=libdiehard make linux-gcc-x86-64-replicated
   TARGET=libdieharder make linux-gcc-x86-64-replicated
   ```

   编译完成在目录下会新增3个动态链接库：libdieharder.so和libdiehard.so、libdieharder_r.so

   ```bash
   cd src/util/
   g++ -pipe -g -fPIC -I. -I.. -I../../src/archipelago/brokenmalloc -D_REENTRANT=1 -shared libbrokenmalloc.cpp -o libbrokenmalloc.so -ldl
   g++ -fPIC -pipe -g -I. -I.. -I../../src/archipelago/brokenmalloc/ -D_REENTRANT=1 -shared libtrackalloc.cpp -o libtrackalloc.so -ldl
   ```

   编译完成会在目录下生成2个动态链接库libbrokenmalloc.so和libtrackalloc.so

## 使用

### 基本使用方法

基本使用方法：
在执行程序之前添加提前加载库选项LD_PRELOAD=libdiehard.so
例如：

```bash
LD_PRELOAD=/mnt/MLK/Tools/DieHard/src/libdiehard.so app app_args
```

## 原理







## 优点和缺点

优点：

1. 性能好。(论文说)

缺点：

1. 安装复杂，并且需要C++14的支持。
2. 可以报错但是不能提供错误的具体位置信息。