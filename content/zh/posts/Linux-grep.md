---
title: "Linux实用指令"
date: 2020-04-16T10:56:00+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/04/16/kZXbdVrBxmu7sKf.png
libraries:
- katex
- mathjax
tags:
- Linux
- grep
- tar
- gzip
series:
- Linux
categories:
-
---

## |

管道符，“|”，表示将前一个命令的处理结果输出传递给后面的命令处理。

<!--more-->

## grep

Linux系统中grep命令是一种强大的文本搜索工具，它能使用正则表达式搜索文本，并把匹 配的行打印出来。grep全称是Global Regular Expression Print，表示全局正则表达式版本，它的使用权限是所有用户。

### 语法

```
grep [选项] 查找内容 源文件
```

### 选项参数

* `-a`   `--text` 															#不要忽略二进制的数据。   

* `-A`<显示行数>   `--after-context`=<显示行数>   #除了显示符合范本样式的那一列之外，并显示该行之后的内容。   

* `-b `  `--byte-offset  ` #在显示符合样式的那一行之前，标示出该行第一个字符的编号。:star:

* `-B<显示行数>   --before-context=<显示行数>`   #除了显示符合样式的那一行之外，并显示该行之前的内容。   

* `-c`    `--count`   #计算符合样式的列数。:star:

* `-C<显示行数>   --context=<显示行数>或-<显示行数>`   #除了显示符合样式的那一行之外，并显示该行之前后的内容。   

* `-d <动作>      --directories=<动作>` #当指定要查找的是目录而非文件时，必须使用这项参数，否则grep指令将回报信息并停止动作。:star:

* `-e<范本样式>  --regexp=<范本样式>`   #指定字符串做为查找文件内容的样式。   

* `-E --extended-regexp` #将样式为延伸的普通表示法来使用。   

* `-f<规则文件>  --file=<规则文件>`   #指定规则文件，其内容含有一个或多个规则样式，让grep查找符合规则条件的文件内容，格式为每行一个规则样式。   

* `-F   --fixed-regexp`   #将样式视为固定字符串的列表。   

* `-G   --basic-regexp`   #将样式视为普通的表示法来使用。   

* `-h   --no-filename`   #在显示符合样式的那一行之前，不标示该行所属的文件名称。   

* `-H   --with-filename `  #在显示符合样式的那一行之前，表示该行所属的文件名称。   

* `-i    --ignore-case `  #忽略字符大小写的差别。:star:

* `-l    --file-with-matches`   #列出文件内容符合指定的样式的文件名称。   

* `-L   --files-without-match`   #列出文件内容不符合指定的样式的文件名称。   

* `-n   --line-number`   #在显示符合样式的那一行之前，标示出该行的列数编号。   

* `-q   --quiet或--silent`   #不显示任何信息。   

* -`r   --recursive`   #此参数的效果和指定“-d recurse”参数相同。   

* `-s   --no-messages`   #不显示错误信息。   

* `-v   --revert-match`   #显示不包含匹配文本的所有行。   

* `-V   --version`   #显示版本信息。   

* `-w   --word-regexp`   #只显示全字符合的列。   

* `-x    --line-regexp`   #只显示全列符合的列。   

* `-y`   #此参数的效果和指定“-i”参数相同。

> 其中标:star:号的为比较常实用的

### 查找内容规则

查找内容的规则与正则表达式大同小异。

* `^`  #锚定行的开始 如：'^grep'匹配所有以grep开头的行。    

* `$`  #锚定行的结束 如：'grep$'匹配所有以grep结尾的行。    

* `.`  #匹配一个非换行符的字符 如：'gr.p'匹配gr后接一个任意字符，然后是p。    

*  `*`#匹配零个或多个先前字符 如：'*grep'匹配所有一个或多个空格后紧跟grep的行。    

* `.*`   #一起用代表任意字符。   

* `[]`   #匹配一个指定范围内的字符，如'[Gg]rep'匹配Grep和grep。    

* `[^] ` #匹配一个不在指定范围内的字符，如：'[^A-FH-Z]rep'匹配不包含A-R和T-Z的一个字母开头，紧跟rep的行。    

* `\(..\)`  #标记匹配字符，如'\(love\)'，love被标记为1。    

* `\<`      #锚定单词的开始，如:'\<grep'匹配包含以grep开头的单词的行。    

* `\>`      #锚定单词的结束，如'grep\>'匹配包含以grep结尾的单词的行。    

* `x\{m\}`  #重复字符x，m次，如：'0\{5\}'匹配包含5个o的行。    

* `x\{m,\} ` #重复字符x,至少m次，如：'o\{5,\}'匹配至少有5个o的行。    

* `x\{m,n\}`  #重复字符x，至少m次，不多于n次，如：'o\{5,10\}'匹配5--10个o的行。   

* `\w  `  #匹配文字和数字字符，也就是[A-Za-z0-9]，如：'G\w*p'匹配以G后跟零个或多个文字或数字字符，然后是p。   

* `\W `   #\w的反置形式，匹配一个或多个非单词字符，如点号句号等。   

* `\b `  #单词锁定符，如: '\bgrep\b'只匹配grep。  



在`/etc/profile`文件中查找关键字`CLASS_PATH`所在位置

![](https://i.loli.net/2020/04/16/WBY7wGp1q5SoacF.png)

查询`ssh`相关进程

![](https://i.loli.net/2020/04/16/b1W9eqvCc2aIjyt.png)



## 压缩解压类命令

### gzip/gunzip

gzip用于压缩文件，gunzip用于解压

**语法**：

`gzip文件名`（功能描述：压缩文件，只能将文件压缩为*.gz文件）

`gunzip 文件名(.gz结尾)`：(功能描述：解压缩文件命令）

压缩`b.txt`文件

![](https://i.loli.net/2020/04/16/WGPsA68im9Szt2c.png)

解压`b.txt.gz`压缩文件

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200416123804.png)

### zip/unzip

zip用于压缩文件，unzip用于解压的，这个在项目打包发布中很有用的.

**语法**：

`zip [选项] XXX.zip 将要压缩的内容`（功能描述：压缩文件和目录的命令）

`unzip [选项] XXX.zip` (功能描述：解压缩文件）

加密`a.txt`文件

![](https://i.loli.net/2020/04/16/4UuIN7jRdafTZBx.png)

解密`a.zip`文件

![](https://i.loli.net/2020/04/16/f2ZBjlxdVLCUJIe.png)

### tar

tar指令是**打包指令**，最后打包后的文件可以是.tar.gz的文件。

**语法**：

`tar [选项] XXX.tar.gz 打包的内容`（功能描述：打包目录，压缩后的文件格式tar.gz)

**选项参数**：

* `-A` 新增压缩文件到已存在的压缩
* `-B` 设置区块大小
* `-c` 建立新的压缩文件

* `-d` 记录文件的差别

* `-r` 添加文件到已经压缩的文件

* `-u` 添加改变了和现有的文件到已经存在的压缩文件

* `-x` 从压缩的文件中提取文件

* `-t `显示压缩文件的内容

* `-z` 支持gzip解压文件

* `-j` 支持bzip2解压文件

* `-Z` 支持compress解压文件

* `-v` 显示操作过程

* `-l` 文件系统边界设置

* `-k` 保留原有文件不覆盖

* `-m` 保留文件不被覆盖

* `-W` 确认压缩文件的正确性

可选参数如下：

* `-b` 设置区块数目

* `-C `切换到指定目录

* `-f `指定压缩文件
* `--help` 显示帮助信息
* `--version` 显示版本信息





**实例**：

打包`/victor`文件夹下所有内容，打包后的文件名为`victor.tar`

![](https://i.loli.net/2020/04/16/DjPRFVdMvxAOwtI.png)

解压`victor.tar`文件

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200416125457.png)

打包文件夹`/victor`并且压缩成`data.tar.gz`

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200416154131.png)

将多个文件压缩成`a.tar.gz`

![](https://gitee.com/wujiahong1998/MyBed/raw/master/img/20200416154436.png)

将`a.tar.gz`解压到当前目录

![](https://i.loli.net/2020/04/16/2qhBXfuJontCIRG.png)

解压到文件夹`/a`(文件夹必须存在，不然报错)

![](https://i.loli.net/2020/04/16/xALa9JldzXuBjRi.png

---

1. [https://www.cnblogs.com/peida/archive/2012/12/17/2821195.html](https://www.cnblogs.com/peida/archive/2012/12/17/2821195.html)
2. [https://www.cnblogs.com/peida/archive/2012/12/19/2824418.html](https://www.cnblogs.com/peida/archive/2012/12/19/2824418.html)
3. [https://www.cnblogs.com/peida/archive/2012/12/06/2804323.html](https://www.cnblogs.com/peida/archive/2012/12/06/2804323.html)