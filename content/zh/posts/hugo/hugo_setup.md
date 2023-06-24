---
title: "部署HUGO博客"
date: 2020-02-10T20:50:09+08:00
description: "Guide to set Hugo site."
draft: false
hideToc: false
enableToc: true
enableTocContent: false
image: https://cos.jiahongw.com/uPic/hugo-logo-wide.svg
tags: 
- hugo
- github
series:
- 折腾计划
categories:
- 博客搭建
---



> HUGO + Github + Github Action 持续集成部署个人博客

## 安装 HUGO 本地环境

首先在 HUGO 的官网下载[Hugo](https://github.com/gohugoio/hugo/releases)的 Windows 安装包，然后将路径添加到环境变量即可。

step1:下载 hugo

![github下载hugo](https://cos.jiahongw.com/uPic/20200210172917.png)

step2:配置环境变量

![配置hugo环境变量](https://cos.jiahongw.com/uPic/20200210173107.png)

> 其他系统安装 HUGO 的方法：
>
> - Mac：`brew install hugo`

## HUGO 站点配置及主题配置

### 创建站点

在目录下直接输入下面的代码即可创建一个名为 blog 的 hugo 站点(注意：新建的站点是没有自带主题的)

```bash
hugo new site blog
```

或者进入 blog 文件夹内直接输入以下语句：

```bash
hugo new site .
```

### 下载主题

可以在[hugo theme](https://themes.gohugo.io/)下载主题，然后根据主题的文档进行配置

![下载hugo博客框架下的主题](https://cos.jiahongw.com/uPic/20200210173607.png)

放到站点文件夹 themes 内，配置 config.toml

![将主题报放到指定文件夹下](https://cos.jiahongw.com/uPic/20200210173725.png)

### 本地测试运行

输入`hugo server`测试

![本地测试](https://cos.jiahongw.com/uPic/20200210173950.png)

## Github 配置

### 创建站点仓库并且设置 GithubPage

![创建GithubPage仓库](https://cos.jiahongw.com/uPic/20200210174906.png)

可以在 Setting 中看见如下：

![GithubPage的url](https://cos.jiahongw.com/uPic/20200210175031.png)

### 创建另一个存储项目的仓库

创建另一个存储项目的仓库，存储写的博客文章

![创建另外一个仓库](https://cos.jiahongw.com/uPic/20200210175700.png)

### 配置 Github Action

首先在项目仓库点击 action，选择**Simple workflow**，输入一下的配置代码：

```yml
name: HUGO_CI #自动化的名称
on:
  push: # push的时候触发
    branches: # 那些分支需要触发
      - master
jobs:
  build:
    runs-on: ubuntu-latest # 镜像市场
    steps:
      - name: checkout # 步骤的名称
        uses: actions/checkout@v3 #软件市场的名称
        with: # 参数
          submodules: true
      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v2.2.2
        with:
          hugo-version: '0.64.1' # 设置HUGO框架的版本
          extended: true # 是否选择拓展版HUGO框架，选择是
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

![过程](https://cos.jiahongw.com/uPic/20200211012715.png)

准备部署，我们开发的项目及**github pages**实际是分开的，一个用于保存项目，相当于源代码，另外一个用于保存最终的网页文件。

1. 使用 git 生成 ssh key(相当于生成对密钥)

   ```bash
   ssh-keygen -t rsa -b 4096 -C "$(git config user.email)" -f gh-pages -N ""
   # You will get 2 files:
   #   gh-pages.pub (public key)
   #   gh-pages     (private key)
   ```

   > 假设 开发项目为 **HUGO_blog** 部署的项目为 **redisread.github.io**

2. 打开**HUGO_blog**仓库的 settings，再点击**Secrets**，然后添加刚刚生成的私钥，name 为**ACTIONS_DEPLOY_KEY**

3. 同理，打开**redisread.github.io**，点击**Deploy keys**，添加公钥，**Allow write access**一定要勾上，否则会无法提交

然后，你就可以提交代码了，push 成功后，打开仓库**actions**，至此部署成功，大功告成！

![finish](https://cos.jiahongw.com/uPic/BrGxitRSbFDlLko.png)

后续可以自己写文章然后 push 了，`github action`会自动帮你部署。
