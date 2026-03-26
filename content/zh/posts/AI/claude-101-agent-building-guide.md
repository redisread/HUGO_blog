---
title: Claude 101：构建高效 AI Agent 的实战指南
subtitle: 基于 Anthropic 官方最佳实践，从简单 Workflow 到自主 Agent 的完整架构设计
date: 2026-03-26 13:15:00
publishDate: 2026-03-26 13:15:00
aliases: []
description: Anthropic 官方发布的 Agent 构建最佳实践，详解 Workflow 与 Agent 的区别、5种核心 Workflow 模式、工具设计黄金法则，以及从简单到复杂的完整开发路径。
image: https://cos.jiahongw.com/agent/20260326/claude-101-agent-building-guide-01-cover.png
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h2", "h3", "h4"]
libraries: []
tags: [AI, Agent, LLM, Claude, Anthropic, Workflow]
series: []
categories: [技术]
---

> 基于 Anthropic 官方最佳实践，从简单 Workflow 到自主 Agent 的完整架构设计

<!--more-->

{{< img src="https://cos.jiahongw.com/agent/20260326/claude-101-agent-building-guide-01-cover.png" title="Claude 101：构建高效 AI Agent" >}}

## 核心认知：Workflow vs Agent

Anthropic 对 agentic 系统做了关键区分：

| 类型 | 定义 | 适用场景 |
|------|------|----------|
| **Workflow** | LLM 和工具通过预定义代码路径编排 | 任务明确、流程固定的场景 |
| **Agent** | LLM 动态自主决策流程和工具使用 | 开放式问题、需要灵活应变的场景 |

**关键原则：从简单开始，只在必要时增加复杂度。**

{{< img src="https://cos.jiahongw.com/agent/20260326/claude-101-agent-building-guide-02-workflow-vs-agent.png" title="Workflow vs Agent 对比" >}}

---

## 基础构建块：增强型 LLM

所有 agentic 系统的起点都是一个具备以下能力的 LLM：

- **检索（Retrieval）**：主动生成搜索查询
- **工具使用（Tools）**：选择并调用合适工具
- **记忆（Memory）**：决定保留什么信息

**推荐方案**：使用 Model Context Protocol (MCP) 集成第三方工具生态。

---

## 5 种核心 Workflow 模式

{{< img src="https://cos.jiahongw.com/agent/20260326/claude-101-agent-building-guide-03-five-patterns.png" title="五种核心 Workflow 模式" >}}

### 1. Prompt Chaining（提示链）

将任务分解为固定步骤序列，每步 LLM 处理上一步输出。

```
输入 → LLM调用1 → 检查点 → LLM调用2 → 检查点 → 输出
```

**适用**：营销文案生成+翻译、文档大纲→正文撰写

**优势**：用延迟换精度，每步任务更简单

---

### 2. Routing（路由）

对输入分类，定向到专门的处理流程。

```
输入 → 分类器 → [分支A] 或 [分支B] 或 [分支C]
```

**适用**：客服工单分流（退款/技术支持/一般咨询）、模型路由（简单问题→Haiku，复杂问题→Sonnet）

---

### 3. Parallelization（并行化）

两种变体：

- **Sectioning**：任务拆分为独立子任务并行执行
- **Voting**：同一任务多次执行，聚合多视角结果

**适用**：内容安全审查（一个模型处理查询，另一个审查）、代码漏洞扫描（多 prompt 投票）

---

### 4. Orchestrator-Workers（编排器-工作者）

中央 LLM 动态分解任务，委派给 worker LLM，再综合结果。

**vs 并行化的区别**：子任务不是预定义的，由编排器根据输入动态决定。

**适用**：跨多文件的代码修改、多源信息搜索与整合

---

### 5. Evaluator-Optimizer（评估-优化）

一个 LLM 生成，另一个评估并提供反馈，循环迭代。

**适用信号**：
- 人类反馈能明显改善 LLM 输出
- LLM 自己能提供有效反馈

**场景**：文学翻译精修、复杂搜索的多轮迭代

---

## 自主 Agent 设计

### Agent 的核心特征

1. **自主规划**：根据环境反馈动态调整策略
2. **工具循环**：观察→决策→执行→再观察
3. **断点交互**：在关键节点暂停等待人类反馈
4. **终止条件**：任务完成或达到最大迭代次数

{{< img src="https://cos.jiahongw.com/agent/20260326/claude-101-agent-building-guide-04-architecture.png" title="Agent 架构循环" >}}

### 何时使用 Agent

| ✅ 适合 | ❌ 不适合 |
|--------|----------|
| 步骤数无法预测 | 固定流程已足够 |
| 需要灵活决策 | 成本敏感、低延迟要求 |
| 可信环境规模化任务 | 高风险、需严格控制的场景 |

---

## 工具设计的黄金法则

Anthropic 在 SWE-bench 上取得 49% 成绩的秘诀：**工具设计比提示工程更重要**

### 设计原则

1. **给模型足够 token 思考**
   - 避免让模型在输出中途"把自己逼入死角"

2. **贴近自然文本格式**
   - 使用模型在互联网文本中见过的格式

3. **消除格式开销**
   - 避免需要精确计数行数（如 diff 格式）
   - 避免大量转义（如 JSON 内嵌代码）

4. **防错设计（Poka-yoke）**
   - 示例：强制使用绝对路径避免相对路径错误

### 工具描述应包含

- 使用示例
- 边界情况处理
- 输入格式要求
- 与其他工具的清晰区分

---

## 实战建议

### 开发路径

```
单轮 LLM 调用 → 增加检索/示例 → Workflow → Agent
     ↑              ↑              ↑          ↑
   最简单        多数场景足够    需要多步骤   开放式问题
```

### 关于框架

Anthropic 的建议：**先直接用 LLM API**

- 多数模式只需几行代码
- 框架的抽象层会隐藏底层 prompts，增加调试难度
- 如果要用框架，务必理解底层实现

### 核心原则

1. **保持简单**：Agent 设计要简洁
2. **透明优先**：显式展示 agent 的规划步骤
3. **精心设计 ACI**：通过完善的工具文档和测试打造良好的 Agent-Computer Interface

---

## 典型应用场景

### 1. 客户支持 Agent
- 对话流 + 工具集成（查询订单、知识库、执行退款）
- 成功标准明确，支持人工介入

### 2. 代码 Agent
- 解决真实 GitHub Issues
- 测试验证 + 人工代码审查
- Claude 3.5 Sonnet 在 SWE-bench Verified 达到 49%

---

## 总结

构建高效 Agent 的关键不是追求复杂度，而是：

1. **从简单开始**，只在必要时增加复杂度
2. **测量性能**，用数据驱动迭代
3. **投资工具设计**，好的 ACI 比复杂的 prompt 更重要
4. **保持透明**，让 agent 的决策过程可见

> "成功的 LLM 应用不在于构建最复杂的系统，而在于构建最适合你需求的系统。"

---

*参考来源：Anthropic Engineering Blog - Building Effective Agents (2024)*
