---
title: "Git免密push"
date: 2020-04-03T19:07:07+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: inner
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

执行此命令后，用户主目录下的`.gitconfig`文件会多了一项：`[credential]`

```
helper = store
```

> 注意: Linux用户主目录一般在`~/`下,而Windows下一般为`C:\users\Administrator`

这样以后push就不需要用户名和密码了



### 2. 使用ssh协议

首先生成密钥对,执行

```bash
ssh-keygen -t rsa -C "youremail"
```

接下来按照提示操作，默认可以一路往下。

然后将生成的位于`~/.ssh/`的`id_rsa.pub`的内容复制到你github setting里的ssh key中。

复制之后，如果你还没有克隆你的仓库，那你直接使用ssh协议用法：`git@github.com:yourusername/yourrepositoryname`克隆就行了。

如果已经使用https协议克隆了，那么按照如下方法更改协议：
`git remote set-url origin git@github.com:yourusername/yourrepositoryname.git`

Done!

### 3. 管理多git账号

参考:

1. [https://www.jianshu.com/p/f7f4142a1556](https://www.jianshu.com/p/f7f4142a1556) 简书
2. [https://segmentfault.com/a/1190000012432367](https://segmentfault.com/a/1190000012432367)
3. [https://juejin.im/post/5d6a23d45188252bd90f601a](https://juejin.im/post/5d6a23d45188252bd90f601a) 掘金
4. [https://www.cnblogs.com/popfisher/p/5731232.html](https://www.cnblogs.com/popfisher/p/5731232.html)

