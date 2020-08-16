---
title: "Leetcode每日一题(2)"
date: 2020-08-16T09:01:25+08:00
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
- 算法
- 动态规划
- hash
- 递归
series:
- leetcode
categories:
-
---



#### [5490. 吃掉 N 个橘子的最少天数](https://leetcode-cn.com/problems/minimum-number-of-days-to-eat-n-oranges/)

厨房里总共有 `n` 个橘子，你决定每一天选择如下方式之一吃这些橘子：

- 吃掉一个橘子。
- 如果剩余橘子数 `n` 能被 2 整除，那么你可以吃掉 `n/2` 个橘子。
- 如果剩余橘子数 `n` 能被 3 整除，那么你可以吃掉 `2*(n/3)` 个橘子。

每天你只能从以上 3 种方案中选择一种方案。

请你返回吃掉所有 `n` 个橘子的最少天数。

**示例 1：**

```
输入：n = 10
输出：4
解释：你总共有 10 个橘子。
第 1 天：吃 1 个橘子，剩余橘子数 10 - 1 = 9。
第 2 天：吃 6 个橘子，剩余橘子数 9 - 2*(9/3) = 9 - 6 = 3。（9 可以被 3 整除）
第 3 天：吃 2 个橘子，剩余橘子数 3 - 2*(3/3) = 3 - 2 = 1。
第 4 天：吃掉最后 1 个橘子，剩余橘子数 1 - 1 = 0。
你需要至少 4 天吃掉 10 个橘子。
```

**示例 2：**

```
输入：n = 6
输出：3
解释：你总共有 6 个橘子。
第 1 天：吃 3 个橘子，剩余橘子数 6 - 6/2 = 6 - 3 = 3。（6 可以被 2 整除）
第 2 天：吃 2 个橘子，剩余橘子数 3 - 2*(3/3) = 3 - 2 = 1。（3 可以被 3 整除）
第 3 天：吃掉剩余 1 个橘子，剩余橘子数 1 - 1 = 0。
你至少需要 3 天吃掉 6 个橘子。
```

**示例 3：**

```
输入：n = 1
输出：1
```

**示例 4：**

```
输入：n = 56
输出：6
```

 

**提示：**

- `1 <= n <= 2*10^9`

### 分析

整个问题就是一个求最值的问题，可以使用递归进行深度优先判断，也可以使用动态规划建立一个dp数组进行求解：

### 代码

递归求解(超时)：

```cpp
    int solve(int n)
    {
        if(n == 0) return 0;
        if(n == 1) return 1;
        int r1 = minDays(n - 1);
        int r2 = n%2==0? minDays(n - n/2):INT_MAX;
        int r3 = n%3==0? minDays(n -2*(n/3)):INT_MAX;
        return min(min(r1,r2),r3) + 1;
    }
```

加上哈希表(堆栈溢出)：

```cpp
 unordered_map<int,int> table;
    int solve(int n)
    {
        if(n == 0) return 0;
        if(n == 1) return 1;
        if(table.find(n) != table.end()) return table[n];
        int r1 = minDays(n - 1);
        int r2 = n%2==0? minDays(n - n/2):INT_MAX;
        int r3 = n%3==0? minDays(n -2*(n/3)):INT_MAX;
        return table[n] = min(min(r1,r2),r3) + 1;
    }
```

动态规划(超出时间限制)：

```cpp
int minDays(int n) {
        vector<int> dp(n+1,0);
        for(int i = 1;i <= n;++i)
        {
            if(i % 6 == 0)
            {
                dp[i] = min(min(dp[i - 2*(i/3)],dp[i-1]),dp[i - i/2]) + 1;
            }
            else if(i % 2 == 0) dp[i] = min(dp[i - i/2],dp[i-1]) + 1;
            else if(i % 3 == 0) dp[i] = min(dp[i - 2*(i/3)],dp[i-1]) + 1;
            else dp[i] = dp[i-1] + 1;
        }
        return dp[n];
    }
```

离散化递归：

```cpp
class Solution {
    unordered_map<int,int> table;
    int solve(int n)
    {
        if(n == 0 || n == 1) return n;
        if(table.find(n) != table.end()) return table[n];
        table[n] = min((n&1) + solve(n/2),(n%3) + solve(n/3))+1;
        return table[n];
    }
public:
    int minDays(int n) {
        return solve(n);
    }
};
```

![结果](https://i.loli.net/2020/08/16/eYZXpiKzOqkN2nU.png)

