---
title: "Good库"
date: 2020-03-04T16:16:05+08:00
description: Github上好玩的那些库~
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/03/04/UD37S59viJ6ybwu.png
libraries:
- 
tags:
-
series:
-
categories:
-
---



All about Intresting in Github.

<!--more-->

# Python好玩的库

## html2text

> 将网页转化为Markdown文件格式

#### 使用前提：

```python
pip install htmltotext
```

#### 使用方法：

```python
## 转化为TEXT
h = HTML2Text()
text = h.handle(parse_html) # text为markdown文件
```

## pypandoc

> 对文件进行任意的转换

#### 使用前提：

安装pypandoc库：`pip install pypandoc`.

#### 使用方法

导入库:`import pypandoc`

##### Markdown -----> docx

```python
output = pypandoc.convert_file('somefile.md', 'docx', outputfile="somefile.docx")
```

##### Markdown -----> Rst

```python
output = pypandoc.convert_file('somefile.md', 'rst')	# way1
output = pypandoc.convert_file('somefile.txt', 'rst', format='md')	# way 2
output = pypandoc.convert_text('#some title', 'rst', format='md')	# 直接转化文本
```



> 其中有对应的工具Pandoc



### 如何把 Markdown 文件批量转换为 PDF

#### mdout转换脚本

项目地址:https://github.com/JabinGP/mdout

#### 使用方法：

> 打开项目地址查看，其中主要命令为:mdout filename -t pdf