---
title: "Http报文格式及Http方法"
date: 2020-11-18T11:52:50+08:00
description: Http是定义在TCP上的一种传输协议，要传输消息就必须遵守规定，本文是使用Http的发送消息与接受消息的报文规定及方法。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/11/18/4CDbIrGoRW3qBF7.png
libraries:
- katex
- mathjax
tags:
- http
series:
- network
categories:
-
---

### :fallen_leaf: HTTP报文

#### 请求报文

HTTP 请求报文由3部分组成(请求行+请求头+请求体)

![HTTP请求报文](https://i.loli.net/2020/11/11/pGh3toQX8WC6Nq5.png)

**请求行**包括：请求方法、请求URL、HTTP协议及版本：

GET和POST是最常见的HTTP方法,初次以外还包括 DELETE、HEAD、OPTIONS、PUT、TRACE，不过现在大部分的浏览器只支持GET和POST

请求对应的URL地址,他和报文头的Host属性,组合起来是一个完整的请求URL



**报文头**是一些参数信息：

有若干个属性,形式为key:val,服务端据此获取客户端信息

**报文体**是具体传输的内容。



#### 响应报文

响应报文与请求报文一样,由三个部分组成(响应行,响应头,响应体)

![HTTP响应报文](https://i.loli.net/2020/11/11/vtYpgrFsSqO6UTA.png)



参考：[HTTP请求头和响应头详解](https://www.jianshu.com/p/9a68281a3c84)

### :station: HTTP状态码：

![HTTP状态码](https://i.loli.net/2020/10/19/3Ow5z4nsGbPrMoD.png)

- 1xx：表示通知信息，如请求收到了或正在进行处理
  - 100 Continue：继续，客户端应继续其请求
  - 101 Switching Protocols 切换协议。服务器根据客户端的请求切换协议。只能切换到更高级的协议，例如，切换到 HTTP 的新版本协议
- 2xx：表示成功，如接收或知道了
  - 200 OK: 请求成功
- 3xx：表示重定向，如要完成请求还必须采取进一步的行动
  - 301 Moved Permanently: 永久移动。请求的资源已被永久的移动到新 URL，返回信息会包括新的 URL，浏览器会自动定向到新 URL。今后任何新的请求都应使用新的 URL 代替
- 4xx：表示客户的差错，如请求中有错误的语法或不能完成
  - 400 Bad Request: 客户端请求的语法错误，服务器无法理解
  - 401 Unauthorized: 请求要求用户的身份认证
  - 403 Forbidden: 服务器理解请求客户端的请求，但是拒绝执行此请求（权限不够）
  - 404 Not Found: 服务器无法根据客户端的请求找到资源（网页）。通过此代码，网站设计人员可设置 “您所请求的资源无法找到” 的个性页面
  - 408 Request Timeout: 服务器等待客户端发送的请求时间过长，超时
- 5xx：表示服务器的差错，如服务器失效无法完成请求
  - 500 Internal Server Error: 服务器内部错误，无法完成请求
  - 503 Service Unavailable: 由于超载或系统维护，服务器暂时的无法处理客户端的请求。延时的长度可包含在服务器的 Retry-After 头信息中
  - 504 Gateway Timeout: 充当网关或代理的服务器，未及时从远端服务器获取请求

### :hand: HTTP的主要方法

<img src="https://i.loli.net/2020/11/07/3rBJ2u5WDK7kRZF.png" alt="HTTP方法" style="zoom: 67%;" />

* 下面这个例子是查询HTTP服务器端支持的HTTP方法种类。

  ![OPTIONS操作](https://i.loli.net/2020/11/11/5VeAOKHfTIRpuvL.png)

![](https://i.loli.net/2020/11/18/tqCpRlavKHYjUcd.png)

---

参考：[HTTP请求头和响应头详解](https://www.jianshu.com/p/9a68281a3c84)