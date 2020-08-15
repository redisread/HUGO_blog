---
title: "Leetcode每日一题(1)"
date: 2020-08-15T09:01:25+08:00
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
series:
- leetcode
categories:
-
---



#### [546. 移除盒子](https://leetcode-cn.com/problems/remove-boxes/)

给出一些不同颜色的盒子，盒子的颜色由数字表示，即不同的数字表示不同的颜色。
你将经过若干轮操作去去掉盒子，直到所有的盒子都去掉为止。每一轮你可以移除具有相同颜色的连续 k 个盒子（k >= 1），这样一轮之后你将得到 `k*k` 个积分。
当你将所有盒子都去掉之后，求你能获得的最大积分和。

**示例：**

```
输入：boxes = [1,3,2,2,2,3,4,3,1]
输出：23
解释：
[1, 3, 2, 2, 2, 3, 4, 3, 1] 
----> [1, 3, 3, 4, 3, 1] (3*3=9 分) 
----> [1, 3, 3, 3, 1] (1*1=1 分) 
----> [1, 1] (3*3=9 分) 
----> [] (2*2=4 分)
```

**提示：**

- `1 <= boxes.length <= 100`
- `1 <= boxes[i] <= 100`

### 分析

一般来说，求最值的问题几乎和动态规划有关系，那么这题也是从动态规划的角度去思考解决方案。

### 代码

```cpp
class Solution {
    int len;
    int removeBoxes(vector<int>& boxes,int i,int j,int k,vector<vector<vector<int>>>& dp)
    {
        if(i > j) return 0;
        if(dp[i][j][k] > 0) return dp[i][j][k];
        for(;i+1 <= j && boxes[i+1] == boxes[i];++i,++k);
        int res = (k+1) * (k+1) + removeBoxes(boxes,i+1,j,0,dp);
        for(int m = i + 1;m <= j;++m)
            if(boxes[m] == boxes[i])
                res = max(res,removeBoxes(boxes,i+1,m-1,0,dp) + removeBoxes(boxes,m,j,k+1,dp));
        return dp[i][j][k] = res;
    }
public:
    int removeBoxes(vector<int>& boxes) {
        len = boxes.size();
        // dp[i][j][k] 表示从i到j的范围有k个相同颜色的数字在i的前面，并且下标i的颜色也与它们相同
        vector<vector<vector<int>>> dp(len+1,vector<vector<int>>(len+1,vector<int>(len+1,0)));
        return removeBoxes(boxes,0,len-1,0,dp);
    }
};
```