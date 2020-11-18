---
title: "CloudFlare+Nginx配置HTTPS连接"
date: 2020-11-18T11:58:01+08:00
description: 使用Nginx配合CloudFlare设置服务器使用Https证书。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image:
libraries:
- katex
- mathjax
tags:
- Nginx
- https
series:
-
categories:
-
---





参考地址：

1. [cloudflare.com](cloudflare.com)
2. [使用Cloudflare和Nginx来托管网站](https://www.howtoing.com/how-to-host-a-website-using-cloudflare-and-nginx-on-ubuntu-16-04)
3. [管理 Cloudflare Origin CA 证书](https://support.cloudflare.com/hc/zh-cn/articles/115000479507-%E7%AE%A1%E7%90%86-Cloudflare-Origin-CA-%E8%AF%81%E4%B9%A6#h_30e5cf09-6e98-48e1-a9f1-427486829feb)
4. [已安装nginx支持https配置](https://blog.seosiwei.com/detail/28) 
5. [nginx启动、重启、关闭](https://www.cnblogs.com/zyw-205520/p/5064568.html)
6. [nginx配置ssl实现https访问](https://juejin.im/post/6844903729632641031)



点击SSL/TLS，并且点击源服务器

![step-1](https://i.loli.net/2020/11/14/Tv9LkRB7Yh8JrxI.png)

进入下面的页面，点击下面的创建证书，接下来按照下面链接的指导进行操作：

[使用Cloudflare和Nginx来托管网站](https://www.howtoing.com/how-to-host-a-website-using-cloudflare-and-nginx-on-ubuntu-16-04)

![step-2](https://i.loli.net/2020/11/14/CaQ95uL1UJIAn4p.png)

同时在Nginx服务器的配置文件nginx.conf中设置相关的配置

[nginx配置ssl实现https访问](https://juejin.im/post/6844903729632641031)

假如Nginx提示`the "ssl" parameter requires ngx_http_ssl_module`,表示Nginx没有安装SSL模块，按照下面的链接指导进行操作

[已安装nginx支持https配置](https://blog.seosiwei.com/detail/28) 



接下来在CloudFlare中设置完全严格

![设置证书](https://i.loli.net/2020/11/14/QaDIqk9Nu1cphKm.png)



最后就可以看到小锁头啦

![结果](https://i.loli.net/2020/11/14/IaFNt5AQJhGDlOx.png)



![TLS](https://i.loli.net/2020/11/14/DCE8PlWAexgaFH2.png)



