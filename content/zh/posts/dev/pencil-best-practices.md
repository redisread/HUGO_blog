---
title: Pencil 最佳实践：IDE 内设计到代码的完整工作流
date: 2026-03-11 17:25:00
publishDate: 2026-03-11 17:25:00
description: 详解如何使用 Pencil 在 VS Code/Cursor 中直接设计 UI 并自动生成代码，涵盖 .pen 文件管理、设计到代码工作流、双向同步策略与 Design Token 管理
image: https://openclaw.cos.jiahongw.com/blog/pencil-best-practices-cover.png
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
tocLevels: ["h2", "h3", "h4"]
tags: [Pencil, 设计工具, AI编程, VS Code, Cursor, Design Token, 设计到代码]
categories: [dev]
---

## 概述

Pencil 是一个嵌入 IDE 的矢量设计工具，支持在 VS Code/Cursor 中直接绘制 UI 设计稿，并通过 AI 自动生成代码，还能实现设计与代码的双向同步。本文从核心定位到实战配置，提供一份完整的使用指南。

---

## 一、理解核心定位：设计即代码

Pencil 不是 Figma 的替代品，而是**设计与代码之间的桥梁**。它的独特价值在于：

- **IDE 原生**：直接在 VS Code/Cursor 里画图，不用切换窗口
- **AI 驱动**：Claude Code/Codex 直接读取设计，生成代码
- **双向同步**：设计改 → 代码更新；代码改 → 设计更新
- **版本控制友好**：`.pen` 文件是 JSON，可以 Git 管理

### 1.1 适用场景

| 场景 | 推荐度 | 原因 |
|------|--------|------|
| 快速原型设计 | ⭐⭐⭐⭐⭐ | 分钟级出图，AI 直接生成代码 |
| UI 组件开发 | ⭐⭐⭐⭐⭐ | 设计与实现同步迭代 |
| 设计系统维护 | ⭐⭐⭐⭐ | Design Token 双向同步 |
| 复杂视觉设计 | ⭐⭐⭐ | 矢量功能不如 Figma/Sketch 强大 |
| 团队协作设计 | ⭐⭐ | 实时协作功能有限 |

### 1.2 不适用场景

- **高保真视觉设计**：复杂渐变、特效、3D 等
- **大型团队协作**：多人同时编辑同一文件
- **设计交付**：客户/设计师习惯 Figma 链接

---

## 二、安装与配置

### 2.1 安装方式选择

Pencil 提供三种使用方式：

| 方式 | 推荐度 | 适用场景 |
|------|--------|----------|
| **VS Code 扩展** | ⭐⭐⭐⭐⭐ | 主力开发环境 |
| **Cursor 扩展** | ⭐⭐⭐⭐⭐ | AI 辅助编程 |
| **桌面应用** | ⭐⭐⭐ | 独立使用，不依赖 IDE |

### 2.2 VS Code/Cursor 安装

```bash
# 1. 打开 Extensions (Cmd/Ctrl + Shift + X)
# 2. 搜索 "Pencil"
# 3. 点击 Install

# 验证安装
echo "test" > test.pen
# 打开文件，右上角应出现 Pencil 图标
```

### 2.3 Claude Code 配置

Pencil 的 AI 功能依赖 Claude Code CLI：

```bash
# 安装 Claude Code CLI
npm install -g @anthropic-ai/claude-code-cli
# 或使用官方安装器
curl https://claude.ai/cli/install.sh | sh

# 登录
claude

# 验证
claude --version
```

### 2.4 MCP Server 验证

在 Cursor 中检查 Pencil MCP 连接：

```
Settings → Tools & MCP → 确认 Pencil 在 MCP server 列表中
```

在 Codex CLI 中：

```bash
# 先启动 Pencil
# 然后打开 Codex
/mcp
# 确认 Pencil 出现在列表中
```

---

## 三、.pen 文件管理策略

### 3.1 文件组织规范

建议将 `.pen` 文件放在项目目录中，与代码一起管理：

```
my-project/
├── src/
│   ├── components/
│   └── styles/
├── design/
│   ├── components.pen      # 组件库
│   ├── pages.pen           # 页面设计
│   └── tokens.pen          # Design Token
├── docs/
│   └── wireframes.pen      # 线框图
└── package.json
```

**好处**：
- AI Agent 可以同时看到设计和代码
- Git 版本控制统一管理
- Code Review 时设计变更一目了然

### 3.2 命名规范

```
# 按功能模块
components/button.pen
components/card.pen
components/modal.pen

# 按页面
pages/login.pen
pages/dashboard.pen
pages/settings.pen

# 按版本（大型项目）
design/v1/home.pen
design/v2/home.pen
```

### 3.3 Git 管理最佳实践

```bash
# .gitignore - 不需要忽略 .pen 文件，它们就是 JSON
# 但可以忽略临时文件
*.pen.tmp
.pencil-cache/

# 提交规范
git add design/components.pen
git commit -m "feat: update Button component design

- Change border-radius from 4px to 8px
- Update primary color to #3b82f6
- Add hover state"
```

---

## 四、设计到代码工作流

### 4.1 基础导出流程

**Step 1: 在 Pencil 中设计**

```
1. 创建 .pen 文件
2. 使用矢量工具绘制 UI
3. 组织图层结构（Frame → Components）
4. 命名规范：使用有意义的图层名
```

**Step 2: AI 生成代码**

```
快捷键: Cmd/Ctrl + K

提示词示例：
- "Generate React code for this design"
- "Create a TypeScript component from this frame"
- "Export this as a Next.js page component"
- "Generate code using Tailwind CSS"
```

**Step 3: 代码落地**

AI 生成的代码会输出到指定位置：

```typescript
// src/components/Button.tsx
// 由 Pencil 设计自动生成

interface ButtonProps {
  variant: 'primary' | 'secondary';
  size: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
}

export function Button({ variant, size, children }: ButtonProps) {
  return (
    <button className={`btn btn-${variant} btn-${size}`}>
      {children}
    </button>
  );
}
```

### 4.2 高级导出技巧

**指定技术栈**

```
"Generate React component with TypeScript"
"Create Vue 3 composition API component"
"Export as Svelte component"
"Generate Angular component with standalone API"
```

**指定样式方案**

```
"Use Tailwind CSS for styling"
"Generate CSS Modules"
"Use Styled Components"
"Export with CSS-in-JS (Emotion)"
```

**指定组件库**

```
"Use Shadcn UI components"
"Generate using Material UI"
"Use Ant Design components"
"Export with Chakra UI"
```

**包含交互逻辑**

```
"Add React Hook Form integration"
"Include React Query data fetching"
"Add loading and error states"
"Implement optimistic updates"
```

---

## 五、代码到设计工作流

### 5.1 导入现有代码

当你已有代码库，想在 Pencil 中维护设计：

```
快捷键: Cmd/Ctrl + K

提示词示例：
- "Recreate the Button component from src/components/Button.tsx"
- "Import the LoginForm from my codebase into this design"
- "Add the Header component from src/layouts/Header.tsx"
- "Sync all components from src/components/"
```

### 5.2 导入范围

AI 可以导入：
- ✅ 组件结构和层级
- ✅ 布局和定位
- ✅ 样式（颜色、字体、间距）
- ✅ 基础交互状态
- ❌ 复杂动画
- ❌ 业务逻辑

### 5.3 导入后优化

导入后通常需要人工调整：

```
1. 调整图层命名和分组
2. 添加设计注释
3. 创建变体（Variants）
4. 定义 Design Token
```

---

## 六、双向同步策略

### 6.1 同步工作流

这是最强大的使用方式：

```
1. 从代码导入 → 在 Pencil 中可视化现有组件
2. 设计改进 → 调整视觉、添加状态
3. 更新代码 → AI 将设计变更应用到代码
4. 迭代优化 → 重复直到满意
```

### 6.2 同步提示词技巧

**设计 → 代码**

```
"Update Button component with new design"
"Apply these changes to src/components/Card.tsx"
"Sync design tokens to globals.css"
```

**代码 → 设计**

```
"Update design to match current code"
"Sync changes from Button.tsx to .pen file"
"Refresh design with latest implementation"
```

### 6.3 冲突处理

当设计和代码同时修改时：

```
策略 A：设计优先
- 在 Pencil 中完成设计
- 一次性同步到代码
- 覆盖代码中的样式变更

策略 B：代码优先
- 先更新代码实现
- 导入到 Pencil 更新设计
- 设计跟随代码

策略 C：手动合并
- 分别查看设计和代码的变更
- 人工决定保留哪些
- 分别更新两边
```

---

## 七、Design Token 管理

### 7.1 CSS Variables ↔ Pencil Variables

建立双向同步的设计令牌系统：

**CSS → Pencil**

```css
/* globals.css */
:root {
  --color-primary: #3b82f6;
  --color-secondary: #64748b;
  --spacing-base: 1rem;
  --font-heading: 'Inter', sans-serif;
}
```

```
提示词：
"Create Pencil variables from my globals.css"
"Import design tokens from src/styles/tokens.css"
```

**Pencil → CSS**

```
提示词：
"Update globals.css with these Pencil variables"
"Sync these design tokens to my CSS"
"Export Pencil color palette to CSS variables"
```

### 7.2 Token 命名规范

```
# 颜色
--color-primary-50  # 最浅
--color-primary-100
--color-primary-500 # 主色
--color-primary-900 # 最深

# 间距
--spacing-xs: 0.25rem
--spacing-sm: 0.5rem
--spacing-md: 1rem
--spacing-lg: 2rem

# 字体
--font-size-xs: 0.75rem
--font-size-sm: 0.875rem
--font-size-base: 1rem
--font-size-lg: 1.125rem
```

---

## 八、从 Figma 迁移

### 8.1 Token 导入

```
1. 在 Figma 中复制 Token 表格
2. 粘贴到 Pencil 或分享给 AI
3. 提示词："Create Pencil variables from these Figma tokens"
```

### 8.2 组件导入

```
1. 在 Figma 中复制元素（Ctrl+C）
2. 粘贴到 Pencil（Ctrl+V）
3. 注意：图片不会复制，需单独处理
```

### 8.3 图片处理

```
Figma 中的图片：
- 导出为 PNG/SVG
- 放入项目 public/ 或 assets/ 目录
- 在 Pencil 中重新引用
```

---

## 九、团队协作策略

### 9.1 单人工作流

```
1. 在 Pencil 中设计
2. 生成代码
3. Git 提交设计和代码
4. Code Review 时展示设计变更
```

### 9.2 小型团队协作

```
设计师：
- 在 Pencil 中维护设计系统
- 提交 .pen 文件到 Git

开发者：
- 拉取最新 .pen 文件
- 使用 AI 生成/更新代码
- 提交代码变更

同步：
- 通过 Git 合并设计和代码变更
- PR 中同时 Review 设计和代码
```

### 9.3 与 Figma 协作

```
设计师（Figma）：
- 高保真视觉设计
- 交付开发

开发者（Pencil）：
- 导入 Figma 设计
- 生成代码
- 维护代码同步
```

---

## 十、性能优化

### 10.1 文件大小管理

```
问题：.pen 文件过大导致加载慢
解决：
- 拆分大文件（按页面/组件）
- 删除未使用的图层
- 压缩图片资源
```

### 10.2 缓存策略

```
.pencil-cache/  # 本地缓存，可清理
*.pen.tmp       # 临时文件，可删除
```

### 10.3 AI 响应优化

```
- 关闭不必要的图层
- 简化复杂矢量路径
- 分模块请求（不要一次性生成所有代码）
```

---

## 十一、常见问题排查

| 问题 | 解决方案 |
|------|----------|
| Pencil 图标不显示 | 检查扩展是否启用，重启 IDE |
| MCP Server 未连接 | 确保 Claude Code 已登录，重新激活 Pencil |
| AI 不响应 | 检查网络，确认 Claude Code 状态 |
| 代码生成失败 | 简化设计，分模块请求 |
| 导入代码不完整 | 确保代码在 Agent 可访问的目录 |
| 同步失败 | 检查文件权限，确认 Git 状态 |

---

## 十二、总结

Pencil 的核心价值是**消除设计与代码之间的摩擦**。

最佳实践要点：
1. **IDE 原生**：在 VS Code/Cursor 中直接设计
2. **AI 驱动**：用自然语言让 AI 处理代码生成
3. **双向同步**：保持设计与代码的一致性
4. **版本控制**：.pen 文件入 Git，统一管理
5. **Design Token**：建立可同步的设计令牌系统

Pencil 不是取代设计师或开发者，而是让两者更高效协作。设计师可以更快看到代码实现，开发者可以更直观地调整 UI。

---

**参考链接**：
- Pencil 官网：https://www.pencil.dev/
- 文档：https://docs.pencil.dev/
- GitHub：https://github.com/pencil-dev
