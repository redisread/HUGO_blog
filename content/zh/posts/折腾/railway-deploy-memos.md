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

点击 `memos` 项目，然后配置 `Variables` 中添加变量PORT，值为5230
![image.png](https://cos.jiahongw.com/PicGo/20230303223937.png)


在进行完上面的端口配置之后，Railway会自动进行重新部署，部署完成之后就可以访问了。访问的域名在 `Deployment` 的最新部署记录中：
![image.png](https://cos.jiahongw.com/PicGo/20230303224156.png)


![image.png](https://cos.jiahongw.com/PicGo/20230303224231.png)



之后只要有新代码的提交或者是执行 `fork sync`，都能够触发Railway的自动部署。


{{< alert theme="info" dir="ltr" >}} 
其他部署平台：
- [vercel](https://vercel.com/)：前端开发人员的平台，提供创新者在灵感迸发时所需的速度和可靠性。
- [render](https://render.com/)：统一的云服务，提供多种服务进行部署和构建应用程序和网站。也能部署数据存储服务和静态网站。
- [fly.io](https://fly.io/)：基于Docker的全栈部署工具。
- [Supabase](https://supabase.com/)：数据库部署服务网站，也能构建其他应用服务。
{{< /alert >}}


---

**_Reference_**:

- [Life after Heroku: What's a dev to do? - Reaktor](https://www.reaktor.com/blog/how-to-deal-with-life-after-heroku/)
- [Dockerfiles | Railway Docs](https://docs.railway.app/deploy/dockerfiles)
