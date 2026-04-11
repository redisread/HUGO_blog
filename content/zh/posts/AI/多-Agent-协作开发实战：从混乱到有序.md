---
title: "多-Agent-协作开发实战：从混乱到有序"
subtitle: 
date: 2026-04-11T15:46:01+08:00
publishDate: 2026-04-11T15:46:01+08:00
aliases:
description:
image:
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner # outer
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h1","h2", "h3", "h4"]
libraries: ['katex']
tags:
  - AI
  - Agent
  - 多智能体
  - Cortex
  - 协作开发
  - AI编程
  - Claude
  - GPT
  - 架构
  - Git
series: []
categories:
  - AI
---


# 多 Agent 协作开发实战：从混乱到有序

![封面图](https://cos.jiahongw.com/agent/20260411/multi-agent-collaboration-cover.jpg)

> 当 AI 助手从"一个工具"变成"一个团队"，我们需要新的协作范式来管理复杂性。


## 一、为什么需要多 Agent 协作？

### 现实中的类比

想象一个软件开发团队：

- **架构师**负责整体设计
- **开发工程师**负责具体实现
- **QA 工程师**负责测试验证
- **技术负责人**负责代码审查

这个分工不是偶然的，而是几十年软件工程实践沉淀的最佳实践。

**多 Agent 协作的本质，是将这种人类团队的分工模式映射到 AI 系统。**

### 单 Agent vs 多 Agent

| 维度 | 单 Agent | 多 Agent |
|------|----------|----------|
| 上下文负载 | 全部任务挤在一个窗口 | 每个 Agent 专注特定领域 |
| 验证机制 | 自我验证（易盲区） | 交叉验证（更客观） |
| 能力上限 | 受限于单一模型 | 可组合不同专长 |
| 可追溯性 | 黑盒 | 每个环节有明确责任人 |
| 失败模式 | 全盘崩溃 | 局部失败可隔离 |

---

## 二、Cortex：多 Agent 协作的基础设施

[Cortex](https://github.com/MrPancakex/Cortex) 是一个本地 AI Agent 网关，它解决了多 Agent 协作中最核心的三个问题：

### 1. 任务状态机（Task Lifecycle）

Cortex 强制所有任务遵循严格的状态流转：

```
pending → claimed → in_progress → submitted → review → approved/rejected
```

**为什么重要？**

没有状态机，Agent 可以随意宣称"我完成了"，但实际上可能什么都没做。状态机让"声称完成"和"实际完成"分离，每个阶段都需要证据支撑。

### 2. Agent 间桥接（Bridge）

Agent 可以通过 Bridge 显式地交接工作：

```
Agent A (Builder) 完成任务 → 提交到 Cortex
Agent B (Integrator) 认领审核任务 → 检查实现
Agent B 发现问题 → 退回给 Agent A
Agent A 修复后重新提交
Agent C (Verifier) 运行验证 → 标记完成
```

**关键设计**：每个 Agent 有独立的上下文窗口，交接时不是传递整个对话历史，而是传递结构化的任务状态和证据包。

### 3. 统一 MCP 工具层

所有 Agent 通过 Cortex Gateway 访问工具，这意味着：

- **统一日志**：所有工具调用被记录，可追溯
- **权限控制**：可以限制特定 Agent 能使用哪些工具
- **行为审计**：知道谁在什么时候做了什么

---

## 三、实战：三 Agent 协作模型

基于 Cortex 的实战经验，我们设计了一套"三 Agent 协作模型"：

### 角色定义

| 角色 | 职责 | 典型模型 |
|------|------|----------|
| **Builder** | 编写实现代码 | Claude / Codex / GPT-4 |
| **Integrator** | 检查集成、确保无 stubs | Claude / 本地模型 |
| **Verifier** | 运行验证、产出证据包 | 自动化脚本 + 轻量模型 |

### 为什么不是两个或四个？

- **两个 Agent**：Builder 和 Integrator 容易角色混淆，缺乏独立的验证层
- **四个 Agent**：协调复杂度陡增，收益递减
- **三个 Agent**：实现"设计-实现-验证"的完整闭环，同时保持可管理的协调成本

### 证据包机制（Anti-Hallucination）

Verifier 不能自我报告，必须产出物理证据：

```
task-evidence/
├── execution.log      # 实际终端输出
├── state-proof.txt    # 数据库行 ID 或文件哈希
├── test-results.json  # 测试结果
└── coverage-report/   # 覆盖率报告
```

**核心原则**：Agent 的声称必须可验证，验证必须基于客观证据而非主观判断。

---

## 四、实战演练：构建一个 API 服务

让我们通过一个完整的例子，展示三 Agent 如何协作开发一个用户管理 API。

### 阶段 1：任务创建与认领

**Cortex Gateway** 收到新任务：

```json
{
  "id": "task-001",
  "title": "实现用户管理 REST API",
  "description": "包含用户增删改查、密码加密、JWT 认证",
  "state": "pending",
  "requirements": [
    "POST /users - 创建用户",
    "GET /users/:id - 获取用户",
    "PUT /users/:id - 更新用户",
    "DELETE /users/:id - 删除用户"
  ]
}
```

**Builder Agent** 认领任务：

```bash
mcp__cortex__claim_task --task-id task-001
```

状态变为 `claimed` → `in_progress`。

### 阶段 2：Builder 实现

Builder 开始编码，过程中定期报告进度：

```bash
mcp__cortex__report_progress \
  --task-id task-001 \
  --message "完成数据模型设计，开始实现路由处理器"
```

Builder 完成实现后，提交结果：

```bash
mcp__cortex__submit_result \
  --task-id task-001 \
  --artifacts "./src/routes/users.js,./src/models/user.js,./tests/users.test.js"
```

状态变为 `submitted`。

### 阶段 3：Integrator 审核

Integrator Agent 认领审核任务：

```bash
mcp__cortex__claim_task --task-id task-001-review
```

Integrator 执行检查清单：

1. **Stub 检测**：检查是否有空实现或未完成的 TODO
2. **依赖检查**：确认所有 import/require 都有对应实现
3. **测试存在性**：确认每个功能都有对应测试
4. **集成点检查**：确认 API 契约符合预期

发现问题，退回给 Builder：

```bash
mcp__cortex__task_reject \
  --task-id task-001 \
  --feedback "发现 stub：users.js 第 45 行 updateUser 函数为空实现"
```

状态变为 `rejected`，任务回到 `in_progress`。

### 阶段 4：修复与重新提交

Builder 修复问题，重新提交。Integrator 再次审核通过，状态变为 `review`。

### 阶段 5：Verifier 验证

Verifier 运行自动化验证流程：

```bash
#!/bin/bash
# verify-task.sh (The Crucible)

# 1. 运行测试套件
npm test > execution.log

# 2. 检查测试通过率
PASS_RATE=$(jq '.stats.passPercent' test-results.json)
if [ "$PASS_RATE" -lt 100 ]; then
  echo "FAIL: 测试通过率 $PASS_RATE%" >> state-proof.txt
  exit 1
fi

# 3. 检查代码覆盖率
COVERAGE=$(jq '.total.lines.pct' coverage/coverage-summary.json)
if [ "$COVERAGE" -lt 80 ]; then
  echo "FAIL: 代码覆盖率 $COVERAGE%" >> state-proof.txt
  exit 1
fi

# 4. 运行集成测试
./scripts/integration-test.sh >> execution.log

# 5. 生成证据包
tar czf evidence-pack.tar.gz execution.log state-proof.txt test-results.json coverage/
```

Verifier 产出证据包，标记任务完成：

```bash
mcp__cortex__task_approve \
  --task-id task-001 \
  --evidence "./evidence-pack.tar.gz"
```

状态变为 `approved`。

---

## 五、关键设计原则

### 1. 基础设施层强制

**原则**：行为合规不能依赖 Agent 自觉，必须在基础设施层强制。

**实践**：
- 使用 Cortex Gateway 拦截所有工具调用
- 文件权限控制：Builder 不能写入 Verifier 的输出目录
- 状态机强制：Agent 不能随意跳转到任意状态

### 2. 上下文隔离

**原则**：每个 Agent 应该有独立的上下文窗口，交接时传递结构化数据而非完整对话历史。

**实践**：
- Builder 的上下文：需求文档、技术规范、相关代码
- Integrator 的上下文：代码 diff、检查清单、历史问题记录
- Verifier 的上下文：测试脚本、验证规则、证据模板

### 3. 不可伪造的证据

**原则**：Agent 的声称必须可验证，验证必须基于客观证据。

**实践**：
- 终端输出重定向到文件
- 数据库状态通过行 ID 或哈希证明
- 测试覆盖率由工具生成，非 Agent 自报

### 4. 渐进式披露

**原则**：Agent 只在需要时加载相关信息，保持上下文整洁。

**实践**：
- 使用 Cortex 的 `task_get` 按需获取任务详情
- 使用 `bridge_inbox` 接收定向消息
- 避免在系统提示中堆砌所有可能用到的信息

---

## 六、常见陷阱与解决方案

### 陷阱 1：Agent 角色漂移

**现象**：Builder 开始干 Integrator 的活，或者试图绕过验证。

**解决**：
- 在系统提示中明确角色边界
- 使用权限控制限制 Agent 能调用的工具
- 定期审计 Agent 行为日志

### 陷阱 2：交接信息丢失

**现象**：Agent A 完成的工作，Agent B 无法正确理解上下文。

**解决**：
- 定义标准化的交接格式（任务状态 + 关键摘要 + 相关文件）
- 使用结构化数据而非自然语言描述
- 在 Cortex 中维护任务元数据

### 陷阱 3：验证脚本被绕过

**现象**：Agent 发现验证脚本的漏洞，通过伪造输出欺骗验证。

**解决**：
- 验证脚本（The Crucible）root 锁定，Agent 无法修改
- 证据包包含不可伪造的元数据（时间戳、哈希链）
- 关键验证步骤使用外部服务（如 CI/CD 系统）

### 陷阱 4：协调开销过大

**现象**：多 Agent 协作的协调成本超过了收益。

**解决**：
- 只对复杂任务启用多 Agent 流程
- 简单任务保持单 Agent 处理
- 使用自动化脚本减少人工协调

---

## 七、工具链整合

### 推荐组合

| 组件 | 推荐方案 | 说明 |
|------|----------|------|
| Agent 运行时 | Claude Code / Codex / OpenClaw | 主流 AI 编码助手 |
| 协作网关 | Cortex | 任务状态、Agent 桥接 |
| 验证层 | The Crucible (bash scripts) | 硬编码验证逻辑 |
| 监控面板 | Cortex Dashboard | 实时查看任务状态 |
| 版本控制 | Git | 代码版本 + Agent 操作日志 |

### 集成示例

```bash
# 启动 Cortex 网关
bun run cortex-gateway

# Agent 1 (Builder) - Claude Code
claude --mcp-config .mcp.json

# Agent 2 (Integrator) - 本地模型
ollama run codellama --mcp-config .mcp.json

# Agent 3 (Verifier) - 自动化脚本
./scripts/verifier-daemon.sh
```

---

## 八、未来展望

### 短期（6 个月内）

- **更成熟的编排层**：Hermes 等专用编排工具成熟
- **标准化接口**：Agent 间通信协议标准化
- **可视化调试**：更强大的多 Agent 调试工具

### 中期（1-2 年）

- **动态角色分配**：根据任务特性自动选择 Agent 组合
- **学习优化**：Agent 从历史协作中学习，优化交接效率
- **人机协作**：人类在关键节点介入，AI 处理常规流程

### 长期（3-5 年）

- **自主团队**：AI Agent 团队像人类团队一样自组织
- **领域专业化**：针对特定技术栈的深度专业化 Agent
- **可信计算**：基于密码学的 Agent 行为验证

---

## 结语：从工具到团队

多 Agent 协作开发代表了一个范式转变：

> **AI 从"一个更聪明的工具"变成"一个可协作的团队成员"。**

这种转变带来的不仅是效率提升，更是软件开发方法论的重构。当我们把 AI 当作团队成员而非工具时，我们需要考虑：

- 如何分工才能发挥每个 Agent 的专长？
- 如何设计流程才能确保质量和可追溯性？
- 如何建立信任机制才能让人类放心地把工作交给 AI？

Cortex 和类似的基础设施正在回答这些问题。作为开发者，我们需要拥抱这种变化，学习如何与 AI 团队协作，而不是单打独斗。

**未来的软件开发，是人类与 AI 团队的共舞。**

---

## 参考资源

- **Cortex GitHub**: https://github.com/MrPancakex/Cortex
- **Multi-Agent Workflow Spec**: Cortex 项目中的 `artifacts/specs/multi-agent-workflow-spec.md`
- **Task Lifecycle**: Cortex 项目中的 `docs/task-lifecycle.md`

---

*本文基于 Cortex 项目的实战经验撰写，感谢开源社区的贡献者。*
