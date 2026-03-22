---
title: git使用笔记
date: 2021-09-04T23:14:21+08:00
description: 记录git的常用操作和一些实际遇到的问题。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
image: https://cos.jiahongw.com/uPic/VpfE08.jpg
libraries:
- katex
- mathjax
tags:
- git
- 开发方法论
series:
categories: ["技术实践"]
---



## 配置信息

git的config的信息又一个全局的配置文件，也有一个局部（当前git项目）的配置文件。他们的位置分别在：

- 全局配置文件.gitconfig：`~/.gitconfig`(用户根目录下)

- 局部配置文件.gitconfig：`.git/config`(当前项目下相对路径)

配置文件内容：

```config
[core]
  editor = vim

[color "diff"]
  whitespace = red reverse

[include]
  path = ~/.gitconfig.user
  
[user]
  name = xxx
  email = xxx@xxx.com

```


配置文件的信息主要包括：

- git使用的编辑器

- diff的配置

- include可以包括用户的自定义信息

- 用户的信息（用户名和邮箱）



> 配置多个账号：
> Mac配置多个Git账号，例如一个公司账号，一个个人账号。
>
> [https://www.jianshu.com/p/698f82e72415](https://www.jianshu.com/p/698f82e72415)
>
>
> 首先unset全部全局的数据，然后参考上面的分别设置多个账号的公钥。最后设置config的时候，公司的不设置，直接设置成global的。
>
> 其他无需更改。



### 通过命令行进行配置


设置用户信息：

```Bash
# 设置提交代码时的用户信息
$ git config [--global] user.name "[name]"
$ git config [--global] user.email "[email address]"
```


查看git配置信息：

```Bash
# 局部配置信息
git config --list
# 全局配置信息
git config --global --list
```

编辑git配置信息可以使用命令行打开：
```bash
# 编辑Git配置文件
$ git config -e [--global]
```

修改远程仓库的地址信息：
```bash
# 设置远程地址
git remote set-url origin [url]
# 删除本地地址
git remote rm origin
# 没有设置远程地址的情况下使用此命令添加远程仓库地址
git remote add origin [url]

```

### 通过配置文件进行修改
```config
[user]
  name = 用户名
	email = 邮箱
[remote "origin"]
	url = 远程仓库地址
	fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
	remote = origin
	merge = refs/heads/master
```



### 配置git代理源

常见的 github 加速方法如修改 `hosts` 文件、魔法上网、设置 `proxy` 等方法。

#### 加速地址一览

- **[fastgit.org](https://hub.fastgit.org/)：**https://doc.fastgit.org/
- **cnpmjs.org：**https://github.com.cnpmjs.org/
- **gitclone.com：**https://gitclone.com/
- **gitee：**https://gitee.com/mirrors
- GitHub 文件加速：https://gh.api.99988866.xyz/
- Github 仓库加速：https://github.zhlh6.cn/
- Github 仓库加速：http://toolwa.com/github/



#### github 国内镜像服务加速

不进行多余网络配置的情况下，直接使用提供了 github 国内镜像服务的网站进行 github 各种资源拉取加速。

加速`clone`：

```bash
# 方法一：手动替换地址
#原地址
$ git clone https://github.com/kubernetes/kubernetes.git
#改为
$ git clone https://github.com.cnpmjs.org/kubernetes/kubernetes.git
#或者
$ git clone https://hub.fastgit.org/kubernetes/kubernetes.git
#或者
$ git clone https://gitclone.com/github.com/kubernetes/kubernetes.git

# 方法二：配置git自动替换
$ git config --global url."https://hub.fastgit.org".insteadOf https://github.com
# 测试
$ git clone https://github.com/kubernetes/kubernetes.git
# 查看git配置信息
$ git config --global --list
# 取消设置
$ git config --global --unset url.https://github.com/.insteadof
```

加速 `release`:

```bash
# 原地址
wget https://github.com/goharbor/harbor/releases/download/v2.0.2/harbor-offline-installer-v2.0.2.tgz
# 加速下载方法一
wget https://download.fastgit.org/goharbor/harbor/releases/download/v2.0.2/harbor-offline-installer-v2.0.2.tgz
# 加速下载方法二
wget https://hub.fastgit.org/goharbor/harbor/releases/download/v2.0.2/harbor-offline-installer-v2.0.2.tgz
```

加速 `raw`:

```bash
# 原地址
$ wget https://raw.githubusercontent.com/kubernetes/kubernetes/master/README.md
# 加速下载方法一
$ wget https://raw.staticdn.net/kubernetes/kubernetes/master/README.md
# 加速下载方法二
$ wget https://raw.fastgit.org/kubernetes/kubernetes/master/README.md
```

#### 设置proxy

命令行设置和取消代理：

```bash
git config --global https.proxy http://127.0.0.1:1080

git config --global https.proxy https://127.0.0.1:1080

git config --global --unset http.proxy

git config --global --unset https.proxy

#只对github.com
git config --global http.https://github.com.proxy socks5://127.0.0.1:1080
#取消代理
git config --global --unset http.https://github.com.proxy)

npm config delete proxy
```

配置文件配置：

```
[http]
    proxy = socks5://127.0.0.1:1080
[https]
    proxy = socks5://127.0.0.1:1080
 
#只对github.com 方案2
[http "https://github.com"]
    proxy = socks5://192.168.10.120:7890
```

>注意：
>
>1, https.proxy设置是无用的, 只需要设置http.proxy
>2, socks5h://更好, 远端DNS

---

Ref：

- [无需代理直接加速各种 GitHub 资源拉取 | 国内镜像赋能 | 助力开发 - Frytea's Blog](https://blog.frytea.com/archives/504/)
- [git 设置和取消代理](https://gist.github.com/laispace/666dd7b27e9116faece6)
- [Linux安装并使用ssr客户端 - 灰鹦鹉](https://www.huiyingwu.com/3756/)



## 关键命令

下图展示了常用的git命令：

![img](https://raw.githubusercontent.com/redisread/Image/master/Blog/image.png)




## 基本操作

```bash
# 初始化git仓库
git init
# 添加文件到暂存区域
git add filename
#添加所有更改的文件到暂存区
git add . (git add --all)
# 提交
git commit
# 提交到远程仓库
```

删除git add操作的文件

```bash
# 删除工作区文件，并且将这次删除放入暂存区
git rm [file1] [file2] ..
# 改名文件，并且将这个改名放入暂存区
git mv [file-original] [file-renamed]
```

## 撤销更改

### 未commit，需要取消更改

已经git add的情况下，使用git checkout . 取消更改。







### 已commit，需要取消更改

关键字：checkout，clean

```Git
$ git checkout # 撤销项目下所有的修改
$ git checkout . # 撤销当前文件夹下所有的修改
$ git checkout xx/xx.py xx/xx2.py # 撤销某几个文件的修改
$ git clean -f # untracked状态，撤销新增的文件
$ git clean -df # untracked状态，撤销新增的文件和文件夹
```


最好不要使用git clean这个命令。



删除commit





## 版本回退

hash_value是在git log查询到的对应提交的哈希值。

```Git
git reset --hard hash_value
```


也可以

```Git
$ git reset --hard origin/master # 回退与本地远程仓库一致
$ git reset --hard HEAD^ # 回退到本地仓库上一个版本
$ git reset --hard <hash code> # 回退到任意版本
$ git reset --soft/git reset # 回退且回到已修改状态，修改仍保留在工作区中。
```



### Git标签tag的使用



### git stash使用


### Git区域

- 1.  工作区(Working Area)

- 2.  暂存区(Stage)

- 3.  本地仓库(Local Repository)

- 4.  远程仓库(Remote Repository)


### 状态

- 1.  未修改(Origin)

- 2.  已修改(Modified)&未追踪(Untracked)

- 3.  已暂存(Staged)

- 4.  已提交(Committed)

- 5.  已推送(Pushed)

git add . 是把文件添加到暂存区中。

git commit 把暂存区中的所有内容提交到当前分支。

git push 是将本版本库库中的当前的修改版本推送到远程仓库。

git pull 将远程仓库的修改版本推送到本地版本库中


取消commit：

```Git
# 不删除工作空间改动代码
git reset --soft HEAD^

```

几个参数：

- –mixed：不删除工作空间改动代码，撤销conmit，并且撤销git add .操作。（这个参数为默认参数）
- –soft：不删除工作空间改动代码，撤销commit，不撤销git add .
- –hard：删除工作空间改动代码，撤销commit，撤销git add .




添加远程仓库：



## 冲突解决

- 强制提交：git push origin branch-name --force


在进行pull和push的时候或者merge的时候，可能会发生冲突，这个时候需要我们手动进行修改冲突的内容。





## git 合并多个commit

最简单的单步操作方法：

```Git
# 使用一次新的commit，替代上一次提交
# 如果代码没有任何新变化，则用来改写上一次commit的提交信息
$ git commit --amend -m [message]
```


重置上次commit的信息：

```Git
# 重做上一次commit，并包括指定文件的新变化
$ git commit --amend [file1] [file2] ...
```


压缩当前版本到指定版本之间的commit为一个commit（不包括命令中的commit）：

```Git
git log

git rebase -i 版本
```

版本不参与合并，文件中最上边的commit不需要修改s。

> 可以删除不需要的commit

**之后选择需要合并的commit的前面的pick改为s，然后保存推出，有冲突按照提示修改即可。** 



# Git将单个commit拆分成多个commit





参考：[Git : 如何将一个commit拆分成多个 | 一个程序员的自我修养](https://codemelody.wordpress.com/2012/12/04/git-%E5%A6%82%E4%BD%95%E5%B0%86%E4%B8%80%E4%B8%AAcommit%E6%8B%86%E5%88%86%E6%88%90%E5%A4%9A%E4%B8%AA/)











## Git查看某次提交的内容

```bash
git show commitId
```

查看某个文件某次提交的内容:

```bash
git show commitId fileName
```



















## git 分支操作

游戏学习分支操作：https://learngitbranching.js.org/?locale=zh_CN



HEAD表示当前的分支节点：

- 使用 `^` 向上移动 1 个提交记录
- 使用 `~<num>` 向上移动多个提交记录，如 `~3`



我使用相对引用最多的就是移动分支。可以直接使用 `-f` 选项让分支指向另一个提交。例如:

```
git branch -f main HEAD~3
```

上面将main分支移动到当前节点的前三个提交。





clone指定分支：

```bash
git clone -b master http://gitslab.yiqing.com/declare/about.git
```





更新远程分支：

```bash
git remote update origin --prune
```



rebase的坑





撤销操作：

虽然在你的本地分支中使用 `git reset` 很方便，但是这种“改写历史”的方法对大家一起使用的远程分支是无效的哦！

为了撤销更改并**分享**给别人，我们需要使用 `git revert`。来看演示：













这里要注意下，如果你的remote branch不是在origin下，按你得把origin换成你的名字。

合并分支到此分支:

```bash
# 合并master分支到此分支
git merge master
```

合并到目标分支：

```bash
# 合并此分支到master分支
git rebase master
```

列出所有分支：

```Git
# 列出本地所有分支
git branch
# 列出本地和远程所有分支
git branch -a
```

删除分支：

```Git
# 删除分支
$ git branch -d [branch-name]
# 删除远程分支
$ git push origin --delete [branch-name]
$ git branch -dr [remote/branch]
```

新建和切换分支：

```bash
# 创建dev分支
git branch dev
# 切换到dev分支
git checkout dev
# 创建dev分支并且切换到该分支
git checkout -b dev
# 新建一个分支，指向指定commit
git branch [branch] [commit]
# 切换到上一个分支
git checkout -
```

重命名分支（本地不存在feature/ones分支）：

```git
# 把远端feature/ones分支名称重命名为feature/12345/ones
git checkout -b feature/ones  origin/feature/ones
git pull
```


重命名feature/ones分支

```git
git branch -m feature/ones feature/12345/ones
```


- 提交分支

提交到feature/12345/ones分支

```git
git push origin feature/12345/ones
```


- 删除远端分支

删除远端feature/ones分支

```git
git push -d feature/ones
```


- 合并分支

将文件合并到master，即合并dev分支到master中去

```git
git merge dev 
```


拉取远程分支：
```bash
# 拉取远程分支并创建本地分支
git checkout -b 本地分支名x origin/远程分支名x
# 拉取远程分支，但是不切换到该分支
git fetch origin 远程分支名x:本地分支名x
```

查看本地分支与远程分支的映射关系
```bash
git branch -vv
```

建立当前分支与远程分支的映射关系:
```bash
git branch -u origin/addFile
git branch --set-upstream-to origin/addFile
```

撤销本地分支与远程分支的映射关系:
```bash

git branch --unset-upstream

```
ref:[git upstream](<++>) 


<++>




### 代码回滚







### 冲突解决


生成发布压缩包

```Git
git archive
```



## 标签使用

```bash
# 列出所有tag
$ git tag

# 新建一个tag在当前commit
$ git tag [tag]

# 新建一个tag在指定commit
$ git tag [tag] [commit]

# 删除本地tag
$ git tag -d [tag]

# 删除远程tag
$ git push origin :refs/tags/[tagName]

# 查看tag信息
$ git show [tag]

# 提交指定tag
$ git push [remote] [tag]

# 提交所有tag
$ git push [remote] --tags

# 新建一个分支，指向某个tag
$ git checkout -b [branch] [tag]
```





## Git规范

### 分支命名

**master 分支** 

- master 为主分支，也是用于部署生产环境的分支，确保master分支稳定性

- master 分支一般由develop以及hotfix分支合并，任何时间都不能直接修改代码

**develop 分支** 

- develop 为开发分支，始终保持最新完成以及bug修复后的代码

- 一般开发的新功能时，feature分支都是基于develop分支下创建的

**feature 分支** 

- 开发新功能时，以develop为基础创建feature分支

- 分支命名: feature/ 开头的为特性分支， 命名规则: feature/user_module、 feature/cart_module

**release分支** 

- release 为预上线分支，发布提测阶段，会release分支代码为基准提测

&ensp;&ensp;&ensp;&ensp;当有一组feature开发完成，首先会合并到develop分支，进入提测时，会创建release分支。

&ensp;&ensp;&ensp;&ensp;如果测试过程中若存在bug需要修复，则直接由开发者在release分支修复并提交。

&ensp;&ensp;&ensp;&ensp;当测试完成之后，合并release分支到master和develop分支，此时master为最新代码，用作上线。

&ensp;&ensp;&ensp;&ensp;复制代码

**hotfix 分支** 

- 分支命名: hotfix/ 开头的为修复分支，它的命名规则与 feature 分支类似

- 线上出现紧急问题时，需要及时修复，以master分支为基线，创建hotfix分支，修复完成后，需要合并到master分支和develop分支

![git规范流程](https://raw.githubusercontent.com/redisread/Image/master/Blog/image_2.png)



### 日志规范

当前业界应用的比较广泛的是 [Angular Git Commit Guidelines](https://link.juejin.cn/?target=https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#-git-commit-guidelines)

Commit message格式：

每次提交，Commit message 都包括三个部分：header，body 和 footer。

```Git
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```


其中，header 是必需的，body 和 footer 可以省略。

type: 本次 commit 的类型，诸如 bugfix docs style 等
scope: 本次 commit 波及的范围
subject: 简明扼要的阐述下本次 commit 的主旨，在原文中特意强调了几点 1. 使用祈使句，是不是很熟悉又陌生的一个词，来传送门在此 祈使句 2. 首字母不要大写 3. 结尾无需添加标点
body: 同样使用祈使句，在主体内容中我们需要把本次 commit 详细的描述一下，比如此次变更的动机，如需换行，则使用 |
footer: 描述下与之关联的 issue 或 break change，详见案例


Header部分只有一行，包括三个字段：`type`（必需）、`scope`（可选）和`subject`（必需）。


- feat: 添加新特性
- fix: 修复bug
- docs: 仅仅修改了文档
- style: 仅仅修改了空格、格式缩进、都好等等，不改变代码逻辑
- refactor: 代码重构，没有加新功能或者修复bug
- perf: 增加代码进行性能测试
- test: 增加测试用例
- chore: 改变构建流程、或者增加依赖库、工具等



使用gitmoji：[🔨 [git]: Write better commits with Gitmoji - DEV Community](https://dev.to/javidjms/git-write-better-commits-with-gitmoji-3193)


### 最佳实践

本地代码双分支，一个提交分支，一个开发分支。

假如从远程仓库那边拉取的分支是


git commit --amend修改push到远程分支的提交

[https://blog.csdn.net/ecjtuhq/article/details/80358656](https://blog.csdn.net/ecjtuhq/article/details/80358656)


---

参考：

1. [https://blog.csdn.net/ivan820819/article/details/78816578](https://blog.csdn.net/ivan820819/article/details/78816578)

2. [https://segmentfault.com/a/1190000007748862](https://segmentfault.com/a/1190000007748862)

3. [https://www.jianshu.com/p/964de879904a](https://www.jianshu.com/p/964de879904a)

4. [https://blog.csdn.net/huangjhai/article/details/109557946](https://blog.csdn.net/huangjhai/article/details/109557946)

5. [https://juejin.cn/post/6844903635533594632](https://juejin.cn/post/6844903635533594632)

6. [https://segmentfault.com/a/1190000009048911](https://segmentfault.com/a/1190000009048911)

7. [https://www.cnblogs.com/jiuyi/p/7690615.html](https://www.cnblogs.com/jiuyi/p/7690615.html)

8. [https://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html](https://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html)
