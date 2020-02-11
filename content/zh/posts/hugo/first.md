---
author: "Victor Hong"
title: "Hugo配置"
date: 2020-02-10T20:50:09+08:00
description: "Guide to set Hugo site."
draft: false
hideToc: false
enableToc: true
enableTocContent: false
author: Victor
authorEmoji: 👻
image: https://d33wubrfki0l68.cloudfront.net/c38c7334cc3f23585738e40334284fddcaf03d5e/2e17c/images/hugo-logo-wide.svg
tags: 
- Hugo
- Github
series:
- Blog
categories:
-
---

HUGO + Github + Github Action持续集成部署个人博客

## HUGO本地环境

首先在HUGO的官网下载[Hugo](https://github.com/gohugoio/hugo/releases)的Windows安装包，然后将路径添加到环境变量即可。

step1:下载hugo

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200210172917.png)

step2:配置环境变量

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200210173107.png)

## HUGO站点配置及主题配置

### 创建站点

在目录下直接输入下面的代码即可创建一个名为blog的hugo站点(注意：新建的站点是没有自带主题的)

```bash
hugo new site blog
```

或者进入blog文件夹内直接输入以下语句：

```bash
hugo new site .
```

### 下载主题

可以在[hugo theme](https://themes.gohugo.io/)下载主题，然后根据主题的文档进行配置

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200210173607.png)

放到站点文件夹themes内，配置config.toml

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200210173725.png)

### 本地测试运行

输入`hugo server`测试

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200210173950.png)







## Github配置

### 创建站点仓库并且设置GithubPage

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200210174906.png)

可以在Setting中看见如下：

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200210175031.png)

### 创建一个存储项目的仓库

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200210175700.png)

### 配置Github Action

首先在项目仓库点击action，选择**Simple workflow**，输入一下的配置代码：

```yml
name: CI #自动化的名称
on:
  push: # push的时候触发
    branches: # 那些分支需要触发
      - master
jobs:
  build:
    runs-on: ubuntu-latest # 镜像市场
    steps:
      - name: checkout # 步骤的名称
        uses: actions/checkout@v1 #软件市场的名称
        with: # 参数
          submodules: true
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2.2.2
        with:
          hugo-version: '0.64.1'
          extended: true
      - name: Build
        run: hugo -D
      - name: Deploy
        uses: peaceiris/actions-gh-pages@v2.5.1
        env:
          ACTIONS_DEPLOY_KEY: ${{ secrets.ACTIONS_DEPLOY_KEY }}
          EXTERNAL_REPOSITORY: redisread/redisread.github.io
          PUBLISH_BRANCH: master
          PUBLISH_DIR: ./public

```

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200211012715.png)

准备部署，我们开发的项目及**github pages**实际是分开的，一个用于保存项目，相当于源代码，另外一个用于保存最终的网页文件。

1. 使用git生成ssh key(相当于生成对密钥)

   ```bash
   ssh-keygen -t rsa -b 4096 -C "$(git config user.email)" -f gh-pages -N ""
   # You will get 2 files:
   #   gh-pages.pub (public key)
   #   gh-pages     (private key)
   ```

   > 假设 开发项目为 **HUGO_blog** 部署的项目为 **redisread.github.io**

2. 打开**HUGO_blog**仓库的settings，再点击**Secrets**，然后添加刚刚生成的私钥，name为**ACTIONS_DEPLOY_KEY**

3. 同理，打开**redisread.github.io**，点击**Deploy keys**，添加公钥，**Allow write access**一定要勾上，否则会无法提交



然后，你就可以提交代码了，push成功后，打开仓库**actions**，至此部署成功，大功告成！





