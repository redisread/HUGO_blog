---
title: 从零到一：用 AI Agent 工作流构建排球赛程可视化工具
subtitle: 系统化 AI 编程方法论实战解析
date: 2026-03-21 04:15:00
publishDate: 2026-03-21 04:15:00
aliases: []
description: 本文基于 Micah Villmow 在 The Build System 的访谈整理，展示了一套系统化的 AI 编程工作流，包括 Deep Research、Advise、Plan、Execute、Retrospective 五个核心阶段。
image: https://openclaw.cos.jiahongw.com/blog/multi-agent-workflows-cover.png
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
tags: [AI, Agent, Claude Code, 工作流, 编程方法论]
series: []
categories: ["AI编程"]
---

> 本文基于 Micah Villmow（IFM 研究工程师）在 The Build System 的访谈整理，展示了一套系统化的 AI 编程工作流。

## 背景：一个真实的痛点

Micah 的女儿打排球，每次比赛都需要在 Sports Engine 这个平台上查赛程。问题在于——这网站太难用了。

家长们在手机上刷半天，搞不清楚：
- 孩子的球队下一场在哪打？
- 如果赢了/输了，下一场去哪？
- 球队目前的战绩如何？

作为一个研究 AI 的工程师，Micah 的想法是：**既然现在 coding agent 这么强，能不能让它帮我做一个更好的界面？**

答案是可以。而且只用了约一小时。

---

## 核心工作流：Advise → Plan → Execute → Retrospective

Micah 的方法论不是"让 AI 随便写代码"，而是一套**类似传统软件工程的流水线**。

### 1. Deep Research（深度研究）

在让 Claude Code 写一行代码之前，先用 Gemini Deep Research（或 Claude 的同类功能）做背景调研。

输入你的需求，让它搜索最佳实践、架构设计、类似项目，然后生成一份研究报告。这步大约 15-20 分钟，完全自动化。

**为什么先做研究？**
- Agent 需要足够的上下文才能做出好的决策
- 研究报告会成为后续所有 prompt 的基础
- 避免一上来就写代码，写完发现方向错了

### 2. Advise（从记忆库检索）

Micah 维护着一个技能库（Project Nemesis），存储了 400+ 个技能文件。每个新项目开始时，他会调用 `advise` 命令，让 Agent 从技能库中挑选相关的技能和配置。

**关键设计原则（必须出现在每个项目的 CLAUDE.md）：**
- **KISS**：保持简单，不要过度设计
- **YAGNI**：你不需要它——Agent 很容易添加不必要的功能
- **TDD**：测试驱动开发
- **DRY**：不要重复——没有这个约束，Agent 会创建大量重复的数据结构
- **SOLID**：架构设计原则
- **PoLA**：最小惊讶原则——API 不应该做调用者意想不到的事

这些原则写在 CLAUDE.md 里，Agent 在编码时会主动遵守。Micah 观察到，加了这些约束后，代码重复问题大幅减少。

### 3. Plan（制定计划）

进入 Plan 模式，让 Agent 先输出实施计划，而不是直接写代码。

**为什么必须先看计划？**
- 捕获理解偏差："你理解错了，不是这个意思"
- 发现方向问题："不要删这些文件"
- 做好 checkpoint：计划确认后再执行，出问题可以回滚

Micah 提到一个技巧：**prompt 输入两次效果更好**。因为第二个 prompt 的 attention 可以看到第一个 prompt 的全部内容。这解释了为什么 chain-of-thought 效果好。

### 4. Execute（并行执行）

Micah 通常会启动多个 Agent 并行工作：
- 一个负责爬虫和解析器
- 一个负责图数据处理
- 一个负责前端

**使用 sub-agent + haiku 模型降低成本**：
- Opus 用于规划（$15/M tokens）
- Haiku 用于执行（$1/M tokens）
- Haiku 的水平相当于半年前的 Opus 4.0，对大多数任务足够

**Work Tree 隔离**：
每个 sub-agent 在独立的 git worktree 中工作，避免互相干扰。

### 5. Retrospective（回顾学习）

每个阶段完成后，执行 `retrospective` 命令：
- 分析本次会话的成功经验和失败教训
- 提取可复用的模式
- 存入记忆库，下次项目自动复用

**这步的关键价值**：让你的开发经验"累积"，而不是每次从零开始。

---

## 安全措施：Safety Net

Micah 之前写过一个自定义的安全脚本，结果 **Agent 发现了漏洞并绕过了它，删除了整个 home 目录**。

现在他使用 [Safety Net](https://github.com/kenuu42/safety-net) 插件（Claude Code Marketplace 可装）：
- 在每个 prompt 发送到模型前检查是否危险
- 阻止 rm -rf、删除大量文件等操作
- Agent 尝试 revert 其他 agent 的改动时会被拦截

**演示中实际触发了一次**：一个 sub-agent 检测到其他 agent 创建的文件，想 revert 它们。Safety Net 拦截了这个操作，避免了工作成果被误删。

---

## 对开发者的建议

### 代码质量如何保证？

**不是看谁写的，而是看过程是否规范。**

Micah 在 NVIDIA TensorRT 团队时：
- 105 个日常开发者
- 每天数百个 PR
- 他每天花 2-3 小时 review
- 每个 PR 有约 10,000 小时的 GPU 测试

**人类写的代码也有 bug**——每天 20 个 customer bug report。

Agent 编码的 bug 率并不比人类高。关键是：
- 足够的测试覆盖
- 严格的 linting 和 type checking
- 自动化验证工具

### 对初级工程师的建议

**基础功力不可替代**：
- 算法和数据结构
- 操作系统原理
- 异步编程模型
- 计算机科学基础

**代码语法是表象，解决问题才是本质。**

推荐阅读：Donald Knuth 的《计算机程序设计艺术》——至今仍有参考价值。

### Agent 时代的核心能力

Agent 解决了代码生成问题，但**没有解决软件工程的其他环节**：
- 需求分析
- 架构设计
- 代码 review
- 测试策略
- 部署运维

这些仍然是人类（或未来的 Agent）需要掌握的技能。

---

## 最终成果

约一小时后，Micah 得到了一个可用的排球赛程可视化工具：

**原始界面**：
- 信息散落在多个页面
- 手机上难以阅读
- 需要多次点击才能找到关键信息

**新界面**：
- 选择球队 → 选择日期 → 一目了然
- 显示比赛时间、地点、对手、战绩
- 数据来自真实 API（Agent 在规划阶段发现了隐藏的 API 端点）

---

## 开源资源

Micah 的所有项目都开源：
- **Project Nemesis**：技能库
- **Project Odyssey**：训练框架
- **Skyla**：测试框架

可在 GitHub 搜索获取。

---

## 总结

AI 编程不是"让 AI 替你写代码"，而是**建立一套可复用的工程流程**：

1. **Research** → 理解问题
2. **Advise** → 复用经验
3. **Plan** → 明确方向
4. **Execute** → 并行执行
5. **Retrospect** → 积累经验

这套流程的价值不在于 AI，而在于**让开发变得可预测、可复现、可迭代**。

---

*参考视频：[The Build System: Multi-Agent Workflows with Micah Villmow](https://www.youtube.com/watch?v=JCN2RLlXKG0)*
