---
title: "Freenom 免费域名申请 & 自动域名续费"
date: 2022-11-27T15:12:33+08:00
description: 
draft: false
hideToc: false
enableToc: true
image: https://my.freenom.com/templates/freenom/img/logo.png
tags:
- 域名
- freenom
series:
- 折腾计划
categories:
- 博客搭建
---

{{< featuredImage >}}

[Freenom](https://my.freenom.com/) 是目前为数不多的免费域名提供商，提供 `.ga`, `.ml`, `.gq`, `.tk`, `.cf` 五个免费顶级域。当然也有一些付费的域名，对于普通人来说，免费域名就够了。<span><code>:smirk:</code></span>

另外，本文后面还提供了一种自动续租 Freenom 免费域名的方法。


## 1 找域名

> Freenom 地址：[freenom.com](freenom.com)

打开[Freenom](https://my.freenom.com/)，登陆后直接在搜索栏搜索自己想要的域名名字，然后系统会返回可以使用的免费域名，选择一个结算即可

![freenom网站寻找可以申请的免费域名](https://cos.jiahongw.com/uPic/20200213152156.png)

## 2 配置解析服务

> 这一步是可选的，也可以直接使用 Freenom 自己的 DNS 解析服务，或者不使用 cloudflare，用其他的 DNS 解析服务也可以。

### 使用[cloudflare](https://dash.cloudflare.com/)解析服务

> Cloudflare 网址：[cloudflare.com](cloudflare.com)

打开[cloudflare](https://dash.cloudflare.com/)，首先需要注册一个账号。然后他会要求输入需要解析的域名

![添加待解析域名](https://cos.jiahongw.com/uPic/20200213170834.png)

填写相应的 DNS 信息，并且将下面的 NS 信息填写到 freenom 的**custom nameservers**

![填写DNS信息](https://cos.jiahongw.com/uPic/20200213172405-20221127164521841.png)

等待个几分钟就好了。Over <span><code>:crossed_fingers:</code></span>

![等待完成](https://cos.jiahongw.com/uPic/20200213173948.png)

## 3 自动续租

> 参考：
>
> - [luolongfei/freenom: Freenom 域名自动续期。Freenom domain name renews automatically.](https://github.com/luolongfei/freenom)
>
> 常见问题：
>
> - [freenom 域名注册失败的解决办法_未名编程的博客-CSDN 博客_some of your domains could not be registered becau](https://blog.csdn.net/qq_44275213/article/details/119347467?app_version=5.11.1&csdn_share_tail=%7B%22type%22%3A%22blog%22%2C%22rType%22%3A%22article%22%2C%22rId%22%3A%22119347467%22%2C%22source%22%3A%22unlogin%22%7D&utm_source=app)

参考这个[github 仓库](https://github.com/luolongfei/freenom)进行下面的操作：

> 通过 Koyeb 部署：[通过 Koyeb 部署 · luolongfei/freenom Wiki](https://github.com/luolongfei/freenom/wiki/%E9%80%9A%E8%BF%87-Koyeb-%E9%83%A8%E7%BD%B2)

1. 注册 Koyeb 账户

   在新标签页打开链接 <https://app.koyeb.com/auth/signup> ，完成注册，并登录

2. 一键部署

   右击在新标签页打开链接 [![Deploy to Koyeb](https://camo.githubusercontent.com/dbd49fd11e4dea39effabf3572eb66edafb50d32aadb31c7458fe7e42ac93790/68747470733a2f2f7777772e6b6f7965622e636f6d2f7374617469632f696d616765732f6465706c6f792f627574746f6e2e737667)](https://app.koyeb.com/deploy?type=docker&name=freenom&ports=80;http;/&env[FF_TOKEN]=20190214&env[SHOW_SERVER_INFO]=1&env[MOSAIC_SENSITIVE_INFO]=1&env[FREENOM_USERNAME]=&env[FREENOM_PASSWORD]=&env[MULTIPLE_ACCOUNTS]=&env[TELEGRAM_CHAT_ID]=&env[TELEGRAM_BOT_TOKEN]=&env[TELEGRAM_BOT_ENABLE]=0&image=docker.io/luolongfei/freenom:koyeb) ，来到部署画面：

   ![编辑部署信息](https://cos.jiahongw.com/uPic/image-20221127165152174.png)

   主要填写 token 和 freenom 的账号和密码，**token 是登陆后台的密码，需要自己保存**。

   然后点击 deploy 或者 create service。

   ![deploy](https://cos.jiahongw.com/uPic/image-20221127165316877.png)

   点击应用地址，跳到工具管理画面：

   ![点击地址](https://cos.jiahongw.com/uPic/image-20221127165348022.png)

   输入 token 值进行验证（点击送信）：

   ![进入后台，触发续租](https://cos.jiahongw.com/uPic/image-20221127165411395.png)

   返回类似下面的结果：

   ![返回](https://cos.jiahongw.com/uPic/image-20221127165503732.png)

   默认会周期进行定时调用，不需要手动触发，上面只是为了展示进行触发的。

---

***Reference***：

- [The fastest way to deploy applications globally - Koyeb](https://www.koyeb.com/)
