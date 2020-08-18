---
title: "Leetcode每日一题(4)"
date: 2020-08-18T10:54:23+08:00
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
- 链表
- 递归
- 分治
- 平衡二叉树
series:
- leetcode
- 算法
categories:
-
---



#### [109. 有序链表转换二叉搜索树](https://leetcode-cn.com/problems/convert-sorted-list-to-binary-search-tree/)

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



