---
title: "使用云监控管理k8s-京东云实践"
date: 2020-04-27T17:11:37+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: inner
author: Victor
authorEmoji: 👻
image:  https://gitee.com/wujiahong1998/MyBed/raw/master/kunpeng/京东云.png
libraries:
- katex
- mathjax
tags:
-  云计算
-  京东云
series:
-
categories:
-
---





## 操作流程

![流程](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426111623.png)

## 用到的云产品及服务

|          |                |                                                      |                                                              |
| -------- | -------------- | ---------------------------------------------------- | ------------------------------------------------------------ |
| **序号** | **云产品**     | **功能及用途**                                       | **备注**                                                     |
| 1        | 容器镜像仓库   | 用于存放示例demo镜像                                 |                                                              |
| 2        | 云编译         | 编译和打包实例demo代码，同时将镜像推送至容器镜像仓库 |                                                              |
| 3        | 私有网络       | 创建用于Kubernetes集群，工作节点所需的VPC            |                                                              |
| 4        | Access Key     | 授权K8S集群访问京东智联云各个服务API的授权凭证。     | 例如：集群向京东智联云监控中心，推送业务监控数据就需要用到AK/SK。 |
| 5        | Kubernetes集群 | 创建K8S集群，部署应用服务                            | 规格：通用型1核4GB，公网IP 5Mpbs                             |
| 6        | 云监控         | 查询业务监控数据，配置告警服务。                     |                                                              |

## 实操

### 第一步：准备Docker镜像

#### 创建容器镜像仓库

**新建注册表**

1. 登录京东智联云控制台，选择云服务->弹性计算->容器镜像仓库。

   ![选择容器镜像仓库服务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426111815.png)

2. 进入注册表页面，选择“华北-北京”地域，点击“新建”按钮，进入新建注册表页面。

   ![新建注册表](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426111942.png)

3. 在新建注册表页面，设置名称，勾选同意服务条款。点击“保存”按钮即可。

   ![输入创建信息](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426112306.png)

**新建镜像仓库**

1. 切换至“镜像仓库”列表页面，选择地域“华北-北京”，点击“创建”按钮。

   ![进入镜像仓库](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426112445.png)

2. 在新建镜像仓库页面， 选择刚新建的注册表，配置注册表名称信息

   ![配置镜像仓库注册表](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426112720.png)

3. 创建成功后，在镜像仓库里列表可以看到到仓库名称。以及镜像仓库的URI

   ![查看镜像仓库](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426112924.png)

#### 编译构建Docker镜像

**新建编译任务**

1. 选择云服务->开发者工具->云编译，进入云编译服务页面。

   ![进入云编译服务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426113052.png)

2. 在任务列表页面，选择华北-北京地域， 点击“创建”按钮，选择中“创建任务”

   ![创建任务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426113145.png)

3. 在创建任务页面做如下配置：

   任务配置与源码配置如下，其中代码库地址为:[https://code.jdcloud.com/jdcloud-monitor/prometheus-demo.git](https://code.jdcloud.com/jdcloud-monitor/prometheus-demo.git)

   ![任务配置与源码配置](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426113509.png)

   构建存放的配置如下：

   ![构建存放配置](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426113710.png)

   其他选项保持默认配置

4. 点击“保存”按钮，完成任务的创建。

**构建任务**

1. 选中刚创建的任务，点击操作了下的执行构建按钮。

   ![进入执行构建](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426114034.png)

2. 在弹出的构建页面，配置如下信息,其中CommitID为ece523fc68cce1cd3d48b38fc07252f81ba2c44c

   ![](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426114138.png)

3. 点击“确定”按钮，执行编译构建操作。当产物归档状态变为完成状态时，完成构建。

   ![完成构建](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426114242.png)

### 第二步：用K8S部署应用服务

#### **前提准备**

创建kubernetes进群时，需要用到**VPC** 和 **密钥信息**， 只需创建VPC即可，无需创建子网，工作节点组用到的子网会自己创建。

**创建VPC**

1. 选择云服务->网络->私有网络，进入私有网络VPC列表页面。

   ![进入私有网络服务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426114433.png)

2. 在私有网络页面，选中华北-北京地域，点击“创建”按钮。

   ![进入创建](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426114540.png)

3. 配置网络名称，IPv4CIRD选择 192.168.0.0/16。

   ![新建vpc](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426114730.png)

**创建AK/SK密钥**

1. 点击顶部导航的账户名称，在弹出的下拉框中点击“Access Key管理”

   ![进入Access Key管理](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/image-20200426115229840.png)

2. 在进入的Access Key管理页面中，点击“创建Access Key”，会提示输入短信验证码，输入完就可以创建了

   ![创建](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/image-20200426115504785.png)

   

#### 创建Kubernetes集群

1. 选择云服务->弹性计算-> Kubernetes集群，进入集群列表页面。

   ![进入Kubernetes集群服务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426115609.png)

2. 选择“华北-北京”地域，点击“创建”按钮，在新建Kubernetes集群，进行如下配置

   集群信息配置

   ![](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426121325.png)

   网络与工作节点配置

   ![](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426121448.png)

   密码配置

   ![](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426121506.png)

#### 部署服务

**注册镜像仓库**

> 本操作是将容器镜像仓库的注册表在K8S服务中进行注册，便于后续pod上部署应用服务。

1. 选择云服务->弹性计算-> 云主机，进入云主机列表页面。在云主机列表可以看到新创建了2台云主机实例。

   ![查看云主机](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426122044.png)

2. 找到k8s-***-nat-vm-***命名的云主机，其为K8S集群的管理节点云主机， 可以公网SSH远程登录进去。

   ![ssh远程登陆](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426122844.png)

3. 获取集群凭据， 选择云服务->弹性计算-> Kubernetes集群, 进入集群列表页面。选中刚创建的集群信息，点击名称，进入详情页面。切换至kubectl客户端配置页。

   ![找到kubectl配置](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426122955.png)

4. 管理节点登录成功后，ssh 登录至 k8s-node-*** 节点的云主机（**命令： ssh root@your_node_ip, 需要将 your_node_ip 替换为你的node云主机的内网ip。点击回车后输入密码即可** ）。

   ![登陆节点](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426130822.png)

5. 配置kubectl客户端

   执行如下的命令

   ```bash
   mkdir -p $HOME/.kube  
   
   cd $HOME/.kube        
   
   vi config 
   ```

   将kubectl客户端配置的凭据，拷贝至config中，保存后退出。执行 sudo chown $(id -u):$(id -g) $HOME/.kube/config 命令。

   ![配置](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426123202.png)

6. 执行以下操作命名，注册镜像仓库。

   ```
   kubectl create secret -n default docker-registry my-secret --docker-server=k8s-monitor-demo01-cn-north-1.jcr.service.jdcloud.com --docker-username=jdcloud --docker-password=Eoj3Ja4mSeXasAbX --docker-email=1427298682@qq.com
   ```

   ![相关信息获取](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426131039.png)

   ![相关信息](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426131158.png)

   输入指令如下：

   ![输入指令](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426131327.png)

**创建Pod**

1. 在kubernetes集群页面，菜单切换至Workloads->Pod，进入Pod列表页面。点击创建pod

   ![创建pod](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426131504.png)

2. 配置如下信息

   a.   集群：请确认刚创建的集群，例如：monitor-demo

   b.  Yaml 文件：将如下内容拷贝至黑色输入框，注意黄色标注内容。

   ```yml
   apiVersion: v1
   
   kind: Pod
   
   metadata:
   
     name: prometheus-demo
   
     labels:
   
       app: prometheus-demo
   
   spec:
   
     imagePullSecrets:
   
       - name: my-secret
   
     containers:
   
       - name: flaskapp-demo
   
         image: k8s-monitor-demo01-cn-north-1.jcr.service.jdcloud.com/k8s-monitor-demo-repo:job-ANbzZdjyyYKEBRX-1587872493
   
         ports:
   
           - containerPort: 5000
   
           - containerPort: 7777
   ```

   > 注意：
   >
   > 1. name：为您注册镜像仓库创建的secret名称，示例用的my-secret。
   >
   > 2. image 标注为黄色的内容包含2个部分，URI:镜像版本，请一定要替换为自己镜像仓库的内容。可通过如下截图位置获取。
   >
   >    ![](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426131730.png)
   >
   >    ![](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426132029.png)

3. 创建Pod![点击创建](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426132152.png)

4. 可以看到创建的pod，进入pod详情，切换至Container可以查看其运行状态，等待3分钟左右，其状态变为运行，服务部署成功。

   ![容器运行](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426132340.png)

#### 配置访问策略

**创建Service**

>
> 注：基于K8S部署的应用服务，若需要外网访问，则需要创建一个负载均衡，同时绑定公网IP，以下步骤就是通过创建Service为服务配置一个负载均衡。

1. 切换至service列表页面，选择“华北-北京”，点击“创建”按钮。

   ![进入service服务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426132502.png)

2. 进入创建Service页面

   配置如下信息

   a.     集群：确认选中的集群。

   b.    Yaml：将如下信息拷贝至输入框中。

   ```yml
   kind: Service
   
   apiVersion: v1
   
   metadata:
   
     name: prometheus-demo
   
     annotations:
   
       prometheus.io/path: /metrics
   
       prometheus.io/port: '7777'
   
       prometheus.io/scrape: 'true'
   
   spec:
   
     ports:
   
       - protocol: TCP
   
         port: 5000
   
         targetPort: 5000
   
     selector:
   
       app: prometheus-demo
   
     type: LoadBalancer
   ```

3. 点击“确定”按钮，完成service创建。点击名称，进入详情页面，可查看到pod状态为running。

   ![查询Pod状态](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426132751.png)

4. 点击顶部导航云服务->网络->负载均衡，进入应用负载均衡页面。可以看到刚新建的的LoadBalancer。

   ![进入负载均衡服务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426132919.png)

   ![查询新建的负载均衡服务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426133006.png)

**访问服务**

1. 在新建的负载均衡服务页面，获取到公网IP， 在浏览器端输入http://公网IP:5000，可看到如下界面。

   ![访问](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426133131.png)

### 第三步：业务监控告警



#### 查看监控图

1. 选择云服务->监控与运维-> 云监控，进入云监控控制台。

   ![进入云监控服务](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426135442.png)

2.  在左侧菜单选中“自定义监控”，进入自定义监控页面。

   ![进入自定义监控](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426135534.png)

3. 输入以下查询条件，可以看到Demo示例内置采集的一些业务数据。查询条件如下：

   ![监控](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426140111.png)



#### 配置告警

1. 在上述查看的的监控图中，点击“配置报警”按钮，进入设置告警页面，进行如下配置：

   **基本信息配置**

   ![基本信息](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/image-20200426221118662.png)

   **触发条件配置**

   ![触发条件](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426221159.png)

   **通知策略配置**

   ![通知策略](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426221236.png)

上面配置完之后当访问页面次数超过10此的时候就会有邮件和短信的通知

**邮件**

![邮件](https://gitee.com/wujiahong1998/MyBed/raw/master/jd/20200426221440.png)

**短信**



<img src="https://gitee.com/wujiahong1998/MyBed/raw/master/jd/cad5d91da9cd657521f816e0d95f118.jpg" style="zoom: 33%;" />