---
title: "从Prompt到脚本：Claude Code Dynamic Workflows如何重新定义AI编程范式"
date: 2026-06-05T04:45:00+08:00
draft: false
toc: true
images:
  - "https://cos.jiahongw.com/rss-daily/20260605/cover.png"
categories:
  - 技术
tags:
  - Claude Code
  - AI编程
  - Dynamic Workflows
  - 子代理
  - 工作流编排
  - Anthropic
---

![Claude Code Dynamic Workflows概念图](https://cos.jiahongw.com/rss-daily/20260605/cover.png)

2026年5月28日，Anthropic发布Claude Opus 4.8的同时，向Claude Code注入了一个足以改变AI编程范式的功能：**Dynamic Workflows**（动态工作流）。这不是一次普通的版本迭代，而是AI编程从"Prompt编排"向"脚本编排"的范式跃迁。

## 核心观点：Prompt已死，脚本当立

传统AI编程的工作模式是：你给模型一段Prompt，模型在对话窗口里逐行生成代码。任务越复杂，上下文窗口越拥挤，模型越容易"失忆"。Claude Code的Dynamic Workflows彻底改变了这个逻辑——**它让Claude把任务计划写成可执行的JavaScript脚本，然后由运行时调度数十到数百个并行子代理（subagents）完成工作**。

这不是简单的"多开几个AI"，而是把"对话式编程"升级为"工程化编程"。脚本化的编排意味着：计划可以被保存、重跑、审计；中间结果不再挤爆上下文窗口；复杂任务可以被拆解成可验证的阶段。

![从Prompt到脚本的演变](https://cos.jiahongw.com/rss-daily/20260605/img-01.png)

## 深度分析：Dynamic Workflows的五个维度

### 一、架构革新：从上下文窗口到脚本变量

传统子代理（subagents）的问题在于：主代理需要逐轮决定派生什么、合并什么，每个结果都要回灌到上下文窗口。任务一长，窗口爆炸，模型开始"胡言乱语"。

Dynamic Workflows的解决方案是**把计划移出对话，放进代码**。

| 特性 | 传统子代理 | Dynamic Workflows |
|------|-----------|-------------------|
| 计划存储 | Claude的上下文窗口 | JavaScript脚本变量 |
| 执行决策 | 逐轮由Claude决定 | 脚本运行时自动执行 |
| 可重复性 | 仅保留Worker定义 | 整个编排脚本可重跑 |
| 规模上限 | 每轮几个任务 | 单次运行数百个代理 |
| 中断恢复 | 重新开始该轮 | 同session可恢复 |

这个架构转变的关键在于：**脚本接管了循环、分支和中间结果存储**，Claude的上下文只保留最终答案。

### 二、成本策略：Haiku做广度，Opus做收束

Dynamic Workflows的另一个杀手锏是**模型分层策略**。开发者可以指定：用便宜的Haiku类模型负责探索、分类、初步检查；用强大的Opus 4.8负责整合、判断、最终验证。

这种"广深分离"的策略直击AI编程的成本痛点。大型任务通常包含大量可并行的低风险工作——扫描文件、整理issue、初步分类、寻找可疑点。这些工作不需要最强模型。真正需要Opus的位置是跨结果整合、冲突判断、架构选择和交付前验证。

| 阶段 | 建议模型 | 任务示例 | 验收方式 |
|------|---------|---------|---------|
| 探索 | Haiku/低成本模型 | 扫描文件、列出候选bug、分群issue | 覆盖率与可追溯清单 |
| 对抗验证 | 多个低成本模型 | 对同一候选问题做交叉检查 | 一致性、反例、重现步骤 |
| 收束 | Opus 4.8 | 整合结论、风险排序、制定修复策略 | 测试、build、审查记录 |

![成本优化策略](https://cos.jiahongw.com/rss-daily/20260605/img-03.png)

### 三、适用场景：什么时候该用Workflow

Dynamic Workflows不是万能药。根据Claude Code官方文档和社区实践，以下场景最适合启用Workflow：

**适合场景：**
- 任务可拆成10个以上独立工作流
- 需要跨多个数据源互相验证
- 需要修改数百个文件（需测试护栏）
- 大型代码库迁移、框架替换
- 跨来源研究与多角度压测

**不适合场景：**
- 单一bug、单一文件修改（编排开销大于收益）
- 没有明确验收标准（agent可能产生不可验证的进度感）
- 任务步骤强依赖（步骤2需要步骤1的输出）

### 四、与Subagents、Skills的层级关系

Claude Code生态中有三个易混淆的概念：Subagents、Skills、Workflows。它们不是替代关系，而是**三个不同层级**。

| 类型 | 本质 | 适合任务 | 主要限制 |
|------|------|---------|---------|
| Subagent | 主session派生的focused worker | 单一审查、研究、局部修复 | 回传摘要仍会进入主上下文 |
| Skill | 可重复载入的指令与资源包 | 固定领域流程、格式、工具使用 | 仍由主模型决定何时与如何使用 |
| Dynamic Workflow | 由模型生成并执行的orchestration script | 大型迁移、多路验证、批次研究 | 需要清楚验收条件与成本控制 |

Subagent是"工人"，Skill是"工具箱"，Workflow是"施工计划"。

### 五、风险与护栏：Workflow不是自动成功保证

Dynamic Workflows扩大了可管理的任务规模，但不会自动解决需求不清、测试不足或数据源错误的问题。

Anthropic官方强调三个必备护栏：

1. **可执行验收条件**：测试命令、build命令、lint、截图比对或数据校验
2. **输入输出格式限制**：避免subagents产生不可合并的自由文字
3. **人工检查点**：尤其在workflow要写入大量文件或影响生产流程时

Opus 4.8的一个关键改进是**更愿标注不确定性**，而不是直接宣称完成。这种"承认不确定"的能力，对长任务比单次benchmark更重要。

![并行处理概念](https://cos.jiahongw.com/rss-daily/20260605/img-02.png)

## 可实践建议

| 场景 | 推荐做法 | 注意事项 |
|------|---------|---------|
| 首次尝试 | 从`/deep-research`内置workflow开始 | 观察多阶段进度与代理输出状态 |
| 自定义任务 | 在prompt中包含"ultracode"关键词 | Claude会自动生成workflow脚本 |
| 高频使用 | 保存workflow为自定义命令 | 保存后可在`/`自动补全中调用 |
| 成本控制 | 明确指定"用Haiku做广度，Opus做收束" | 避免全程使用旗舰模型 |
| 团队推广 | 从有明确测试与低风险rollback的工作开始 | 把workflow当成工程流程的一部分 |

## 行业影响：AI编程进入"工程系统"时代

Dynamic Workflows的发布标志着AI编程从"聊天工具"向"工程系统"的转型。过去两年，开发者争论的是"Cursor vs Claude Code vs Codex"；现在，真正的分水岭是"Prompt技巧 vs 可验证的workflow artifact"。

这种转变的深层含义是：**AI coding工作正在接近传统软件工程的可审计性**。脚本可以被版本控制、代码审查、CI集成；而对话历史只是一堆难以检索的文本。

对于独立开发者和小团队，这意味着可以用更少的资源完成更复杂的项目。一位Reddit用户分享的经验颇具代表性："3个月的vibe coding让我意识到，写代码从来不是最难的部分——最难的是发布、获客、合规、运营。Dynamic Workflows让我能把70%的精力从代码转移到这些'周围的事'上。"

## 一句话总结

> **Dynamic Workflows的真正价值不是"一次能开多少subagents"，而是让agent orchestration从prompt技巧变成可保存、可重跑、可审查的workflow artifact。**

这是AI编程从"魔法"走向"工程"的关键一步。

---

## 参考链接

1. [Claude Code官方文档 - Dynamic Workflows](https://code.claude.com/docs/en/workflows) - Anthropic官方文档，详细介绍workflow的使用方法和最佳实践
2. [Introducing Claude Opus 4.8](https://www.anthropic.com/news/claude-opus-4-8) - Anthropic官方发布说明
3. [Claude Code Advanced Patterns: Subagents, MCP, and Scaling](https://resources.anthropic.com/hubfs/Claude%20Code%20Advanced%20Patterns%20Subagents%2C%20MCP%2C%20and%20Scaling%20to%20Real%20Codebases.pdf) - Anthropic官方资源，subagents和scaling模式
4. [Tenten AI - Claude Opus 4.8与Dynamic Workflows深度解析](https://tenten.co/learning/claude-opus-dynamic-workflows/) - 中文深度技术分析
5. [AI Coding Workflow Best Practices 2026](https://www.youngju.dev/blog/culture/2026-05-14-ai-coding-workflow-best-practices-2026-claude-md-agents-md-cursorrules-subagent-skill-design-deep-dive.en) - CLAUDE.md、AGENTS.md、Skills、Subagents完整指南
6. [Agensi - Claude Code Subagents实战指南](https://www.agensi.io/learn/claude-code-subagents-guide) - 子代理并行工作流实践
7. [Tech Times - Claude Code Dynamic Workflows报道](https://www.techtimes.com/articles/317363/20260529/claude-code-dynamic-workflows-scripts-replace-context-windows-ultracode-automates-orchestration.htm) - 技术媒体深度报道
8. [InfoQ - Dynamic Workflows技术解析](https://www.infoq.com/news/2026/06/dynamic-workflows-claude-code/) - 企业级技术视角分析
9. [r/ClaudeCode社区讨论](https://www.reddit.com/r/ClaudeCode/comments/1twz78u/anthropic_gave_the_failure_mode_i_kept_hitting/) - 开发者社区关于"agentic technical debt"的讨论
10. [GitHub - Claude Code Skills示例](https://github.com/anthropics/claude-code) - 官方Skills和workflow示例

---

*本文基于2026年6月最新技术动态撰写，涵盖Claude Code Dynamic Workflows官方发布及社区实践经验。*
