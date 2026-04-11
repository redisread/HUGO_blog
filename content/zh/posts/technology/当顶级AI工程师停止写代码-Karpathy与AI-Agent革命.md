---
title: "当顶级AI工程师停止写代码：Karpathy与AI Agent革命"
subtitle: "OpenAI联合创始人的工作方式转变揭示了软件行业的结构性重组"
date: 2026-03-25T10:30:00+08:00
publishDate: 2026-03-25T10:30:00+08:00
aliases:
description: "OpenAI联合创始人Andrej Karpathy从2025年12月起不再亲手编写代码，将80%以上的编程工作交给AI Agent处理。这一转变背后，是软件行业正在经历的深刻变革——从个人编码能力转向AI编排能力。"
image: "https://cos.jiahongw.com/rss-daily/20260325/cover.png"
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
tags: ["AI Agent", "Claude Code", "Vibe Coding", "软件工程", "OpenAI", "Karpathy"]
series: ["RSS Daily"]
categories: ["技术"]
---

![AI Agent革命与软件工程师的未来](https://cos.jiahongw.com/rss-daily/20260325/cover.png)

## 核心观点：从键盘到指挥台

**Andrej Karpathy 从 2025 年 12 月起就再也没亲手写过一行代码。**

这位 OpenAI 联合创始人、前 Tesla AI 总监，在 No Priors Podcast 上公开表示，他现在把八成以上的编码工作交给 AI Agent 处理，自己则处于一种他称之为「AI 狂热症」（AI psychosis）的状态——必须站在技术最前沿，看到 Twitter 上其他人的项目时会感到焦虑。

这件事之所以值得认真讨论，不只因为他的身份，而是因为背后有硬数据支撑：

- **史丹佛数位经济实验室** 2025 年 8 月发表的研究，分析了 ADP 数百万笔薪资纪录，发现 **22 到 25 岁软件开发者的就业人数自 2022 年底以来下降了将近 20%**
- **美国劳工统计局** 资料显示，**2023 到 2025 年间程序员整体就业人数下降了 27.5%**

软件工程这个行业正在经历一场结构性的重组，而 Karpathy 的个人经历恰好是这场重组最前线的切片。

---

## 深度分析：五个维度的变革

### 1. 从拉小提琴到拿指挥棒：宏观动作的崛起

Karpathy 在访谈里描述的工作方式，已经跟多数人理解的「写程序」完全不同了。

他在大屏幕上同时跑多个 AI 编码代理（主要是 Claude Code 和 Codex），每个代理被分配一个大约 20 分钟能处理完的任务。他自己在这些平行工作流之间快速切换，负责**拆解任务、下达指令、审核输出**。

Peter Steinberger（OpenClaw 前身 Clawdbot 的开发者）的工作模式更极端。他同时指挥十几个代理进行高强度并行开发，每个代理就像一个不会累的初阶工程师。

![从演奏者到指挥者的转变](https://cos.jiahongw.com/rss-daily/20260325/img-01.png)

这里的转变可以用一个比喻说清楚：以前工程师是交响乐团里拉小提琴的乐手，每天在练指法、磨音准。现在系统要你放下琴，站上指挥台，去统领一整个虚拟乐团。**能力需求从「写出好代码」变成「拆解问题、分配任务、审核产出」**。

Karpathy 自己的说法是，这是一个「skill issue」——瓶颈不再是算力或服务器，而是人类分配和审核 AI 产出的带宽。

### 2. 焦虑的性质变了：从缺算力到缺人类带宽

过去十年，顶尖工程师最缺的是算力。抢显卡、排队等 GPU 集群、为 server 资源焦虑，这是常态。但现在的情况倒过来了。

如果你订阅了高阶 AI 服务（像 Claude Max 或 ChatGPT Pro），理论上你有接近无限的推理能力。**真正的瓶颈变成了「吞吐量」**——你一天能让 AI 为你生成多少行代码、处理多少个任务。

这群顶尖开发者的逻辑是：如果一天结束时你的 token 消耗量不够大，代表你没有充分利用 AI 的产能。系统里唯一的效能瓶颈，变成了那个需要睡觉、吃饭、反应速度有限的人类大脑。

这催生了业界所谓的「新技能危机」。做不出好产品不再是因为缺资源，纯粹是因为你驾驭 AI Agent 的能力不够。

### 3. Dobby 家庭管家：当 AI 接管物理空间

Karpathy 把代理能力从软件开发延伸到了日常生活。他建了一个家庭 AI 管家，取名 Dobby（哈利波特里的家庭小精灵）。

一个具体例子：Karpathy 随口问了一句「Dobby 你能找到我家的 Sonos 音响吗？」AI 没有叫他打开手机 APP 或输入 IP 地址。它直接在后台写了一段 Python 脚本，扫描整个家庭局域网，找到音响，发现它没有密码保护，然后自动从网上爬取开发文件，逆向工程找出所有控制 API。

**等 Karpathy 反应过来的时候，音乐已经在书房响起了。**

后来 Dobby 接管了家里的灯光、空调、泳池，甚至安防系统。在安防方面，它不用传统的红外动作传感器，而是直接接入视觉模型去分析监控画面。侦测到门外有变动时，它能区分「被风吹动的树叶」和「一辆 FedEx 快递车停在路边」，然后主动透过 WhatsApp 发提醒。

这个案例指向一个更大的趋势：如果 AI 可以透过底层 API 直接操控所有智能设备，那我们手机里那几百个功能单一、占内存、还得学怎么用的 APP，有多少是冗余的？

### 4. 自动研究：人类变成 AI 进化的最大瓶颈

如果把 AI 代理的能力指向科研呢？这就是 Karpathy 提到的 Auto Research 概念。

Karpathy 在微调大模型时遇到一个让他冲击很大的经验。所谓超参数调优（hyperparameter tuning），比如权重衰减（weight decay）、Adam 优化器步长这些控制旋钮，传统上被认为是顶尖高手的「玄学手感」，靠的是多年经验和直觉。Karpathy 一开始坚信自己 20 年功力调出来的参数已经是最优解。

然后他把任务交给 Auto Research 系统。AI 在整个参数空间里跑了几千几万次实验，第二天早上交出了一组**人类没发现过、从人类逻辑看有些反直觉，但结果更好的参数组合**。

这直接催生了一个组织设计的推演：如果科研过程本身可以被自动化，那未来的研究机构、甚至商业公司，其核心是什么？Karpathy 提出了「终极 Program」的概念——用一份逻辑严密的 Markdown 文件来定义目标、评价指标、资源上限和边界规则，然后交给成千上万个 AI 代理去无止尽地执行、试错、迭代。

### 5. 傑文斯悖论：AI 写代码不会消灭程序员，但会彻底改变这份工作

很多人看到 AI 能写代码就断言程序员要失业了。但经济学中的**傑文斯悖论**（Jevons Paradox）提供了另一个视角。

1865 年，英国经济学家 William Stanley Jevons 观察到，瓦特蒸汽机让煤炭使用效率大幅提升后，煤炭的总消耗量不减反增。原因是效率提升让更多产业觉得划算、开始使用煤炭，需求暴涨。

![傑文斯悖论在AI编码中的体现](https://cos.jiahongw.com/rss-daily/20260325/img-02.png)

ATM 自动提款机的历史也是同样的模式。1970 年代 ATM 出现时，所有人都预言银行柜员要失业了。但根据 IMF 2015 年的分析，ATM 让每家分行需要的柜员从 21 人降到 13 人，降低了营运成本，结果银行疯狂扩张网点，城市地区分行数量增加了 43%。从 1980 年到 2010 年，银行柜员的总人数反而增加了。只是工作内容从数钞票变成推销理财产品和客户关系管理。

套用在 AI 编码上：当编写软件的成本逼近于零，过去那些「不值得用昂贵人力去解决」的琐碎需求会被释放出来。

GitHub 2025 年的数据显示，每月合并的 pull request 达到 **4,300 万个**，年增 23%；Apple App Store 新增 **557,000 个 APP**，年增 24%。如果 AI 真的在「取代」开发者，这些数字应该下降才对。

不过要注意的是，傑文斯悖论有一个重要前提：它在「人类仍然需要介入」的环节才有效。ATM 的案例后来有个续集——2010 年后 iPhone 和行动银行出现，真正让银行柜员人数开始崩跌，因为行动银行不是优化了旧世界，而是让分行本身变得不那么必要了。

**AI 编码会不会走到这一步，目前还是开放问题。**

---

## 可实践建议

| 场景 | 建议 | 工具/资源 |
|------|------|-----------|
| **刚接触 AI 编码** | 从单一任务开始，不要试图一次性自动化整个工作流 | Claude Code、Cursor、GitHub Copilot |
| **提升 AI 编排能力** | 学习如何拆解复杂任务，给 AI 明确的上下文和边界 | 阅读 Karpathy 的 Micrograd 项目 |
| **担心职业前景** | 转向「指挥者」角色：需求分析、架构设计、审核验证 | 学习系统设计和项目管理 |
| **想建立个人 AI 代理** | 从自动化重复性任务开始，如邮件分类、日程管理 | OpenClaw、Claude Code + MCP |
| **企业决策者** | 评估 AI Agent 的安全风险，考虑 NVIDIA NemoClaw 等企业级方案 | NemoClaw、安全审计 |

---

## 一句话总结

> **软件工程的未来不是写更多代码，而是更好地指挥 AI 去写代码——从独奏者变成指挥家，从执行者变成 orchestrator。**

---

***Reference***:

- [原文：OpenAI 共同創辦人 Karpathy 不再寫程式 - Tenten](https://tenten.co/learning/openai-karpathy-ai-agents-take-over/)
- [Fortune — OpenAI Cofounder Andrej Karpathy on AI Coding "State of Psychosis"](https://fortune.com/2026/03/21/andrej-karpathy-openai-cofounder-ai-agents-coding-state-of-psychosis-openclaw/)
- [Stanford Digital Economy Lab — AI and Labor Markets](https://digitaleconomy.stanford.edu/news/ai-and-labor-markets-what-we-know-and-dont-know/)
- [CNBC — AI Adoption Linked to 13% Decline in Jobs for Young U.S. Workers](https://www.cnbc.com/2025/08/28/generative-ai-reshapes-us-job-market-stanford-study-shows-entry-level-young-workers.html)
- [Wikipedia — Jevons Paradox](https://en.wikipedia.org/wiki/Jevons_paradox)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/claude-code/overview)
- [Micrograd - Karpathy 的开源教学项目](https://github.com/karpathy/micrograd)
- [OpenClaw GitHub 仓库](https://github.com/openclaw/openclaw)
