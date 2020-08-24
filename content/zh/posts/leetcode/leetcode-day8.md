---
title: "Leetcode每日一题(8)"
date: 2020-08-24T22:24:19+08:00
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



#### [459. 重复的子字符串](https://leetcode-cn.com/problems/repeated-substring-pattern/)

给定一个非空的字符串，判断它是否可以由它的一个子串重复多次构成。给定的字符串只含有小写英文字母，并且长度不超过10000。

**示例 1:**

```
输入: "abab"

输出: True

解释: 可由子字符串 "ab" 重复两次构成。
```

**示例 2:**

```
输入: "aba"

输出: False
```

**示例 3:**

```
输入: "abcabcabcabc"

输出: True

解释: 可由子字符串 "abc" 重复四次构成。 (或者子字符串 "abcabc" 重复两次构成。)
```



### 分析

假如有重复，那么至少重复两个相同的字符串，假如A是相同的字符串，AA是一个最小重复的字符串，即s = AA，当我们执行s + s的时候，得到AAAA，我们在中间也可以找到与原来字符串相等的子串AA，那么也就证明了s中存在重复的子串，其中子串匹配的方法可以使用KMP算法。[参考](https://vhope.cf/zh/posts/leetcode/leetcode-day6/)

### 代码

```cpp
class Solution {
public:
    bool repeatedSubstringPattern(string s) {
        string str = s.substr(1) + s.substr(0,s.length()-1);
        string pattern = s;
        int n = str.length();
        int m = pattern.length();
        vector<int> next(m+1);
        for(int i = 0,j = next[0] = -1;i < m;next[++i] = ++j)
        {
            while(~j && pattern[i] != pattern[j]) j = next[j];
        }
        
        for(int i = 0,j = 0;i < n;++i)
        {
            while(j > 0 && str[i] != pattern[j]) j = next[j];
            if(str[i] == pattern[j]) ++j;
            if(j == m) return true;
        }
        return false;
    }
};
```

