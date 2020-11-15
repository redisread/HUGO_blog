---
title: "Leetcode Problem Solve"
date: 2020-11-15T00:04:50+09:00
publishDate: 2020-11-15
description:
enableToc: true
enableTocContent: false
tags:
-
series:
-
categories:
-
---


## [546. 移除盒子](https://leetcode-cn.com/problems/remove-boxes/)

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




## [5490. 吃掉 N 个橘子的最少天数](https://leetcode-cn.com/problems/minimum-number-of-days-to-eat-n-oranges/)

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



## [743. 网络延迟时间](https://leetcode-cn.com/problems/network-delay-time/)

有 `N` 个网络节点，标记为 `1` 到 `N`。

给定一个列表 `times`，表示信号经过**有向**边的传递时间。 `times[i] = (u, v, w)`，其中 `u` 是源节点，`v` 是目标节点， `w` 是一个信号从源节点传递到目标节点的时间。

现在，我们从某个节点 `K` 发出一个信号。需要多久才能使所有节点都收到信号？如果不能使所有节点收到信号，返回 `-1`。

 

**示例：**

![img](https://assets.leetcode.com/uploads/2019/05/23/931_example_1.png)

```
输入：times = [[2,1,1],[2,3,1],[3,4,1]], N = 4, K = 2
输出：2
```

 

**注意:**

1. `N` 的范围在 `[1, 100]` 之间。
2. `K` 的范围在 `[1, N]` 之间。
3. `times` 的长度在 `[1, 6000]` 之间。
4. 所有的边 `times[i] = (u, v, w)` 都有 `1 <= u, v <= N` 且 `0 <= w <= 100`。

### 分析

本题为一个图算法题，两点之间的时间可以抽象成路程，那么本题相当于求某一点到其他各点的最短路径，然后求出各点最短路径的最大值。

常见的最短路问题分为两类：**单源最短路**和**多源最短路**。前者只需要求一个**固定的起点**到各个顶点的最短路径，后者则要求得出**任意两个顶点**之间的最短路径。

## Dijkstra算法

Dijkstra(迪杰斯特拉)算法是典型的**单源最短路径算法**，用于计算一个节点到其他所有节点的最短路径。主要特点是以起始点为中心向外层层扩展，直到扩展到终点为止。算法主要的思想是**贪心法**。

**适用范围**

- 1、不能处理负权边或环
- 2、可以处理正权边
- 3、可以处理无向图和有向图

**使用步骤**

1. 初始化邻接矩阵
2. 初始化还未确定最短路径的节点列表
3. 双重循环：
   最外层为除源点之外的其他节点的遍历
   里面为遍历和更新未确定距离的节点列表的遍历
   3.1、从还未确定最短路径的节点列表中找出距离源点最近的节点
   3.2、更新还未确定最短路径的节点列表
   3.3、根据找到的这个最短路径节点，更新每一个还未确定最短路径的节点到源点的距离
4. 根据题目要求计算结果

## Floyd算法

Floyd算法是一个经典的**动态规划**算法。是解决**任意两点间的最短路径**(称为多源最短路径问题)的一种算法，可以正确处理有向图或负权的最短路径问题。

其核心思想就是从任意节点u到任意节点v的最短路径有2种：

- 是直接从u到v
- 是从u经过若干个节点k到v

所以，我们假设graph(u,v)为节点u到节点v的最短路径的距离(当然，不同的题目代表的不一样，比如有的可能是花费，需要灵活变通)，对于每一个节点k(1~N个节点)，我们检查graph(u,k) + graph(k,v) < graph(u,v)是否成立，如果成立，证明从u到k再到v的路径比u直接到v的路径短，我们便设置graph(u,v) = graph(u,k) + graph(k,v)，当我们遍历完所有节点k，graph(u,v)中记录的便是u到v的最短路径的距离。

**适用范围**

- 1、可以处理负权边
- 2、不能处理负权环
- 3、可以处理无向图和有向图

**使用步骤**

1. 初始化邻接矩阵

2. 三重循环：

   >   最外层为中间节点k的遍历
   >   里面两层分别为节点u和节点v的遍历

   

   2.1、根据k为中间跳节点更新(u, v)的最短距离

3. 根据题目要求计算结果



### 代码

**Dijkstra算法**

```cpp
class Solution {
public:
    int networkDelayTime(vector<vector<int>>& times, int N, int K) {
        const int INF = 102;
        vector<vector<int>> graph(N+1,vector<int>(N+1,INF));
        for(auto& v:times) graph[v[0]][v[1]] = v[2];
        vector<int> dist(N + 1,INF);
        vector<bool> st(N + 1,false);
        // 设置起始点
        dist[K] = 0;
        for(int i = 1;i < N;++i)    // 外层循环N-1次
        {
            int t = -1;
            int tmin = INF;
            for(int j = 1;j <= N;++j)
            {
                // 从还未确定最短路径的节点列表中找出距离源点最近的节点
                if(!st[j] && (dist[j] < tmin))
                {
                     t = j;
                     tmin = dist[j];
                }
            }
            st[t] = true;   // 标记确定最短路径

            // 用t更新其他点的距离
            for(int j = 1;j <= N;++j)
                dist[j] = min(dist[j],dist[t] + graph[t][j]);

        }
        int r = *max_element(dist.begin() + 1,dist.end());
        return r == INF ? -1:r;
    }
};
```

**Floyd算法**(十分暴力)

```cpp
int Floyd(vector<vector<int>>& times, int N, int K)
    {
         const int INF = 102;
        vector<vector<int>> dist(N+1,vector<int>(N+1,INF));
        for(int i = 1;i <= N;++i) dist[i][i] = 0;
        for(auto& v:times) dist[v[0]][v[1]] = min(dist[v[0]][v[1]],v[2]);
        for(int k = 1;k <= N;++k)
            for(int i = 1;i <= N;++i)
                for(int j = 1;j <= N;++j)
                    if(i != j)
                        dist[i][j] = min(dist[i][j],dist[i][k]+dist[k][j]);
        int r = 0;
        for(int i = 1;i <= N;++i)
            r = max(r,dist[K][i]);
        return r == INF?-1:r;  
    }
```

**堆优化版的Dijkstra算法**

```cpp
class Solution {
public:
    int networkDelayTime(vector<vector<int>>& times, int N, int K) {
        const int INF = 0x3f3f3f3f;
        typedef pair<int, int> PII; // first:距离; second: 几号点
        vector<bool> st(N+1, false); // 是否已得到最短距离
        vector<int> dist(N+1, INF); // 距离起始点的最短距离
        unordered_map<int, vector<PII>> graph; // 邻接表；u->v,权重w
        priority_queue<PII, vector<PII>, greater<PII>> heap; // 小顶堆；维护到起始点的最短距离和点

        for (auto &t: times){ // 初始化邻接表
            graph[t[0]].push_back({t[2],t[1]});
        }
        heap.push({0, K});
        dist[K] = 0;
        while(heap.size()){
            auto t = heap.top();
            heap.pop();
            int ver = t.second, distance = t.first;
            if (st[ver]) continue; // 之前更新过，是冗余备份
            st[ver] = true;
            for (auto &p: graph[ver]){
                if (dist[p.second] > distance + p.first){ // 用t去更新其他点到起始点的最短距离
                    dist[p.second] = distance + p.first;
                    heap.push({dist[p.second], p.second});
                }
            }
        }
        int ans = *max_element(dist.begin()+1, dist.end());
        return ans == INF ? -1: ans;
    }
};
```



---

参考链接：

1. [学图论，你真的了解最短路吗？](https://www.luogu.com.cn/blog/FrozaFerrari/xue-tu-lun-ni-zhen-di-liao-xie-zui-duan-lu-ma-post)
2. [https://leetcode-cn.com/problems/network-delay-time/solution/csetban-dui-you-hua-dijkstra-by-ray-152/](https://leetcode-cn.com/problems/network-delay-time/solution/csetban-dui-you-hua-dijkstra-by-ray-152/)



## [109. 有序链表转换二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-list-to-binary-search-tree/)

给定一个单链表，其中的元素按升序排序，将其转换为高度平衡的二叉搜索树。

本题中，一个高度平衡二叉树是指一个二叉树*每个节点* 的左右两个子树的高度差的绝对值不超过 1。

**示例:**

```
给定的有序链表： [-10, -3, 0, 5, 9],

一个可能的答案是：[0, -3, 9, -10, null, 5], 它可以表示下面这个高度平衡二叉搜索树：

      0
     / \
   -3   9
   /   /
 -10  5
```

### 分析

构建一个平衡二叉树的关键就是左右子树的高度差不超过1，那么**我们可以每次取链表中间的节点作为当前子树的根节点，然后递归链表左边的子链表和右边的子链表进行递归求解**。

### 代码

```cpp
class Solution {
public:
    TreeNode* sortedListToBST(ListNode* head) {
        if(head == nullptr) return nullptr; // 空链表情况
        if(head->next == nullptr)   // 链表长度为1
        {
            TreeNode *tt = new TreeNode(head->val);
            return tt;
        }
        ListNode *slow = head;
        ListNode * fast = head;
        ListNode *slow_pre = nullptr;
        // 下面快慢指针找到链表的中间节点
        while(fast->next && fast->next->next)
        {
            slow_pre = slow;
            slow = slow->next;
            fast = fast->next->next;
        }
        TreeNode *t;
        // 判断并且递归求解
        if(slow_pre == nullptr)
        {
            t = new TreeNode(slow->next->val);
            slow->next = nullptr;
            t->left = sortedListToBST(head);
            t->right = nullptr;
        }
        else
        {
            t = new TreeNode(slow->val);
            slow_pre->next = nullptr;
            t->left = sortedListToBST(head);
            t->right = sortedListToBST(slow->next);
        }
        return t;
    }
};
```

![result](https://i.loli.net/2020/08/18/2B5XqcGdxLRpkZv.png)



## [647. 回文子串](https://leetcode-cn.com/problems/palindromic-substrings/)

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

## [28. 实现 strStr()](https://leetcode-cn.com/problems/implement-strstr/)

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




## [459. 重复的子字符串](https://leetcode-cn.com/problems/repeated-substring-pattern/)

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



