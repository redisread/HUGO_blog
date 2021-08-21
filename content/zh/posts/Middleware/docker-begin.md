---
title: "入门Docker"
date: 2020-04-09T17:00:28+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://gitee.com/wujiahong1998/MyBed/raw/master/img/Docker.png
libraries:
- katex
- mathjax
tags:
- docker
series:
-
categories:
-
---



Docker是基于内核的容器,可以运行在宿主机上,看作是一个容器.

<!--more-->

# Docker:whale:

### 安装配置

略,可以百度搜索.如下:

[https://juejin.im/post/5dc241ce6fb9a04aa333c1bd](https://juejin.im/post/5dc241ce6fb9a04aa333c1bd)

### 基本使用

安装完成之后,可以使用以下命令查看版本

```shell
docker version
```

![version](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408210635163.png)

拉取并且运行hello-world镜像进行测试

```
docker run hello-world
```

![run](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408210808009.png)

查看本地镜像:

```
docker image ls
```

![image-ls](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408210722186.png)

本地有一个hello-world镜像

![image-20200408211557057](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408211557057.png)

### Image的获取

#### 1. 从Dockerfile制作

#### 2. 从Register拉取(Pull from Register)

例如:

```shell
docker pull ubuntu:14.04
```

可以在DockerHub里面搜索相关的镜像

添加Docker用户权限，创建docker组

```shell
sudo groupadd docker
```

```shell
sudo gpasswd -a vagrant docker
```

```shell
sudo service docker restart
```

最后重新登陆服务器即可

### 自定义image

构建一个输出信息的C语言编译的可执行文件镜像

首先编写C文件,如下:

```c
#include <stdio.h>
int main(){

  printf("Hello,Docker!\n");
  return 0;
}
```

安装gcc及相关库:

```shell
sudo yum install gcc
sudo yum install glibc-static
```

编译:

```shell
gcc -static hello.c -o hello
```

在当前文件夹下创建`Dockerfile`

```shell
vim Dockerfile
```

编写下面的内容

```plaintext
FROM scratch
ADD hello /
CMD ["/hello"]
```

使用docker构建:

```shell
docker build -t victorhong/hello .
```

其中`victorhong`是用户名,`hello`是镜像名,`.`表示当前文件夹下的内容

构建完可以查看到镜像:

![see](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408214120131.png)



查看构建的历史

![image-20200408214239393](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408214239393.png)

运行容器

```
docker run victorhong/hello
```

![running](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408214351527.png)

### Container

什么是container?

![image-20200408214452782](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408214452782.png)

查看container

```shell
docker container ls
```

查看所有cpntainer,包括结束的

```shell
docker container ls -a
```



运行ubuntu:16.04是马上就会结束的,要想交互式的执行容器,使用以下的mingl

```shell
docker run -it ubuntu:16.04
```

![image-20200408215205478](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408215205478.png)

另外开一个窗口,查看container

```shell
docker container ls
```

![image-20200408215309404](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408215309404.png)

可以看到有一个ubuntu容器正在运行



### 构建自己的Docker镜像



1. docker container commit

   ```shell
   docker commit clever_franklin victorhong/centos-vim
   ```

   在对容器进行修改了之后,`clever_franklin`为容器名,`victorhong/centos-vim`为提交的镜像名

2. Dockerfile build

   ```dockerfile
   FROM centos
   RUN yum install -y vim
   ```

   然后执行

   ```shell
   docker build -t victorhong/centos-vim-new .
   ```

   

### Dockerfile语法

#### FROM

定义base image

![image-20200408222406004](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408222406004.png)

### Label

定义数据信息,类似注释

![image-20200408222511423](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408222511423.png)

> Metadata不可少

#### RUN

![image-20200408222544189](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408222544189.png)

每执行一次run,都会新建一层,尽量少用多次run

#### WORKDIR

设定当前工作目录,类似cd

![image-20200408222702258](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408222702258.png)

> 注意:
>
> ![image-20200408222820225](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408222820225.png)

#### ADD and COPY

ADD还有解压功能

![image-20200408222835474](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408222835474.png)

![image-20200408222953712](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408222953712.png)

#### ENV

设置环境变量或者常量变量

![image-20200408223039377](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408223039377.png)

尽量使用ENV增加可维护性

#### VOLUME ADN EXPOSE

 VOLUME用于挂载数据卷，EXPOSE用于暴露端口

#### CMD and ENTRYPOINT

区别:

![image-20200408223421720](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408223421720.png)

执行命令格式:

![image-20200408223523838](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408223523838.png)

![image-20200408224406683](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408224406683.png)



![image-20200408224422977](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408224422977.png)



GitHub上的官方Dockerfile

### 镜像的发布

使用DockerHub去push

登陆docker

```shell
docker login
```

push

```shell
docker push victorhongdream/hello:latest
```

查看DockerHub

![image-20200408225543016](https://gitee.com/wujiahong1998/MyBed/raw/master/img/image-20200408225543016.png)