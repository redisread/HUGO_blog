---
title: "Claude Code 发布 /workflows：用代码取代 LLM 编排器，终结多智能体"token 税""
subtitle: Anthropic 在 Claude Code 2.1.147 中悄悄推出的重大更新，可能改变多智能体系统的构建方式
date: 2026-05-23T01:12:30Z
publishDate: 2026-05-23T01:12:30Z
aliases:
description: Anthropic 在 Claude Code 2.1.147 中发布 /workflows 功能，用代码编排取代 LLM 编排器，解决多智能体系统的"token 税"问题，实现子智能体输出直接流转、主上下文零污染。
image: "https://cos.jiahongw.com/rss-daily/20260523/cover.png"
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h1","h2", "h3", "h4"]
libraries: [katex, mathjax, mermaid, chart, flowchartjs, msc, viz, wavedrom]
tags: ["Claude Code", "AI", "workflows", "multi-agent", "orchestration", "token optimization"]
series: []
categories: ["技术"]
---

![Claude Code Workflows 封面](https://cos.jiahongw.com/rss-daily/20260523/cover.png)

<!--more-->

## 核心观点

Anthropic 在 Claude Code 2.1.147 版本中悄悄发布了 `/workflows` 功能，这可能是多智能体系统构建方式的重大转变。

传统模式是：一个主智能体（LLM）决定派生哪些子智能体，保存每个中间结果，规划下一步。**问题是：每个子智能体的结果都会重新进入编排器的上下文。** 启动 10 个子智能体，主会话就要支付"token 税"——随着上下文窗口被填满，变得越来越混乱和健忘。

`/workflows` 用**代码取代 LLM 编排器**。你定义一个 `workflow.js` 文件，子智能体输出直接从一阶段流向下一阶段，从不触碰主上下文窗口。

**关键收益：**
- **结构化输出阶段**（可预测的输出模式）
- **并行扇出 + 流式管道**
- **条件、循环和预算控制（真实 JS）**
- **失败自动重试**
- **通过 `/workflows` 实时查看进度**
- **后台运行工作流，主会话保持空闲**

---

## 深度分析：为什么传统多智能体模式会崩溃

### 1. "Token 税"：被忽视的隐形成本

![Token 税概念图](https://cos.jiahongw.com/rss-daily/20260523/img-01.png)

在 Claude Code 的 Agent View、Subagents 和 Agent Teams 中，存在一个被官方文档轻描淡写却致命的问题：**每个子智能体的输出都会回流到主会话的上下文窗口**。

根据 [CloudZero 的分析报告](https://www.cloudzero.com/blog/claude-code-agents/)，Anthropic 官方文档中有一句话被大多数开发者忽略：

> "rate limits apply: background sessions draw down your subscription usage the same as interactive sessions, so running ten agents in parallel uses quota ten times faster"

**实际成本计算：**

| 场景 | 会话数 | 预估日成本 | 月成本（20天） | 所需套餐 |
|------|--------|-----------|--------------|----------|
| 独立开发者，常规工作流 | 1 | ~$13 | ~$260 | Pro ($20/月) |
| 3 个并行智能体 | 3 | ~$30-40 | ~$600-800 | Max 5x ($100/月) |
| 5-10 个智能体 | 5-10 | ~$50-130 | ~$1,000-2,600 | Max 20x ($200/月) |
| 10 人团队，每人 3 个智能体 | 30 | ~$300-400 | ~$6,000-8,000 | Enterprise |

更糟的是**上下文污染**。当子智能体返回结果时，这些结果（可能包含数千 token 的代码、日志、搜索结果）全部涌入主会话。主智能体从"清晰的架构师"变成"被信息淹没的救火队员"。

### 2. LLM 编排器的根本缺陷

传统模式依赖 LLM 作为编排器，存在三个结构性问题：

**非确定性决策**：每次子智能体完成，LLM 都要决定下一步做什么。这个决策是概率性的——同样的输入可能产生不同的执行路径。

**状态管理脆弱**：LLM 必须在上下文窗口中"记住"所有中间结果。但上下文窗口是有限的，而且 LLM 的注意力机制会遗忘早期信息。

**无法真正并行**：虽然子智能体可以并行运行，但它们的**结果必须串行回流**到主会话。10 个并行任务完成后，主会话要依次处理 10 份结果报告。

### 3. /workflows 的架构革新

![代码编排 vs LLM 编排](https://cos.jiahongw.com/rss-daily/20260523/img-02.png)

`/workflows` 的核心洞察是：**用代码定义工作流，而不是让 LLM 即兴编排**。

**传统模式（LLM 编排）：**
```
用户 → 主 LLM → 子智能体 A → 结果回流 → 主 LLM 决策 → 子智能体 B → 结果回流...
```

**Workflows 模式（代码编排）：**
```
用户 → workflow.js → 阶段 1 → 阶段 2 → 阶段 3 → 输出
                ↓         ↓         ↓
           [并行子智能体] [并行子智能体] [并行子智能体]
```

关键差异：
- **子智能体输出直接流向下一阶段**，不经过主上下文
- **阶段间通过结构化数据传递**，不是自然语言描述
- **控制流由代码定义**，不是 LLM 即兴决策

---

## 可实践建议：何时使用 /workflows

| 场景 | 推荐方案 | 原因 |
|------|----------|------|
| 独立任务，无需协调 | Agent View (`claude agents`) | 简单并行，无依赖 |
| 可重复的工作流 | Subagents | 定义一次，多次复用 |
| 需要讨论和协作的复杂任务 | Agent Teams | 智能体间直接通信 |
| **结构化多阶段流水线** | **/workflows** | **代码定义，零上下文污染** |
| 大规模批量处理 | `/batch` | 自动分解，独立 worktree |

### 实践建议表格

| 问题 | 传统方案 | /workflows 方案 |
|------|----------|-----------------|
| 上下文溢出 | 手动清理、重启会话 | 子智能体输出不回流 |
| 执行不确定 | 依赖 LLM 决策 | 代码定义确定性流程 |
| 成本失控 | 难以预测 token 消耗 | 阶段预算可控 |
| 调试困难 | 黑盒 LLM 决策 | 可查看 workflow.js 和执行日志 |
| 复用性差 | 每次重新描述流程 | YAML/JS 文件可版本控制 |

---

## 相关资源与引用

### 官方文档
- [Claude Code 官方文档](https://code.claude.com/)
- [Subagents 文档](https://code.claude.com/docs/en/sub-agents)
- [Agent Teams 文档](https://code.claude.com/docs/en/agent-teams)
- [Agent View 文档](https://code.claude.com/docs/en/agent-view)

### 社区分析
- [Claude Code Agents 成本分析 - CloudZero](https://www.cloudzero.com/blog/claude-code-agents/)
- [Claude Code 并行智能体编排指南](https://joeyyu23.github.io/claude-code-handbook/en/book2-advanced/06-parallel-agents)
- [ClaudeFast Agent Teams 使用指南](https://claudefa.st/blog/guide/agents/agent-teams)

### Reddit 讨论
- [Claude Code dropped /workflows - r/ClaudeCode](https://www.reddit.com/r/ClaudeCode/comments/1tkjy4u/claude_code_dropped_workflows/)
- [/remote-control is a window into what the future is going to be like](https://www.reddit.com/r/ClaudeCode/comments/1tkv87g/remotecontrol_is_a_window_into_what_the_future_is/)

### 相关技术
- [GitHub - anthropics/claude-code](https://github.com/anthropics-claude/claude-code)
- [Claude Multi-Agent Orchestration Patterns](https://claudeguide.io/claude-multi-agent-orchestration)

---

## 一句话总结

> `/workflows` 不是让 AI 更聪明地编排，而是让开发者用代码定义编排——把控制权从概率性的 LLM 手中收回，交给确定性的代码逻辑。

这是多智能体系统从"实验玩具"走向"生产工具"的关键一步。
