---
title: "Git免密push"
date: 2020-04-03T19:07:07+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/04/03/xw9tEWQy1L2cJHm.png
libraries:
- katex
- mathjax
tags:
- git
- github
series:
- github
categories:
-
---



每次push都需要输入用户名和密码,其实可以免去这些操作.:articulated_lorry:

<!--more-->

### 1. 使用.git-credentials文件

在git项目目录下新建`.git-credentials`这个文件,然后在里面填写下面内容(大括号不用填写):

```
https://{username}:{password}@github.com
```

然后在git项目目录执行:

```bash
git config --global credential.helper store
```

执行此命令后，用户主目录下的.gitconfig文件会多了一项：`[credential]`

```
helper = store
```