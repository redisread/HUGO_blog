---
title: "Linux用户管理"
date: 2020-04-15T16:34:03+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/04/15/Uxgb7hFP2YDVMuQ.png
libraries:
- katex
- mathjax
tags:
- Linux
- 用户管理
series:
- Linux
categories:
-
---









每一个用户都是一个个体，每一个个体都属于一个群组，而每一个群组又有区别!

——Users

<!--more-->

> Linux系统是一个多用户多任务的操作系统，任何一个要使用系统资源的用户，都必须首先向系统管理员申请一个账号，然后以这个账号的身份进入系统。



## 添加用户

### 基本语法

```
useradd [选项] 用户名
```

### 实操

输入以下命令之后创建一个用户victor

![创建用户](https://i.loli.net/2020/04/15/tJLFclqwxGHb5rm.png)

这里我们选项参数什么也没有写，此时会默认在`/home`目录下创建一个`/victor`的文件夹用于保存用户victor用户的数据信息。

![](https://i.loli.net/2020/04/15/3wTmBWdzl6y1Vnv.png)

当然我们可以指定参数：

用参数 `-d 目录`指定用户信息存储的目录，使用命令`useradd -d /home/test tom`创建用户tom。

![](https://i.loli.net/2020/04/15/zCa2dONRnbeGPYk.png)

使用`-g 用户组`指定将当前创建的用户添加到指定的用户组，使用命令`useradd -g root wjh`将新建用户`wjh`添加到root用户组。

![](https://i.loli.net/2020/04/15/NOZvBLeQiyT8skC.png)

## 给用户设置密码

### 基本语法

```
passwd 用户名
```

### 实操

给用户victor设置密码(默认密码是不会显示出来的)

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415165840.png)

下面可以使用victor这个用户登陆

![](https://i.loli.net/2020/04/15/ZilrfSbX3Yyjgco.png)

默认是不能访问root用户的文件的，因为不在同一个组

![](https://i.loli.net/2020/04/15/AqL6VMnfsSgjo4D.png)

## 切换用户

### 基本语法

```
su - 切换用户名
```

### 实操

切换到root。其中低权限用户切换到高权限用户需要输入密码。

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415170504.png)

退出切换使用`exit`![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415170554.png)

## 删除用户

### 基本语法

```
userdel [选项] 用户名
```

其中选项参数可以添加`-r`，表示删除用户时同时删除保存用户的文件夹。

### 实操

删除用户tom

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415171056.png)

可以看到之前tom致电给创建的文件夹`test`并没有删除。

> 注意，删除用户必须要root权限，不然删除不了。
>
> ![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415170855.png)

删除用户victor，同时删除其文件夹，victor文件夹消失了

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415171226.png)



## 其他操作

### 查询用户信息

语法

```
id 用户名
```

如下查询用户root的信息

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415171453.png)

*root用户的用户id为0，组id为0，组为0*

### 查询当前用户

语法

```
whoami
```

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415171729.png)



## 用户组

> 类似于角色，系统可以对有共性的多个用户进行统一的管理。

用户组关系图：

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415172934.png)

### 增加组

语法

```
groupadd 组名
```

增加用户组`test`

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415172239.png)

### 删除组

语法

```
groupdel 组名
```

删除用户组`test`

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415172320.png)

### 修改用户的组

语法

```
usermod -g 用户组 用户名
```



## 相关配置文件

* 用户信息文件：`/etc/passwd`
* 密码文件： `/etc/shadow`
* 用户组文件：`/etc/group`
* 用户组密码文件： `/etc/gshadow`
* 用户配置文件：
     `/etc/login.defs`
     `/etc/default/useradd`
* 新用户信息文件：`/etc/skel`
* 登录信息：`/etc/motd`



### /etc/passwd

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415175058.png)

每一行内容存放一个用户的信息，每个用户信息有7部分组成
root​：x:0:0:root:/root:/bin/bash
root        用户名     　　  用户登录系统时使用的用户名
x             密码         　　 密码位
2             UID        　　  用户标识号
2             GID     　　     缺省组标识
root     注释性描述  　　  例如存放用户全名等信息
/root         宿主目录       用户登录系统后的缺省目录
/bin/bash   命令解释器    用户使用的Shell ,默认为bash



> UID分类
>
> **超级用户**：（root  UID=0）
>
> **普通用户**： （UID 500~60000）
>
> **伪用户**：  （UID  1~499）
>
> 
>
> 什么是**伪用户**?
>
> 1. 伪用户与系统和程序服务相关
>
>   bin、daemon、shutdown、halt等，任何Linux系统默认都有这些伪用户。
>
>   mail、news、games、apache、ftp、mysql及sshd等，与linux系统的进程相关。
>
> 2. 伪用户通常不需要或无法登录系统
>
> 3. 可以没有宿主目录

### /etc/shadow

每行的含义： 登录名: 加密口令: 最后一次修改时间: 最小时间间隔: 最大时间间隔:警告时间: 不活动时间: 失效时间:标志

![/etc/shadow](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415175551.png)



### /etc/group

每行含义： 组名: 口令: 组标识号: 组内用户列表

![/etc/group](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200415175715.png)

---

1. [https://www.cnblogs.com/qmfsun/p/3674024.html](https://www.cnblogs.com/qmfsun/p/3674024.html) [linux用户管理命令](https://www.cnblogs.com/qmfsun/p/3674024.html)