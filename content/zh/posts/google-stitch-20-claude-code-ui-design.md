---
title: "Google Stitch 2.0 + Claude Code：工程师终于不用再为 UI 设计挣扎"
subtitle: "探索 AI 工具如何彻底改变 UI 设计工作流"
date: 2026-04-01T17:16:05+08:00
publishDate: 2026-04-01T17:16:05+08:00
aliases:
description: "Google Stitch 2.0 与 Claude Code 完美结合，让不擅长前端设计的开发者能在 30 分钟内从零产出一个可用的网页原型。本文详细介绍这套工作流程的实际应用。"
image: https://s4.tenten.co/learning/content/images/2026/03/Tenten_AI_3d_rendering_blue_and_white_lines_of_the_same_lengt_cb75d844-6805-469a-abfd-1c3d5375a0e6_1.jpeg
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
tags: ["AI", "Claude Code", "Google Stitch", "UI设计", "开发工具"]
series: []
categories: ["技术"]
---

## 引言

2026 年 3 月，Google 推出了 **Stitch 2.0** 的 Web 模式，搭配 Anthropic 的 **Claude Code**，透过 **MCP（Model Context Protocol）** 串接，形成了一套从设计到部署的完整工作流程。这套组合的核心价值在于：让不擅长前端设计的开发者，能在 **30 分钟内从零产出一个可用的网页原型**。

开发者 Prajwal Tomar 在 X 上分享了他的实测心得："Claude Code + Stitch 2.0 彻底改变了我设计 App 的方式"。他的核心论点是：如果你的应用程式看起来像"AI 量产品"，问题出在工作流程，不在工具本身。

## Stitch 2.0 解决的核心问题

AI 编码工具目前面临的一个实际困境是：**程式逻辑写得出來，但前端介面一做就走样**。你在 prompt 里描述了配色和间距，AI 生成了一个按钮元件，再要求做一张卡片时，字体大小、颜色、留白全跑掉了。

问题的根源在于 AI 编码工具没有持久的**设计系统意识**。每次生成新元件时，它都从头猜测你要什么风格。

Stitch 2.0 用 `design.md` 文件解决了这件事。这份 Markdown 文件记录了完整的设计系统规格，包括色彩、字型、间距、元件模式。Claude Code 读取后，就能在整个项目中一致地套用同一套视觉语言。

## 两条主要工作流程

目前实务上有两种串接方式，适合不同场景：

### 流程一：design.md 手动匯出

1. 在 Stitch 2.0 的 Web 模式中描述你要的 UI —— 建议选择 **Gemini Pro 模型**，品质明显高于 Flash
2. 匯出 `design.md` 文件，内含色彩代码、字型规格、元件佈局等完整设计参数
3. 将文件餵给 Claude Code，指定技术栈（例如 React + Tailwind CSS）
4. Claude Code 依照设计规格生成前端程式码，过程中可以即时修正

这条路线适合单一项目。你失去了即时同步的能力，但设定过程最简单。

### 流程二：MCP 直接串接

透过 [stitch-mcp](https://github.com/davideast/stitch-mcp) 工具，Claude Code 可以直接存取 Stitch 的设计资源 —— HTML、CSS、截图、设计 token 全部即时取用。设定方式是在 Claude Code 的 MCP 设定档中加入：

```json
{
  "mcpServers": {
    "stitch": {
      "command": "npx",
      "args": ["@_davideast/stitch-mcp", "proxy"]
    }
  }
}
```

MCP 串接的优势在于**双向同步**。你在 Stitch 里调整设计，Claude Code 那边会即时反映。Google Labs 也释出了官方的 [Stitch Skills](https://github.com/google-labs-code/stitch-skills) 套件，包含 prompt 增强、设计系统文件生成、React 元件转换等功能。

## 实际操作中的注意事项

用过这套流程的开发者普遍回报几个共同经验：

### 效果好的场景

- Landing Page
- 行销页面
- 简易仪表板
- 个人作品集
- React 标准应用

有团队实测在 **10 分钟内完成一个高端室内设计网站**，从设计系统到视觉元件全部到位。

### 容易出问题的地方

- **间距问题**：padding 和 margin 经常"接近但不精确"
- **图片佔位符**：需要手动替换
- **静态设计**：Stitch 的设计是静态的，任何 hover 效果、动画、转场都需要额外指定
- **多页面状态管理**：多页面应用中共享导览列的状态管理，目前还是个痛点

对于 Vibe Coding 爱好者来说，这套流程最大的改变在于"**设计品质的下限**"被大幅提高了。过去用 AI 从头写前端，成品往往看得出机器味。现在有了 Stitch 做设计输入，加上 Claude Code 的程式码生成能力，产出的品质至少达到"可以拿去给人看"的水准。

## 与既有工具生态的比较

过去设计师和开发者的协作，通常经过 **Figma 设计 → 开发者手动还原** 的流程，中间的落差是出了名的大。Cursor + Figma MCP 是另一条路线，走的是把 Figma 设计稿直接餵给 AI 编码工具的思路。

Stitch 2.0 的差异点在于它从一开始就为 **AI 消费设计**。`design.md` 文件不是设计师的交付物转档，而是 AI 原生可读的结构化规格。这让设计到程式码的转换損耗比较小。

不过要注意，Stitch 目前还在 Google Labs 阶段，每月免费额度是 **350 次生成**。Claude Code 则需要 Pro 方案（约 NTD 640/月）。对照 Bolt.new、Lovable 等一站式 AI 开发工具，Stitch + Claude Code 的优势在于：

- **优势**：设计品质更高、技术栈更弹性
- **劣势**：设定步骤多、学习曲线稍陡

## 从工作流程看 AI 辅助开发的走向

21st.dev 提供 AI Coding 专用的 UI 元件库，Andrew Ng 的 Claude Code 课程涵盖了 Agentic Workflow 的实作基础 —— 这些工具和教育资源的出现，指向一个共同趋势：**AI 辅助开发正从"写程式码"延伸到"做设计"**。

Prajwal Tomar 在文章中的观察值得关注：真正区分"AI 量产品"和"专业产品"的，是开发者是否有一套**结构化的设计输入流程**。单纯靠 prompt 描述 UI，结果难以控制。有了 Stitch 这类工具生成的设计规格做锚点，AI 才有办法在整个项目中维持一致性。

对团队来说，这套流程的潜在价值在于**压缩设计与开发之间的来回次数**。过去一个 Landing Page 从设计到上线可能要设计师半天加开发者一整天。现在同一个人在一个下午就能完成原型。那个省下来的时间可以花在用户测试和内容优化上，对最终品质的影响可能更大。

## 实测心得

我在测试这套流程时最意外的发现是：**design.md 不只对 Claude Code有用**。把同一份设计规格丢给任何 AI 编码工具 —— Cursor、Copilot、甚至是 ChatGPT 的 Canvas —— 出来的介面一致性都会明显提升。

这代表 Stitch 的真正价值不在於它是哪家公司的产品，而在於"**结构化设计规格**"这个概念本身。从前你可能花两小时在 Figma 上排版，然后再花三小时跟开发者沟通"这里的间距不对"。现在整个过程压缩到一杯咖啡的时间。这不是魔法，但确实是个实际的效率跳升。

## 引用来源

- [Google Stitch 官方文件](https://stitch.withgoogle.com/docs/mcp/setup/) — Google Labs
- [stitch-mcp GitHub Repository](https://github.com/davideast/stitch-mcp) — David East
- [Stitch Skills Agent Library](https://github.com/google-labs-code/stitch-skills) — Google Labs Code
- [Model Context Protocol 规范](https://modelcontextprotocol.io/) — Anthropic
- [MindStudio: Design.md + Claude Code Workflow](https://www.mindstudio.ai/blog/google-stitch-design-md-claude-code-consistent-ui) — MindStudio
- [原文来源](https://tenten.co/learning/google-stitch-20-claude-code/) — Tenten AI

