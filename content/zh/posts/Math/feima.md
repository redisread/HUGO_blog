---
title: "费马🦓定理"
date: 2020-05-06T11:12:38+08:00
description: 费马大定理、费马小定理
draft: false
hideToc: false
enableToc: true
enableTocContent: false
#tocPosition: outer
author: Victor
authorEmoji: 👻
image:  https://i.loli.net/2020/05/06/Ly65MvdGuVKCpkT.png
libraries:
- katex
- mathjax
tags:
- 费马
series:
- Math
categories:
-
---



费马大定理在数学里有一个特殊的现象，即在于它是错误证明数量最多的数学题。

<!--more-->

## 费马小定理



费马小定理是数论中的一个定理：假如$a$是一个整数，$p$是一个质数，那么$a^{p}-a$是$p$的倍数，可以表示为
$$
a^{p} \equiv a \pmod p
$$
当a不是p的倍数时也可以表示为
$$
a^{p-1} \equiv 1 \pmod p
$$

> **同余符号**
>
> 两个整数a，b，若它们除以正整数m所得的余数相等，则称a，b对于模m同余
>
> 记作$a \equiv b\pmod {m}$
>
> 读作a同余于b模m，或读作a与b关于模m同余。
>
> 比如$26 \equiv 14 \pmod{12}$



一种证明：

考虑一根有 [公式] 颗珠子的项链，其每颗珠子有 [公式] 种染色选择，然后由下图蕴含的精神可得原命题成立。

![链珠证明](https://i.loli.net/2020/05/06/V9LG7FPJDdT8WUl.png)

## 费马大定理

当整数$n>2$时，关于$x, y, z$的不定方程
$$
x^{n} + y^{n} = z^{n}
$$
没有整数解