---
title: "Huffman Tree是如何编码的？"
date: 2020-11-18T12:00:27+08:00
description: 哈夫曼编码算法用字符在文件中出现的频率表来建立一个用0，1串表示各字符的最优表示方式。
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: Victor
authorEmoji: 👻
image: https://i.loli.net/2020/11/18/HIZ8cLu1Flqo7ES.png
libraries:
- katex
- mathjax
tags:
- huffman
series:
- AlgorithmStructure
categories:
-
---



哈夫曼编码算法用字符在文件中出现的频率表来建立一个用0，1串表示各字符的最优表示方式。给出现频率高的字符较短的编码，出现频率较低的字符以较长的编码，可以大大缩短总码长。

#### Huffman Coding两个步骤

1. 编码(从输入的字符数据构建一颗哈夫曼树，并将字符串转化位01编码)
2. 解码(遍历哈夫曼树将01编码转化为字符)



#### 构建哈夫曼树的过程

1. 计算输入数据的每一个字符的出现频率。
2. 从**最小堆**中提取两个频率最小的字符。
3. 创建一个频率等于两个节点频率之和的新内部节点。使第一个提取的节点为其左子节点，另一个提取的节点为其右子节点。将此节点添加到最小堆中。
4. 重复step2和step3直到最小堆为空。

假如有如下几个字母及它们出现的次数(频率):

| 字符 | 字数 |
| :--: | :--: |
|  a   |  5   |
|  b   |  4   |
|  c   |  3   |
|  d   |  2   |
|  e   |  1   |



在线演示霍夫曼树的构建：<https://people.ok.ubc.ca/ylucet/DS/Huffman.html>

![演示过程](https://i.loli.net/2020/11/16/XtdGbjk6lJciuzZ.png)

#### C++使用STL实现

```cpp
// C++ program for Huffman Coding 
#include <bits/stdc++.h> 
using namespace std; 

// A Huffman tree node 
struct MinHeapNode { 

	// One of the input characters 
	char data; 

	// Frequency of the character 
	unsigned freq; 

	// Left and right child 
	MinHeapNode *left, *right; 

	MinHeapNode(char data, unsigned freq) 

	{ 

		left = right = NULL; 
		this->data = data; 
		this->freq = freq; 
	} 
}; 

// For comparison of 
// two heap nodes (needed in min heap) 
struct compare { 

	bool operator()(MinHeapNode* l, MinHeapNode* r) 

	{ 
		return (l->freq > r->freq); 
	} 
}; 

// Prints huffman codes from 
// the root of Huffman Tree. 
void printCodes(struct MinHeapNode* root, string str) 
{ 

	if (!root) 
		return; 

	if (root->data != '$') 
		cout << root->data << ": " << str << "\n"; 

	printCodes(root->left, str + "0"); 
	printCodes(root->right, str + "1"); 
} 

// The main function that builds a Huffman Tree and 
// print codes by traversing the built Huffman Tree 
void HuffmanCodes(char data[], int freq[], int size) 
{ 
	struct MinHeapNode *left, *right, *top; 

	// Create a min heap & inserts all characters of data[] 
	priority_queue<MinHeapNode*, vector<MinHeapNode*>, compare> minHeap; 

	for (int i = 0; i < size; ++i) 
		minHeap.push(new MinHeapNode(data[i], freq[i])); 

	// Iterate while size of heap doesn't become 1 
	while (minHeap.size() != 1) { 

		// Extract the two minimum 
		// freq items from min heap 
		left = minHeap.top(); 
		minHeap.pop(); 

		right = minHeap.top(); 
		minHeap.pop(); 

		// Create a new internal node with 
		// frequency equal to the sum of the 
		// two nodes frequencies. Make the 
		// two extracted node as left and right children 
		// of this new node. Add this node 
		// to the min heap '$' is a special value 
		// for internal nodes, not used 
		top = new MinHeapNode('$', left->freq + right->freq); 

		top->left = left; 
		top->right = right; 

		minHeap.push(top); 
	} 

	// Print Huffman codes using 
	// the Huffman tree built above 
	printCodes(minHeap.top(), ""); 
} 

// Driver program to test above functions 
int main() 
{ 

	char arr[] = { 'a', 'b', 'c', 'd', 'e', 'f' }; 
	int freq[] = { 5, 9, 12, 13, 16, 45 }; 

	int size = sizeof(arr) / sizeof(arr[0]); 

	HuffmanCodes(arr, freq, size); 

	return 0; 
} 

// This code is contributed by Aditya Goel 
```

![](https://i.loli.net/2020/11/18/HJTpWPEx6vCwdX1.png)

---

Reference:

1. [哈夫曼编码的理解(Huffman Coding)](https://zhuanlan.zhihu.com/p/75048255)
2. [哈夫曼编码](https://sites.google.com/a/chaoskey.com/algorithm/04/04)
3. [Huffman Coding | Greedy Algo-3](https://www.geeksforgeeks.org/huffman-coding-greedy-algo-3/)





