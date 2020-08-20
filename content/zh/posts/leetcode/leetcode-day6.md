---
title: "Leetcode每日一题(6)"
date: 2020-08-20T21:29:58+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/08/15/XCv8hYSQUDmc4qN.png
libraries:
- katex
- mathjax
tags:
- leetcode
- KMP
series:
- leetcode
categories:
-
---



#### [28. 实现 strStr()](https://leetcode-cn.com/problems/implement-strstr/)

实现 [strStr()](https://baike.baidu.com/item/strstr/811469) 函数。

给定一个 haystack 字符串和一个 needle 字符串，在 haystack 字符串中找出 needle 字符串出现的第一个位置 (从0开始)。如果不存在，则返回 **-1**。

**示例 1:**

```
输入: haystack = "hello", needle = "ll"
输出: 2
```

**示例 2:**

```
输入: haystack = "aaaaa", needle = "bba"
输出: -1
```

**说明:**

当 `needle` 是空字符串时，我们应当返回什么值呢？这是一个在面试中很好的问题。

对于本题而言，当 `needle` 是空字符串时我们应当返回 0 。这与C语言的 [strstr()](https://baike.baidu.com/item/strstr/811469) 以及 Java的 [indexOf()](https://docs.oracle.com/javase/7/docs/api/java/lang/String.html#indexOf(java.lang.String)) 定义相符。

### 分析

使用KMP算法。

**KMP算法**

KMP 是一种模式匹配算法，要解决的问题可以形式化为：给定模式串 T 与目标串 S，我们要在目标串 S 中寻找 T 的所有出现。

使用KMP算法最关键的一步是构建next数组。next[i]储存的是string中前i+1位字符串前缀和后缀的最长长度。如abadefg，next[2]存的是aba这个字符串前缀和后缀的最长长度。但是这里为了和代码相对应，将next数组的大小设置为字符串的长度加1。

假如我们现在求字符串"abababac"的next数组:

在下标为0的时候设置next[0] = -1;并且i = 0，j = -1

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   |      |      |      |      |      |      |      |      |

一个字符的字符串的最长相同前缀和后缀的长度为0，此时i = 1,j = 0

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   | 0    |      |      |      |      |      |      |      |

接下来str[j] != str[i]，j的值又变为next[j] = next[0] = -1；然后继续执行得到next[++i] = ++j，即next[2] = 0,此时i = 2,j = 0;

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   | 0    | 0    |      |      |      |      |      |      |

接下来str[j] == str[i] ,next[++i] = ++j，即next[30] = 1，此时i = 3,j = 1

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   | 0    | 0    | 1    |      |      |      |      |      |

接下来str[i] == str[j]，则next[++i] = ++j，即next[4] = 2，此时i = 4,j = 2

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   | 0    | 0    | 1    | 2    |      |      |      |      |

接下来str[i] == str[j]，则next[++i] = ++j，即next[5] = 3，此时i = 5,j = 3

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   | 0    | 0    | 1    | 2    | 3    |      |      |      |

接下来str[i] == str[j]，则next[++i] = ++j，即next[6] = 4，此时i = 6,j = 4

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   | 0    | 0    | 1    | 2    | 3    | 4    |      |      |

接下来str[i] == str[j]，则next[++i] = ++j，即next[7] = 5，此时i = 7,j = 5

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   | 0    | 0    | 1    | 2    | 3    | 4    | 5    |      |

接下来str[i] != str[j]，j = next[j] = next[5] = 3;i = 7;此时str[3] != str[7],j = next[j] = next[3] = 1;此时str[1] != str[7],j = next[j] = next[1] = 0;此时str[0] != str[7],j = next[j] = next[0] = -1;接下来next[++i] = next[8] = ++j = 0

| index | 0    | 1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    |
| ----- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| str   | NULL | a    | b    | a    | b    | a    | b    | a    | c    |
| next  | -1   | 0    | 0    | 1    | 2    | 3    | 4    | 5    | 0    |



**匹配字符串的思路与构建next数组的思路类似。**



### 代码

```cpp
class Solution {
public:
    int strStr(string haystack, string needle) {
        if(needle == "") return 0;
        int n = haystack.length();
        // 构建next数组
        int m = needle.length();
        vector<int> next(m + 1,0);
        for(int i = 0,j = next[0] = -1;i < m;next[++i] = ++j)
            while(~j && needle[j] != needle[i]) j = next[j];
        
        // 搜索
        for(int i = 0,j = 0;i < n;++i)
        {
            while(j > 0 && haystack[i] != needle[j]) j = next[j];
            if(haystack[i] == needle[j]) ++j;
            if(j == m) return (i - m + 1);
        }
        return -1;
    }
};
```

---

参考链接：

1. [【算法ABC】KMP 算法](https://leetcode-cn.com/circle/article/yCI2iS/)
2. [动态规划之KMP字符匹配算法](https://labuladong.gitbook.io/algo/dong-tai-gui-hua-xi-lie/dong-tai-gui-hua-zhi-kmp-zi-fu-pi-pei-suan-fa)
3. [从头到尾彻底理解KMP](https://blog.csdn.net/v_july_v/article/details/7041827)

