---
title: "什么是 Agentic Engineering？"
subtitle: "当 AI 能写代码也能跑代码，开发者还剩什么？"
date: 2026-03-17T02:10:00+08:00
publishDate: 2026-03-17T02:10:00+08:00
description: "Simon Willison 提出的 Agentic Engineering 概念，定义了使用 Coding Agents 开发软件的新范式。本文深入解读其核心特征与 Vibe Coding 的本质区别。"
image: "https://openclaw.cos.jiahongw.com/blog/uploaded-image.jpg"
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
tocLevels: ["h2", "h3", "h4"]
libraries: []
tags: ["AI", "编程工具", "Agentic Engineering", "开发者效率"]
series: []
categories: ["AI"]
---

Simon Willison 最近提出了一个概念：**Agentic Engineering**——使用 Coding Agents 开发软件的实践。

这个词看起来又是一个 AI 热词，但它实际上精准地描述了我们正在进入的新阶段。

## 什么是 Coding Agent？

首先搞清楚定义。Coding Agent 是能**写代码 + 执行代码**的 Agent。

典型代表：Claude Code、OpenAI Codex、Gemini CLI。

注意：**代码执行能力**是区分普通 LLM 和 Coding Agent 的关键。

ChatGPT 也能写代码，但它只能输出代码片段。真正的 Coding Agent 能在循环中运行工具、执行代码、读取结果、再迭代。这个闭环让它能够"边写边跑"，朝着目标不断逼近。

![Agent 循环图](https://openclaw.cos.jiahongw.com/blog/agent-loop.png)

## Agent 的本质定义

AI 研究界对"什么是 Agent"争论了几十年。Simon Willison 给出了一个务实的定义：

> **Agents run tools in a loop to achieve a goal.**
> 
> Agent 是在循环中调用工具来实现目标的软件。

具体来说：你给 Agent 一个目标，它调用 LLM 生成代码，执行代码，把结果喂回 LLM，再决定下一步——直到目标达成。

这个定义简单但精确。它划清了"聊天机器人"和"Agent"的界限：**前者是单向输出，后者是闭环迭代。**

## Agentic Engineering：代码能跑了，人类干嘛？

当软件能写出可运行的代码，开发者还剩什么？

**答案是：几乎所有事情。**

写代码从来不是软件工程师的唯一工作。真正的挑战一直在于：**弄清楚该写什么代码。**

任何软件问题都有几十种潜在解决方案，每种都有取舍。我们的工作是导航这些选项，找到最适合当前场景的那一个。

Agentic Engineering 时代，人类的核心任务变成了：

1. **定义问题**——把模糊需求转化为精确目标
2. **配置工具**——给 Agent 提供它需要的上下文和能力
3. **验证迭代**——审查输出，修正方向，确保稳健

LLM 不会从过去的错误中学习，但 Coding Agent 可以——前提是我们把学到的教训写进指令和工具配置里。

## Agentic Engineering vs Vibe Coding

2025年2月，Andrej Karpathy 创造了"Vibe Coding"这个词：让 LLM 写代码，同时"忘记代码的存在"。

很多人把 Vibe Coding 扩展为"任何用 LLM 生成代码的行为"。这不对。

**Vibe Coding 的本质是：不审查的原型代码。**

它有用，但只适用于快速验证想法。而 Agentic Engineering 是：**把代码带到生产级标准。**

![Vibe Coding vs Agentic Engineering](https://openclaw.cos.jiahongw.com/blog/vibe-vs-agentic.png)

区分这两个概念很重要。我们需要一个词来描述"未经审查的 LLM 生成代码"，也需要一个词来描述"经过验证、可投入生产的 Agent 协作代码"。

Vibe Coding 是草稿，Agentic Engineering 是交付。

## 为什么这个概念重要？

因为它把"用 AI 写代码"从模糊的实践变成了可讨论的方法论。

我们不再只是"试试看 AI 能不能帮我写"。我们开始思考：

- 怎么定义问题才能让 Agent 理解？
- 怎么设计工具链才能让 Agent 高效？
- 怎么验证输出才能确保质量？
- 怎么迭代指令才能让 Agent 越来越聪明？

这些问题构成了 Agentic Engineering 的核心。

它不是一个热词，而是一个新工种的萌芽。

---

**参考**：[Agentic Engineering Patterns - Simon Willison](https://simonwillison.net/guides/agentic-engineering-patterns/what-is-agentic-engineering/)