---
title: "x-digest-blog"
date: 2026-05-17T00:48:02+08:00
publishDate: 2026-05-17T00:48:02+08:00
description:
tags:
  - AI
  - Claude
  - Prompt
  - OpenAI
  - Anthropic
  - AI
  - Daily Digest
categories:
  - 技术
  - AI
image:
---




# X Following Digest - 2026-05-17

生成时间：2026-05-17 00:45:11 UTC  
筛选范围：最近 24 小时  
精选推文数：65  
筛选率：35.7%

<!--more-->

---

## 🤖 AI & 技术前沿

### 1. @dotey - AI 编程的规划与验证

**原文：**
让 AI 干很长时间的活，核心是规划和验证：
1. 如原推那样规划成小的阶段
2. 另外每个阶段最好有明确的验证方法，这一步很重要，可以是自动化测试（单元测试、集成测试、端到端测试）

所以长任务最适合的场景是那种测试覆盖完整的语言迁移，比如 bun 从 zig 迁移到 rust，一百万行代码的变更，但是测试覆盖完整，而且 AI 主要做的是"翻译"的工作，还可以验证，那连着跑几个几周都没问题，还不担心跑偏。

普通任务，如果没有办法让 Agent 自己验证，还跑很久，就很容易出现南辕北辙的情况，跑的时间越长，偏的越远。还是自己中间验证一下更好。

**引用推文：**
> 我看了很多人描述他们如何使用AI编程，看到里面很多有类似"让AI干了一晚上"这样的表述，所以这是现在使用AI编程的常规操作？按照这样干很长时间产生很多代码的做法，碳基人想review都难。
> 
> 我大致说一下我怎么AI编程的。最开始我先了解需求，划分阶段，生成一个类似 phase.md 的文件，里面详细按照顺序划分了每一步要实现什么...
> — @lichuang

**互动数据：** 5 likes · 0 RT · 3 replies  
**发布时间：** 2026-05-17 00:10  
**原文链接：** https://x.com/dotey/status/2055682292937326638

**核心观点：** AI 编程的关键在于阶段性规划和验证机制，不能一次性让 AI 跑太长时间的任务，否则容易偏离目标。

---

### 2. @turingou - Codex App 远程工作流

**原文：**
我在尝试使用 codex app 的远程连接功能将我本地 mac studio 上所有活跃的 git 项目全部迁移到我的 sandbank tyo 节点服务器，创建了一个单独的 workspace 来负责开发，测试和构建。然后，我设置了一个服务器的定时任务将这些 git 仓库同步提交到 github，这样我就不再使用 本地开发 -> GHA -> runner -> 生产环境 的工作流程，而是彻底反过来，直接使用 codex 控制生产环境。

**互动数据：** 16 likes · 2 RT · 2 replies  
**发布时间：** 2026-05-16 23:36  
**原文链接：** https://x.com/turingou/status/2055673697068093652

**核心观点：** Codex App 的远程连接功能可以实现"反向工作流"——直接用 AI 控制生产环境开发，颠覆传统的本地开发模式。

---

### 3. @Tz_2022 - 超算中心 vs AI 集群算力对比

**原文：**
严肃问了一下 AI 这个问题：单就算力而言，现在超算中心和 AI 集群是一个什么情况？

传统超算榜单还在，但算力权力的主战场已经换了。

如果按传统超算口径，也就是 FP64 / HPL Linpack，超算中心依然有明确排名：
- 第一名 El Capitan：1.809 exaFLOPS
- 第二名 Frontier：1.353 exaFLOPS
- 第三名 Aurora：1.012 exaFLOPS

整个 Top500 合计 HPL 算力大约 14.99 exaFLOPS。

但 AI 集群用的是另一套算力语言。大模型训练和推理主要吃的是 BF16、FP16、FP8，甚至 FP4 的张量计算能力。

粗略算：
- 1 万张 H100：BF16/FP16 dense 峰值约 9.9 EFLOPS
- 10 万张 H100：BF16/FP16 dense 峰值约 99 EFLOPS
- 20 万张 H100/H200 级别：BF16/FP16 dense 峰值约 198 EFLOPS

这就是为什么现在"超算中心排名"突然显得没那么性感了。因为最强的 AI 算力，很多已经藏在公司机房里。

**互动数据：** 273 likes · 1 RT · 58 replies  
**发布时间：** 2026-05-16 03:43  
**原文链接：** https://x.com/Tz_2022/status/2055373550152736833

**核心观点：** 传统超算中心排名正在失去意义，AI 算力的主战场已转向科技公司的私有 AI 工厂（如 xAI Colossus、OpenAI Stargate）。

---

### 4. @aakashgupta - Prompt Library vs Skill Library

**原文：**
Your prompt library expires every week. Your skill library compounds every Monday.

Most people are still treating Claude like a smarter Google... A skill is a folder. SKILL.md, references, a worked example. You drop it into Claude's skills directory once. From then on, the workflow loads automatically when your message matches what the skill does.

The 2023-2025 meta was a prompt library. The 2025-2027 meta is a skill library. The gap between the two compounds at agent-speed.

**互动数据：** 7 likes · 0 RT · 1 replies  
**发布时间：** 2026-05-17 00:01  
**原文链接：** https://x.com/aakashgupta/status/2055679961416315306

**核心观点：** Prompt 库每周过期，Skill 库每周复利。2023-2025 是 Prompt 时代，2025-2027 是 Skill 时代。

---

## 💻 开发技术

### 5. @Barret_China - iOS Simulator 安全爬取

**原文：**
通过 Xcode simulator 启动一个模拟器，再加上苹果自家的 UI 测试框架 XTest，走 Accessibility API 读取 App 界面的元素树（按钮/文本框/文本内容），并模拟点击、输入、滚动，这样就可以安全地拿到很多被限制的内容了，例如微信/小红书等内容读取。

iOS Simulator 里跑的是真 Safari / App，发出去的每个请求都带着合法 User-Agent、TLS 指纹，服务端看到的就一普通 iPhone 用户在刷 feed。因此技术上几乎无痕。

**互动数据：** 47 likes · 2 RT · 13 replies  
**发布时间：** 2026-05-16 22:57  
**原文链接：** https://x.com/Barret_China/status/2055663814725787726

**核心观点：** 利用 iOS Simulator + XTest 框架可以"无痕"爬取 App 内容，规避平台检测。

---

### 6. @rwayne - tinyhumansai/openhuman 本地 AI

**原文：**
tinyhumansai/openhuman 是今年 2 月才开始的项目，3 个月 9901 stars。

slogan 一句话讲完。Your Personal AI super intelligence. Private, Simple and extremely powerful.

Rust 写的，全程本地跑。不把数据交给 OpenAI、Anthropic、Google，自己留一份完整的智能助手在本地。

**互动数据：** 5 likes · 0 RT · 3 replies  
**发布时间：** 2026-05-16 23:33  
**原文链接：** https://x.com/rwayne/status/2055672873650688459

**核心观点：** 本地运行的个人 AI 助手正在崛起，隐私和自主可控成为新趋势。

---

## 📊 商业与产品

### 7. @SuisPasDaVinci - 学生求职五要素

**原文：**
对学生求职来说最重要的是：

1. 有具体问题
2. 有可展示 demo
3. 有真实用户反馈
4. 有迭代记录
5. 面试时讲得清楚

不会代码真不是问题。没有作品，才是问题。

**互动数据：** 4 likes · 0 RT · 1 replies  
**发布时间：** 2026-05-16 23:55  
**原文链接：** https://x.com/SuisPasDaVinci/status/2055678638448578589

**核心观点：** 求职的核心是"作品"而非"代码能力"，能展示解决问题的完整过程比技术栈更重要。

---

### 8. @HarryStebbings - Abridge $5.3B 估值的 6 个经验

**原文：**
Abridge 是一家垂直 AI 医疗公司，估值已达 53 亿美元。创始人 Shivdev Rao 分享了 6 个关键经验：

1. **Survive Long Enough** - 在市场时机到来前活下去
2. **Pivot the Product, Never the Core Thesis** - 可以调整产品，但核心论点不能动摇
3. **Target Concentration of Scale Early** - 尽早瞄准大规模集中的市场
4. **Own Your Stack** - 40% 的模型输出由内部模型生成，控制 P&L 和用户体验
5. **Don't Fight Foundation Models** - 不与基础模型巨头正面竞争，而是深耕垂直领域
6. **Move Toward the "Flat Company" Era** - 构建扁平化组织，减少管理层级

**互动数据：** 22 likes · 3 RT · 6 replies  
**发布时间：** 2026-05-16 23:05  
**原文链接：** https://x.com/HarryStebbings/status/2055665930676433030

**核心观点：** 垂直 AI 公司的成功路径：深耕细分领域 + 自建核心能力 + 避开与巨头的正面竞争。

---

## 🌟 其他精选

### 9. @rwayne - 投资的本质

**原文：**
最近股市又有一波涨跌，又有一群人开始写反思文章。反思这反思那，甚至反思价值投资，反思要不要看 10 年。

这种反思大多没用。每次涨跌都有不同的叙事。

投资其实就两件事可想：想明白什么是不变的，然后看价格。

很多人把"看 10 年"理解成"算准 10 年后的业绩"。这完全是错的。看 10 年其实是问什么东西是不变的。

**互动数据：** 6 likes · 0 RT · 7 replies  
**发布时间：** 2026-05-16 23:57  
**原文链接：** https://x.com/rwayne/status/2055678913313997306

**核心观点：** 投资的本质不是预测未来，而是识别"不变的东西"。

---

### 10. @SuisPasDaVinci - 百事可乐的捆绑销售逻辑

**原文：**
在加拿大很多小店用百事可乐的机打饮料，并不是因为百事更好喝。而是它把机器、供应、维护、维修这些麻烦事一起打包了。

对老板来说，真正值钱的不是那杯可乐。是机器坏了有人管，耗材缺了有人补，出了问题不用自己到处找人修。

同质化产品想赢，很多时候不是继续降价。而是把客户最烦、最怕、最不想折腾的都搞定。

**互动数据：** 2 likes · 0 RT · 1 replies  
**发布时间：** 2026-05-16 23:39  
**原文链接：** https://x.com/SuisPasDaVinci/status/2055674484837744998

**核心观点：** 同质化竞争的关键是"解决客户的麻烦"，而非单纯的价格战。

---

## 📈 汇总统计

| 指标 | 数值 |
|------|------|
| 总推文数 | 200 |
| 最近24小时推文 | 182 |
| 精选高质量推文 | 65 |
| 筛选率 | 35.7% |

---

*本报告由 X Following Digest 自动生成*  
*数据来源：X (Twitter) Following Timeline*
