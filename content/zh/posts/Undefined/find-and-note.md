---
title: "这段时间的一些记录"
date: 2020-12-20T18:05:01+08:00
description: 零零散散，最近都不怎么记录了。又开始回到之前的懒惰状态了。这里记录了近期一些零散的学习以及过程。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/12/20/czwN2uVIMlEDodv.png
libraries:
- katex
- mathjax
tags:
- life
series:
-
categories:
-
---



# Find and Note

### 代码规范

#### pylint

https://www.jianshu.com/p/c0bd637f706d

https://pylint.readthedocs.io/en/latest/tutorial.html

#### flake8

https://www.jianshu.com/p/adf743fc8e78

### 日志的等级

![日志等级](https://i.loli.net/2020/12/20/sGgpx9UF4l6bLMm.png)

日志级别 | 描述 ---|--- OFF | 关闭：最高级别，不打印日志。 FATAL | 致命：指明非常严重的可能会导致应用终止执行错误事件。 ERROR | 错误：指明错误事件，但应用可能还能继续运行。 WARN | 警告：指明可能潜在的危险状况。 INFO | 信息：指明描述信息，从粗粒度上描述了应用运行过程。 DEBUG | 调试：指明细致的事件信息，对调试应用最有用。 TRACE | 跟踪：指明程序运行轨迹，比DEBUG级别的粒度更细。 ALL | 所有：所有日志级别，包括定制级别。

所以，日志优先级别标准顺序为：

> ALL < TRACE < DEBUG < INFO < WARN < ERROR < FATAL < OFF



---

### 云计算相关社区

https://www.linux-kvm.org/page/Main_Page

https://www.qemu.org/

https://wiki.qemu.org/Features/

---



### vi vim 查找和替换字符串 命令

[https://blog.csdn.net/doubleface999/article/details/55798741](https://blog.csdn.net/doubleface999/article/details/55798741)

[如何替换文件中的字符串？](https://qastack.cn/unix/112023/how-can-i-replace-a-string-in-a-files)

**sed**是一种流编辑器，它是文本处理中非常中的工具，能够完美的配合正则表达式使用，功能不同凡响。处理时，把当前处理的行存储在临时缓冲区中，称为“模式空间”（pattern space），接着用sed命令处理缓冲区中的内容，处理完成后，把缓冲区的内容送往屏幕。接着处理下一行，这样不断重复，直到文件末尾。文件内容并没有 改变，除非你使用重定向存储输出。Sed主要用来自动编辑一个或多个文件；简化对文件的反复操作；编写转换程序等。



：%s/vivian/sky/（等同于：g/vivian/s//sky/）替换每一行的第一个 vivian 为 sky
：%s/vivian/sky/g（等同于：g/vivian/s//sky/g）替换每一行中所有 vivian 为 sky



---

### Linux文件系统类型差别

在Linux中，ext2文件系统将磁盘划分成若干个block groups，每个block group包含一个inode bitmap, data bitmap, inodes和若干个data blocks，它没有使用日志。
![image-20201220181248526](https://i.loli.net/2020/12/20/76lu5c8yp3rRUdJ.png)

而在ext3文件系统中，加入了对日志的支持，日志部分单独占据一块磁盘空间。
![image-20201220181303261](https://i.loli.net/2020/12/20/nWts7F5i3bEHNrj.png)

---

### 什么是linux系统磁盘只读问题？

只读的原因在系统日志/var/log/messages里有，一般是因为检测到文件系统有错误

磁盘只读一般的常见原因：

- **磁盘空间满：可以通过df -h命令查看磁盘的使用情况，然后删除多余的文件释放磁盘空间；**

- **磁盘inode资源占用完：可以通过df -i命令查看，确认相关的进程；**

- 硬件故障：

- ---

### 什么是内存ECC？

https://www.crucial.cn/learn-with-crucial/memory/what-is-ecc-memory

对于大多数企业来说，消除数据损坏是一项关键任务——这正是 ECC（纠错码）内存的目的。ECC 是一种指令纠错技术，能够检测并纠正常见的各种内存数据损坏情况，即Error Checking and Correcting。

---



### linux /dev目录

https://www.cnblogs.com/hongzg1982/articles/2168450.html

dev 是设备(device)的英文缩写。这个目录对所有的用户都十分重要。因为在这个目录中包含了所有Linux系统中使用的外部设备。

---



### /sbin目录？

https://blog.csdn.net/kkdelta/article/details/7708250

- **/bin**是系统的一些指令。bin为binary的简写主要放置一些系统的必备执行档例如:cat、cp、chmod df、dmesg、gzip、kill、ls、mkdir、more、mount、rm、su、tar等。
- **/sbin**一般是指超级用户指令**。**主要放置一些系统管理的必备程式例如:cfdisk、dhcpcd、dump、e2fsck、fdisk、halt、ifconfig、ifup、 ifdown、init、insmod、lilo、lsmod、mke2fs、modprobe、quotacheck、reboot、rmmod、 runlevel、shutdown等。
- **/usr/bin**　是你在后期安装的一些软件的运行脚本。主要放置一些应用软体工具的必备执行档例如c++、g++、gcc、chdrv、diff、dig、du、eject、elm、free、gnome*、 gzip、htpasswd、kfm、ktop、last、less、locale、m4、make、man、mcopy、ncftp、 newaliases、nslookup passwd、quota、smb*、wget等。
- **/usr/sbin** 放置一些用户安装的系统管理的必备程式例如:dhcpd、httpd、imap、in.*d、inetd、lpd、named、netconfig、nmbd、samba、sendmail、squid、swap、tcpd、tcpdump等。

---



### 虚拟化

https://zhuanlan.zhihu.com/p/69629212

完全虚拟化和类虚拟化

https://www.redhat.com/zh/topics/virtualization

虚拟机监控程序(Hypervisor)可能位于操作系统的顶层（例如在便携式计算机上），或者直接安装在硬件上（例如服务器），这是大多数企业使用虚拟化的方式。虚拟机监控程序接管物理资源，并对它们进行划分，以便虚拟环境能够对其进行使用

---





### makefile教程

makefile关系到了整个工程的编译规则。一个工程中的源文件不计数，其按****类型、功能、模块****分别放在若干个目录中，makefile定义了一系列的规则来指定，哪些文件需要先编译，哪些文件需要后编译，哪些文件需要重新编译，甚至于进行更复杂的功能操作，因为makefile就像一个Shell脚本一样，其中也可以执行操作系统的命令。makefile带来的好处就是——“自动化编译”，一旦写好，只需要一个make命令，整个工程完全自动编译，极大的提高了软件开发的效率。make是一个命令工具，是一个解释makefile中指令的命令工具，一般来说，大多数的IDE都有这个命令，比如：Delphi的make，Visual C++的nmake，Linux下GNU的make。可见，makefile都成为了一种在工程方面的编译方法。

https://blog.csdn.net/weixin_38391755/article/details/80380786

### GCC 参数详解

https://www.runoob.com/w3cnote/gcc-parameter-detail.html

### C风格指南

https://zh-google-styleguide.readthedocs.io/en/latest/google-cpp-styleguide/comments/#id2

---



### 多服务器管理工具——ClusterShell

https://www.cnblogs.com/kevingrace/p/6099205.html

---





### Vim使用大全

![img](https://i.loli.net/2020/12/20/6tOVEXoDlvTqZIj.jpg)

![20160907135434231](https://i.loli.net/2020/12/20/iZ3M9OAw2vElTDb.png)

![img](https://i.loli.net/2020/12/20/qws3oWpveaEBLcV.png)

### linux 命令行 光标移动技巧

https://blog.csdn.net/leo_618/article/details/53003111

Ctrl+a跳到本行的行首，
Ctrl+e则跳到页尾。
Ctrl+u删除当前光标前面的文字
ctrl+k-删除当前光标后面的文字
Ctrl+w和Alt+d-对于当前的单词进行删除操作，w删除光标前面的单词的字符，d则删除后面的字符
Alt+Backsapce-删除当前光标后面的单词，
如果删除错误，使用Ctrl+y进行恢复Ctrl+L进行清屏操作

ctrl+a:光标移到行首。
ctrl+b:光标左移一个字母
ctrl+c:杀死当前进程。
ctrl+d:退出当前 Shell。
ctrl+e:光标移到行尾。
ctrl+h:删除光标前一个字符，同 backspace 键相同。
ctrl+k:清除光标后至行尾的内容。
ctrl+l:清屏，相当于clear。
ctrl+r:搜索之前打过的命令。会有一个提示，根据你输入的关键字进行搜索bash的history
ctrl+u: 清除光标前至行首间的所有内容。
ctrl+w: 移除光标前的一个单词
ctrl+t: 交换光标位置前的两个字符
ctrl+y: 粘贴或者恢复上次的删除
ctrl+d: 删除光标所在字母;注意和backspace以及ctrl+h的区别，这2个是删除光标前的字符
ctrl+f: 光标右移
ctrl+z : 把当前进程转到后台运行，使用’ fg ‘命令恢复。比如top -d1 然后ctrl+z ，到后台，然后fg,重新恢复
esc组合
esc+d: 删除光标后的一个词
esc+f: 往右跳一个词
esc+b: 往左跳一个词
esc+t: 交换光标位置前的两个单词。

---



### 区别gcc中的-w -W和-Wall选项

https://blog.csdn.net/cjtstrive/article/details/85375477

-w的意思是关闭编译时的警告，也就是编译后不显示任何warning，因为有时在编译之后编译器会显示一些例如数据转换之类的警告，这些警告是我们平时可以忽略的。

-Wall选项意思是编译后显示所有警告。

-W选项类似-Wall，会显示警告，但是只显示编译器认为会出现错误的警告。

在编译一些项目的时候可以-W和-Wall选项一起使用。

---





### 中文技术文档的写作规范

[https://github.com/ruanyf/document-style-guide](https://github.com/ruanyf/document-style-guide)

---





### 为什么选择“〜”代表主目录？

[https://qastack.cn/unix/34196/why-was-chosen-to-represent-the-home-directory](https://qastack.cn/unix/34196/why-was-chosen-to-represent-the-home-directory)

![image-20201220182101741](https://i.loli.net/2020/12/20/7dGbYjHgEwmiPCB.png)

---





### 将github中的issue导出(其实是调用Github的API文档)

[https://www.jianshu.com/p/5180f364be18](https://www.jianshu.com/p/5180f364be18)

[https://github.com/verygood-ops/export-pull-requests](https://github.com/verygood-ops/export-pull-requests)



```
epr -x issues -m 7 redisread/HUGO_blog -t 0cbb300dffa5d19e30e4fffee6f23cc504252904 -p github > issue.csv
```

```
epr redisread/HUGO_blo > pr.csv
```

---



### Bpazy blog issue

[https://github.com/Bpazy/blog/issues](https://github.com/Bpazy/blog/issues)

---

### Shell常用命令

[https://www.cnblogs.com/mainz/articles/1027168.html](https://www.cnblogs.com/mainz/articles/1027168.html)

---

### 将github中的issue导出(其实是调用Github的API文档)

[https://www.jianshu.com/p/5180f364be18](https://www.jianshu.com/p/5180f364be18)

[https://github.com/verygood-ops/export-pull-requests](https://github.com/verygood-ops/export-pull-requests)



```
epr -x issues -m 7 redisread/HUGO_blog -t 0cbb300dffa5d19e30e4fffee6f23cc504252904 -p github > issue.csv
```

```
epr redisread/HUGO_blo > pr.csv
```



### awk命令

[awk命令用法](https://www.cnblogs.com/walk1314/p/9077590.html)



---



