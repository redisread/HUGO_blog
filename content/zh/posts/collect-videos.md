---
title: "视频的收集"
date: 2020-03-02T01:19:51+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/03/02/ay4vF9pUYQ2rTfV.png
libraries:
- 
tags:
- blog
- 视频
- BliBli
- weibo
series:
- Blog
categories:
-
---

:biking_man:一些手机视频的方法:hammer_and_pick:

<!--more-->

# 视频归总方法

## BiliBli视频嵌入代码

### 使用方法

首先找到嵌入代码

![](https://i.loli.net/2020/03/02/UxwTkSMDJpvHmg6.png)

然后复制代码到Markdown文件就可以得到如下显示效果：

<iframe src="//player.bilibili.com/player.html?aid=6731067&cid=10959711&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" marginwidth="50" width="650px" height="360px"> </iframe>

代码如下:

```HTML
<iframe src="//player.bilibili.com/player.html?aid=6731067&cid=10959711&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>
```

> 其中可以在ifram中添加相关属性

## weibo上传的视频

### 使用方法

在微博中上传视频后，打开视频的页面，按F12打开工具,鼠标点击视频找到链接

![](https://i.loli.net/2020/03/02/2A1tHV3GMknUwv8.png)

接下来直接在Markdown中添加代码

<video poster="https://i.loli.net/2020/03/02/GabXC4JmfN6H2hE.png" src="https://f.video.weibocdn.com/00393mgEgx07BmNCEF4j01041200eeW00E010.mp4?label=mp4_720p&template=1280x720.25.0&trans_finger=721584770189073627c6ee9d880087b3&Expires=1583079687&ssig=%2BAmJANwAPn&KID=unistore,video" style="max-height :100%; max-width: 100%; display: block; margin-left: auto; margin-right: auto;" controls="controls" preload="meta">Your browser does not support the video tag.</video>

代码如下:

```HTML
<video poster="https://i.loli.net/2020/03/02/GabXC4JmfN6H2hE.png" src="https://f.video.weibocdn.com/00393mgEgx07BmNCEF4j01041200eeW00E010.mp4?label=mp4_720p&template=1280x720.25.0&trans_finger=721584770189073627c6ee9d880087b3&Expires=1583079687&ssig=%2BAmJANwAPn&KID=unistore,video" style="max-height :100%; max-width: 100%; display: block; margin-left: auto; margin-right: auto;" controls="controls" preload="meta">Your browser does not support the video tag.</video>
```

## QQ空间发布的视频

### 使用方法

与微博的操作类似，打开视频页面，先点击下载按钮

![](https://i.loli.net/2020/03/02/2VPXhBfpu7FIvla.png)

然后会自动跳转，搜索栏上的地址就是视频的地址

![](https://i.loli.net/2020/03/02/ayOLhEi7olwCMGf.png)

接下来直接在Markdown中添加代码

<video poster="https://i.loli.net/2020/03/02/GabXC4JmfN6H2hE.png" src="http://photovideo.photo.qq.com/1075_0b53zeiu6vidieapa3kya5pdbsiej6zqhfsa.f20.mp4?dis_k=97f710c26b204f7f2312614fbcf8f897&dis_t=1583082992&vuin=1427298682&save=1&d=1" style="max-height :100%; max-width: 100%; display: block; margin-left: auto; margin-right: auto;" controls="controls" preload="meta">Your browser does not support the video tag.</video>

代码如下:

```html
<video poster="https://i.loli.net/2020/03/02/GabXC4JmfN6H2hE.png" src="http://photovideo.photo.qq.com/1075_0b53zeiu6vidieapa3kya5pdbsiej6zqhfsa.f20.mp4?dis_k=97f710c26b204f7f2312614fbcf8f897&dis_t=1583082992&vuin=1427298682&save=1&d=1" style="max-height :100%; max-width: 100%; display: block; margin-left: auto; margin-right: auto;" controls="controls" preload="meta">Your browser does not support the video tag.</video>
```

