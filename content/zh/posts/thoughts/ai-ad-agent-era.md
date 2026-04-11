---
title: "AI 广告代理人时代：广告投手不会失业，但工作内容已经变了"
date: 2026-03-30T17:00:00+08:00
publishDate: 2026-03-30T17:00:00+08:00
description: "2026年广告投放工作正在从「按钮操作员」转型成「agent指挥官」。OpenClaw和Claude Code重新定义了广告投放的工作流程。"
image: "https://cos.jiahongw.com/ai-ad-agent/20260330/cover.png"
draft: false
author: VictorHong
authorEmoji: 🪶
tags: ["AI", "广告投放", "OpenClaw", "Claude Code", "营销自动化"]
categories: ["思考"]
---

2026年3月，两个数字震惊了营销圈：OpenClaw在60天内拿下25万GitHub星，打破React十年记录；Claude Code年化营收突破25亿美元。这两个工具分别从"自主任务执行"和"代码级营销工程"两个方向，重新定义了广告投放的工作流程。

Salesforce 2026年营销报告显示，90.3%的营销团队已在至少一项功能中部署AI agent，AI营销自动化市场规模达到470亿美元。但真正值得思考的不是这些数字，而是背后隐藏的转变：**广告投手的核心技能正在从"操作工具"变成"设计系统"**。

## 先讲结论

广告投手不会被AI取代，但只会手动操作Meta Ads Manager的投手会被淘汰。

这不是危言耸听。AdVenture Media Group的案例显示，12人团队靠agentic工作流管理超过80个高单价客户，手动操作的工时减少了90%。以前一个资深投手管10-15个客户账户已经是极限，每个客户的月报要花两天整理。现在用Claude Code建好自动化pipeline之后，同一套系统可以在40分钟内跑完80个客户的报表。

但这并不意味着人类变得无用。恰恰相反，人类的价值在提升——从重复劳动中解放出来，去做真正需要判断力的事情。**Gartner预测到2028年，15%的日常工作决策会由agentic AI自主做出，但这意味着85%仍然需要人类判断。**

## OpenClaw vs Claude Code：两种AI Agent范式

理解这两个工具的差异，是理解AI广告代理人时代的第一步。

{{< img src="https://cos.jiahongw.com/ai-ad-agent/20260330/img-01.png" title="两种AI Agent范式对比" >}}

**OpenClaw是"让agent在通讯软件里自主跑任务"。** 它通过WhatsApp、Telegram、Discord等通讯软件当作操作介面，agent在本机执行，可以读写文件、跑shell指令、浏览网页、呼叫API。核心场景是24/7 always-on的自主监控——预算自动调整、Landing Page健康检查、竞品素材监控。

**Claude Code是"让营销人员用命令列建立完整的广告工程系统"。** 它更适合需要建构复杂系统的场景：竞品分析pipeline、批量素材生成、跨平台报表整合。它的价值在于"代码级"的控制力——不只是自动化执行，而是建立可持续演进的营销工程架构。

| 维度 | OpenClaw | Claude Code |
|------|----------|-------------|
| 介面 | WhatsApp/Telegram/Discord | 终端机（CLI） |
| 核心能力 | 24/7自主执行、跨平台消息控制 | 读写本机文件、执行程式码、重构程式码 |
| 广告应用 | 预算自动调整、Landing Page健康检查 | 竞品分析agent、报表pipeline、批量素材生成 |
| 扩展方式 | 安装社群Skills | 撰写Node.js/Python脚本 |
| 年化营收（2026.3） | 开源免费（API成本另计） | USD 25亿 |

一个有趣的对比：OpenClaw的社区技能系统（SKILL.md + ClawHub）像是一个"技能市集"，你可以安装别人写好的skill，快速获得能力扩展；Claude Code的CLAUDE.md记忆档更像是一个"个人知识库"，你需要自己积累领域知识，但一旦建立就持续有效。

## 深度思考：为什么"模式匹配vs问题解决"的对比是误导性的

社区里有一种流行的说法："Claude Opus擅长模式匹配和遵循指令，Codex擅长问题解决"。这个对比听起来很有道理，但实际上是误导性的。

**第一，原版Codex已经退役。** 2023年OpenAI就退役了Codex，现在GitHub Copilot用的是GPT-4/GPT-4o系列。如果指的是OpenAI o1/o3系列推理模型，那确实在复杂推理任务上领先，但"问题解决"这个维度没有官方基准测试直接支持。

**第二，"模式匹配"和"问题解决"不是对立概念。** Claude Opus在SWE-bench Verified上得分43-49%，这个成绩恰恰证明了它在"问题解决"上的能力。关键差异不是能力类型，而是**工作方式**——Claude强调长上下文理解和指令遵循稳定性，OpenAI o系列强调推理链展开和问题分解。

**第三，这个对比忽略了场景差异。** 在广告投放场景，"问题解决"往往是结构化的——你需要分析数据、做决策、执行调整。这类任务Claude和OpenAI都能做，差异在于你希望agent有多大的自主性。Claude Code的Plan Mode强制人工审核步骤，OpenClaw则可以24/7自主运行。

**更准确的对比应该是：**

- **Claude Opus/Code**：上下文理解、多步骤稳定性、指令遵循强
- **OpenAI o1/o3**：复杂推理、问题分解、数学能力强
- **GPT-4o**：速度、多模态、通用性好

选模型别迷信标签，看具体任务需求才是正道。

## 安全悖论：AI Agent的快速发展伴随着严重风险

OpenClaw的快速成长带来严重的安全问题。两个月内累积了9个以上的CVE（通用漏洞揭露），42,665个OpenClaw实例在公开网络上被发现暴露。Bitdefender在ClawHub上找到超过824个恶意skill，占整个skill仓库的20%，大多数会安装AMOS信息窃取软件。

这揭示了一个悖论：**AI agent越强大，安全风险越大。** OpenClaw可以在本机读写文件、跑shell指令、浏览网页、呼叫API——这些能力正是它的价值所在，但也正是风险的来源。Peter Steinberger自己连门锁系统都接上了OpenClaw，但他也承认："理论上，AI可以把我锁在门外。"

Nvidia在GTC 2026发布了NemoClaw来回应这个问题。核心元件是OpenShell——一个在程序层级做沙箱隔离的开源执行时期。但Nvidia自己也明确说"这不是生产就绪的软件"。对企业来说，NemoClaw解决的是第一层问题（沙箱隔离），但多租户治理、PII侦测、成本归因、合规稽核这些还需要另外建置。

**不管用OpenClaw还是Claude Code来做广告自动化，这几个安全原则要守住：**

- 用Claude Code的话，永远开Plan Mode（Shift+Tab）审查agent打算执行的步骤
- 不要用主账号的管理员权限连接API，建立只读的服务账号
- 把敏感客户数据通过中介层脱敏之后再给agent处理
- 用OpenClaw的话，建议搭配NemoClaw做沙箱部署，不要把OpenClaw实例暴露在公开网络上
- 安装社群skill之前先审查SKILL.md的内容和脚本

## 广告投手的转型路线图

这张表整理了不同程度的投手该怎么切入：

| 现有技能 | 建议起步 | 目标 |
|----------|----------|------|
| 只会操作Meta Ads Manager UI | 学Claude Code基础，从自动报表开始 | 每周省10小时报表工时 |
| 会写Google Sheets公式和基础SQL | 用Claude Code建GA4 + Meta API整合 | 即时ROAS监控系统 |
| 有Node.js / Python基础 | 同时用OpenClaw + Claude Code | 24/7自主优化的广告系统 |
| 已经在跑n8n / Zapier自动化 | 把OpenClaw当作控制中心 | 跨平台agent调度 |

**关键转变是思维模式：从"我要一个更好的工具"变成"我要重新设计工作流程"。**

Tenten的AI Growth Marketer - Maria Ning提出的策略是："先把基础架构建成skill"。在项目根目录建立MARKETING.md或SEO_AUDIT.md档案，让Claude Code有持续性的领域知识，不会因为开新对话就遗忘之前的脉络。

这个建议的深意在于：**AI agent的价值不是替代你做决策，而是帮你积累知识、自动化执行、释放时间让你做更高价值的判断。**

## OpenClaw和Claude Code最强的用法：搭配使用

OpenClaw和Claude Code最强的用法是搭配使用。

Tenten Tech Lead - Wean Mak在Medium上分享的案例是一个完整示范：他用Claude Code的agent teams功能建了一支AI营销团队——CMO agent负责排程和分配任务，content writer agent写文章，social media agent管社群。整套系统跑在一台Mac Mini M4上，用crontab每小时触发一次，Claude Code以headless模式执行。

每个agent就是一个markdown档案，放在.claude/agents/目录下。CMO agent读取周计划，根据当前时间段分派任务给专业agent，专业agent各自在独立的context window里平行运作。这套系统的关键在agent memory——每个agent都有持久性记忆目录（.claude/agent-memory/<agent-name>/），可以跨session记住策略、已发布的内容、效果数据。

如果要加入OpenClaw的通讯层，可以用webhook桥接：OpenClaw收到WhatsApp讯息 → 触发n8n webhook → n8n呼叫Claude Code CLI → 结果回传到OpenClaw。

这套架构的真正价值在于：**它把"通讯层"（OpenClaw）、"执行层"（Claude Code）、"编排层"（n8n/crontab）分离开来，每个层次都可以独立演进，不会因为一个环节的改变而牵动整个系统。**

## 结语：重新设计工作流程，不是寻找更好工具

从我们接触的客户案例来看，导入agentic工作流的团队在三个月内，营销营运效率提升了30-40%，报表和素材生成的工时缩减最为显著。但最大的收益不是效率提升，而是**人的价值重新定位**。

广告投手的核心价值从来不是"设定出价策略"或"看报表调预算"，而是**定义品牌定位、解读市场信号、做策略判断**。这些工作以前被淹没在重复劳动里，现在AI agent把它们解放出来了。

**真正的转变是：从"按钮操作员"变成"agent指挥官"。**

如果你的团队正在评估AI广告代理人的建构方案，记住这个原则：不要问"哪个工具更好"，要问"我的工作流程需要怎样重新设计"。工具会迭代，但设计好的工作流程会持续产生价值。

---

*导入agentic工作流的团队，自主agent vs 简单AI助理的ROI差异：544% vs 195%。学习曲线的投入是值得的。*
