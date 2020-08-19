---
title: "Leetcode每日一题(5)"
date: 2020-08-19T14:40:19+08:00
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
- 回文串
series:
- leetcode
categories:
-
---



#### [647. 回文子串](https://leetcode-cn.com/problems/palindromic-substrings/)

给定一个字符串，你的任务是计算这个字符串中有多少个回文子串。

具有不同开始位置或结束位置的子串，即使是由相同的字符组成，也会被视作不同的子串。

 

**示例 1：**

```
输入："abc"
输出：3
解释：三个回文子串: "a", "b", "c"
```

**示例 2：**

```
输入："aaa"
输出：6
解释：6个回文子串: "a", "a", "a", "aa", "aa", "aaa"
```

 

**提示：**

- 输入的字符串长度不会超过 1000 。

### 分析

中心拓展法。

### 代码

```cpp
class Solution {
public:
    int countSubstrings(string s) {
        int r = 0;
        int len = s.length();
        // 奇数类型
        for(int i = 0;i < len;++i)
        {
            ++r;
            int left = i - 1;
            int right = i + 1;
            while(left >= 0 && right < len && s[left] == s[right])
            {
                ++r;
                --left;
                ++right;
            }
            left = i;
            right = i + 1;
            // 偶数类型
            while(left >= 0 && right < len && s[left] == s[right])
            {
                ++r;
                --left;
                ++right;
            }
        }
        return r;
    }
};
```