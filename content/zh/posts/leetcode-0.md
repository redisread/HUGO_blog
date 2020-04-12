---
title: "Leetcode-最长回文子串"
date: 2020-04-12T19:26:20+08:00
description:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/04/12/chQvDldfragqm4P.png
libraries:
- katex
- mathjax
tags:
- C++
- leetcode
series:
- C++
categories:
-
---



### 问题描述

给定一个字符串 `s`，找到 `s` 中最长的回文子串。你可以假设 `s` 的最大长度为 1000。

<!--more-->

**示例 1：**

```
输入: "babad"
输出: "bab"
注意: "aba" 也是一个有效答案。
```

**示例 2：**

```
输入: "cbbd"
输出: "bb"
```

### 解答

使用动态规划，把原来的字符串倒置，然后找最长的公共子串就可以了。例如 S = "caba" ，S = "abac"，最长公共子串是 "aba"，所以原字符串的最长回文串就是 "aba"。其中求最大公共子串就是使用动态规划的方法。

示意图：

![动态规划](https://i.loli.net/2020/04/12/5zG8l9KhgBidNmI.png)

* 当`S[i]`==`S[j]`时，矩阵`arr[i][j]`=`arr[i-1][j-1]`+`1`；特殊情况i、j为0时`arr[i][j]`=`1`
* 其他情况跳过。

> 另外，还需要考虑最长公共子串不是回文的情况，只需要判断翻转前后的末尾字符下标是否一样即可，比如 S="caba"，S'="abac" ，S’ 中 aba 的下标是 0 1 2 ，倒置前是 3 2 1，和 S 中 aba 的下标符合，所以 aba 就是我们需要找的。当然我们不需要每个字符都判断，我们只需要判断末尾字符就可以。

**代码实现**：

```c++
#include <iostream>
#include <algorithm>
class Solution
{
public:
    string longestPalindrome(string s)
    { //暴力法
        int len = s.length();
        if (len <= 1)
            return s;
        std::string r;
        std::string real = s;
        reverse(s.begin(), s.end());
        std::string reverse = s;
        int arr[len][len];
        for (int i = 0; i < len; ++i)
            for (int j = 0; j < len; ++j)
                arr[i][j] = 0;
        int maxLen(0), maxEnd(0);
        for (int i = 0; i < len; ++i)
        {
            for (int j = 0; j < len; ++j)
            {
                if (real[i] == reverse[j])
                {
                    if (i == 0 || j == 0)
                        arr[i][j] = 1;
                    else
                    {
                        arr[i][j] = arr[i - 1][j - 1] + 1;
                    }
                }
                if (arr[i][j] > maxLen)
                {
                    int beforeindex = len - 1 - j;
                    if ((beforeindex + arr[i][j] - 1) == i)
                    {
                        maxLen = arr[i][j];
                        maxEnd = i;
                    }
                }
            }
        }
        return real.substr(maxEnd - maxLen + 1, maxLen);
    }
};
```

### 结果：

![result](https://i.loli.net/2020/04/12/qLKCupE8m6B5ezf.png)