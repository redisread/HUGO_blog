---
title: "Google Stitch 2.0 + Claude Code：工程师终于不用再为 UI 设计挣扎"
date: 2026-03-31
draft: false
tags: ["ai", "claude", "frontend", "design", "vibe-coding"]
categories: ["tech"]
description: "AI 能写逻辑但 UI 一做就崩？Stitch 2.0 用 design.md 解决设计一致性难题，配合 Claude Code 实现 30 分钟从 0 到可用原型。"
---

2026 年 3 月，Google 推出了 Stitch 2.0 的 Web 模式。搭配 Anthropic 的 Claude Code 通过 MCP（Model Context Protocol）串接，形成了一套从设计到部署的完整工作流程。这套组合的核心价值在于：让不擅长前端设计的开发者，能在 30 分钟内从零产出一个可用的网页原型。

<!--more-->

开发者 Prajwal Tomar 近期在 X 上分享了他的实测心得，标题直接点出「Claude Code + Stitch 2.0 彻底改变了我设计 App 的方式」。他的核心论点是：**如果你的应用看起来像「AI 量产品」，问题出在工作流程，不在工具本身。**

## Stitch 2.0 到底解决了什么问题

AI 编码工具目前面临的一个实际困境是：程序逻辑写得出来，但前端界面一做就走样。你在 prompt 里描述了配色和间距，AI 生成了一个按钮组件，再要求做一张卡片时，字体大小、颜色、留白全跑掉了。

问题的根源在于 AI 编码工具**没有持久的设计系统意识**。每次生成新组件时，它都从头猜测你要什么风格。

Stitch 2.0 用 `design.md` 文件解决了这件事。这份 Markdown 文件记录了完整的设计系统规格，包括色彩、字体、间距、组件模式。Claude Code 读取后，就能在整个项目中一致地套用同一套视觉语言。

## 两条主要工作流程

目前实务上有两种串接方式，适合不同场景：

### 流程一：design.md 手动导出

1. 在 Stitch 2.0 的 Web 模式中描述你要的 UI——建议选 Gemini Pro 模型，品质明显高于 Flash
2. 导出 `design.md` 文件，内含色彩代码、字体规格、组件布局等完整设计参数
3. 将文件喂给 Claude Code，指定技术栈（例如 React + Tailwind CSS）
4. Claude Code 依照设计规格生成前端代码，过程中可以即时修正

这条路线适合单一项目。你失去了即时同步的能力，但设定过程最简单。

### 流程二：MCP 直接串接

通过 [stitch-mcp](https://github.com/davideast/stitch-mcp) 工具，Claude Code 可以直接存取 Stitch 的设计资源——HTML、CSS、截图、设计 token 全部即时取用。设定方式是在 Claude Code 的 MCP 设定档中加入：

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

MCP 串接的优势在于**双向同步**。你在 Stitch 里调整设计，Claude Code 那边会即时反映。Google Labs 也释出了官方的 [Stitch Skills](https://github.com/google-labs-code/stitch-skills) 套件，包含 prompt 强化、设计系统文件生成、React 组件转换等功能。

## 实际操作中的注意事项

用过这套流程的开发者普遍回报几个共同经验：

**效果好的场景**：Landing Page、营销页面、简易仪表板、个人作品集、React 标准应用。有团队实测在 10 分钟内完成一个高端室内设计网站，从设计系统到视觉组件全部到位。

**容易出问题的地方**：
- 间距（padding 和 margin）经常「接近但不精确」
- 图片都是占位符，需要手动替换
- Stitch 的设计是静态的，任何 hover 效果、动画、转场都需要额外指定
- 多页面应用中共享导航列的状态管理，目前还是个痛点

对于 Vibe Coding 爱好者来说，这套流程最大的改变在于「设计品质的下限」被大幅提高了。过去用 AI 从头写前端，成品往往看得出机器味。现在有了 Stitch 做设计输入，加上 Claude Code 的程序代码生成能力，产出的品质至少达到「可以拿去给人看」的水准。

## 与既有工具生态的比较

过去设计师和开发者的协作，通常经过 Figma 设计→开发者手动还原的流程，中间的落差是出了名的大。Cursor + Figma MCP 是另一条路线，走的是把 Figma 设计稿直接喂给 AI 编码工具的思路。

Stitch 2.0 的差异点在于它**从一开始就为 AI 消费设计**。`design.md` 文件不是设计师的交付物转档，而是 AI 原生可读的结构化规格。这让设计到程序代码的转换损耗比较小。

不过要注意，Stitch 目前还在 Google Labs 阶段，每月免费额度是 350 次生成。Claude Code 则需要 Pro 方案（约 NTD 640/月）。对照 Bolt.new、Lovable 等一站式 AI 开发工具，Stitch + Claude Code 的优势在于**设计品质更高、技术栈更弹性**；劣势是设定步骤多、学习曲线稍陡。

## 从工作流程看 AI 辅助开发的走向

21st.dev 提供 AI Coding 专用的 UI 组件库，Andrew Ng 的 Claude Code 课程涵盖了 Agentic Workflow 的实作基础——这些工具和教育资源的出现，指向一个共同趋势：**AI 辅助开发正从「写程序代码」延伸到「做设计」。**

Prajwal Tomar 在文章中的观察值得关注：真正区分「AI 量产品」和「专业产品」的，是开发者是否有一套**结构化的设计输入流程**。单纯靠 prompt 描述 UI，结果难以控制。有了 Stitch 这类工具生成的设计规格做锚点，AI 才有办法在整个项目中维持一致性。

对团队来说，这套流程的潜在价值在于**压缩设计与开发之间的来回次数**。过去一个 Landing Page 从设计到上线可能要设计师半天加开发者一整天。现在同一个人在一个下午就能完成原型。那个省下来的时间可以花在用户测试和内容优化上，对最终品质的影响可能更大。

## 个人实测心得

我在测试这套流程时最意外的发现是：`design.md` 不只对 Claude Code 有用。把同一份设计规格丢给任何 AI 编码工具——Cursor、Copilot、甚至是 ChatGPT 的 Canvas——出来的界面一致性都会明显提升。

这代表 Stitch 的真正价值不在于它是哪家公司的产品，而在于**「结构化设计规格」这个概念本身**。从前你可能花两小时在 Figma 上排版，然后再花三小时跟开发者沟通「这里的间距不对」。现在整个过程压缩到一杯咖啡的时间。

这不是魔法，但确实是个实际的效率跳升。

---

**参考来源**：
- [Google Stitch 官方文件](https://stitch.withgoogle.com/docs/mcp/setup/)
- [stitch-mcp GitHub Repository](https://github.com/davideast/stitch-mcp)
- [Stitch Skills Agent Library](https://github.com/google-labs-code/stitch-skills)
