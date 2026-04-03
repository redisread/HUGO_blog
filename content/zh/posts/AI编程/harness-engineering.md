---
title: "harness-engineering"
subtitle: 
date: 2026-04-03T14:17:28+08:00
publishDate: 2026-04-03T14:17:28+08:00
aliases:
description:
image: harness-engineering-cover.png
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner # outer
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h1","h2", "h3", "h4"]
libraries: [katex, mathjax, mermaid, chart, flowchartjs, msc, viz, wavedrom]
tags: []
series: []
categories: []
---


# Harness Engineering：AI 时代的工程化新范式

![Harness Engineering Cover](https://cos.jiahongw.com/agent/20260403/harness-engineering-cover.png)

> 从 Prompt Engineering 到 Context Engineering，再到 Harness Engineering——AI 工程化正在进入"系统管控"的新阶段。

当 AI 大模型市场规模持续攀升，2024 年中国市场已达 294 亿元，预计 2026 年突破 700 亿元时，AI 技术的狂飙突进并未完全转化为企业可落地的生产力。多数 AI 项目仍停留在"Demo 惊艳、落地艰难"的困境。

背后的核心症结是：**AI 开发缺乏标准化、体系化的工程化支撑**。

而 Harness Engineering（驾驭工程）的出现，正是为了破解这一困局。

---

## Harness Engineering 的四大支柱

### 一、搭建隔离式运行环境

通过沙箱隔离与资源管控，避免 AI 错误操作污染生产环境：

- 为每个任务分配独立的临时文件系统、容器或虚拟机
- 限制网络访问权限（白名单机制）
- 设置 CPU、内存、时间上限等资源配额
- 构建标准化的算力适配层，兼容国产与国外算力生态

### 二、构建标准化工具链

- 整合 AI 开发全流程工具（数据清洗、模型训练、微调、部署、监控）
- 封装标准化 API 接口（OpenAPI/Swagger）
- 预置代码执行器、数据库连接器、UI 自动化控制器等常用工具库
- 搭建协同平台，打破"各自为战"的局面

### 三、建立闭环反馈与自愈机制

通过 **Plan-Act-Observe-Reflect-Correct** 循环实现 AI 的自我纠错：

![Feedback Loop](https://cos.jiahongw.com/agent/20260403/harness-engineering-illustration-03-feedback-loop.png)

1. **PLAN** - AI 生成执行计划
2. **ACT** - 执行工具调用
3. **OBSERVE** - 捕获结果和日志
4. **REFLECT** - 分析成功/失败
5. **CORRECT** - 调整并重试

建立错误复盘机制，让 AI 永不犯同类错误。

### 四、完善可观测性与合规管控

- **全链路追踪**：记录 AI 每一步的思考链、工具调用参数及返回值
- **人类介入点**：在删除数据、发布生产代码等关键决策节点强制人工审批
- **多层级校验**：格式校验、业务规则校验、语法检测、安全过滤、违规拦截
- **核心指标监控**：任务成功率、平均修复时间、Token 消耗成本、异常频率

---

## 前沿探索：Meta-Harness

Stanford 的最新研究提出了 **Meta-Harness**——一种自动优化 Harness 的"外循环"系统。

**核心洞察**：Harness 已经复杂到人类无法手动优化。传统优化器只看最终分数（如"准确率 0.8"），但 Meta-Harness 需要**丰富的执行级 traces**——看到 bash 命令在哪里失败，为什么记忆检索拿到无用片段。

**Filesystem-as-Feedback**：把文件系统当实验数据库，记录完整历史：
- 完整源代码
- 性能分数（准确率、token 成本）
- 执行 traces（原始提示、工具调用、状态更新）

**Agentic Proposer**（Claude Code）通过搜索历史、诊断失败、提出新代码、评估、更新的循环，自动迭代优化 Harness。

一个关键发现：在 Terminal-Bench 实验中，优化后的 Harness 在初始调用就塞入环境快照（工作目录、可用语言、包管理器等），**消除了 2-4 轮探索，模型立即开始生产性工作**。

---

## 决策痕迹：企业级 Harness 的下一个 frontier

Foundation Capital 提出了 **Context Graphs（决策图谱）**的概念：

消费互联网巨头（Google、Meta、Netflix）用 20 年构建了基于"行为信号"的复合循环。但企业软件一直缺少这个——**只记录结果（折扣数字、合同条款），不记录决策过程**（为什么给这个折扣、哪些备选方案被否决）。

现在 Agent 改变了游戏：每次人类修改 Agent 的提案，**隐性知识就变成了结构化信号**。从"可搜索"到"可学习"，从"检索"到"预测"。

关键问题：**你在写路径（write path）还是读路径（read path）？**

- Salesforce、Snowflake 们在读路径
- 创业公司的机会在写路径——执行工作流时捕获理由，作为一等记录

---

## 给实践者的建议

### 如果你是 AI 项目负责人

1. 不要只关注模型能力，**工程化体系**才是规模化落地的关键
2. 建立**沙箱环境**，防止 AI 错误操作污染生产
3. 设计**反馈闭环**，让 AI 能从错误中学习并自我纠正
4. 记录**决策痕迹**，不只是结果数据
5. 设置**人类介入点**和**资源上限**，避免"5 万美元账单"事故

### 如果你是开发者

1. 从"写提示词"转向"**设计环境、制定规则、搭建反馈闭环**"
2. 把 Harness 当作**代码优化问题**，不只是提示工程
3. 记录**完整的执行 traces**，不只是最终分数
4. 设计**可搜索的实验日志结构**

### 如果你是创业者

1. **垂直领域决策图谱**是巨大机会——法律、保险、医疗、金融
2. 关键问题：你坐在写路径还是读路径？
3. 必须解决**权限化推理**——企业数据敏感，信任是复合资产
4. **Harness 优化工具**是下一个基础设施层机会

---

## 结语

Harness Engineering 标志着 AI 工程化从"单点优化"进入"系统管控"的新阶段。

它不仅是技术问题，更是**组织能力的重构**：
- 工程师角色从"写代码、写提示词"转向"设计环境、制定规则、搭建反馈闭环"
- 企业从"各自为战"转向"协同作战"
- 知识从"在个人脑中"变成"在机构层面复合"

当消费巨头用 20 年证明了复合信号的价值，企业级 Harness 的复合循环才刚刚开始。

**The harness is the Operating System for the LLM.**

而 Harness Engineering，就是构建这个操作系统的方法论。

---

*本文参考了以下资料：*
- *Waylau: Harness Engineering 让 AI 项目工程化*
- *Stanford: Meta-Harness - Automated model harness optimization*
- *Foundation Capital: Context Graphs - AI's trillion dollar opportunity*
- *Blockchain Capital: Compound Intelligence*
