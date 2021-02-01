---
title: "Nginx配置SSL证书"
date: 2021-02-01T10:02:08+08:00
description: 使用Nginx + certbot快速的配置一个可以https访问的网站。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2021/02/01/VXhnNbyzqu37vtd.png
libraries:
- katex
- mathjax
tags:
- nginx
series:
-
categories:
-
---









## 申请证书

### letsencrypt的证书

申请网站：[https://letsencrypt.osfipin.com/](https://letsencrypt.osfipin.com/)

### 腾讯云的证书

申请网站：[https://cloud.tencent.com/product/ssl](https://cloud.tencent.com/product/ssl)

证书申请完成之后，记录证书的位置，在nginx.conf文件进行修改即可，修改方式可以参照下面的步骤。



## 使用certbot自动化

参考地址：https://blog.csdn.net/xs18952904/article/details/79262646

### 检查nginx

查看 nginx 是否安装 http_ssl_module 模块

```
/usr/local/nginx/sbin/nginx -V
```

如果出现 configure arguments: –with-http_ssl_module, 则已安装，不然的话需要重新编译安装，参考下面：

https://segmentfault.com/a/1190000022673232

### 安装certbot

```shell
yum install certbot python2-certbot-nginx
```

配置 SSL 证书证书时,报错`ImportError: cannot import name UnrewindableBodyError`，可以参考：https://www.cnblogs.com/codecheng99/p/12620850.html



### 部署步骤

申请证书

```
certbot certonly --standalone -d jiahongw.com -d www.jiahongw.com
```

证书路径：

```
/etc/letsencrypt/live/jiahongw.com/fullchain.pem
/etc/letsencrypt/live/jiahongw.com/privkey.pem
```

进入修改

```
vim nginx.conf
```

设置HTTP强制跳转HTTPS

```nginx
server {
    listen 80;
    server_name example.com;  #这里修改为网站域名
    rewrite ^(.*)$ https://$host$1 permanent;
}
```

设置HTTPS

```nginx
server {
        listen       443 ssl;
        server_name  jiahongw.com www.jiahongw.com;
        ssl_certificate      /etc/letsencrypt/live/jiahongw.com/fullchain.pem;
        ssl_certificate_key  /etc/letsencrypt/live/jiahongw.com/privkey.pem;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  10m;

        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2;    #安全链接可选的加密协议
        ssl_prefer_server_ciphers  on;

        location / {
            root   html/my_website;  # my
            index  index.html index.htm;
        }
    }
```

测试配置文件的正确性

```
nginx -t
```

重启nginx

```
/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
```

自动续费

```
echo "0 0,12 * * * root python -c 'import random; import time; time.sleep(random.random() * 3600)' && certbot renew" | sudo tee -a /etc/crontab > /dev/null
```

手动续期

```
certbot certonly --standalone -d example.com -d www.example.com
```

配置https代理

```
server {
    listen       443 ssl;
    server_name  hostname.com;

    ssl_certificate   cert/214547145790616.pem;
    ssl_certificate_key  cert/214547145790616.key;

    location / {
        proxy_pass http://localhost:12345;
    }
}
```

配置http2.0

https://segmentfault.com/a/1190000017847301





