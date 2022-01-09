---
title: Nvchad使用
date: 2021-11-28T15:10:01+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: outer
author: Victor
authorEmoji: 🪶
image: https://nvchad.github.io/img/logo.svg
plantuml: true
libraries:
- katex
- mathjax
tags:
- Nvchad
- nvim
- vim
series:
-
categories:
-
---

## 安装更新卸载

参考：[https://nvchad.github.io/getting-started/setup](https://nvchad.github.io/getting-started/setup)


## 参考指令

参考：[https://neovim.io/doc/user/quickref.html](https://neovim.io/doc/user/quickref.html)


## 自定义

自定义需要在目录`lua/custom/`,防止在更新的时候覆盖了。

一开始该目录只有下面两个文件：

![lua-custom目录](https://cos.jiahongw.com/uPic/2DFeuT.png)

要根据您的需要开始设置 NvChad，请复制这些模板文件：

```bash
cp example_init.lua init.lua
cp example_chadrc.lua chadrc.lua
```

![NredD1](https://cos.jiahongw.com/uPic/NredD1.png)

- custom/init.lua 在 NeoVim 设置期间运行，这是一种运行通用代码并运行大量 NvChad 修改的方法
- custom/chadrc.lua用于覆盖core/default_config.lua，您只需要包含您希望从默认文件更改的值


## 切换主题

`<leader> + th`


## Lua笔记

编译器使用IDEA + EmmyLua插件


### 输出和评论

```lua
-- a comment
print("hi") -- another comment
```

### 变量的定义

```lua
-- Different types
local x = 10 -- number
local name = "Sid" -- string
local isAlive = true -- boolean
local a = nil --no value or invalid value
```

local的作用域只在当前的函数内，在外部的话就是文件内。

### 字符串操作

```lua
-- 字符串拼接
local name_first = "Victor"
local name_Second = "Hong"
print(name_first .. name_Second)

-- 多个字符串拼接
print(name_first .. "and" .. name_Second)

```

输出为：

```
VictorHong
VictorandHong
```


### 比较判断

多了一个不等的符号`~=` ,其他的和其他语言一样。

> 另外，使用not表示!，常在条件判断语句使用。


### 条件判断语法

类似shell语言，条件判断语句不需要花括号，但是增加了两个关键字then和end


例子：

```lua
-- number comparisions
local age = 10

if age > 18 then
  print("over 18") -- this will not be executed
end

-- elseif and else
age = 20

if age > 18 then
  print("over 18")
elseif age == 18 then
  print("18 huh")
else
  print("kiddo")
end
```

复合判断语句：

```lua
local age = 22

if age == 10 and x > 0 then -- both should be true
  print("kiddo!")
elseif x == 18 or x > 18 then -- 1 or more are true
  print("over 18")
end

--result: over 18
```


### 函数

函数定义：

```lua
function num(a)
  print(a)
end

-- or


local num = function(a)
  print(a)
end


-- 多参数函数定义

function sum(a,b)
  local result = a + b
  print(result)
end

```

函数调用：

```lua
num(5)
sum(2,3)
```


### 循环

```lua
-- while loop
local i = 0

while i <= 3 do
   print("hi")
   i = i + 1
end

OR

--for loop
for i = 0, 3 do
   print("hi")
   i = i + 1
end

-- result
hi
hi
hi
```


### tables（数组）

```lua
-- basic table
local colors = { "red", "green", "blue" }

print(colors[1]) --red
print(colors[2]) --green
print(colors[3]) --blue

-- use a loop to iterate though the table
for i=1, #colors do
  print(colors[i])
end


--tables within tables
local data = {
    { "billy", 12 },
    { "john", 20 },
}

for i = 1, #data do
  print(data[i][1] .. " is " .. data[i][2] .. " years old")
end
 

```

### 模块

使用模块
```lua
require("otherfile")

```




## 自定配置


目录树：

![1kJY9c](https://cos.jiahongw.com/uPic/1kJY9c.png)


Nvchad的配置目录下有一个 `lua` 文件夹和一个 `init.lua` 文件， 而 `init.lua` 主要加载核心的配置。

假如你在 `chadir` 目录下有一个自定义文件 `test.lua` ,你可以在 `init.lua` 文件中加载使用它：

```lua
require("chadir.test") or require "chadir.test".
```

你也可以将 `test.lua` 重命名为 `init.lua` ，这样你就可以直接：

```lua
require "chadir".
 -- which calls the init.lua present in the chadir
```



### 颜色

颜色配置目录 `lua/colors/` ,该目录有两个文件 `init.lua` 和 `highlight.lua` ,主题是用nvim-base16.lua 插件完成的.

使用 空格 + th更换主题。


### custom配置


添加插件，在 `custom/init.lua` 取消注释包含“install_plugins”内容的 hooks.add 行,添加：

```lua

hooks.add("install_plugins", function(use)
   use {
       "folke/which-key.nvim"
        event = "something",
        config = function()
            require("custom.plugin_confs.whichkey")
        end
    }
 end)

-- so the path of the config here basically is in the custom/plugin_confs/whichkey.lua
```

然后使用 `:PackSync` 进行同步

添加Markdown预览插件：
```lua
hooks.add("install_plugins", function(use)
  use {
      "davidgranstrom/nvim-markdown-preview",
   }

```


---



## 相关插件的使用



文件浏览器： [kyazdani42/nvim-tree.lua: A file explorer tree for neovim written in lua](https://github.com/kyazdani42/nvim-tree.lua)

触发条件：`:NvimTreeToggle` 或者 `Ctrl + n`

刷新文件树：`:NvimTreeRefresh` 或者 `<leader>r`

寻找文件：`:NvimTreeFindFile` 或者 `<leader>n`

键入s将使用系统默认的软件打开文件，Ctrl+t将在新标签页打开



---


***Reference***:

1. [NvChad](https://nvchad.github.io/)

