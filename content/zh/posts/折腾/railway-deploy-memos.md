---
title: "使用Railway部署memos"
subtitle: 
date: 2023-03-03T21:20:08+08:00
publishDate: 2023-03-03T21:20:08+08:00
aliases:
description: Railway是一个提供基础设施的部署平台，可以方便的在本地使用该基础架构进行开发，然后部署到云端。支持Docker、Java、JS等程序的部署，并且集成了CICD。
image: https://railway.app/brand/logo-dark.png
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner # outer
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h2", "h3", "h4"]
libraries: 
tags: [Railway, memos]
series: [折腾计划]
categories: [折腾]
---

使用云进行部署的好处是，我们不需要负责云主机的相关运维；在使用部署平台进行服务的部署时，我们还能省去部署的一系列操作。

下面介绍使用 Railway 部署 memos（Dockerfile 部署）

{{< boxmd >}}
Railway 地址：[https://railway.app/](https://railway.app/)
memos 地址：[https://github.com/usememos/memos](https://github.com/usememos/memos)
{{< /boxmd >}}

## 注册并且登录 Railway

注册就按照注册流程进行注册即可，进入首页：
![image.png](https://cos.jiahongw.com/PicGo/20230303222909.png)

每个月 Railway 是有 5 美元的免费额度的，在右上角下拉的 `Project Usage` 可以查看

![image.png](https://cos.jiahongw.com/PicGo/20230303223032.png)

## 新建项目

选择新建项目按钮，然后选择 `Deploy from Github repo` 。然后会让你登录 Github 账号并且验证。
![image.png](https://cos.jiahongw.com/PicGo/20230303223218.png)

验证完成之后选择需要部署的代码仓库（注意，这里是需要自己的代码仓库，需要将 memos 的 Github 仓库 fork 一份到自己的仓库下）。选择仓库下的 `memos` 仓库进行立即部署：
![image.png](https://cos.jiahongw.com/PicGo/20230303223541.png)

立即部署之后还不能直接使用，还需要进行后面的一些配置。

## 配置端口

点击 `memos` 项目，然后配置 `Variables` 中添加变量 PORT，值为 5230
![image.png](https://cos.jiahongw.com/PicGo/20230303223937.png)

在进行完上面的端口配置之后，Railway 会自动进行重新部署，部署完成之后就可以访问了。访问的域名在 `Deployment` 的最新部署记录中：
![image.png](https://cos.jiahongw.com/PicGo/20230303224156.png)

![image.png](https://cos.jiahongw.com/PicGo/20230303224231.png)

之后只要有新代码的提交或者是执行 `fork sync`，都能够触发 Railway 的自动部署。

{{< alert theme="info" dir="ltr" >}}
其他部署平台：

- [vercel](https://vercel.com/)：前端开发人员的平台，提供创新者在灵感迸发时所需的速度和可靠性。
- [render](https://render.com/)：统一的云服务，提供多种服务进行部署和构建应用程序和网站。也能部署数据存储服务和静态网站。
- [fly.io](https://fly.io/)：基于 Docker 的全栈部署工具。
- [Supabase](https://supabase.com/)：数据库部署服务网站，也能构建其他应用服务。
  {{< /alert >}}

[2023-07-09]更新，使用 Railway 的 Volume 可不丢失数据进行更新，下面的具体的指导教程

Railway 不丢失数据更新：

1. 参考[https://docs.railway.app/reference/volumes](https://docs.railway.app/reference/volumes)这里的说明，使用`volume`功能需要优先登机会员，参考[Priority Boarding | Railway Docs](https://docs.railway.app/reference/priority-boarding)可知道加入的方法即连接官方的`Discord`即可。
   - 访问您的 Railway General Settings
   - 滚动到 Account Settings，连接您的 Railway 帐户到 Discord
   - 在 Discord 中打开任何频道，输入“/beta”命令并按照提示操作
   - 现在您应该可以访问“#priority-boarding”频道，并且您的帐户设置中应该显示新的 Priority Boarding 状态
   - 从此时起，您将自动启用 Priority Boarding 功能
     ![8xT7xL](https://cos.jiahongw.com/uPic/8xT7xL.jpg)
2. 在项目界面，按`Commond + K`新建一个`volume`
   ![GYpOOq](https://cos.jiahongw.com/uPic/GYpOOq.png)
   volume 的地址填写为`/var/opt/memos`，名字随便。
3. 因为 VOLUME 关键字在 Railway 被禁用了，需要修改 memos 的 Dockerfile 文件，将 VOLUME 那一行删除
   ![ojHt1B](https://cos.jiahongw.com/uPic/ojHt1B.png)
4. 重新部署，记得配置 `Variables` 中添加变量 PORT，值为 5230，就可以了。

---

**_Reference_**:

- [Life after Heroku: What's a dev to do? - Reaktor](https://www.reaktor.com/blog/how-to-deal-with-life-after-heroku/)
- [Dockerfiles | Railway Docs](https://docs.railway.app/deploy/dockerfiles)
