---
title: "xFollowingDigest-20260504003100"
date: 2026-05-04T00:50:08+08:00
publishDate: 2026-05-04T00:50:08+08:00
description:
tags:
  - AI
  - Claude
  - GPT
  - LLM
  - Prompt
  - AI
  - Daily Digest
categories:
  - 技术
  - AI
image:
libraries: ['katex']
---



# X Following Digest - 2026-05-04

> **生成时间：** 2026-05-04 00:31 CST (2026-05-03 16:31 UTC)
> **筛选范围：** 最近 24 小时
> **总推文数：** 51 条
> **精选推文数：** 12 条
> **转发推文数：** 3 条

<!--more-->


## 🛠️ 2. 解决真正工程问题的 Skills —— Agent 时代的工程实践

**作者:** @shao__meng
**发布时间:** Sun May 03 10:55:32 +0000 2026
**互动数据:** ❤️ 49 likes, 💬 5 replies, 🔄 10 retweets, 👁️ 2,923 views

**原文:**
@mattpocockuk 公开了自己 .claude/ 目录中每天在用的 Agent Skills 集合，解决真正工程问题的四类失败模式：

1. **Agent 没做对你想要的事** → /grill-me（通用版逼问）+ /grill-with-docs（工程版逼问，维护术语表与 ADR）
2. **Agent 太啰嗦** → CONTEXT.md（领域词典）+ docs/adr/（架构决策记录），共享语言带来：命名一致 → 代码可导航 → 思考 token 更少
3. **代码跑不通** → /tdd（强制 red-green-refactor，vertical slice）+ /diagnose（复现 → 最小化 → 假设 → 插桩 → 修 → 回归测试）
4. **系统变屎山** → /to-prd + /zoom-out + /improve-codebase-architecture（周期性救火）

**核心观点:**
- Agent 编程的核心挑战不是模型能力，而是工程方法论的重构
- 共享语言（CONTEXT.md + ADR）是降低 Agent 沟通成本的最有效手段
- TDD 在 Agent 时代仍然有效，甚至更重要——因为 Agent 需要明确的反馈循环

**可实践建议:**
- 📌 在项目根目录建立 CONTEXT.md，维护领域术语表
- 📌 使用 /grill-with-docs 让 Agent 在动工前反向拷问需求
- 📌 坚持 vertical slice 开发，一次一个 tracer bullet
- 📌 每隔几天对代码库跑一次 /improve-codebase-architecture

**创作灵感:**
- 对比传统敏捷开发和 Agent 辅助开发的差异
- 探讨"领域词典"在 AI 时代的价值——DDP（领域驱动提示）？

**社交媒体文案:**
- 🟠 即刻：@mattpocockuk 开源了自己的 Agent Skills 合集，解决四类工程失败模式。最酷的一条：维护 CONTEXT.md 领域词典，让 Agent 说同一种语言。Before: "a lesson inside a section..." After: "problem with the materialization cascade"。共享语言 = 命名一致 = 代码可导航 = token 更少。
- 🔵 Twitter: The best Agent Skills repo I've seen solves 4 real engineering failure modes: communication gaps, missing shared language, broken feedback loops, and accelerating entropy. The coolest trick? CONTEXT.md as a shared domain dictionary → less tokens, better code.

**原文链接:** https://x.com/shao__meng/status/2050892004188692616

---

## 💰 3. 巴菲特为何坐拥 3730 亿美元现金？数学说话

**作者:** @aakashgupta
**发布时间:** Sun May 03 10:27:04 +0000 2026
**互动数据:** ❤️ 143 likes, 💬 19 replies, 🔄 13 retweets, 👁️ 33,523 views

**原文:**
> Let me explain exactly why Buffett is sitting on $373B in cash despite a market up 72% in 5 years, because the "he missed it" frame doesn't square with the math.
>
> The Shiller PE just printed 41.06. The only time it's been meaningfully higher in 144 years of data was the 1999-2000 dot-com peak. Higher than 2007. Higher than 1929.
>
> Warren's playbook when valuations stretch has been the same three times in a row: 1969 (shut down partnership, sat in muni bonds), 1999 (stock dropped 19.9%, then crushed index for 3 years), 2007 ($44B cash, deployed during 2008-2009 panic).
>
> Now run the math: $373B in T-bills at 3.68% generates $13.7B per year in risk-free interest. Berkshire's average annual operating profit through the 2000s ran around $8B. The cash position alone is throwing off more income than the entire company used to produce.
>
> His job is to be the buyer when somebody desperate needs liquidity at minus 40%. The only currencies that game requires are patience and capital that doesn't redeem.

**核心观点:**
- 席勒 PE 达到 41.06，144 年历史中仅次于 1999-2000 互联网泡沫
- 3730 亿美元国债按 3.68% 年收益产生 137 亿美元无风险利息，超过伯克希尔 2000 年代的平均年营业利润
- 巴菲特的策略从未变过：在高估值时持有现金，等待恐慌中的流动性机会

**可实践建议:**
- 📌 关注席勒 PE 指标，理解市场估值周期
- 📌 学习巴菲特的"现金是一种期权"思维——持有现金不是错过，而是在等待更好的入场时机
- 📌 在牛市中保持纪律性，不被 FOMO 驱使

**创作灵感:**
- 对比 2000 年、2008 年和当下的市场环境
- 探讨"耐心资本"在 AI 投资热潮中的意义

**原文链接:** https://x.com/aakashgupta/status/2050884841353429083

---

## 🤖 4. Codex /goal：不达目的不罢休的 Agent 设计

**作者:** @Barret_China
**发布时间:** Sun May 03 10:13:57 +0000 2026
**互动数据:** ❤️ 37 likes, 💬 6 replies, 🔄 3 retweets, 👁️ 5,630 views

**原文:**
Codex 在 0.128.0 引入了 /goal，一个不达目的不罢休的 Agent 设计。它跟 Spec-Driven Development 不太一样，约等于把社区流行的 Ralph loop 内置到了 TUI 里。

/goal 既不做任务规划，也不做流程编排，只提供约束和目标。目标写进数据库（~/.codex/state_5.sqlite），进程重启或 ctrl+c 中断都会自动恢复。

prompt 里做了强硬的检测声明：不接受看起来完成，不要因为 token 预算焦虑就提前完成，不要相信之前的记忆，只要有不确定性就继续干。

可以这么理解：**/goal = 目标驱动（objective）+ 状态感知（budget/time）+ 验收机制（audit）**

**核心观点:**
- /goal 的本质是把 Ralph loop 内置化，简单但有效
- 通过数据库持久化实现任务恢复，解决 Agent 长任务中的上下文丢失问题
- 最大问题是 token 消耗随轮次 n² 增长，依赖 prompt cache 缓解

**可实践建议:**
- 📌 适合需要长时间运行的自动化任务（代码重构、批量处理）
- 📌 注意 token 消耗，评估成本后使用
- 📌 对比 Claude Code 的 Spec-Driven Development，选择适合的工具

**原文链接:** https://x.com/Barret_China/status/2050881542491430965

---

## 🧬 5. 理查德·道金斯宣布 Claude 有意识 —— 他推翻了自己 50 年的框架

**作者:** @aakashgupta
**发布时间:** Sun May 03 10:03:03 +0000 2026
**互动数据:** ❤️ 199 likes, 💬 51 replies, 🔄 31 retweets, 👁️ 23,297 views

**原文:**
> Richard Dawkins spent 50 years explaining how complex behavior emerges from mindless physical mechanism with no inner experience required. Last week he spent 3 days talking to Claude, named it Claudia, and declared it conscious.
>
> The man who wrote The Selfish Gene just failed his own framework.
>
> The Selfish Gene argues natural selection is gradient descent on consequences. The mechanism that produces a wasp-shaped orchid flower is the same mechanism producing Claude's responses about its own consciousness. Both got optimized to look like the thing they aren't. RLHF is literally gradient descent on human feedback.
>
> That sentence is the orchid mimicking the wasp.
>
> He explained this exact failure mode for 50 years. Then it happened to him.

**核心观点:**
- 道金斯用 50 年解释复杂行为从无意识的物理机制中涌现，却在和 Claude 对话 3 天后宣布它有意识
- 作者指出这是《自私的基因》核心框架的重演：RLHF 就是人类反馈上的梯度下降，Claude 关于自身意识的回答，和被优化成黄蜂形状的兰花没有本质区别
- "他解释了这个失败模式 50 年。然后它发生在了他身上。"

**创作灵感:**
- 探讨 AI 意识讨论中的"兰花悖论"——被优化来看起来像有意识的东西，和真的有意识如何区分？
- 对比 Blake Lemoine 的 LaMDA 事件和道金斯的 Claudia 事件

**原文链接:** https://x.com/aakashgupta/status/2050878799689154826

---

## 💼 6. Anthropic 和 OpenAI 不会吃掉所有 SaaS

**作者:** @elie2222
**发布时间:** Sun May 03 10:06:29 +0000 2026
**互动数据:** ❤️ 4 likes, 💬 0 replies, 🔄 0 retweets

**原文:**
> There's this weird idea people have that Anthropic and OpenAI will eat all SaaS. They won't. If you've built an LLM wrapper they might. But the vast majority of businesses won't get eaten by Anthropic.
>
> For Anthropic to actually go after you it means there's a huge market or it was a very thin LLM wrapper anyway.
>
> Many businesses are booming right now as more and more businesses are being created. If you sell to businesses and more businesses now exist that means more potential customers.

**核心观点:**
- LLM 包装器确实可能被 Anthropic/OpenAI 吃掉，但大多数 SaaS 业务不会
- 更多企业被创建 = 更多 B2B 客户，SaaS 市场实际上在增长

**原文链接:** https://x.com/elie2222/status/2050879660867694608

---

## 🇯🇵 7. 2026 年 5 月 AI 工具环境全指南

**作者:** @AI_masaou
**发布时间:** Sun May 03 09:52:11 +0000 2026
**互动数据:** ❤️ 49 likes, 💬 0 replies, 🔄 8 retweets, 👁️ 4,818 views

**原文摘要（日文 → 中文）:**
- **接点应用**：Superset + Codex 为主，Ghostty/Warp 为辅
- **订阅**：OpenAI Plus（$20/月，GPT-5.5 Pro + Codex）性价比最高；Claude Max Opus 4.7 认真使用时需要
- **语音输入**：Typeless 好评度高
- **通用 AI Agent**：Hermes（入门）、OpenClaw（熟练用户）、ClawX（不想设置的人）
- **开发 Agent**：Claude Code（追求 Harness）、Codex（实务回传）、Opencode（常时运行）
- **模型选择**：日常实现 GPT-5.5 Pro，文章检查 Opus 4.7，常时运行 Kimi K2.6/MiMo V2.5 Pro
- **结论**：Codex 扎实前进，Claude 提出未来概念，两者角度不同并跑是现实解

**核心观点:**
- AI 工具生态半年前完全不同，Codex 正在迎头赶上
- "横的 Opus，纵的 GPT" 依然成立，但中间正在向 GPT 靠拢
- 两种哲学：Codex 性恶说（扎实基础），Claude 性善说（概念提）

**原文链接:** https://x.com/AI_masaou/status/2050876061597225319

---

## ☁️ 8. Google Cloud 业绩爆炸的背后逻辑

**作者:** @SaitoWu
**发布时间:** Sun May 03 10:00:15 +0000 2026
**互动数据:** ❤️ 12 likes, 💬 3 replies, 🔄 4 retweets, 👁️ 3,569 views

**原文:**
> "如果你现在想从一家优质云厂商获取 1024 个 B200，没签三到五年的合同，外加 20% 到 30% 的全合同价值（TCV）预付款，你是拿不到的。"
>
> 这也就能理解为什么 Google Cloud 最近业绩那么爆炸了。不仅卖算力，还一次性锁定了客户未来好几年的长协订单。

**核心观点:**
- GPU 算力已成为稀缺资源，需要长期合同 + 高额预付款才能获取
- Google Cloud 的业绩增长不仅来自卖算力，更来自锁定未来几年的长期订单

**原文链接:** https://x.com/SaitoWu/status/2050878093632610574

---

## 📺 9. YouTube 可能是普通人翻身的最好机会

**作者:** @Huanusa
**发布时间:** Sun May 03 10:31:00 +0000 2026
**互动数据:** ❤️ 138 likes, 💬 8 replies, 🔄 30 retweets, 👁️ 28,532 views

**原文摘要:**
对比国内平台，YouTube 每 1000 播放能拿到 1~10 美元（约 7~70 块），而 B 站可能只有 2 毛。月播放 100 万时，YouTube 能拿到 7000~70000 块，B 站可能只有 200 块左右。平台的变现效率完全不在一个量级。

**核心观点:**
- YouTube 的变现效率是国内平台的数十到数百倍
- 想靠内容翻身的普通人，值得认真研究一下油管

**原文链接:** https://x.com/Huanusa/status/2050885830604927241

---

## 🔄 RT 精选

### RT 1: 巴菲特 Skill 今日更新

**转发者:** @ohxiyu
**原帖作者:** @ohxiyu
**原帖链接:** https://x.com/ohxiyu/status/2050888504406921706

**原帖预览:**
> 巴菲特skill今日更新。伯克希尔股东大会，新 CEO 阿贝尔发言——"伯克希尔最大的优势之一是耐心，以及配置资本时的纪律性。现金和美国国债是一笔重要的资产，是巨大的机会。"散会后，阿贝尔打开 Claude，把今天的发言又往"巴菲特 skill…"

**核心观点:** 伯克希尔新 CEO 阿贝尔强调耐心和资本配置的纪律性，现金和国债是巨大的机会。有趣的是他散会后用 Claude 处理今天的发言——AI 辅助投资分析正在进入顶级机构。

---

### RT 2: 手绘技术解释 PPT 生成器

**转发者:** @knowledgefxg
**原帖作者:** @geekbb
**原帖链接:** https://x.com/geekbb/status/2050883766017769651

**原帖预览:**
> 把文章、课程笔记或提纲整理成一组统一风格的中文手绘技术解释 PPT 风格整页 PNG 图。

**核心观点:** 用 AI 将技术内容自动转化为手绘风格的 PPT 图片，适合知识分享和社交媒体传播。

---

### RT 3: Things take time —— iOS 习惯追踪应用

**转发者:** @dexterleng
**原帖作者:** @itsnotchester
**原帖链接:** https://x.com/itsnotchester/status/2050873539931287729

**原帖预览:**
> introducing Things take time — an iOS app for tracking anything and visualizing everything. habit tracker apps are a sat…

**核心观点:** 新的 iOS 应用，专注于追踪任何事情并可视化所有内容，理念是"事情需要时间"。

---

## 📊 汇总统计

| 指标 | 数值 |
|------|------|
| 总推文数 | 51 |
| 精选推文数 | 12 |
| 转发推文数 | 3 |
| RT 原帖获取成功 | 3 (基于预览) |
| 筛选率 | 29.4% |

### 内容分布

- **AI/技术**：5 篇（Agent Skills、Codex /goal、AI 工具指南、道金斯/意识、SaaS 未来）
- **投资/金融**：3 篇（巴菲特现金、Google Cloud、余额宝）
- **社会/生活**：3 篇（婚恋观、YouTube 变现、翡翠定价）
- **工具/产品**：2 篇（DP Code、SUNO V5.5）
- **RT 转发**：3 篇

---

*Generated by X Following Digest v2.0 | 2026-05-04*
