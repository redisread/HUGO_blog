---
title: AI 自动研究：Shopify CEO 如何用编码智能体优化 20 年老代码库
date: 2026-03-13 12:30:00
publishDate: 2026-03-13 12:30:00
description: Shopify CEO Tobias Lütke 使用 AI 自动研究模式优化 Liquid 模板引擎，实现 53% 性能提升，探索编码智能体在遗留代码优化中的新范式
image: https://openclaw.cos.jiahongw.com/blog/autoresearch-cover.png
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
tocLevels: ["h2", "h3", "h4"]
tags: [AI自动研究, 性能优化, Shopify, Liquid, 编码智能体, Tobi Lütke]
categories: [dev]
---

> 参考 Simon Willison 的 [Link Blog](https://simonwillison.net/2026/Mar/13/liquid/)，本文深入解析 Shopify CEO 如何使用 AI 自动研究模式优化 20 年历史的老代码库。

---

## 事件背景

2026 年 3 月，Shopify CEO Tobias Lütke（Tobi）向开源社区提交了一个令人瞩目的 PR：对 Liquid（Shopify 的 Ruby 模板引擎）进行性能优化，实现了 **53% 的解析+渲染速度提升**，以及 **61% 的内存分配减少**。

这本身是一个 impressive 的技术成就，但更令人惊讶的是：**这些优化来自一个拥有 7500+ 员工的公司 CEO，使用 AI 编码智能体在两天内完成的**。

---

## 什么是 Autoresearch？

Autoresearch（自动研究）是 Andrej Karpathy 提出的概念，源自他的 [nanochat](https://github.com/karpathy/nanochat) 项目。核心思想是：

> **让编码智能体运行数百个半自主实验，自动寻找有效的优化技术。**

### Autoresearch 的工作模式

```
┌─────────────────────────────────────────────────────────────┐
│                    Autoresearch 循环                        │
│                                                             │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐            │
│  │ 头脑风暴  │ → │ 实验验证  │ → │ 结果分析  │            │
│  │ 潜在优化  │    │ 代码修改  │    │ 性能测试  │            │
│  └──────────┘    └──────────┘    └──────────┘            │
│        ↑                              │                    │
│        └──────────────────────────────┘                    │
│                    (反馈循环)                               │
└─────────────────────────────────────────────────────────────┘
```

**关键组件**：
1. **提示词文件**（autoresearch.md）：定义研究目标和约束
2. **执行脚本**（autoresearch.sh）：运行测试套件和基准测试
3. **状态文件**（autoresearch.jsonl）：记录实验历史和结果
4. **编码智能体**：执行具体代码修改

---

## Liquid 优化案例分析

### 优化成果

| 指标 | 优化前 | 优化后 | 提升 |
|------|--------|--------|------|
| 解析+渲染时间 | 基准 | -53% | **1.53x 加速** |
| 内存分配 | 基准 | -61% | **2.56x 减少** |
| 实验次数 | - | 120 次 | 93 个有效提交 |
| 时间投入 | - | 2 天 | CEO 个人项目 |

### 关键优化技术

#### 1. StringScanner → String#byteindex

**优化前**：
```ruby
# 使用 StringScanner 的 skip_until 方法
scanner = StringScanner.new(template)
scanner.skip_until(/{%/)
```

**优化后**：
```ruby
# 使用 String#byteindex 单字节搜索
pos = template.byteindex("{%")
```

**效果**：单字节搜索比正则表达式快 ~40%，解析时间减少 ~12%

#### 2. 消除 StringScanner#string= 重置

**问题**：每次解析 `{% %}` 标签时都调用昂贵的字符串重置（878 次）

**优化**：纯字节解析标签名和标记提取，避免重置和重新扫描

```ruby
# 优化前：每次重置 StringScanner
scanner.string = template
scanner.scan(/\w+/)

# 优化后：直接字节操作
start = template.byteindex("{%")
# 手动解析标签名...
```

#### 3. 缓存小整数 to_s

**优化**：预计算 0-999 的冻结字符串

```ruby
# 优化前：每次渲染都创建新字符串
counter.to_s  # 267 次分配

# 优化后：使用预计算的冻结字符串
SMALL_INTEGERS[counter]  # 零分配
```

**效果**：每次渲染避免 267 次 Integer#to_s 分配

---

## 为什么这很重要？

### 1. 测试套件是 AI 的解锁器

Tobi 强调了这一点：

> **974 个单元测试是这种研究工作的大规模解锁器。**

没有可靠的测试套件，AI 无法安全地进行数百次实验。测试提供了：
- **安全网**：确保优化不破坏功能
- **反馈循环**：快速验证每次修改
- **信心**：敢于尝试激进的优化

### 2. "让它更快"成为可行目标

当你提供基准测试脚本时，"make it faster" 从一个模糊的愿望变成可执行的目标：

```bash
# autoresearch.sh 示例
#!/bin/bash

# 运行测试套件
bundle exec rake test

# 运行基准测试
bundle exec ruby benchmark/run.rb

# 输出性能指标
# 智能体可以读取并优化
```

### 3. CEO 可以再次编码了

这是 Simon Willison 观察到的趋势：

> **编码智能体让高干扰角色的人能够再次高效地处理代码。**

Tobi 的 GitHub 贡献图显示，自 2025 年 11 月（编码智能体能力拐点）以来，他的代码贡献显著增加。

```
GitHub 贡献图趋势：
2024: ████░░░░░░░░░░░░░░░░
2025 Q1-Q3: █████░░░░░░░░░░░░░░░
2025 Q4+: ██████████████░░░░░░  (11月后激增)
```

### 4. 老代码库的新生命

Liquid 是一个 **20 年历史**的代码库，经过数百名贡献者的打磨。通常认为这种代码已经优化到极致，但 AI 发现了人类遗漏的微优化机会。

**启示**：
- 没有"完美"的代码，只有"足够好"的代码
- AI 可以从不同角度审视问题
- 自动化实验可以发现人类忽略的优化点

---

## 如何实施 Autoresearch

### 步骤 1：准备基础设施

**1.1 可靠的测试套件**
```bash
# 确保测试覆盖核心功能
bundle exec rake test
# 目标：>90% 覆盖率，<5秒执行时间
```

**1.2 基准测试脚本**
```ruby
# benchmark/run.rb
require 'benchmark'

templates = load_test_templates()

Benchmark.bm do |x|
  x.report("parse:") { templates.each(&:parse) }
  x.report("render:") { templates.each(&:render) }
  x.report("parse+render:") { templates.each { |t| t.parse.render } }
end
```

**1.3 提示词文件**
```markdown
# autoresearch.md

## 目标
优化 Liquid 模板引擎的解析和渲染性能

## 约束
- 不能破坏现有功能（974 个测试必须通过）
- 优先考虑内存分配减少
- 关注微优化机会

## 方法
1. 分析当前瓶颈
2. 提出潜在优化方案
3. 实现并测试
4. 记录结果

## 成功标准
- 解析+渲染时间减少 >10%
- 内存分配减少 >20%
```

### 步骤 2：选择编码智能体

Tobi 使用了 [Pi](https://github.com/badlogic/pi-mono)，但其他选择包括：

| 工具 | 特点 | 适用场景 |
|------|------|----------|
| **Pi** | 专注性能优化 | 底层代码优化 |
| **Claude Code** | 上下文理解强 | 复杂重构 |
| **Codex** | 速度快 | 快速迭代 |
| **Aider** | 多文件编辑 | 大型项目 |

### 步骤 3：运行 Autoresearch

```bash
# 启动自动研究循环
./autoresearch.sh

# 智能体将：
# 1. 读取 autoresearch.md
# 2. 分析代码瓶颈
# 3. 提出优化假设
# 4. 实现修改
# 5. 运行测试
# 6. 记录结果到 autoresearch.jsonl
# 7. 重复直到收敛
```

### 步骤 4：筛选和合并

```bash
# 查看实验历史
cat autoresearch.jsonl | jq '.[] | {commit: .commit, improvement: .benchmark_improvement}'

# 筛选有效提交（>5% 提升）
git log --oneline --since="2 days ago" | grep "autoresearch"

# 合并到主分支
git merge --squash feature/autoresearch-optimizations
```

---

## 最佳实践

### DO（推荐）

- ✅ 从可靠的测试套件开始
- ✅ 定义明确的性能指标
- ✅ 设置时间/预算上限
- ✅ 人工审查每个优化
- ✅ 记录实验过程

### DON'T（避免）

- ❌ 在没有测试的代码上运行
- ❌ 让 AI 无限制地实验
- ❌ 盲目接受所有优化
- ❌ 忽略代码可读性
- ❌ 跳过回归测试

---

## 未来展望

### Autoresearch 的发展方向

1. **多智能体协作**
   - 一个智能体提出假设
   - 另一个验证实现
   - 第三个分析结果

2. **领域专业化**
   - 数据库优化专家
   - 前端性能专家
   - 算法优化专家

3. **与 CI/CD 集成**
   - 每次 PR 自动运行性能回归测试
   - 自动检测性能退化
   - 持续优化建议

### 对开发者的影响

- **性能优化民主化**：不需要专家级知识
- **老代码库维护**：延长遗留系统的生命周期
- **学习工具**：通过观察 AI 优化学习最佳实践

---

## 结语

Tobi 的 Liquid 优化案例展示了 AI 自动研究的潜力：

> **一个 20 年的老代码库，在两天内实现了 53% 的性能提升。**

这不是魔法，而是**系统性实验 + 自动化执行 + 人类审查**的结果。

对于开发者来说，这意味着：
1. **测试套件比以往更重要** - 它是 AI 工作的基础
2. **性能优化有了新的工具** - 不再依赖专家直觉
3. **代码审查需要新的技能** - 理解 AI 生成的优化

正如 Simon Willison 所说：

> **编码智能体让高干扰角色的人能够再次高效地处理代码。**

也许下一个优化你代码库的，就是你自己 + AI。

---

## 参考资源

- **原文**：[Simon Willison's Link Blog](https://simonwillison.net/2026/Mar/13/liquid/)
- **PR**：[Shopify/liquid #2056](https://github.com/Shopify/liquid/pull/2056)
- **Autoresearch**：[Andrej Karpathy's nanochat](https://github.com/karpathy/nanochat)
- **Pi 智能体**：[badlogic/pi-mono](https://github.com/badlogic/pi-mono)
- **Pi Autoresearch 插件**：[davebcn87/pi-autoresearch](https://github.com/davebcn87/pi-autoresearch)

---

*本文基于 Simon Willison 的 Link Blog 整理，感谢开源社区的分享。*
