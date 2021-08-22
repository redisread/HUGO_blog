---
title: "Shortcodes使用"
date: 2020-01-25T06:40:51+09:00
description: tabs, code-tabs, expand, alert, warning, notice, img, box
draft: false
hideToc: false
enableToc: true
enableTocContent: true
#tocPosition: inner
tags:
- shortcode
series:
-
categories:
-
image: images/feature3/code-file.png
---





## 盒子

### 支持Markdown语法的盒子

语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822151028711.png" alt="boxmd" style="zoom: 67%;" />

或者：

```html
<div class="box">This is <strong>boxmd</strong> shortcode</div>
```

渲染显示：

{{< boxmd >}}
This is **boxmd** shortcode
{{< /boxmd >}}

### 简单盒子

语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822151055228.png" alt="box" style="zoom: 67%;" />

渲染显示：

{{< box >}}
This is **box** shortcode
{{< /box >}}



## 代码选项卡

可以在不同的代码块之间切换，语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822151330018.png" alt="code-tab" style="zoom:50%;" />

渲染显示：

{{< codes java javascript >}}
  {{< code >}}

  ```java
  System.out.println('Hello World!');
  ```

  {{< /code >}}

  {{< code >}}

  ```javascript
  console.log('Hello World!');
  ```

  {{< /code >}}
{{< /codes >}}

## 常规选项卡

这个和代码选项卡类似，不同的是，这种选项卡更加“常规”。语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822151412190.png" alt="tab" style="zoom:50%;" />

渲染显示：

{{< tabs Windows MacOS Ubuntu >}}
  {{< tab >}}

  ### Windows section

  ```javascript
  console.log('Hello World!');
  ```

  ⚠️Becareful that the content in the tab should be different from each other. The tab makes unique id hashes depending on the tab contents. So, If you just copy-paste the tabs with multiple times, since it has the same contents, the tab will not work.

  {{< /tab >}}
  {{< tab >}}

  ### MacOS section

  Hello world!
  {{< /tab >}}
  {{< tab >}}

  ### Ubuntu section

  Great!
  {{< /tab >}}
{{< /tabs >}}

## 展开栏

语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822151433085.png" alt="expand" style="zoom:50%;" />

渲染显示：

{{< expand "Expand me" >}}

### Title

contents

{{< /expand >}}

{{< expand "Expand me2" >}}

### Title2

contents2

{{< /expand >}}

## 彩色文本框

语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822151517314.png" alt="color-box" style="zoom:50%;" />

渲染显示：

{{< alert theme="warning" >}}
**this** is a text
{{< /alert >}}

{{< alert theme="info" >}}
**this** is a text
{{< /alert >}}

{{< alert theme="success" >}}
**this** is a text
{{< /alert >}}

{{< alert theme="danger" >}}
**this** is a text
{{< /alert >}}

## 彩色注意框

语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822151605088.png" alt="notice-box" style="zoom:50%;" />

渲染显示：

{{< notice success >}}
success text
{{< /notice >}}

{{< notice info >}}
info text
{{< /notice >}}

{{< notice warning >}}
warning text
{{< /notice >}}

{{< notice error >}}
error text
{{< /notice >}}



## 图片描述

使用语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822152923916.png" alt="image" style="zoom: 50%;" />

渲染显示：

{{< img src="https://i.loli.net/2021/06/23/bfAkG5v4X8qQpRD.jpg" title="Sample Image" caption="Image with title, caption, alt, ..." alt="image alt" width="700px" position="center" >}}



## 按钮

语法：

<img src="https://raw.githubusercontent.com/redisread/Image/master/Blog/image-20210822151228564.png" alt="button" style="zoom:50%;" />

简单按钮：

{{< button href="https://hugo.jiahongw.com/zh/posts/hugo/shortcodes/" >}}button{{< /button >}}

设置宽度高度：

{{< button href="https://hugo.jiahongw.com/zh/posts/hugo/shortcodes/" width="100px" height="36px" >}}button{{< /button >}}

设置颜色：

{{< button href="https://hugo.jiahongw.com/zh/posts/hugo/shortcodes/" width="100px" height="36px" color="primary" >}}button{{< /button >}}

