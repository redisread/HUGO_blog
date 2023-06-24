---
title: 使用Obsidian编写Hugo博客
subtitle: 一个还行的笔记工具🔧
date: 2023-06-24 15:07:41
publishDate: 2023-06-24 15:07:41
aliases: []
description: 之前使用的是Typora，感觉没有特别好，虽然简洁，但是模版或者提交等操作繁杂，最终还是选择功能强大的Obsidian，虽然功能多，但我只需要我要的就够了。
image: https://cos.jiahongw.com/uPic/PqMz2x.jpg
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner # outer
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h2", "h3", "h4"]
libraries: [katex, mathjax, mermaid, chart, flowchartjs, msc, viz, wavedrom]
tags: [Obsidian, 笔记, 效率]
series: []
categories: []
---

使用 Obsidian 编写 Hugo 博客的原因之一是，Obsidian 有插件能够支持配置模板，这样我新建文章的时候，只需要一个指令就能够帮我构建好一个文章的基本框架内容了。而这个支持快速配置模板进行创建文章的插件，就是 `QuickAdd` 插件。

## QuickAdd 插件配置

首先在插件市场里面找到 quickAdd 这个插件，下载之后进入插件的设置页面，点击新建 template 的 choice，然后在选择对应的模板文件地址，并且配置新建文件所在的文件夹，我这里配置的新建文件所在的文件夹设置的是项目目录下的`content/zh/posts`下。
![QuickAdd配置](https://cos.jiahongw.com/uPic/E3rx1R.jpg)

对应的模版文件是：

```
---
title: {{NAME}}
subtitle:
date: {{DATE:YYYY-MM-DD HH:mm:ss}}
publishDate: {{DATE:YYYY-MM-DD HH:mm:ss}}
aliases: []
description:
image:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner # outer
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h2", "h3", "h4"]
libraries: [katex, mathjax, mermaid, chart, flowchartjs, msc, viz, wavedrom]
tags: []
series: []
categories: []
---



---

***Reference***:

```

其中，文章的名称是我在输入新建指令的时候输入的。

使用插件直接在 Obsidian 中输入`Commond + P` ，输入`QuickAdd`
![LSpNQl](https://cos.jiahongw.com/uPic/LSpNQl.png)

然后选择新建博客，输入文件名就会在指定文件夹下面出现对应的文件

![BSImD0](https://cos.jiahongw.com/uPic/BSImD0.png)

## 其他插件

其他插件例如图片上传的插件[Obsidian Image Auto Upload Plugin](https://github.com/renmu123/obsidian-image-auto-upload-plugin/blob/master/readme-zh.md)以及自动 git 提交的插件[Obsidian Git](https://github.com/denolehov/obsidian-git)，目前来看都不是必须的，暂且不安装使用。

[Obsidian Pangu](https://github.com/Natumsol/obsidian-pangu) 这个插件还可以，可以在英文与中文之间自动添加空格，使用方法为`Commond + Shift + S`

---

**_Reference_**:

- [Hugo 博客写作最佳实践 | 胡说](https://blog.zhangyingwei.com/posts/2022m4d11h19m42s28/)
- [Hugo With Obsidian :: 木木木木木](https://immmmm.com/hugo-with-obsidian/)
