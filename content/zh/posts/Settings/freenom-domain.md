---
title: "Freenom 免费域名申请"
date: 2020-02-13T15:12:33+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: true
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://my.freenom.com/templates/freenom/img/logo.png
tags:
- 域名
- freenom
series:
- Blog
categories:
-
---

[Freenom](https://my.freenom.com/) 是目前为数不多的免费域名提供商，提供 `.ga`, `.ml`, `.gq`, `.tk`, `.cf` 五个免费顶级域。当然也有一些付费的域名，对于普通人来说，免费域名就够了。<span><code>:smirk:</code></span>

<!--more-->

## 第一步，找域名

打开[Freenom](https://my.freenom.com/)，登陆后直接在搜索栏搜索自己想要的域名名字，然后系统会返回可以使用的免费域名，选择一个结算即可

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200213152156.png)

## 第二步，配置解析服务

### 使用[cloudflare](https://dash.cloudflare.com/)解析服务

打开[cloudflare](https://dash.cloudflare.com/)，首先需要注册一个账号。然后他会要求输入需要解析的域名

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200213170834.png)

填写相应的DNS信息，并且将下面的NS信息填写到freenom的**custom nameservers**

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200213172405.png)

![image-20200213172538683](C:/Users/Victor/AppData/Roaming/Typora/typora-user-images/image-20200213172538683.png)

等待个几分钟就好了。Over <span><code>:crossed_fingers:</code></span>

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200213173948.png)

