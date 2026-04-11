---
title: "Block 裁员 40%：AI 驱动的企业重构，是先驱还是特例？"
date: 2026-04-10T01:00:00Z
draft: false
categories: ["技术"]
tags: ["AI", "企业变革", "裁员", "Jack Dorsey", "Block", "Goose"]
image: "https://cos.jiahongw.com/rss-daily/20260410/cover.png"
description: "Block 在 2026 年裁掉 40% 员工，这是 S&P 500 历史上规模最大的 AI 驱动裁员。Jack Dorsey 直言：我们不再手写代码了。这背后到底发生了什么？"
---

## 核心观点

2026 年 2 月 27 日，Block（原 Square）在一封致股东信中宣布裁员超过 4,000 人——约 40% 的员工。这不是一家经营不善的公司在止血，恰恰相反，Block 2025 年全年毛利润达 103.6 亿美元，年增 17%。CEO Jack Dorsey 在信中写得直白：**"智慧工具已经改变了建造和经营一家公司的意义。"**

更关键的是，这次裁员的重心不是行政或客服部门，而是**开发团队**。Block 的业务主管 Owen Jennings 说得更绝："我们不再手写代码了。那个时代结束了。"

![AI Agent 工作流](https://cos.jiahongw.com/rss-daily/20260410/img-01.png)

这标志着企业 AI 应用的一个拐点：从"辅助工具"变成"结构性替代"。Block 不是用 AI 提效，而是用 AI 重新定义组织形态。

## 深度分析

### 一、转折点：2024 年 12 月的第一周

Jennings 把时间线定位得很精确。Block 在 2024 年初就开始投入 agentic 开发，他们的开源 AI agent 框架 Goose 在 2024 年初推出。但真正的"二元性转变"发生在 2024 年 11 月底到 12 月初。

那段时间，Claude Opus 和 Claude Code 的能力出现明显跳升。Jennings 的说法是：基础模型本来蛮会写新项目的代码，但在 12 月初，它们突然变得非常擅长处理"既有的、复杂"的代码库。

他用了一个很具体的描述：**"公司里员工人数和产出之间的相关性，在 12 月第一周断裂了。"** 一两个工程师搭配 AI 工具，生产力可以是过去的 10 倍、20 倍，甚至 100 倍。

这不是渐进式优化，是指数级跃升。当生产力曲线和组织结构曲线突然分离，CEO 必须做出选择：维持旧结构还是重构新形态。

### 二、新的工作方式：4 个人加 2000 美元的 Token

Jennings 给了一个具体的前后对比。以 Cash App 的 AI 金融助手 Moneybot 为例：

- **过去**：推进到 50% 用户覆盖，需要一个 15 人团队
- **现在**：4 个人加上每月 2,000 美元的 AI token 成本

工作流程也彻底变了。以前是一个工程师写好一个 PR（Pull Request），提交、等 code review、根据反馈修改，然后下一个。现在是一个工程师同时指挥 14 个 AI agent 各自建 PR，工程师在它们之间快速切换，做判断和最终决策。

Block 还有一个内部工具 Builderbot。它可以自主合并 PR 和建构功能到完成状态。Jennings 说，大多数时候 Builderbot 能做到 85-90%，然后由一个有大量 context 的人类工程师做最后 10% 的收尾。

这意味着工程团队的分工逻辑被重写：从"人均产出 X"变成"人均指挥 N 个 agent"。人力不是被替代，而是被放大，放大倍数取决于 agent 的可靠性和 context 的复杂度。

### 三、Goose：开源的 AI Agent 框架

![Generative UI 概念](https://cos.jiahongw.com/rss-daily/20260410/img-02.png)

Goose 是 Block 开源计划办公室在 2025 年 1 月正式发布的 AI agent 框架，采用 Apache 2.0 授权。它使用 Anthropic 的 Model Context Protocol（MCP）做为工具连接标准，可以搭配任何 LLM。

Block 内部的数据：
- Goose 为团队节省了 50-75% 的开发时间
- 60% 的员工每周在使用它

2025 年 12 月，Goose 和 MCP、OpenAI 的 AGENTS.md 一起被捐赠给 Linux Foundation 新成立的 Agentic AI Foundation（AAIF），创始白金会员包括 AWS、Anthropic、Block、Bloomberg、Cloudflare、Google、Microsoft 和 OpenAI。

Block 的 CTO Dhanji Prasanna 说得很实际："我们不靠 Goose 赺钱，它完全是 Apache 授权的。我们的策略是让产品能无缝地和 agent 协作，从开源生态系里受益。"

这是一个战略布局：Block 不是卖 AI 工具的公司，而是用 AI 工具的公司。开源 Goose 意味着行业标准由他们参与定义，而非被动跟随。

### 四、Generative UI：产品端的 AI 原生化

Jennings 提到了一个比裁员更值得注意的观点：Generative UI。

"每个人都习惯了静态的、僵硬的 UI。每个人的 Uber、Lyft、Cash App 看起来都一样。这要根本性地改变。Generative UI 已经到了。你的 Cash App 应该跟我的长得很不一样。"

Cash App 的 Moneybot 是这个方向的第一产品实例。2025 年 11 月发布，Moneybot 是一个 agentic AI 金融助手，可以分析用户消费习惯、建立自动储蓄计划、买卖股票和比特币，而且会主动提出建议。Jennings 的原话是："我们对用户有足够深入的理解，如果还要靠客户问对问题才能帮到他们，那是我们的失败。"

Moneybot 使用三个不同的 AI 模型，根据用户的问题类型自动选择。所有涉及资金移动的操作都需要用户确认，但确认流程通常就是按一个按钮或在对话框里说"是"。

这和传统银行的做法形成鲜明对比。JPMorgan Chase 的首席数据官对 McKinsey 表示，大型银行还在观望 agentic AI，主要担心 AI 出错买了不该买的东西，或被恶意利用。

Block 的逻辑是：因为对用户理解够深，所以敢让 AI 主动行动。护城河不在"技术"，在于"理解"。

### 五、Jevons 悖论：工程师会变多还是变少？

Jennings 自己提出了一个反直觉的观点。他认为，对一个特定产品或 roadmap 来说，需要的工程师、设计师和 PM 确实会变少。但放到整个产业来看，他援引了 Jevons 悖论：当某项资源的使用效率大幅提升，总需求反而可能增加，因为"现在有一个超集的东西是可以被建造出来的"。

经济学家 Anton Korinek 对 Fortune 的看法比较谨慎："2025 年 AI 对就业市场的影响还很模糊，但过去几个月 AI 能力的进步很快。这可能是白领工作被更严重威胁的新趋势的起点。一旦少数公司带头，竞争压力会迫使其他公司跟进。"

Challenger Gray & Christmas 的数据显示，2025 年有约 55,000 个美国科技职位裁员时引用了 AI 因素，占全年约 120 万总裁员数的 4.5%。市场和状况（21%）、重组（11%）和成本削减（7%）仍然是更常见的裁员原因。

但 2025 年的 McKinsey 报告也指出，大多数企业还在 AI 导入的实验阶段，近三分之二尚未规模化部署。Oxford Economics 在 2026 年 1 月的报告指出，许多 CEO 口中"因 AI 裁员"其实是疫情期间过度招聘的回调。

## 可实践建议

| 行动项 | 适用场景 | 具体做法 | 风险提示 |
|--------|----------|----------|----------|
| 评估 AI 工具成熟度 | 技术团队 | 用 Claude Code 或 Goose 处理既有代码库，记录效率差距 | 不要只测新项目，要测复杂既有系统 |
| 重新定义角色分工 | 工程团队 | 从"人均产出"转向"人均指挥 agent 数"指标 | 需要配套的 context 管理机制 |
| 小范围试点 | 非技术部门 | 选一个高重复性流程，用 AI agent 替代 | 先跑 3 个月，看容错率 |
| 建立护城河清单 | 公司战略层 | 列出"只有我们理解"的领域，AI 能放大这些理解 | 如果清单是空的，可能被"vibe code"掉 |
| 开源 vs 自建权衡 | 技术决策 | Goose 是开源的，评估是否值得自建类似框架 | 自建成本高，但可控性强 |

## 一句话总结

Block 裁员 40% 不是因为经营不善，而是因为 AI 工具让生产力与组织结构的关系断裂——真正的护城河是"理解"，不是"人头"。

---

## 相关链接

- [原文：Block 砍掉四千人之後：一家上市公司如何用 AI 重建自己](https://tenten.co/learning/block-is-rebuilding-with-ai/)
- [Goose GitHub 开源项目](https://github.com/block/goose)
- [Goose 官方文档](https://block.github.io/goose/)
- [Block 官方公告：Goose 开源介绍](https://block.xyz/inside/block-open-source-introduces-codename-goose)
- [Fortune 报道：Jack Dorsey 因 AI 裁员 4000 人](https://fortune.com/2026/02/27/block-jack-dorsey-ceo-xyz-stock-square-4000-ai-layoffs/)
- [CNN Business：Block 因 AI 裁减近半员工](https://www.cnn.com/2026/02/26/business/block-layoffs-ai-jack-dorsey)
- [Reuters：Block AI 改裁近半员工](https://www.reuters.com/business/blocks-fourth-quarter-profit-rises-announces-over-4000-job-cuts-2026-02-26/)
- [TechCrunch：Cash App 推出 Moneybot AI 助手](https://techcrunch.com/2025/11/13/cash-app-debuts-a-new-ai-assistant-that-answers-questions-about-your-finances/)
- [Linux Foundation：Agentic AI Foundation 成立公告](https://www.linuxfoundation.org/press/linux-foundation-announces-the-formation-of-the-agentic-ai-foundation)
- [Cash App Moneybot 官方帮助文档](https://cash.app/help/us/en-US/671-moneybot-on-cash-app)