---
title: "Leetcode每日一题(3)"
date: 2020-08-17T23:18:31+08:00
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
- Dijikstra
- Floyd
- 最短路径
- 图论
- leetcode
series:
- leetcode
- 算法
categories:
-
---



#### [743. 网络延迟时间](https://leetcode-cn.com/problems/network-delay-time/)

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

#### Dijkstra算法

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

#### Floyd算法

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