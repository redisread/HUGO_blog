---
title: "Claude Code Dynamic Workflows：多智能体编排的技术革命"
date: 2026-06-06T05:30:00+08:00
draft: false
tags: ["Claude Code", "AI", "Multi-Agent", "Workflow", "Anthropic"]
categories: ["技术"]
image: "https://cos.jiahongw.com/rss-daily/20260606/cover.png"
description: "Anthropic 发布 Claude Code Dynamic Workflows，支持数百个并行子智能体协同工作，彻底改变了 AI 辅助编程的规模和效率。"
---

2026 年 5 月 28 日，Anthropic 正式发布 Claude Opus 4.8 模型，同时推出了备受瞩目的 **Dynamic Workflows**（动态工作流）功能。这不仅是模型能力的升级，更是 AI 辅助编程范式的一次根本性转变——从单轮对话到多智能体并行编排，从人工协调到脚本自动化执行。

<!--more-->

## 核心观点：从对话到编排的范式转移

传统 AI 编程工具的核心交互模式是**对话式**：用户提出需求，AI 逐步响应，双方在一轮轮交流中完成任务。这种模式在简单任务上表现良好，但面对大型代码库迁移、跨文件重构、复杂系统审计等场景时，效率瓶颈明显。

Dynamic Workflows 的核心创新在于**将编排逻辑从对话中抽离，转化为可执行的 JavaScript 脚本**。Claude 根据任务需求生成编排脚本，运行时环境在后台并行执行数百个子智能体，而主会话始终保持响应状态。这意味着：

- **规模突破**：单会话可协调数十至数百个智能体，而非传统的单轮单任务
- **可重复性**：编排逻辑以脚本形式固化，可跨项目复用
- **质量保证**：支持对抗性审查、多角度验证等质量模式
- **会话解耦**：主会话仅接收最终结果，不受中间过程干扰

![Dynamic Workflows 架构示意图](https://cos.jiahongw.com/rss-daily/20260606/img-01.png)

## 深度分析：技术架构与实现机制

### 1. Claude Opus 4.8 的模型升级

在深入 Workflows 之前，有必要理解支撑这一功能的底层模型——Claude Opus 4.8。根据 Anthropic 官方发布的数据，Opus 4.8 在多个维度实现突破：

**编码能力**：在 CursorBench 评测中，Opus 4.8 在所有 effort 级别均超越前代模型，工具调用效率显著提升，以更少的步骤完成同等复杂度的任务。

**Agent 能力**：在 Super-Agent 基准测试中，Opus 4.8 成为首个完成所有端到端测试用例的模型，在成本持平的情况下击败 GPT-5.5。对于翻译、深度研究、幻灯片制作和分析类 Agent 产品，可靠性大幅增强。

**法律 Agent**：在 Legal Agent Benchmark 中创下最高得分，成为首个在全通过标准上突破 10% 的模型。对于实质性法律工作，这种精度提升直接转化为可委托给 AI 的真实律师工作量。

**计算机使用**：在 Online-Mind2Web 评测中得分 84%，相比 Opus 4.7 和 GPT-5.5 实现显著跃升，在计算机使用和浏览器 Agent 场景表现最强。

**诚实度**：Opus 4.8 最突出的改进之一是诚实度——更可能标记自身工作中的不确定性，减少无根据的断言。评测显示，Opus 4.8 对代码缺陷的未标记率比前代低约 4 倍。

这些能力升级是 Workflows 能够可靠执行复杂编排任务的底层保障。当数百个子智能体并行运行时，模型需要具备自我纠错、质量判断和任务分解的稳健能力。

### 2. 编排模型对比

Dynamic Workflows 并非 Anthropic 唯一的任务分解方案。Claude Code 目前提供四种任务协调机制，各有适用场景：

| 机制 | 决策主体 | 中间状态存储 | 可重复性 | 规模 | 中断恢复 |
|------|----------|--------------|----------|------|----------|
| Subagents | Claude 逐轮决策 | 上下文窗口 | Worker 定义 | 每轮少量任务 | 重启当前轮 |
| Skills | Claude 遵循指令 | 上下文窗口 | 指令本身 | 同 Subagents | 重启当前轮 |
| Agent Teams | 主导智能体监督 | 共享任务列表 | 团队定义 | 少量长期并行 | 队友继续运行 |
| **Workflows** | **脚本执行** | **脚本变量** | **编排本身** | **数百智能体** | **同会话恢复** |

关键区别在于**谁持有执行计划**。Subagents、Skills 和 Agent Teams 都依赖 Claude 作为编排者，每轮决定下一步操作，所有中间结果涌入上下文窗口。Workflows 将计划移入代码，脚本自身掌控循环、分支和中间结果，Claude 的上下文仅保留最终答案。

![四种机制对比](https://cos.jiahongw.com/rss-daily/20260606/img-02.png)

### 3. 运行时架构

Dynamic Workflows 的运行时采用**事件驱动架构**：

1. **脚本生成阶段**：Claude 分析任务需求，生成 JavaScript 编排脚本
2. **执行阶段**：运行时环境解析脚本，创建子智能体池，并行分发任务
3. **监控阶段**：用户可通过 `/workflows` 命令查看进度、暂停或重启特定阶段
4. **验证阶段**：支持多智能体交叉验证，过滤未通过审查的结果
5. **输出阶段**：最终结果汇入主会话，附带完整引用链

脚本可定义多阶段流水线，每个阶段可配置不同的智能体数量、模型选择和执行策略。例如，代码审计工作流可能包含：

- **Phase 1**：广度扫描（Haiku 模型，100 个智能体并行分析文件）
- **Phase 2**：深度验证（Opus 4.8 模型，20 个智能体交叉审查）
- **Phase 3**：报告生成（Sonnet 模型，综合输出）

这种**分层验证模式**是 Workflows 的核心价值所在。传统单轮对话中，AI 可能遗漏关键细节或产生幻觉；而在 Workflows 中，多个独立智能体从不同角度审视同一问题，通过投票机制过滤不可靠结论。Reddit 用户描述的 Critic 阶段正是这种对抗性审查的体现——专门设置一个「质疑者」角色，追问「我们漏掉了什么检查？」，然后派生调查智能体去实际验证。

**内置的 `/deep-research` 工作流**展示了这一模式的威力：它会从多个角度展开网络搜索，获取并交叉验证找到的源，对每个声明进行投票，最终返回带有完整引用的报告，未通过交叉验证的声明已被过滤。这与传统 AI 搜索工具的单轮检索-生成模式形成鲜明对比。

### 4. 权限与安全模型

Workflows 采用**分层权限设计**：

- **工作流启动**：受用户权限模式控制（Default/Auto/Bypass）
- **子智能体执行**：固定使用 `acceptEdits` 模式，继承用户工具白名单
- **文件编辑**：自动批准，无需逐轮确认
- **Shell/Web/MCP**：非白名单工具仍会触发中途确认

这种设计平衡了自动化效率与安全性——高频操作（文件编辑）无摩擦执行，高风险操作（网络请求、系统命令）保持人工把关。

**会话恢复机制**是 Workflows 的另一重要特性。与 Subagents 或 Skills 不同，Workflows 在中断后可在同一会话中恢复，而非从头开始。这对于耗时数小时的大规模任务至关重要——网络波动、系统重启或用户主动暂停都不会导致工作丢失。

**监控与控制**方面，用户可通过 `/workflows` 命令打开进度视图，查看每个阶段的智能体数量、Token 总计和耗时。支持的操作包括：

- `↑/↓`：选择阶段或智能体
- `Enter/→`：深入查看选定阶段的智能体详情
- `p`：暂停或恢复运行
- `x`：停止选定智能体或整个工作流
- `r`：重启选定的运行中智能体
- `s`：将运行脚本保存为可复用命令

这种细粒度控制让用户在享受自动化便利的同时，保持对执行过程的可见性和干预能力。

## 实践建议：何时使用 Workflows

### 适用场景与真实案例

社区开发者已基于 Workflows 构建出多个实用场景。Reddit 用户 `/u/FreHu_Dev` 分享了一个代码库可维护性审查工作流的迭代过程：初期版本只是表面扫描，经过多轮迭代后加入了数据模型分析、对抗性审查（Critic）阶段，最终能够发现开发者自己都未意识到的深层问题。

另一个典型案例是 `/u/not-ekalabya` 开源的 co-scientist 实现——完全复现 Google 论文中的科学代理编排框架，用于药物新应用发现研究。这证明了 Workflows 不仅适用于软件工程，还可扩展到科学研究领域。

| 场景 | 典型任务 | 推荐配置 |
|------|----------|----------|
| 代码库审计 | 全站 API 端点安全扫描、依赖漏洞检测 | `/deep-research` 或自定义脚本 |
| 大规模迁移 | 500+ 文件的语言/框架迁移、类型系统重构 | Ultracode 模式 |
| 交叉验证研究 | 多源信息对比、事实核查、文献综述 | 多阶段验证工作流 |
| 方案比选 | 架构设计多角度论证、技术选型评估 | 并行草案生成 |

### 使用方式

**方式一：关键词触发**
在提示词中包含 `ultracode` 关键词，Claude 自动识别并生成工作流：

```
ultracode: 审计 src/routes/ 下所有 API 端点的鉴权缺失问题
```

**方式二：全局模式**
设置 `/effort ultracode`，Claude 为每个实质性任务自动规划工作流：

```
/effort ultracode
```

**方式三：内置命令**
直接使用 `/deep-research` 进行深度研究：

```
/deep-research Node.js v20 到 v22 权限模型的变更
```

### 成本与效率权衡

Workflows 的并行执行带来显著效率提升，但也意味着更高的 Token 消耗。根据社区反馈，Ultracode 模式下的 Token 消耗可能达到普通对话的 5-10 倍，需要谨慎使用。

Reddit 用户 `/u/supernatrual_wave11` 分享了一个警示案例：使用 Claude Enterprise 账户仅 5 个提示就消耗了 145 美元，按此速度月度账单可能超过 5000 美元。这凸显了成本管理的重要性。

建议：

- **日常开发**：保持默认 effort 级别，单轮对话即可满足
- **复杂任务**：使用 `ultracode` 关键词触发单次工作流
- **系统性工程**：开启 Ultracode 模式，接受全程自动化编排

Anthropic 已针对高 effort 级别提升速率限制，用户可根据项目需求灵活选择。

## 行业影响与竞争格局

Dynamic Workflows 的发布标志着 AI 编程工具进入**多智能体编排时代**。这一时间点（2026 年 5 月 28 日）与 OpenAI Codex 的「Agent 团队」功能、微软 Build 大会发布的 Scout 形成密集竞争态势。

### 技术路线之争

当前市场呈现三种技术路线：

**Claude Code 路线**：脚本化编排，强调可重复性和质量控制。优势在于编排逻辑透明可审计，适合企业级合规场景。劣势是上手门槛较高，需要理解脚本结构和阶段配置。

**OpenAI Codex 路线**：实时协作，强调人机交互流畅度。优势是体验无缝，适合快速原型开发。劣势是编排逻辑黑盒化，难以复现和审计。

**GitHub Copilot 路线**：IDE 深度集成，强调上下文感知。优势是与开发环境无缝融合，劣势是跨文件、跨项目的全局编排能力较弱。

从开发者社区反馈看，Claude Code 的 Workflows 在**大规模代码库处理**和**复杂任务质量保证**方面建立差异化优势。Reddit r/ClaudeCode 社区近期涌现大量 Workflow 实践分享，包括代码库健康度检查、自动化测试生成、跨语言迁移等场景。

### 商业模式演进

Anthropic 在发布 Opus 4.8 和 Workflows 的同时，完成了 650 亿美元的 H 轮融资，估值达到 9650 亿美元，首次超越 OpenAI 的 8520 亿美元。这一融资节奏与产品发布形成协同效应——资本看好企业级 AI 编程市场的长期价值。

值得注意的是，Anthropic 同时宣布暂停 Red Team 项目，并传出「Oceanus」企业级模型的泄露消息，定价高达输入 $16/M tokens、输出 $80/M tokens。这表明 Anthropic 正在构建分层产品矩阵：Claude Code 面向开发者，Oceanus 面向企业，Mythos 面向高端研究场景。

Dynamic Workflows 的发布标志着 AI 编程工具进入**多智能体编排时代**。这一趋势与 OpenAI Codex 的「Agent 团队」功能、GitHub Copilot 的「Agent Mode」形成直接竞争。

关键差异点：

- **Claude Code**：脚本化编排，强调可重复性和质量控制
- **OpenAI Codex**：实时协作，强调人机交互流畅度
- **GitHub Copilot**：IDE 深度集成，强调上下文感知

从开发者社区反馈看，Claude Code 的 Workflows 在**大规模代码库处理**和**复杂任务质量保证**方面建立差异化优势，特别适合企业级应用场景。

## 开发者实践心得与避坑指南

基于社区反馈，使用 Workflows 时需注意以下实践要点：

**迭代优化工作流**：Reddit 用户 `/u/FreHu_Dev` 强调，工作流不是一次成型，而是需要多轮迭代。初期版本可能只是表面扫描，需要通过反馈告诉 Claude「你没有查看数据模型，通常能从那里发现很多问题」，让 Claude 将反馈转化为工作流的新版本。

**隐藏思考过程的影响**：近期更新后，Claude Code 隐藏了思考过程，导致用户难以判断 AI 是否走偏方向。`/u/ContributionMotor150` 反馈这引入了不必要的延迟——必须等待 Claude 思考完毕才能发现理解错误。建议在使用 Workflows 时明确指定检查点，让阶段性结果可见。

**Token 消耗预警**：`/u/supernatrual_wave11` 的教训表明，Ultracode 模式下的 Token 消耗可能远超预期。建议：
- 首次使用新工作流时，先用小规模数据测试
- 监控 `/workflows` 界面的 Token 总计
- 为大型任务设置预算上限
- 考虑使用 Haiku 模型做广度扫描，仅在关键节点使用 Opus

**自动切换 Effort 级别**：有用户反馈 Opus 会自动切换到 High Effort（`/u/xblade724`），导致 Token 消耗激增。建议定期检查当前 effort 设置，或在 `/config` 中关闭自动升级。

**导出功能的限制**：`/u/Ok-Affect-7503` 指出，达到使用限制后无法使用 `/export` 命令导出会话，尽管这只是本地命令。这提示我们在使用 Workflows 处理重要任务时，应定期手动备份或设置自动导出。

## 可实践建议速查表

| 建议 | 具体做法 |
|------|----------|
| 快速体验 | 运行 `/deep-research <问题>` 感受工作流效果 |
| 单次使用 | 提示词中加入 `ultracode:` 前缀 |
| 项目级启用 | 执行 `/effort ultracode` 开启全局模式 |
| 监控进度 | 使用 `/workflows` 查看实时状态和 Token 消耗 |
| 保存复用 | 成功的工作流执行 `s` 键保存为自定义命令 |
| 成本优化 | 大型任务使用 Haiku 做广度扫描，Opus 做收敛验证 |
| 权限管理 | 提前将常用命令加入白名单，避免中途打断 |

## 一句话总结

Dynamic Workflows 将 AI 编程从「对话式协作」推进到「编排式工程」——Claude 不再只是回答问题的助手，而是能够自主规划、并行执行、质量自检的**工程团队**。

---

## 参考链接

1. [Claude Code Dynamic Workflows 官方文档](https://code.claude.com/docs/en/workflows) - Anthropic 官方技术文档
2. [Introducing dynamic workflows](https://claude.com/blog/introducing-dynamic-workflows-in-claude-code) - Anthropic 官方博客
3. [Claude Opus 4.8 发布公告](https://www.anthropic.com/news/claude-opus-4-8) - 模型能力与功能更新
4. [Anthropic 估值 9650 亿美元融资分析](https://tenten.co/learning/anthropic-ipo-965b-valuation/) - 商业背景解读
5. [Claude Code Ultracode 与 Dynamic Workflows 深度解析](https://tenten.co/learning/claude-opus-dynamic-workflows/) - 中文技术解读
6. [GitHub: co-scientist 开源实现](https://github.com/not-ekalabya/co-scientist) - 基于 Claude Code 的科学代理框架

---

## 技术实现细节补充

### Workflows 脚本结构

一个典型的 Workflow 脚本包含以下结构：

```javascript
// 阶段定义
const phases = [
  {
    name: "broad_scan",
    model: "claude-sonnet-4",
    agentCount: 50,
    prompt: "Analyze the following files for security issues..."
  },
  {
    name: "deep_verify", 
    model: "claude-opus-4-8",
    agentCount: 10,
    prompt: "Cross-validate findings from phase 1..."
  },
  {
    name: "critic_review",
    model: "claude-opus-4-8", 
    agentCount: 5,
    prompt: "What did we miss? Identify gaps in coverage..."
  }
];

// 执行与验证
async function executeWorkflow() {
  const results = [];
  for (const phase of phases) {
    const phaseResults = await runParallelAgents(phase);
    results.push(...phaseResults);
  }
  return aggregateResults(results);
}
```

脚本支持条件分支、循环、动态任务分配等编程结构，使复杂编排逻辑得以表达。

### 与 Agent SDK 的集成

Workflows 不仅可在 Claude Code CLI 中使用，还可通过 Agent SDK 程序化调用。这为构建自动化 CI/CD 流水线、批量处理任务提供了可能。SDK 调用时无启动确认提示，工具调用遵循配置的权限规则。

### 未来演进方向

Anthropic 在 Opus 4.8 发布公告中透露，正在开发 Project Glasswing 项目，计划在未来几周将 Mythos 级别模型带给所有客户。Mythos 是当前最高能力的模型系列，需要更强的网络安全保障才能广泛发布。Workflows 的架构显然为这类更强大的模型做好了准备——当单智能体能力进一步提升，多智能体编排的复合效应将更加显著。

---

*本文基于 Anthropic 2026 年 5 月 28 日发布的技术文档与社区实践整理，功能细节可能随版本更新而变化。*
