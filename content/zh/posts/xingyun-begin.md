---
title: "行云开发"
date: 2020-04-01T17:12:29+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: outer
author: Victor
authorEmoji: 👻
image: http://mart.cloudtogo.cn/assets/img/logo.svg
libraries:
- katex
- mathjax
tags:
- 云计算
- 行云趣码
series:
-
categories:
-
---

outer

简单地说，云计算就是计算服务的提供（包括服务器、存储、数据库、网络、软件、分析和智能）- 通过 Internet（云）提供快速创新、弹性资源和规模经济。对于云服务，通常你只需使用多少支付多少，从而帮助降低运营成本，使基础设施更有效地运行，并能根据业务需求的变化调整对服务的使用。

<!--more-->

# 行云趣码记录

行云趣码官网：http://mart.cloudtogo.cn/

## Linux服务器

### 生成自己的服务器

进入应用商店，选择需要的Linux服务器，这里选择`CentOS`

![](https://i.loli.net/2020/03/28/VkdSiEHqtpfPBTw.png)

点击部署，等待生成自己的服务器

![](https://i.loli.net/2020/03/28/VxyBDksONwuv3lc.png)

发布成功

![](https://i.loli.net/2020/03/28/coO6U7qAnGDv2T1.png)



### 参数解释

点击访问，会跳出访问地址，部署区域以及提示信息，一步一步看。

**访问地址**

![](https://i.loli.net/2020/03/28/GfLOa5dbiuc16pS.png)

**部署区域**

部署区域没什么好说的，就是这个服务器部署的区域。

**详情**

![](https://i.loli.net/2020/03/28/8WwzkutUmy1BSEs.png)

---

从上面给的信息，可以归为如下：

1. ssh远程访问的地址为[2c56369b3c95a919.c.cloudtogo.cn](2c56369b3c95a919.c.cloudtogo.cn)，端口为34920(注意：端口不是22)。远程登陆的用户名为：`root`，密码为：`123456`.

2. 有五个映射端口，他们的对应关系如下：

   | Linux内部 |     外部访问     |
   | :-------: | :--------------: |
   |   8001    | 34921(预留a端口) |
   |   8002    | 34916(预留b端口) |
   |   8003    | 34917(预留c端口) |
   |   8004    | 34918(预留d端口) |
   |   8005    | 34924(预留e端口) |

   也就是说，当我们在Linux内部启用8001-8005这五个端口运行相应的应用时，我们可以访问对应的外部预留端口以及子域名进行访问测试。

   例如在Linux内运行了一个web应用在8001端口，我们可以在浏览器访问[61823a63ab19b300.c.cloudtogo.cn:34921](61823a63ab19b300.c.cloudtogo.cn:34921)

ssh远程连接：

![ssh](https://i.loli.net/2020/03/28/wf21xD9TmiGabj8.png)

### 查看配置

查看CPU型号: `Intel(R) Xeon(R) CPU E5-2680 v3`

```bash
cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c
```

![](https://i.loli.net/2020/03/28/KjLTWl3XxZv1cYH.png)

查看物理CPU个数: 2

```bash
cat /proc/cpuinfo | grep "physical id" | sort | uniq|wc -l
```

![](https://i.loli.net/2020/03/28/XaKtuWbfecNrC2j.png)

查看逻辑CPU的个数: 8个

```bash
cat /proc/cpuinfo | grep "processor" |wc -l
```

![](https://i.loli.net/2020/03/28/PcV8EfI9Q5lN1b3.png)

查看CPU是几核: 4核

```bash
cat /proc/cpuinfo | grep "cores"|uniq
```

![](https://i.loli.net/2020/03/28/iOPUxcRqKXbBunz.png)



### 设置远程访问jupyter

安装完jupyter之后，输入以下命令生成配置文件：

```bash
 jupyter notebook --generate-config
```

参考：

https://www.jianshu.com/p/960f011f712e

https://zhuanlan.zhihu.com/p/64524822

结果：

![](https://i.loli.net/2020/03/29/hXF2frExeWgd6Gc.png)

添加虚拟环境：[https://ofooo.github.io/wiki/python/%E5%B7%A5%E5%85%B7/jupyter-notebook/](https://ofooo.github.io/wiki/python/工具/jupyter-notebook/)

更换pip源：https://www.linuxidc.com/Linux/2019-04/158178.htm

部署nodejs：https://blog.csdn.net/xerysherryx/article/details/78920978

npm镜像：https://www.cnblogs.com/alps/p/12439387.html

### CentOS基本命令

查看服务进程

```bash
[victor@mylove ~]$  ps -aux|grep mysql
victor   23477  0.0  0.0 110656  2688 pts/3    S+   12:26   0:00 grep --color=auto mysql

```

查看进程端口

```bash
netstat -anp |grep 1506
```

查看端口进程

```bash
netstat -lnp|grep 3306
```

关闭进程

```bash
kill –9  1506
```



## 生产应用

### 使用docker生产自己的应用

![](https://i.loli.net/2020/03/29/uIt49gE5erXzbVa.png)



### 开发网页App



进入应用工厂,打开一个Blank的模板继续,然后再设计页面拖入一个代码组件,如下:

![](https://i.loli.net/2020/04/01/un14jwmtc9ZM2LX.png)

输入名字为webpy,应为使用的是web.py框架进行编写,然后点击下一步.

![](https://i.loli.net/2020/04/01/HZFViaftMYvdKTc.png)

然后输入存放代码的地址,代码需要编写完成之后存到GitHub上,程序默认的运行入口时main.py,在运行main.py之前,还会执行`pip install -r requirements.txt`这个代码,所以我们可以将所需要的依赖包都写在`requirements.txt`这个文件中.

![](https://i.loli.net/2020/04/01/FPgX1epJfwT75jY.png)

我的代码地址: https://github.com/redisread/webpy.git

编写组件向导,有许多参数

![](https://i.loli.net/2020/04/01/IuNyPFkeGq39AxJ.png)

其他的参数作用:

* 环境变量: 存储系统的相关需要运行的程序的位置
* 多副本: 多副本设置支持可以使用弹性伸缩功能,可开启可不开启
* 会话保持: 维持客户端与一台服务器的连接,即对于某个客户端,,不会更换与他进行连接的服务器
* 执行命令: 可以执行Linux的相关命令
* 存储路径: 可以设置存储到数据卷中,填写的Linux的位置就是数据卷存放的位置
* root权限: 是否开启root权限
* 服务名称: 就是服务的名称
* 读取指定文件: **0
* 日志文件: 填写日志文件存放的的地方
* 映射配置文件: 可以映射(相当于替换)配置文件,例如nginx的`nginx.conf`文件.
* 健康检查: 
* 特权模式:
* 资源限制: 限制CPUy以及内存的设置



最后点击完成就可以发发布应用了

![](https://i.loli.net/2020/04/01/VUZp7h8uoIC6X1t.png)



发布一般不需要配置什么,需要的话可以自行设置.

![](https://i.loli.net/2020/04/01/VEUDBbzIPKSmsjQ.png)



发布成功!

![](https://i.loli.net/2020/04/01/TO5IKFmftyR1LwH.png)

访问该地址就能够访问我们写的应用了.

![](https://i.loli.net/2020/04/01/BdiX8Y7jqhSvpIK.png)



![](https://i.loli.net/2020/04/01/Ebui2dLBwMIaGmk.png)

### 运维管理

在发布页的侧边栏有一个运维按钮,点击进入运维界面

![](https://i.loli.net/2020/04/01/39kNfdGZO8EyKnq.png)

如下就是可以进行查看的相关信息

![](https://i.loli.net/2020/04/01/MgQGzEUxXaAq9mF.png)

![](https://i.loli.net/2020/04/01/YSctKnmlwjT5XQh.png)



