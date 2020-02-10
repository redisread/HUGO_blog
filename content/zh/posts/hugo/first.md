---
title: "First"
date: 2020-02-10T20:50:09+08:00
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



