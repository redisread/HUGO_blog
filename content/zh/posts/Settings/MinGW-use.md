---
title: "MinGW在Windows的使用"
date: 2020-02-11T18:01:16+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/02/15/hifGyj65CEsR4D8.png
tags:
-
series:
-
categories:
-
---

安装`MinGW`之后，我们可以那它来作为C或C++的编译器.<span><code>:spider_web:</code></span>

<!--more-->

## CMD编译程序

> 编译过程分为四个步骤：预处理、编译、汇编、链接。

使用g++可以在命令行分别实现上面四个步骤。使用下面的程序作为例子。

```C++
#include <iostream>
#include <cmath>
using namespace std;

// this is my test program

#ifndef myNum
#define myNum 666

#endif
int main()
{

    cout << "Hello!" << endl;
    cout << "myNum = " << myNum <<endl;

    return 0;
}
```



### 预处理

{{< notice info >}}
预处理主要完成的工作有：

（1）删除#define，展开宏；

（2）处理条件编译指令，预处理程序先判断条件，在根据条件修改源代码；

（3）删除注释；

（4）添加行号，以及文件名标识，便于调试

（5）删除“#include”，插入相应的头文件；
{{< /notice >}}

使用下面的命令，得到预处理后的文件`test.i`

```bash
g++ -E test.cpp -o test.i
```

查看`test.i`文件

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205145757.png)

### 编译

使用下面的代码生成汇编文件`test.s`

```bash
g++ -S test.i -o test.s
```

{{< notice info >}}
注意：直接从test.cpp文件得到汇编文件也可以。直接使用命令 g++ -S test.cpp -o test.s
{{< /notice >}}

查看`test.s`文件

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205150653.png)

### 汇编

使用下面的命令将汇编指令转化为机器指令，生成文件`test.o`

```bash
g++ -c test.s -o test.o
```

查看文件`test.o`

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205151131.png)

### 链接

通过链接库文件，可以将目标文件`test.o`转化为可执行文件`test.exe`

{{< notice info >}}
注意:Windows下可执行文件的后缀为exe，而Linux下不需要后缀。
{{< /notice >}}

`CMD`输入以下代码

```bash
g++ test.o -o test.exe
```

{{< notice info >}}
注意:Windows下.o文件已经可以执行，在命令行输入test.o就可以看到如下的效果：

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205152459.png)

{{< /notice >}}

另外一个命令是

```bash
g++ test.o -o test.exe -L  所需库文件路径
```

{{< alert theme="warning" >}}
其中L为link的缩写。
{{< /alert >}}

### 快速生成可执行文件

一般情况下，可以直接使用`g++  test.cpp  -o test` 就可以生成可执行程序了。

### 运行程序

如下：

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205152931.png)

## MinGW + SublimeText配置C++环境

### 下载MinGW和SublimeText

<a href="https://www.sublimetext.com/3" class="LinkCard">SublimeText下载</a>

<a href="https://jiahong.cf/posts/ded73fd3.html" class="LinkCard">MinGW下载及相关配置</a>

### 使用SublimeText

因为前面配置好环境变量了，所以可以直接在`SublimeText`下编译运行程序

Tools->build(或者按快捷键`Ctrl+B` 或 `Ctrl + Shift + B`)

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205165022.png)

可以在最下面一栏看到输出结果

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205154514.png)

enjoy it!

### 解决SublimeText下不能使用输入的问题

{{< notice warning >}}
`SublimeText`是把shell执行的结果读回来显示在终端，这意味无法使用输入语句，无法使用调试功能。
{{< /notice >}}

解决方法:让程序直接运行在`CMD`

在sublime->Tools>Build System里新建编译系统，输入以下内容构建C++编译环境,保存名字为`C++Buider`

```yml
{
    "cmd": ["g++", "$file_name", "-o", "${file_base_name}", "-lm", "-Wall"],
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "selector": "source.c, source.c++",
    "shell": false,
    "working_dir": "$file_path",
    "variants": [
    {
        "name": "RunInCommand",
        "cmd": ["cmd", "/c", "g++", "-g", "${file}", "-o", "${file_path}/${file_base_name}", "&&", "start", "cmd", "/k", "${file_path}/${file_base_name}"]
    }]
}
```

然后可以使用快捷键`Ctrl + Shift + B`，会显示如下，使用命令行打开模式选项即可

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205174238.png)

结果如下：

![](https://raw.githubusercontent.com/wujiahong1998/PicGoBed/master/img/20200205174328.png)


其他编译环境的配置也类似：

C编译配置文件：

```yml
{
    "cmd": ["gcc", "$file_name", "-o", "${file_base_name}", "-lm", "-Wall"],
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "selector": "source.c, source.c++",
    "shell": false,
    "working_dir": "$file_path",
    "variants": [
    {
        "name": "RunInCommand",
        "cmd": ["cmd", "/c", "gcc", "-g", "${file}", "-o", "${file_path}/${file_base_name}", "&&", "start", "cmd", "/k", "${file_path}/${file_base_name}"]
    }]
}
```



Java编译配置文件

```bash
{
    "cmd": ["javac", "$file_name"],
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "selector": "source.java",
    "shell": false,
    "working_dir": "$file_path",
    "variants": [
    {
        "name": "RunInCommand",
        "cmd": ["cmd", "/c", "javac", "${file}", "&&", "start", "cmd", "/k", "java $file_name"]
    },
    {
        "name": "Debug",
        "cmd": ["cmd", "/c", "javac", "${file}", "&&", "start", "cmd", "/k", "gdb ${file_path}/${file_base_name}"]
    }]
}
```

### 解决不能输入中文的问题

使用下面的编译配置文件即可：

```yml
{
    "encoding": "GBK",
    "working_dir": "$file_path",
    "shell_cmd": "g++ -fexec-charset=GBK -Wall  -std=c++11  \"$file_name\" -o \"$file_base_name\"",
    "file_regex": "^(..[^:]*):([0-9]+):?([0-9]+)?:? (.*)$",
    "selector": "source.c++",

    "variants": 
    [
        {   
        "name": "Run in sublime",
            "shell_cmd": "g++ -fexec-charset=GBK -Wall -std=c++11 \"$file_name\" -o \"$file_base_name\" && cmd /c \"${file_path}/${file_base_name}\""
        },
        {   
        "name": "CMD Run",
            "shell_cmd": "g++ -fexec-charset=GBK -Wall -std=c++11 \"$file\" -o \"$file_base_name\" && start cmd /c \"\"${file_path}/${file_base_name}\" & pause\""
        },
        {   
        "name": "gdb Debug",
            "shell_cmd": "g++ -fexec-charset=GBK -g -std=c++11 \"$file\" -o \"$file_base_name\" && start cmd /c gdb ${file_path}/${file_base_name} & pause"
        }
    ]
}
```



### 配置代码格式化

从菜单里选View->Show Console，跳出Console，下面有一行输入的（光标位置），把下面这段代码输入进去回车(只适用sublime Text 3)

```python
import urllib.request,os; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); open(os.path.join(ipp, pf), 'wb').write(urllib.request.urlopen( 'http://sublime.wbond.net/' + pf.replace(' ','%20')).read()) 
```

安装`CoolFormat`，按`Ctrl+Shift+P`，然后输入install,就会出现“Package Control: Install Package”，输入`CoolFormat`进行下载，下载完成之后输入`Ctrl+Shift+P`，然后输入`CoolFormat`，选下Formatter Settings，可以看到如下配置:

```yml
; Please visit http://akof1314.github.io/CoolFormat/doc/index.html for more information
[SynTidy]
C++=""-A1-p-N-Y-k3""
Java=""-A1-p-N-Y-k3""
C#=""-A1-p-N-Y-k3""
Objective-C=""-A1-p-N-Y-k3""
HTML=""-aan-dep-fb-fbc-fu-js-ll-n-ox-pe-qa-qn-m-wa-wj-wp-ws-sw-fo-i0-d1-ce0-ie0-oe0-w0-sbo0""
XML=""-aan-dep-fb-fbc-js-ll-n-ix-qa-qn-m-wa-wj-wp-ws-sw-fo-i1-ce0-ie0-oe0-w0""
PHP=""-sas-icd-samt-salo-saeo-saro-sabo-saao-samp-aas-rsl-iel-rpc-rst-st""
JavaScript=""-nb-cn4""
CSS=""-c2-rub-cl0-os1-cc-cf-cfp0-rs2""
JSON=""-cn3""
SQL=""-cn2-el-ml0""
Verilog=""-A1""
```

**建立快捷键**

进入菜单选Preferences->Browse Packages，然后进CoolFormat，里面有个Default.sublime-keymap

打开后，里面有快捷方式的按键,更改如下：

```yml
[
    {
        "keys": ["ctrl+q"], "command": "coolformat", "args": {"action": "quickFormat"}
    },
    {
        "keys": ["ctrl+alt+shift+s"], "command": "coolformat", "args": {"action": "selectedFormat"}
    }
]

```

> 这样以后写完的代码直接按 “Ctrl+Q” 便可以格式化代码

另一种格式化代码：

```yml
; Please visit http://akof1314.github.io/CoolFormat/doc/index.html for more information
[SynTidy]
C++=""-A2-p-N-Y-o-T-N-k3""
Java=""-A1-p-N-T-Y-k3""
C#=""-A1-p-N-Y-T-k3""
Objective-C=""-A1-p-N-Y-k3""
HTML=""-aan-dep-fb-fbc-fu-js-ll-n-ox-pe-qa-qn-m-wa-wj-wp-ws-sw-fo-i0-d1-ce0-ie0-oe0-w0-sbo0""
XML=""-aan-dep-fb-fbc-js-ll-n-ix-qa-qn-m-wa-wj-wp-ws-sw-fo-i1-ce0-ie0-oe0-w0""
PHP=""-sas-icd-samt-salo-saeo-saro-sabo-saao-samp-aas-rsl-iel-rpc-rst-st""
JavaScript=""-nb-cn4""
CSS=""-c2-rub-cl0-os1-cc-cf-cfp0-rs2""
JSON=""-cn3""
SQL=""-cn2-el-ml0""　
```

