---
title: "Markdown深入使用"
date: 2020-02-14T16:12:40+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: true
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/02/14/Qgcb4yzqUEYC3Of.png
tags:
- markdown
- Typora
series:
- Blog
categories:
- 写作
libraries:
- katex
---

:blonde_woman:介绍一些markdown中比较实用的一些写作方法。

<!--more-->

### 任务列表✍

- [ ] a task list item
- [ ] list syntax required
- [ ] normal **formatting**, @mentions, #1234 refs
- [ ] incomplete
- [x] completed

上面的代码如下：

```markdown
- [ ] a task list item
- [ ] list syntax required
- [ ] normal **formatting**, @mentions, #1234 refs
- [ ] incomplete
- [x] completed
```

### 数学公式:triangular_ruler:

使用MathJax渲染LaTeX数学表达式。:bulb:

$$ \mathbf{V}_1\times\mathbf{V}_2=\begin{vmatrix}\mathbf{i}&mathbf{j} & \mathbf{k} \\\frac{\partial X}{\partial u}&\frac{\partial Y}{\partial u} & 0 \\\frac{\partial X}{\partial v} &\frac{\partial Y}{\partial v} & 0 \\\end{vmatrix} $$

上面的代码如下：

```markdown
$$
\mathbf{V}_1 \times \mathbf{V}_2 =  \begin{vmatrix}
\mathbf{i} & \mathbf{j} & \mathbf{k} \\
\frac{\partial X}{\partial u} &  \frac{\partial Y}{\partial u} & 0 \\
\frac{\partial X}{\partial v} &  \frac{\partial Y}{\partial v} & 0 \\
\end{vmatrix}
$$
```

$$ \begin{align*}
y = y(x,t) &= A e^{i\theta} \\
&= A (\cos \theta + i \sin \theta) \\
&= A (\cos(kx - \omega t) + i \sin(kx - \omega t)) \\
&= A\cos(kx - \omega t) + i A\sin(kx - \omega t)  \\
&= A\cos \Big(\frac{2\pi}{\lambda}x - \frac{2\pi v}{\lambda} t \Big) + i A\sin \Big(\frac{2\pi}{\lambda}x - \frac{2\pi v}{\lambda} t \Big)  \\
&= A\cos \frac{2\pi}{\lambda} (x - v t) + i A\sin \frac{2\pi}{\lambda} (x - v t)
\end{align*} $$

上面的代码如下：

```markdown
$$
\begin{align*}
y = y(x,t) &= A e^{i\theta} \\
&= A (\cos \theta + i \sin \theta) \\
&= A (\cos(kx - \omega t) + i \sin(kx - \omega t)) \\
&= A\cos(kx - \omega t) + i A\sin(kx - \omega t)  \\
&= A\cos \Big(\frac{2\pi}{\lambda}x - \frac{2\pi v}{\lambda} t \Big) + i A\sin \Big(\frac{2\pi}{\lambda}x - \frac{2\pi v}{\lambda} t \Big)  \\
&= A\cos \frac{2\pi}{\lambda} (x - v t) + i A\sin \frac{2\pi}{\lambda} (x - v t)
\end{align*}
$$
```

### 脚注:footprints:

如下是使用的代码，将鼠标悬停在“ fn1”或“ fn2”上标上可以查看脚注的内容。您可以将任何喜欢的唯一标识用作脚注标记（例如“ fn1”）。

```markdown
[^fn1]: Here is the *text* of the first **footnote**.
[^fn2]: Here is the *text* of the second **footnote**
```

你也可以内嵌脚注，就像`^[Here is the text of the first footnote.]`

### 水平线:wavy_dash:

:star2:在空行输入`***`或`---`，如下：

****

### YMAL首要事项:thinking:

包含YAML前事块的文件将作为特殊文件进行处理，下面是一个例子

```yaml
---
layout: post
title: Blogging Like a Hacker
---
```

### 目录:bookmark_tabs:

输入[toc]并回车即可。

### 内部链接:link:

这是一个跳转到`任务列表`的链接,[this link](#任务列表✍) ！

代码如下：

```markdown
[this link](#任务列表✍)
```

### 参考链接:book:

参考链接使用两组方括号的格式，第一个是显示的文字，第二个括号内是查找的id，代码如下：

```markdown
This is [an example][id] reference-style link.

Then, anywhere in the document, you define your link label on a line by itself like this:

[id]: http://example.com/  "Optional Title Here"
```

隐式链接，直接使用`Google`查阅：

```
[Google][]
And then define the link:

[Google]: http://google.com/
```

### 删除线:x:

删除~~Mistaken text.~~，代码为`~~Mistaken text.~~`

### 高亮:high_brightness:

==highlight==，使用两个等号在两边进行包围，代码如下：

```markdown
==highlight==
```

