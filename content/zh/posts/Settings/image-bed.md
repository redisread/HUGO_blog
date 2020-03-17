---
title: "配置基于Github的PicGo图床"
date: 2020-02-04T23:51:21+09:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: true
tocPosition: inner
tags:
- PicGo
- Github
- 图床
series:
-
categories:
-
image: https://i.loli.net/2020/02/14/jbMKRxsOIZT1Uc6.png
---

使用Github+PicGo建立一个免费的个人图床。

<!--more-->

## PicGo介绍

`PicGo`是一款图片上传的工具，目前支持`微博图床`，`七牛图床`，`腾讯云`，`又拍云`，`GitHub`等图床

## 在Github创建图床

### 创建Repository

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200204235740316.png)

### 生成一个Token用于操作GitHub repository

步骤如下:

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200204235942470.png)

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205000404800.png)

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205000438671.png)

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205000506694.png)

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205000649335.png)

{% note warning %}
注：创建成功后，会生成一串token，这串token之后不会再显示，所以第一次看到的时候，就要好好保存
{% endnote %}

## 配置PicGo

### 下载PicGo

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205001453409.png)

Windows用户下载exe文件

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205113338203.png)

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205113404987.png)

### 配置图床

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205115015945.png)

> * 设定仓库名的时候，是按照“账户名/仓库名的格式填写”
>
> * 分支名统一填写“master”
>
> * 将之前的Token黏贴在这里
>
> * 存储的路径可以按照我这样子写，就会在repository下创建一个“img”文件夹
>
> * 自定义域名的作用是，在上传图片后成功后，PicGo会将“自定义域名+上传的图片名”生成的访问链接，放到剪切板上`https://raw.githubusercontent.com/用户名/RepositoryName/分支名，`，自定义域名需要按照这样去填写

### 快捷键及相关配置

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/image-20200205115334849.png)

> 这里配置上传快捷键为`ctrl+shift+c`

## 使用

经过上面的配置就大功告成了，每次截图之后，只需要`ctrl+shift+c`一下就可以把剪切板上面的截图转化为在线网络图片链接。