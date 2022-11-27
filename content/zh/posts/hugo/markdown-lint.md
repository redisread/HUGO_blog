---
title: 使用Markdown规范检查工具
date: 2022-11-27T14:51:51+08:00
description: 通常我们使用编辑器，写出来的Markdown不太符合标准的Markdown格式，例如多个无用的换行和空格，以及图片未添加描述等。通过工具可以让我们写出更标准的Markdown文章。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 🪶
image: https://cos.jiahongw.com/uPic/(null).jpg
plantuml: true
libraries:
- katex
- mathjax
tags:
- Markdown
series:
-
categories:
-
---



目前有中文和英文的 Markdown 规范检查工具，目前中文支持的比较少，英文的支持比较多，但是对英文比较友好，对中文支持也较少。

下面介绍这几个工具

## lint-md

> github 仓库：<https://github.com/lint-md/lint-md>

安装

```bash
npm install -g @lint-md/cli@beta
```

使用

```bash
# 校验当前目录下的 test.md 文件
lint-md test.md

# 校验当前目录下的 test.md 文件，并修复之
lint-md test.md --fix

# 校验 examples 目录下所有的 Markdown 文件，并修复之
lint-md examples/**/* --fix

# 校验 examples 目录下所有的 Markdown 文件，指定 config.json 为配置文件（配置文件语法见下文）
lint-md examples/**/* --config=config.json

# 校验 examples 目录下所有的 Markdown 文件，仅存在 warning 时程序正常退出（warning 不会阻断 CI）
lint-md examples/**/* --suppress-warnings

# 校验 examples 目录下所有的 Markdown 文件，并开启多线程模式（线程数 === CPU 核心数）
lint-md examples/**/* --threads

# 校验 examples 目录下所有的 Markdown 文件，并开启多线程模式（线程数 === 8）
lint-md examples/**/* --threads=8
```

## markdownlint-cli2

> github 仓库：<https://github.com/DavidAnson/markdownlint-cli2>

安装

```bash
npm install markdownlint-cli2 --global
```

使用

```bash
# 检查单个文件
markdownlint-cli2 hugo_setup.md

# 检查多个文件,hugo文件夹下所有markdown文件
markdownlint-cli2 'hugo/*.md'

# 修复
markdownlint-cli2-fix hugo_setup.md
markdownlint-cli2-fix 'hugo/*.md'
```

---

***Reference***:

- [Markdown 书写风格指南](http://einverne.github.io/markdown-style-guide/zh.html)
