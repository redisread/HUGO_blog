---
title: "X-Following-Digest---2026-05-29"
date: 2026-05-29T12:44:20+08:00
publishDate: 2026-05-29T12:44:20+08:00
description:
tags:
  - AI
  - Twitter
  - Digest
  - Agent
  - Continuous Learning
  - Claude
  - GPT
  - Prompt
  - OpenAI
  - AI
  - Daily Digest
categories:
  - 技术
  - AI
image:
libraries: ['katex']
---



# 🦀 X Following Digest — 2026-05-29

> 生成时间：2026-05-29 12:40 CST | 数据源：api.fxtwitter.com
> 覆盖账号：Andrew Ng, Sam Altman, OpenAI, Meta Newsroom, Yann LeCun, Andrej Karpathy, Rohan Paul, Cognition, NVIDIA AI, Artificial Analysis


## 🔥 最近 24 小时推文深度分析

### 1️⃣ Cognition — $1B 融资，$26B 估值

> **@cognition** | 2026-05-27 15:39 UTC | ❤️ 2,350 | 🔁 194 | 🔖 436 | 👁️ 720K

**原文：**
> 1/ We've raised over $1B at a $26B valuation, led by @Lux_Capital, @generalcatalyst, and @8vc.
>
> Our enterprise usage has grown >10x since the start of this year, and our run-rate revenue grew to $492 M.
>
> We launched Devin two years ago as the first AI software engineer. Since then, cloud agents have gone from niche to mainstream, and today they are the fastest growing way to create software.

**核心观点：**
- Cognition（Devin 的开发商）完成超 $1B 融资，估值 $26B，由 Lux Capital、General Catalyst、8VC 领投
- 企业使用量今年增长超 **10 倍**，年化营收达 **$492M**
- "Cloud agents" 从小众走向主流，成为软件创建增长最快的方式

**可实践建议：**
- 如果你是开发者/CTO，现在是评估 AI 编码 agent（如 Devin）进入生产环境的窗口期
- $492M ARR 且 10x 增长表明企业端真实需求正在爆发，而非 PoC 阶段
- 关注 "cloud agent" 模式 vs 本地部署 agent 的取舍

**创作灵感：**
- 话题：`"AI 编程 agent 从玩具到生产力的转折点"` — 以 Cognition 数据为论据
- 角度：对比 2024 Devin 发布时的 hype vs 2026 年的真实营收数字

---

### 2️⃣ Rohan Paul — Trajectory：持续学习平台

> **@rohanpaul_ai** | 2026-05-27 16:05 UTC | ❤️ 19 | 🔁 9 | 🔖 6 | 👁️ 3.4K

**原文：**
> Cracking continual learning would make AI far more capable, because models could improve from real usage after deployment.
>
> Trajectory just launched a continual learning platform, backed by a $15M round, to turn every agent trace and user correction into a system that keeps improving after deployment.
>
> A neolab with ex-DeepMind, OpenAI, and Meta Superintelligence researchers that also has paying customers, totally normal.
>
> AI products are still frozen software, because users correct them every day but those corrections rarely update the model, the prompts, or the surrounding agent workflow.
>
> Trajectory's core unit is the trajectory, which combines what the agent did with what the user accepted, rejected, edited, retried, or fixed later, so companies can train on full failure chains and improve model weights, harness, and prompts together.
>
> The next major AI leap almost certainly will come from models that keep learning after they are shipped.

**核心观点：**
- **Trajectory** 推出持续学习平台，融资 $15M，团队来自 DeepMind/OpenAI/Meta
- 当前 AI 产品的根本问题：**"frozen software"** — 用户每天都在纠正 AI，但这些纠正从未回流到模型、prompt 或 agent 流程中
- Trajectory 的核心数据单元是 **"trajectory"**：将 agent 行为 + 用户反馈（接受/拒绝/编辑/重试/修复）组合成完整的失败链
- 预测：AI 的下一个重大突破将来自**部署后持续学习的模型**

**可实践建议：**
- 如果你在做 AI agent 产品，立即开始系统化收集用户纠正数据 — 这是最有价值的训练数据
- 考虑构建"反馈循环"基础设施：记录每次用户修正 → 分析模式 → 更新 prompt/微调模型
- 关注 Trajectory 平台的进展，评估是否适合集成到你的 agent workflow 中

**创作灵感：**
- 话题：`"AI 产品为什么总是 frozen software？"` — 一个深刻的行业洞察
- 角度：从"用户每天都在纠正 AI 但模型从不学习"这个矛盾出发
- 对比：人类从反馈中学习 vs AI 的"一次训练，永久部署"模式

---

## 📌 近期重要推文（补充分析）

### 3️⃣ Andrew Ng — AI Prompting for Everyone 课程

> **@AndrewYNg** | 2026-04-30 16:21 UTC | ❤️ 4,650 | 🔁 854 | 🔖 5,986 | 👁️ 834K

**原文：**
> How we prompt AI is very different in 2026 than 2022 when ChatGPT came out.
>
> I'm teaching a new course, AI Prompting for Everyone, to help you become an AI power user — whatever your current skill level.
>
> It covers skills that apply across ChatGPT, Gemini, Claude, and other AI tools. How to use deep research mode for well-researched reports on complex questions. How to give AI the right context, including more documents and images than most people realize you can provide. When to ask AI to think hard for several minutes on important decisions like what car to buy, what to study, or what job to take. And how to use AI to generate images, analyze data, and build simple games and websites.
>
> I also cover intuitions about how these models work under the hood, so you know when to trust an answer and when not to.

**核心观点：**
- 2026 年的 prompt 方式与 2022 年 ChatGPT 发布时**完全不同**
- 新课程覆盖：deep research mode、多模态上下文注入、长思考推理、图像/数据分析/建站
- 关键理念：理解模型底层原理 → 知道何时信任、何时质疑

**社交媒体文案：**
> Andrew Ng 说 2026 年的 prompt 方式已经完全不同了。他的新课程强调：给 AI 更多上下文（文档+图片）、让它花几分钟深度思考重要决策、理解模型原理以判断何时信任。bookmark 5986，说明大家都意识到了 prompt 技能的代差。🧵

---

### 4️⃣ Meta Newsroom — Muse Spark + AI Voice Conversations

> **@MetaNewsroom** | 2026-05-12 14:21 UTC | ❤️ 1,068 | 🔁 160 | 🔖 309 | 👁️ 255K

**原文：**
> Today we're introducing Meta AI Voice Conversations powered by Muse Spark that let you talk naturally to Meta AI (interrupt, switch topics, or swap languages), and as you talk, Meta AI can generate images and pull up recommendations from Reels, maps, and more. We're also bringing live AI to the app, so you can point your camera at the world and ask about what you're seeing in real time.

**核心观点：**
- Meta AI 语音对话：支持**打断、切换话题、切换语言**
- Muse Spark 引擎支持实时图像生成 + 内容推荐（Reels/地图）
- **Live AI**：摄像头对准现实世界 → 实时问答（AR + AI 结合）

---

### 5️⃣ Sam Altman — OpenAI 政府立场声明

> **@sama** | 2025-11-06 19:21 UTC | ❤️ 12,484 | 🔁 1,446 | 🔖 6,940 | 👁️ 8.0M

**核心观点：**
- OpenAI **不想要也不需要**政府担保数据中心建设
- 建议政府自建 AI 基础设施并持有所有权，收益归政府
- 唯一讨论贷款担保的领域：半导体制造回流美国
- OpenAI 年化营收预计超 **$20B**，目标 2030 年达 **数千亿**
- 8 年承诺约 **$1.4 万亿**基础设施投入
- 明确表态：如果 OpenAI 搞砸了，应该让它失败，让其他公司继续

---

### 6️⃣ OpenAI — Advanced Voice 免费预览

> **@OpenAI** | 2025-02-25 21:13 UTC | ❤️ 6,663 | 🔁 564 | 🔖 501 | 👁️ 1.0M

**核心观点：**
- 基于 GPT-4o mini 的 Advanced Voice 向免费用户开放每日预览
- 对话节奏和语气接近 GPT-4o 版本，但服务成本更低

---

## 🎯 趋势总结

1. **AI Agent 经济化爆发**：Cognition $492M ARR + 10x 增长，验证了 AI 编码 agent 的企业市场需求
2. **持续学习是关键瓶颈**：Trajectory 的 "frozen software" 洞察 — AI 产品需要部署后学习能力
3. **Prompt 技能代差**：Andrew Ng 指出 2024→2026 的 prompt 范式变化，deep research + 长思考 + 多模态
4. **基础设施竞赛加速**：Sam Altman 的 $1.4T/8年承诺 vs OpenAI 不寻求政府担保的立场
5. **实时交互成为标配**：Meta 的语音对话 + Live AI 摄像头实时问答

---

*数据获取：api.fxtwitter.com API | 报告生成：VictorClaw 🦀*
