---
title: "Anthropic 发布 Mythos Preview：45+ 科技巨头联手用 AI 防御网络安全"
subtitle: "当 AI 能在几分钟内发现人类几十年未察觉的漏洞时，我们该如何应对？"
date: 2026-04-09T01:08:31Z
publishDate: 2026-04-09T01:08:31Z
aliases:
description: Anthropic 发布 Claude Mythos Preview 模型，该模型在网络安全测试中展现出惊人的漏洞发现能力。同时启动 Project Glasswing 项目，联合 45+ 科技巨头共同应对 AI 时代的网络安全挑战。
image: "https://cos.jiahongw.com/rss-daily/20260409/cover.png"
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪰
authorImageUrl:
tocLevels: ["h1","h2", "h3", "h4"]
libraries: []
tags: ["AI", "网络安全", "Anthropic", "Claude", "Project Glasswing"]
series: []
categories: ["技术"]
---

## 核心观点

2026年4月7日，Anthropic 正式发布了 Claude Mythos Preview 模型，同时宣布启动 Project Glasswing 项目。这不仅仅是一次模型发布，而是 AI 时代网络安全范式转变的开端。**Mythos Preview 不是因为强大才被限制发布，而是因为太危险——它能在几分钟内发现人类安全研究员几十年都未曾察觉的漏洞。**

Project Glasswing 的名字源自玻璃翅膀蝴蝶（Glasswing Butterfly），象征着透明与脆弱的美感。这个项目汇聚了 Microsoft、Apple、Google、Amazon Web Services、NVIDIA、Cisco 等 45+ 科技巨头，Anthropic 甚至承诺投入高达 1 亿美元的使用额度，以及 400 万美元直接捐赠给开源安全组织。

![网络安全攻防对抗](https://cos.jiahongw.com/rss-daily/20260409/img-01.png)

## 深度分析

### 一、Mythos Preview：为什么它「太危险」而不公开发布？

Anthropic CEO Dario Amodei 在发布会上直言：「我们没有专门训练它擅长网络安全，我们训练它擅长代码。但作为擅长代码的副作用，它也擅长网络安全。」

这种「副作用」有多可怕？根据 Anthropic 公布的数据：

- **SWE-bench Verified 达到 93.9%**，比当前最强公开模型高出近 20 个百分点
- **GPQA Diamond 达到 94.6%**，在科学问答领域接近专家水平
- **CyberGym 达到 83.1%**，网络安全能力测试中的最高分
- 在约 1000 个开源代码库中，发现了 **595 个严重级别的漏洞**，并在 10 个系统中实现了完整的控制流劫持

更关键的是，Mythos Preview 发现的漏洞中，**有些已经存在了几十年**，经历过无数安全研究员的审查却从未被发现。这意味着 AI 的漏洞发现能力已经超越了人类最顶尖的专家。

Anthropic 的边界红队负责人 Logan Graham 表示：「我们观察到 Mythos Preview 能够完成高级安全研究员才能完成的事情。这对如何发布这类能力有非常大的影响。如果不谨慎处理，这可能成为攻击者的显著加速器。」

### 二、Project Glasswing：AI 安全的「协同漏洞披露」模式

Project Glasswing 的核心理念借鉴了软件安全领域长期以来的「协同漏洞披露」（Coordinated Vulnerability Disclosure）原则：在漏洞被公开之前，先给开发者足够的时间进行修复。

Anthropic 选择了一种「阶梯式发布」策略：

1. **第一阶段**：仅向 45+ 科技巨头和关键基础设施组织提供 Mythos Preview 访问权限
2. **第二阶段**：这些组织使用模型扫描自身系统，发现并修复漏洞
3. **第三阶段**：逐步扩大访问范围，最终（如果安全评估通过）才会考虑公开发布

Google 安全工程副总裁 Heather Adkins 在声明中表示：「Google 很高兴看到这个跨行业网络安全倡议的形成。我们一直认为 AI 在网络安全领域提出了新的挑战，同时也打开了新的机遇。」

Microsoft 全球首席信息安全官 Igor Tsyganskiy 则更加直接：「当我们进入网络安全不再仅受人类能力限制的阶段时，负责任地使用 AI 来大规模改善安全、降低风险的机会是前所未有的。」

![科技巨头联盟协作](https://cos.jiahongw.com/rss-daily/20260409/img-02.png)

### 三、攻击与防御的博弈：AI 如何改变网络安全格局？

网络安全本质上是一场猫鼠游戏。攻击者寻找漏洞，防御者修复漏洞。AI 的介入从根本上改变了这场游戏的节奏：

**对攻击者而言：**
- 漏洞发现从「需要高级专家团队数月努力」变成「AI 几分钟就能完成」
- 攻击成本大幅降低，攻击门槛从专业技能变成了 API 访问权限
- 自动化的漏洞利用链生成成为可能

**对防御者而言：**
- 同样的 AI 能力可以用于快速发现自身系统的漏洞
- 在攻击者利用漏洞之前完成修复，实现「抢占先机」
- 安全审计从周期性检查变成持续性监控

这正是 Project Glasswing 的核心逻辑：**如果 AI 的攻击能力不可避免地扩散，那就先让防御者获得同样的能力。**

Anthropic 强调，他们观察到 AI 能力正在「颠覆当前的软件安全和数字防御实践」，许多现代安全范式所依赖的假设可能会被打破。

### 四、行业生态：为什么竞争对手愿意合作？

值得注意的是，Project Glasswing 的参与者中包括了 Anthropic 的直接竞争对手——Google 和 Microsoft 都有自己的 AI 模型和网络安全产品。为什么它们愿意加入？

**第一，网络安全的特殊性。** 安全漏洞一旦被利用，影响的不是单一公司，而是整个数字生态系统。Microsoft 的操作系统漏洞可能影响全球数十亿用户，Google 的浏览器漏洞可能威胁所有网民。

**第二，AI 能力的扩散不可避免。** Anthropic 并非唯一在开发强大 AI 模型的公司。如果 Anthropic 不做，其他公司迟早也会开发出类似能力。与其各自为战，不如协同应对。

**第三，防御优先的窗口期有限。** Anthropic 的 Graham 指出：「我们需要现在为一个这些能力在 6、12、24 个月后广泛可用的世界做准备。」Project Glasswing 是抢占防御先机的唯一机会。

Linux 基金会的参与尤其值得注意，这表明开源生态系统同样面临威胁——开源代码是全球基础设施的基石，其中的漏洞一旦被发现，影响范围可能极其广泛。

### 五、未来展望：AI 时代的安全范式转型

Project Glasswing 只是起点。Anthropic 明确表示：「这个项目如果只是一小部分公司在使用模型，它就会失败。它必须成长为一个更大的东西。」

几个关键问题值得思考：

**1. AI 安全监管框架**
当 AI 模型能够自主发现安全漏洞时，现有的安全监管框架是否需要更新？模型开发者应该承担怎样的责任？

**2. 开源与闭源的博弈**
Mythos Preview 目前不公开发布，但开源模型的能力也在快速提升。开源社区如何在追求透明与保障安全之间平衡？

**3. 技能转型**
传统安全研究员的角色将如何变化？从「漏洞发现者」变成「AI 漏洞审核者」？

**4. 国际协作**
网络安全是全球性问题。当 AI 能力成为双刃剑，各国如何在技术共享与安全管控之间找到平衡？

## 可实践建议

| 对象 | 建议 | 时间框架 |
|------|------|----------|
| **企业安全团队** | 开始评估 AI 辅助安全审计工具，建立 AI 漏洞发现流程 | 立即 |
| **软件开发者** | 在代码审查流程中引入 AI 扫描，关注 Mythos 等模型发现的漏洞模式 | 3-6 个月 |
| **开源维护者** | 申请加入 Project Glasswing 的开源安全捐赠计划，获取 AI 安全扫描资源 | 立即 |
| **安全研究员** | 学习 AI 模型的漏洞发现逻辑，转型为 AI 安全审计专家 | 6-12 个月 |
| **技术管理者** | 建立内部 AI 安全使用规范，防止 AI 能力被滥用 | 立即 |
| **企业决策者** | 评估关键系统的 AI 安全审计预算，将安全投入视为基础设施投资 | 3-6 个月 |

## 一句话总结

**AI 的漏洞发现能力已经超越人类，Project Glasswing 是科技巨头在 AI 安全时代抢占防御先机的关键尝试——成败取决于能否在攻击者获得同等能力之前，完成全球数字基础设施的安全升级。**

---

## 相关链接

- [Anthropic Project Glasswing 官方公告](https://www.anthropic.com/glasswing)
- [Claude Mythos Preview System Card](https://www.anthropic.com/claude-mythos-preview-system-card)
- [WIRED: Anthropic Teams Up With Its Rivals to Keep AI From Hacking Everything](https://www.wired.com/story/anthropic-mythos-preview-project-glasswing/)
- [CyberScoop: Tech giants launch AI-powered Project Glasswing](https://cyberscoop.com/project-glasswing-anthropic-ai-open-source-software-vulnerabilities/)
- [Anthropic Red Team: Claude Mythos Preview 安全评估](https://red.anthropic.com/2026/mythos-preview/)
- [InfoSecurity Magazine: Anthropic Project Glasswing](https://www.infosecurity-magazine.com/news/anthropic-launch-project-glasswing/)