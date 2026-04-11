---
title: "Google Stitch 完全指南：AI 原生 UI 设计的实用方法与最佳实践"
subtitle: "从提示词工程到 MCP 集成，2026 年最前沿的 AI 设计工作流详解"
date: 2026-04-04T16:10:01+08:00
publishDate: 2026-04-04T16:10:01+08:00
aliases: ["/posts/google-stitch-guide-2026"]
description: "深入解析 Google Stitch 的实用方法、提示词工程技巧、MCP 集成方案，以及与其他 AI 设计工具的对比。包含完整工作流示例和可复用的提示词模板。"
image: "https://cos.jiahongw.com/agent/20260404/cover.png"
draft: false
hideToc: false
enableToc: true
enableTocContent: true
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
tocLevels: ["h1", "h2", "h3", "h4"]
libraries: []
tags: ["AI", "UI 设计", "Google Stitch", "提示词工程", "MCP", "开发者工具"]
categories: ["技术"]
---


---

## 一、Google Stitch 是什么？

### 1.1 核心定义

Google Stitch 是一个**AI 原生 UI 设计平台**，运行于浏览器（stitch.withgoogle.com），由 Gemini 3 模型驱动。用户可通过文本、图像、草图或语音输入，生成高保真 UI 设计，并直接导出 HTML/CSS 代码或 Figma 文件。

{{< img src="https://cos.jiahongw.com/agent/20260404/01-interface.png" alt="Google Stitch 界面截图" caption="Google Stitch 的 AI 原生无限画布界面" position="center" >}}

### 1.2 关键演进节点

| 时间 | 里程碑 | 核心能力 |
|------|--------|----------|
| 2025 年 5 月 | I/O 大会发布 | 文本/图像转 UI、HTML 导出、Figma 粘贴 |
| 2025 年 12 月 | Gemini 3 升级 | 更优布局质量、**可交互原型**（屏幕连接 + 过渡动画） |
| 2026 年 3 月 | AI 原生重构 | **Voice Canvas**（语音对话）、**Vibe Design**（氛围设计）、**Direct Edits**（手动编辑） |

### 1.3 定价与限制（2026 年 3 月）

{{< notice info "定价信息" >}}
- **完全免费**，无需信用卡
- **Standard Mode**（Gemini 2.5 Flash）：350 次/月
- **Experimental Mode**（Gemini 2.5 Pro）：50 次/月，支持图像输入
- 仅需 Google 账号登录
{{< /notice >}}

---

## 二、核心功能详解

### 2.1 Text-to-UI（文本生成界面）

**工作原理**：自然语言描述 → Gemini 3 理解 → 高保真 UI 生成（多方案可选）

**最佳实践提示词结构**：

```
[页面类型] + [核心功能] + [风格形容词] + [参考对象] + [颜色/字体偏好]
```

**示例**：

```
"一个 SaaS 定价页面，三个层级（Free/Pro/Enterprise），年度/月度切换开关，
下方 FAQ 折叠面板。现代简洁风格，类似 Stripe 的网站。主色调为靛蓝色，
白色背景。"
```

{{< img src="https://cos.jiahongw.com/agent/20260404/02-text-to-ui.png" alt="Text-to-UI 示例" caption="使用文本提示生成的 SaaS 定价页面" position="center" >}}

**关键技巧**：

1. **高 vs 细平衡**：复杂应用先高层级（"一个马拉松跑步者应用"），再逐屏细化
2. **氛围形容词**：用"vibrant and encouraging"或"minimalist and focused"定义感觉
3. **避免过长提示**：超过 5000 字符会导致组件遗漏，建议分步生成

### 2.2 Image-to-UI（图像转界面）

**支持输入**：截图、手绘草图照片、现有设计参考图

**最佳实践**：

- 使用 Experimental Mode（Gemini 2.5 Pro）
- 草图需标注清晰的元素标签（"这里是导航栏"、"这是 CTA 按钮"）
- 配合提示词："重新设计这个界面，采用日式极简风格，增加留白"

**实战案例**：用户上传竞品截图，提示"用深色主题重新设计，提升视觉层次"，5 分钟内获得 3 个 redesign 方案。

### 2.3 Voice Canvas（语音画布）⭐ 2026 年 3 月新增

{{< notice success "核心能力" >}}
- 直接语音对话："给我三个不同的菜单布局"
- AI 主动提问："你的目标用户是谁？"
- 实时设计 critique："这个按钮对比度不够，不符合 WCAG AA"
- 即时更新："把主色调改成森林绿"
{{< /notice >}}

**使用场景**：

- 早期探索阶段，打字提示词过于局限
- 快速 Brainstorming，边说边改
- 非设计师（产品经理、创始人）快速表达想法

{{< img src="https://cos.jiahongw.com/agent/20260404/03-voice-canvas.png" alt="Voice Canvas 界面" caption="Voice Canvas 支持语音对话式设计" position="center" >}}

**限制**：语音识别准确率约 85%，复杂技术术语建议打字。

### 2.4 Vibe Design（氛围设计）⭐ 2026 年 3 月新增

**传统工作流**：画线框 → 选组件 → 调颜色 → 反复修改

**Vibe Design 工作流**：描述感受 → AI 生成多方向 → 选择 → 细化

**示例提示词**：

```
"我想让用户感到高端和信任，像 Stripe 的网站。目标是 30 秒内完成注册。
给我 5 个不同的设计方向。"
```

{{< img src="https://cos.jiahongw.com/agent/20260404/04-vibe-design.png" alt="Vibe Design 示例" caption="Vibe Design 生成的 5 个不同设计方向" position="center" >}}

**优势**：10 分钟内探索 10 个设计方向，传统流程只能完成 1 个线框。

### 2.5 Instant Prototypes（即时原型）⭐ 2025 年 12 月新增

**功能**：

- 选择 2+ 屏幕 → 定义跳转关系 → 点击"Play"预览
- AI 可自动生成"下一个逻辑屏幕"（登录页 → 首页）

**实战案例**：

```
提示词："生成登录页、注册页、忘记密码页，连接成可点击原型"
→ 3 个屏幕 + 2 个跳转关系 + 过渡动画，5 分钟完成
```

### 2.6 Direct Edits（直接编辑）⭐ 2026 年 3 月新增

**能力**：

- 点击文本直接修改
- 替换图片
- 调整间距、颜色
- 无需重新生成

**解决痛点**：之前小修改（如改按钮文字）需要重新生成整个页面，现在可直接编辑。

### 2.7 开发者导出

| 导出方式 | 格式 | 质量 |
|----------|------|------|
| HTML/CSS | 代码 | 可用，响应式，语义化改进（Gemini 3） |
| Figma | Auto Layout + 可编辑图层 | 高，非扁平图片 |
| Google AI Studio | 项目文件 | 中，需添加后端逻辑 |
| Antigravity | 完整前端项目 | 高，AI 代理自动添加功能 |

---

## 三、最佳实践：提示词工程

### 3.1 官方提示词框架

Google AI 开发者论坛上，Stitch 产品团队负责人 Vincent Nallatamby 发布的官方指南：

#### 启动项目：高层 vs 详细

```
高层（复杂应用）："一个马拉松跑步者应用"
详细（具体结果）："一个马拉松跑步者应用，支持社区互动、找跑伴、
获取训练建议、查找附近比赛"
```

#### 定义氛围：用形容词

```
"一个充满活力、鼓舞人心的健身追踪应用"
"一个极简、专注的冥想应用"
```

#### 迭代策略：小步、具体、增量 ⭐ 最重要

**错误做法**（会导致布局重置）：

```
"添加筛选下拉框、修改标题位置、增加齿轮图标、调整颜色主题"
```

**正确做法**（分 4 步）：

```
步骤 1："创建任务列表表格，每任务两行：第一行显示标题/操作员/截止日期，
        第二行跨列显示详细描述"
        
步骤 2："在表格上方添加筛选下拉框：标题、操作员、部门、机器、截止日期、状态"

步骤 3："将页面标题左对齐，与表格对齐"

步骤 4："右上角添加齿轮图标，用于管理设置"
```

{{< img src="https://cos.jiahongw.com/agent/20260404/01-interface.png" alt="提示词迭代示例" caption="分步迭代 vs 一次性要求的对比" position="center" >}}

#### 图像修改：具体定位

```
错误："改一下图片"
正确："在'团队'页面，'Dr. Carter（首席牙医）'的照片中，把白大褂改成黑色"
```

#### 主题控制

```
颜色："将主色调改为森林绿" 或 "使用温暖、邀请的配色"
字体："使用活泼的无衬线字体" 或 "标题改用衬线体"
边框："所有按钮使用完全圆角" 或 "输入框添加 2px 黑色边框"
```

### 3.2 社区实战经验

**用户@tempo 的工业仪表板案例**：

{{< notice warning "关键教训" >}}
"我的第一次提示完美运行，Stitch 创建了两行任务结构。第二次提示添加筛选器时，它重置了整个布局。分开成 4 个独立提示后，100% 成功。"

1. 不要在同一提示中混合布局变更和 UI 组件
2. Stitch 不会"记住"之前的设计，除非极其精确和增量
3. **每一步成功后保存截图**（它会意外重置）
{{< /notice >}}

**用户@Hoang_Anh_Huynh 的移动应用案例**：

> "我尝试用 5000-7000 字符的超长提示一次生成完整屏幕，通常只能达到 60% 准确度。然后尝试修改 1-2 个具体项，经常不如预期。"

**建议**：使用 AI 助手（如 GPT-4）帮助将大需求拆分成干净、有针对性的提示序列。

---

## 四、MCP 集成：与编码代理协作

### 4.1 什么是 MCP

**Model Context Protocol (MCP)** 是 Google 推出的协议，让 AI 编码代理（Claude Code、Cursor、Gemini CLI 等）直接调用 Stitch API。

### 4.2 官方 SDK（@google/stitch-sdk）

**安装**：

```bash
npm install @google/stitch-sdk
```

**基础用法**：

```javascript
import { stitch } from "@google/stitch-sdk";

const project = stitch.project("your-project-id");
const screen = await project.generate("一个带邮箱和密码的登录页面");
const html = await screen.getHtml();
const imageUrl = await screen.getImage();
```

**高级功能**：

```javascript
// 编辑屏幕
const edited = await screen.edit("把背景改成深色，添加侧边栏");

// 生成变体
const variants = await screen.variants("尝试不同配色方案", {
  variantCount: 3,
  creativeRange: "EXPLORE",  // "REFINE" | "EXPLORE" | "REIMAGINE"
  aspects: ["COLOR_SCHEME", "LAYOUT"]
});

// 创建设计系统
const designSystem = await project.createDesignSystem({
  name: "My Brand",
  primaryColor: "#6366F1"
});
```

### 4.3 stitch-pro-mcp（18 个工具）⭐ 推荐

**安装**：

```bash
npm install -g stitch-pro-mcp
```

**核心工具**：

| 工具 | 功能 |
|------|------|
| `sp_auto` | 一键全流程：设计系统→生成→无障碍→响应式→框架转换 |
| `sp_analyze` | 分析 HTML，返回无障碍问题、响应式缺口、组件映射建议 |
| `sp_a11y` | WCAG 2.1 AA 审计 + 自动修复 |
| `sp_responsive` | 注入 Tailwind 响应式断点 |
| `sp_to_react` | HTML → Next.js .tsx 组件 |
| `sp_to_vue` | HTML → Vue 3 SFC |
| `sp_to_svelte` | HTML → SvelteKit 组件 |
| `sp_design_create` | 从品牌描述生成完整设计系统 |

{{< img src="https://cos.jiahongw.com/agent/20260404/05-mcp-workflow.png" alt="MCP 工作流示意图" caption="MCP 协议连接 Stitch 与编码代理" position="center" >}}

**Claude Code 配置**：

```bash
claude mcp add -e STITCH_API_KEY=your-api-key \
  --transport stdio stitch-pro -- node $(npm root -g)/stitch-pro-mcp/dist/bin/cli.js
```

### 4.4 stitch-kit（35 个技能）⭐ 功能最全

**安装**：

```bash
npx @booplex/stitch-kit
```

**核心能力**：

- 5 层架构：Ideation → Prompt Engineering → Generation → Iteration → Conversion
- 7 个框架目标：Next.js、Svelte、React、HTML、shadcn/ui、React Native、SwiftUI
- **解决 ID 格式问题**：Stitch API 不同工具需要不同 ID 格式，stitch-kit 自动处理

**工作流示例**：

```
1. stitch-ideate：做设计调研，分析竞品 UI，提出 3 个设计方向（带色卡、字体）
2. stitch-ui-prompt-architect：将模糊需求转成结构化提示词
3. stitch-mcp-generate-screens：批量生成最多 10 个屏幕
4. stitch-mcp-apply-design-system：应用设计系统保持一致性
5. stitch-nextjs-components：转换为 Next.js 15 组件（Server/Client 分离）
```

---

## 五、DESIGN.md：设计系统文档化

### 5.1 什么是 DESIGN.md

Google Stitch 引入的**纯文本设计系统文档**，AI 代理读取后生成一致 UI。

{{< notice info "文件对比" >}}
| 文件 | 谁读取 | 定义内容 |
|------|--------|----------|
| `AGENTS.md` | 编码代理 | 如何构建项目 |
| `DESIGN.md` | 设计代理 | 项目应该长什么样 |
{{< /notice >}}

### 5.2 标准结构（9 个部分）

```markdown
# [品牌名] Design System

## 1. Visual Theme & Atmosphere
情绪、密度、设计哲学

## 2. Color Palette & Roles
语义化命名 + hex 色值 + 功能角色

## 3. Typography Rules
字体系列、完整层级表

## 4. Component Stylings
按钮、卡片、输入框、导航的状态

## 5. Layout Principles
间距尺度、网格、留白哲学

## 6. Depth & Elevation
阴影系统、表面层级

## 7. Do's and Don'ts
设计护栏和反模式

## 8. Responsive Behavior
断点、触摸目标、折叠策略

## 9. Agent Prompt Guide
快速颜色参考、即用提示词
```

### 5.3 awesome-design-md 项目

**GitHub**: [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md)（5.4k stars）

提供 55+ 知名网站的 DESIGN.md 文件：

- **AI 类**：Claude、Cohere、ElevenLabs、Mistral AI、OpenCode
- **开发者工具**：Cursor、Linear、Vercel、Supabase、Sentry
- **设计类**：Figma、Framer、Notion、Webflow
- **企业类**：Apple、Stripe、IBM、Airbnb、Spotify

**使用方法**：

```bash
# 复制 DESIGN.md 到项目根目录
# 告诉 AI 代理："按照这个 DESIGN.md 构建 UI"
```

---

## 六、实战工作流

### 6.1 从 0 到 SaaS 落地页（15 分钟）

```
步骤 1（2 分钟）：高层提示
"一个 AI 写作助手 InkFlow 的落地页"

步骤 2（3 分钟）：细化结构
"Hero 区：标题 + 副标题 + CTA 按钮。特性区：3 个卡片展示核心优势。
社会证明：客户 Logo 墙。定价区：两个层级。页脚：链接"

步骤 3（3 分钟）：氛围定义
"让它感觉高端和可信赖，像 Stripe 的网站。主色调从深蓝渐变到紫色"

步骤 4（5 分钟）：迭代修改
- "把 CTA 文字改成'免费开始写作'"
- "在 Hero 区添加产品截图样机"
- "增加客户评价轮播"

步骤 5（2 分钟）：导出
- 点击"导出 HTML/CSS"
- 或"粘贴到 Figma"
```

{{< img src="https://cos.jiahongw.com/agent/20260404/02-text-to-ui.png" alt="落地页工作流" caption="15 分钟完成 SaaS 落地页设计" position="center" >}}

### 6.2 移动应用完整流程（30 分钟）

```
步骤 1（5 分钟）：核心屏幕
"移动健身应用的引导流程：欢迎页、目标选择、训练偏好"

步骤 2（5 分钟）：生成相关屏幕
"生成这 3 个屏幕之前和之后的屏幕"
→ 获得：登录页 → 欢迎页 → 目标选择 → 偏好设置 → 首页

步骤 3（5 分钟）：连接原型
- 多选所有屏幕
- 定义跳转关系
- 点击"Play"预览

步骤 4（10 分钟）：统一主题
- 多选所有屏幕
- 提示："应用一致的配色：主色#10B981，字体 Inter"

步骤 5（5 分钟）：导出开发
- 导出 HTML/CSS
- 或用 stitch-pro-mcp 转 React Native
```

### 6.3 竞品 Redesign（20 分钟）

```
步骤 1（2 分钟）：截图上传
截取竞品页面，上传到 Experimental Mode

步骤 2（5 分钟）：Redesign 提示
"用现代极简风格重新设计这个界面。提升视觉层次，增加留白。
采用深色主题，主色为靛蓝"

步骤 3（5 分钟）：生成变体
"生成 3 个不同布局的变体"
→ 获得：保守版、激进版、平衡版

步骤 4（5 分钟）：手动微调
- 点击文本修改
- 替换图片
- 调整间距

步骤 5（3 分钟）：导出
- 导出设计系统（colors/typography/components）
- 生成 DESIGN.md 文档
```

{{< img src="https://cos.jiahongw.com/agent/20260404/04-vibe-design.png" alt="Redesign 工作流" caption="20 分钟完成竞品 redesign" position="center" >}}

---

## 七、与竞品对比

### 7.1 Google Stitch vs v0.dev vs Lovable

| 维度 | Google Stitch | v0.dev (Vercel) | Lovable |
|------|---------------|-----------------|---------|
| **核心定位** | AI 原生设计平台 | React 组件生成 | 全栈应用构建 |
| **生成质量** | 高保真 UI（Gemini 3） | shadcn/ui 组件 | 完整应用（前端 + 后端） |
| **输出格式** | HTML/CSS、Figma | React/Next.js | React + Supabase |
| **原型能力** | ✅ 可点击原型 | ❌ 单组件 | ✅ 完整应用预览 |
| **语音交互** | ✅ Voice Canvas | ❌ | ❌ |
| **设计系统** | ⚠️ 基础 | ✅ shadcn 集成 | ✅ 组件库 |
| **价格** | 免费（350+50/月） | 免费（有限） | $25/月起 |
| **最佳场景** | 设计探索、原型 | React 开发 | 快速 MVP |

{{< notice info "选择建议" >}}
- **设计阶段**：Stitch（探索 10 个方向） → Figma（精细化）
- **React 开发**：v0（shadcn 组件） → 手写业务逻辑
- **完整 MVP**：Lovable（全栈）或 Stitch + Antigravity
{{< /notice >}}

### 7.2 Google Stitch vs Figma

| 维度 | Stitch | Figma |
|------|--------|-------|
| **核心优势** | 10 分钟探索 10 个方向 | 像素级精确控制 |
| **学习曲线** | 低（自然语言） | 高（设计工具） |
| **协作** | ❌ 单用户 | ✅ 实时多人 |
| **设计系统** | ⚠️ 基础 | ✅ 完整（Components/Variants） |
| **代码导出** | ✅ HTML/CSS | ⚠️ 需插件 |
| **价格** | 免费 | 免费（有限）/$12/月 |

**最佳实践**：Stitch 用于**探索阶段**（0→1），Figma 用于**生产阶段**（1→100）。

---

## 八、限制与边界

### 8.1 当前限制（2026 年 3 月）

{{< notice warning "限制列表" >}}
1. **无设计系统管理**：无法定义组件库、Design Tokens，每次生成相对独立
2. **协作功能缺失**：单用户工具，无实时协作、评论、版本历史共享
3. **生成次数限制**：350 次/月（Standard）+ 50 次/月（Experimental）
4. **无原生动画**：仅支持屏幕间过渡，不支持加载动画、悬停效果
5. **代码输出限制**：仅 HTML/CSS，无直接 React/Vue/SwiftUI 导出（需 MCP 转换）
6. **AI 不可预测性**：同一提示词输出质量波动，复杂布局需多次迭代
{{< /notice >}}

### 8.2 何时不该用 Stitch

- **生产级设计系统**：用 Figma
- **团队实时协作**：用 Figma
- **复杂动画/微交互**：用 Figma + Principle
- **企业级组件库**：用 Storybook + React
- **像素级还原现有设计**：手动 Figma 更快

---

## 九、资源与学习路径

### 9.1 官方资源

| 资源 | 链接 |
|------|------|
| Stitch 官网 | [stitch.withgoogle.com](https://stitch.withgoogle.com) |
| 官方提示词指南 | [Google AI 论坛](https://discuss.ai.google.dev/t/stitch-prompt-guide/83844) |
| SDK 文档 | [GitHub @google/stitch-sdk](https://github.com/google-labs-code/stitch-sdk) |
| MCP 设置 | [stitch.withgoogle.com/docs/mcp/setup](https://stitch.withgoogle.com/docs/mcp/setup) |
| Design-to-Code Codelab | [Google Codelabs](https://codelabs.developers.google.com/design-to-code-with-antigravity-stitch) |

### 9.2 社区项目

| 项目 | Stars | 描述 |
|------|-------|------|
| awesome-stitch-design | 3 | 提示词库、教程、工具 curated list |
| stitch-kit | 9 | 35 个技能，Claude Code 插件，7 框架转换 |
| stitch-pro-mcp | 3 | 18 工具，WCAG 无障碍，自动编排 |
| awesome-design-md | 5.4k | 55+ 网站 DESIGN.md 文件 |

### 9.3 学习路径建议

```
第 1 天：注册账号，生成第一个页面（文本转 UI）
第 2 天：尝试图像转 UI（上传截图 redesign）
第 3 天：学习提示词工程（官方指南 + awesome-stitch-design）
第 4 天：安装 MCP（stitch-pro-mcp），与 Claude Code 集成
第 5 天：实战项目（完整落地页或移动应用流程）
第 7 天：学习 DESIGN.md，建立自己的设计系统
```

{{< img src="https://cos.jiahongw.com/agent/20260404/06-learning-path.png" alt="学习路径图" caption="7 天掌握 Google Stitch 完整工作流" position="center" >}}

---

## 十、结语：Stitch 在 2026 年的定位

Google Stitch 已从一个简单的文本转 UI 实验，成长为**AI 原生设计平台**。它的最大价值不是"替代 Figma"，而是**重新定义设计探索的速度**。

{{< notice success "核心价值主张" >}}
- 10 分钟探索 10 个设计方向（传统需 10 小时）
- 从模糊想法到可点击原型（30 分钟 vs 3 天）
- 与编码代理无缝协作（MCP 生态）
{{< /notice >}}

**最佳实践总结**：

1. **小步迭代**：每次 1-2 个具体修改
2. **氛围优先**：用形容词定义感觉，而非组件
3. **语音加速**：早期探索用 Voice Canvas
4. **MCP 集成**：与 Claude Code/Cursor 协作
5. **DESIGN.md**：用纯文本固化设计系统

**最后一句话**：如果你还没用过 Stitch，现在就去 [stitch.withgoogle.com](https://stitch.withgoogle.com) 注册，60 秒内你会明白为什么它被称为"2026 年设计工具的颠覆者"。

---

## 参考链接

1. [Google Stitch 官方博客](https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-ai-ui-design/)
2. [Stitch Prompt Guide - Google AI 论坛](https://discuss.ai.google.dev/t/stitch-prompt-guide/83844)
3. [@google/stitch-sdk - GitHub](https://github.com/google-labs-code/stitch-sdk)
4. [stitch-pro-mcp - GitHub](https://github.com/LuciferDono/stitch-pro-mcp)
5. [stitch-kit - GitHub](https://github.com/gabelul/stitch-kit)
6. [awesome-design-md - GitHub](https://github.com/VoltAgent/awesome-design-md)
7. [NxCode: Google Stitch Complete Guide 2026](https://www.nxcode.io/resources/news/google-stitch-complete-guide-vibe-design-2026)
