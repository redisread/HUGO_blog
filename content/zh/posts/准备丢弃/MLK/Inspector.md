---
title: Inspector
date: 2021-01-12T16:54:31+08:00
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



# Inspector

Intel®Inspector是一个动态内存和线程错误检查工具，适用于在Windows和Linux操作系统上开发串行和多线程应用程序的用户。

## 基本介绍

官网：
https://software.intel.com/en-us/inspector

源码：
https://software.intel.com/en-us/inspector/choose-download(需要intel账号)

文档：
https://software.intel.com/en-us/inspector-tutorial-linux-memory-cplusplus

## 支持

- Windows、Linux

## 安装

> dnf install
> dnf groupinstall "Development Tools"
> dnf install gtk2-devel pango-devel xorg-x11-server-Xorg alsa-lib

1. 解压。

   ```shell
   tar -zxvf inspector_2020_update1.tar.gz
   cd inspector_2020_update1/
   ```

2. 执行安装脚本。

   ```bash
   bash install.sh
   ```



**安装信息**

1.默认安装路径<inspector-install-dir>:
/opt/intel/:对于root用户
$HOME/intel/:对于非root用户

2.开始使用Inspector 2020 Update 1设置环境变量：
添加<inspector-install-dir>/bin32或者<inspector-install-dir>/bin64到路径中。
csh/tcsh 用户: source /opt/intel/inspector_2020.1.0.604266/inspxe-vars.csh
bash users 用户: source /opt/intel/inspector_2020.1.0.604266/inspxe-vars.sh

3.使用图形接口使用inspxe-gui，使用命令行接口使用inspxe-cl。

## 使用

### 基本使用方法



## 原理



## 优点和缺点



