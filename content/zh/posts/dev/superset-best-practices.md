---
title: Superset 最佳实践：把 AI 变成你的并行工程团队
date: 2026-03-12 09:43:00
publishDate: 2026-03-12 09:43:00
description: 核心思想：你不是在用一个 AI 助手，而是在管理一支 10 人工程团队。详解 Superset 的并行 Agent + Git worktree 隔离机制，以及微任务拆分、Agent 分工、Review 工作流等实战策略
image: https://openclaw.cos.jiahongw.com/blog/superset-best-practices-cover.png
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
tocLevels: ["h2", "h3", "h4"]
tags: [Superset, AI Agent, Claude Code, Codex, Git Worktree, 并行开发, 效率工具]
categories: [dev]
---

> **核心思想：你不是在用一个 AI 助手，而是在管理一支 10 人工程团队。**

Superset 是一个基于 Git worktree 的 AI Agent 并行编排工具。与传统 AI 编程（任务 → 等待 Agent → Review → 下一个任务）不同，Superset 让你可以同时启动多个 Agent 并行工作，然后集中 Review。

本文从核心理念到实战配置，提供一份完整的使用指南。

---

## 一、两种工作流对比

| 维度 | 传统 AI 编程 | Superset |
|------|------------|----------|
| 执行方式 | 串行 | 并行 |
| 任务粒度 | 越大越好 | 越小越好 |
| 你的角色 | 程序员 | 架构师/Tech Lead |
| AI 角色 | Copilot | 10 个 Junior Engineer |
| 时间分配 | 写代码 70% | 设计 10% + Review 10% |

**关键机制：**
- 每个任务自动创建独立 Git worktree
- Agent 在隔离环境执行
- 完成后统一 review / merge
- 支持 Claude Code / Codex / Cursor 等多种 CLI agent

所以最佳实践不是"怎么写 prompt"，而是**怎么管理 Agent pipeline**。

---

## 二、核心原则：任务必须拆成"微任务"

并行 Agent 最怕什么？**一个任务过大。**

### 理想任务粒度

| 粒度 | 示例 |
|------|------|
| 一个函数 | 实现 `validateEmail()` |
| 一个 API | 写 `POST /api/login` |
| 一个组件 | 写 `LoginForm.tsx` |
| 一个 bug | 修复 #123 的 null pointer |
| 一个 test | 写 `auth.test.ts` |

### ❌ 错误示范

```
实现用户系统
```

### ✅ 正确示范

```
1. 实现 user schema
2. 写 register API
3. 写 login API
4. 写 auth middleware
5. 写单元测试
```

这样你可以**同时启动 5 个 agent**。

---

## 三、Agent 分工策略

**不要混合任务类型。**

| 类型 | 用途 | 示例 |
|------|------|------|
| Feature | 新功能 | 实现支付接口 |
| Bugfix | 修 bug | 修复内存泄漏 |
| Refactor | 重构 | 提取公共组件 |
| Test | 测试 | 写集成测试 |
| Docs | 文档 | 更新 API 文档 |

**推荐配置：**

```
Agent 1 → 写 API
Agent 2 → 写前端组件
Agent 3 → 写测试
Agent 4 → 写文档
```

这样几乎不会冲突。

---

## 四、Git 分支命名规范

Superset 自动用 git worktree 隔离代码。

### ✅ 推荐命名

```
feature/auth-api
feature/auth-ui
test/auth-tests
refactor/auth-utils
```

### ❌ 避免命名

```
feature/auth
```

多个 agent 改同一个目录 = 冲突地狱。

---

## 五、Prompt 工程模板

不要写随意 prompt，用**工程 spec 模板**：

```markdown
## Goal
实现 JWT 登录 API

## Requirements
- POST /api/login
- 输入 email + password
- 返回 JWT token
- 错误码规范

## Constraints
- Node.js + Express
- 使用现有 db util（/lib/db.ts）
- 必须写单元测试

## Output
- 完整代码
- 测试文件
- 修改的文件列表
```

### 给 Agent 上下文

```
read:
- /docs/architecture.md
- /lib/db.ts
- /api/user.ts
```

### 让 Agent 先规划

```
First produce a plan. Then implement.
```

---

## 六、理解核心机制：Git Worktree

Superset 的魔法建立在 Git worktree 之上。理解这一点，才能用好它。

### 1.1 什么是 Git Worktree？

Git worktree 允许你在同一仓库的多个分支上同时工作，每个分支有独立的工作目录，但共享同一个 `.git` 目录。

```bash
# 传统方式：切换分支（会丢失未提交修改）
git checkout feature-a
# 干活...
git checkout feature-b  # 刚才的修改去哪了？

# Worktree 方式：并行目录
git worktree add ../feature-a-worktree feature-a
git worktree add ../feature-b-worktree feature-b
# 两个目录同时存在，互不干扰
```

### 1.2 Superset 如何利用 Worktree？

![Git Worktree 原理](https://openclaw.cos.jiahongw.com/blog/illustrations/superset/01-worktree.png)

Superset 为每个 Workspace 创建一个独立的 worktree：

```
~/superset-worktrees/
├── my-project/
│   ├── main/              # 原始仓库
│   ├── workspace-1/       # Worktree 1 → 分支 feature/auth
│   ├── workspace-2/       # Worktree 2 → 分支 fix/login-bug
│   └── workspace-3/       # Worktree 3 → 分支 refactor/api
```

**关键优势**：
- 每个 Agent 在自己的目录里干活，不会互相覆盖文件
- 所有 worktree 共享同一个 Git 历史，切换成本极低
- 磁盘占用只增加工作目录，不增加完整的 `.git`

---

## 二、Workspace 设计策略

### 2.1 任务粒度划分

![Workspace 任务划分](https://openclaw.cos.jiahongw.com/blog/illustrations/superset/02-workspace.png)

不要一个 Workspace 干太多事。建议的划分维度：

| 维度 | 示例 | 适用场景 |
|------|------|----------|
| 功能模块 | `feature/payment`, `feature/notifications` | 大型功能开发 |
| Bug 修复 | `fix/login-redirect`, `fix/memory-leak` | 紧急修复 |
| 重构任务 | `refactor/api-v2`, `refactor/redux-to-zustand` | 代码重构 |
| 探索性任务 | `spike/graphql`, `experiment/new-ui` | 技术预研 |
| 代码审查 | `review/pr-123`, `review/pr-124` | PR 审查 |

**反模式**：一个 Workspace 里让 Agent "把项目所有功能都优化一遍"——这会导致混乱，且难以 review。

### 2.2 分支命名规范

Superset 自动基于 Workspace 名称创建分支，建议采用以下规范：

```
# 功能开发
feature/<module>-<description>
feature/auth-mfa-support
feature/api-rate-limiting

# Bug 修复
fix/<issue>-<brief-description>
fix/#1234-login-loop
fix/memory-leak-in-dashboard

# 重构
refactor/<scope>-<target>
refactor/api-to-trpc
refactor/class-to-hooks

# 探索
spike/<technology>-<goal>
spike/tanstack-query-migration
```

这样即使不打开 Superset，光看分支名也知道每个 Workspace 在干嘛。

---

## 三、Setup/Teardown 脚本深度配置

这是 Superset 最被低估的功能。配置好它，创建 Workspace 就是一键的事。

### 3.1 基础配置结构

在项目根目录创建 `.superset/config.json`：

```json
{
  "setup": [
    "bun install",
    "cp \"$SUPERSET_ROOT_PATH/.env\" .env",
    "bun run db:migrate"
  ],
  "teardown": [
    "bun run db:rollback",
    "docker-compose down -v"
  ]
}
```

### 3.2 环境变量注入

Superset 提供以下环境变量供脚本使用：

| 变量 | 说明 | 示例 |
|------|------|------|
| `SUPERSET_ROOT_PATH` | 原始仓库路径 | `/Users/victor/projects/my-app` |
| `SUPERSET_WORKSPACE_NAME` | 当前 Workspace 名称 | `feature-auth` |

**实战技巧**：用这些变量实现动态配置

```bash
#!/bin/bash
# .superset/setup.sh

set -e  # 遇到错误立即退出

echo "🚀 Setting up workspace: $SUPERSET_WORKSPACE_NAME"

# 1. 复制环境变量
cp "$SUPERSET_ROOT_PATH/.env" .env

# 2. 安装依赖（根据 lockfile 存在与否选择）
if [ -f "bun.lockb" ]; then
  bun install --frozen-lockfile
elif [ -f "package-lock.json" ]; then
  npm ci
else
  bun install
fi

# 3. 数据库准备
if [ -f "docker-compose.yml" ]; then
  docker-compose up -d postgres redis
  sleep 3  # 等待服务启动
fi

# 4. 运行迁移
bun run db:migrate

# 5. 可选：种子数据
if [ "$SUPERSET_WORKSPACE_NAME" = "dev-seed" ]; then
  bun run db:seed
fi

echo "✅ Workspace ready!"
```

### 3.3 分层配置策略

Superset 支持三层配置，优先级从高到低：

```
1. ~/.superset/projects/<project-id>/config.json     # 用户级覆盖
2. <worktree>/.superset/config.json                  # Worktree 级
3. <repo-root>/.superset/config.json                 # 项目默认
```

**使用场景**：

**场景 A：团队共享基础配置**
```json
// .superset/config.json (提交到 Git)
{
  "setup": ["bun install", "bun run db:migrate"],
  "teardown": ["docker-compose down"]
}
```

**场景 B：个人添加私有步骤**
```json
// .superset/config.local.json (Git 忽略)
{
  "setup": {
    "after": ["bun run my-personal-tool"]
  }
}
```

**场景 C：完全覆盖（不修改仓库）**
```json
// ~/.superset/projects/my-app/config.json
{
  "setup": ["./my-custom-setup.sh"],
  "teardown": []
}
```

### 3.4 Teardown 最佳实践

Teardown 是清理资源的关键，务必配置好：

```json
{
  "teardown": [
    "docker-compose down -v",      # 停止并删除容器+卷
    "bun run db:rollback",         # 回滚数据库变更
    "rm -rf node_modules/.cache",  # 清理缓存
    "echo 'Cleanup complete'"
  ]
}
```

**注意**：如果 teardown 失败，Superset 会提示 "Delete Anyway"，但建议先查看日志修复问题，避免资源泄漏。

---

## 七、并行 Agent 调度策略

### 4.1 任务类型与 Agent 选择

不同任务适合不同 Agent：

| 任务类型 | 推荐 Agent | 原因 |
|----------|-----------|------|
| 复杂架构设计 | Claude Code | 推理能力强，上下文理解好 |
| 快速原型开发 | Codex | 速度快，代码生成准确 |
| UI/样式调整 | Cursor | 编辑器集成好，实时预览 |
| 代码审查 | Claude Code | 能给出详细解释和建议 |
| 文档编写 | Claude Code | 语言表达能力强 |
| 测试生成 | Codex/Cursor | 模式匹配准确 |

### 4.2 并行任务组合示例

![Agent 并行工作](https://openclaw.cos.jiahongw.com/blog/illustrations/superset/03-agents.png)

**场景：大型功能开发**

假设你要开发一个支付系统，可以这样拆分：

```
Workspace 1: feature/payment-api
  → Agent: Claude Code
  → 任务: 设计 API 接口、数据库 Schema

Workspace 2: feature/payment-ui  
  → Agent: Cursor
  → 任务: 开发支付表单、确认页面

Workspace 3: feature/payment-tests
  → Agent: Codex
  → 任务: 编写单元测试、集成测试

Workspace 4: feature/payment-docs
  → Agent: Claude Code
  → 任务: 编写 API 文档、使用指南
```

4 个 Agent 同时工作，互不影响，完成后分别 review 再合并。

### 4.3 避免资源冲突

虽然 worktree 隔离了文件，但以下资源仍可能冲突：

**数据库端口冲突**
```yaml
# docker-compose.yml
# 不要用固定端口，用环境变量
services:
  postgres:
    ports:
      - "${DB_PORT:-5432}:5432"
```

然后在 setup 脚本里动态分配端口：
```bash
# 基于 workspace 名称生成端口
DB_PORT=$((5000 + $(echo "$SUPERSET_WORKSPACE_NAME" | cksum | cut -d' ' -f1) % 1000))
export DB_PORT
docker-compose up -d
```

**进程端口冲突**
```json
// package.json
{
  "scripts": {
    "dev": "next dev -p ${PORT:-3000}"
  }
}
```

---

## 八、Review 与合并工作流

### 5.1 Changes 面板使用技巧

Superset 内置 diff viewer，但高效 review 需要策略：

**Step 1: 快速筛选**
- 只看 `.ts/.tsx` 文件，忽略 `node_modules` 和 lockfile
- 关注测试文件变化（如果测试没改，大概率有问题）

**Step 2: 关键检查点**
- [ ] 是否有硬编码的调试代码？
- [ ] 错误处理是否完善？
- [ ] 敏感信息（密钥、密码）是否泄露？
- [ ] 性能是否有明显劣化（如 N+1 查询）？

**Step 3: 交互式修复**
如果发现问题，可以直接在 Superset 的编辑器里修改，不用切换回主 IDE。

### 5.2 合并策略

**策略 A：逐个合并（保守）**
```bash
# 在 Superset 里点击 "Open in IDE" 打开 workspace
git checkout main
git merge feature/auth
# 解决冲突...
git push
```

**策略 B：批量合并（激进）**
```bash
# 在主仓库执行
git merge --no-ff feature/auth feature/payment fix/login
# 一次性处理所有冲突
```

**策略 C：Rebase 合并（干净历史）**
```bash
git checkout feature/auth
git rebase main
# 解决冲突...
git checkout main
git merge feature/auth  # 现在会是 fast-forward
```

---

## 九、性能优化与故障排查

### 6.1 磁盘空间管理

每个 worktree 都会占用磁盘空间，定期清理：

```bash
# 查看所有 worktree 大小
du -sh ~/superset-worktrees/*/*

# 删除已合并的 workspace（在 Superset 里操作更安全）
```

### 6.2 内存优化

同时运行多个 Agent 会占用大量内存：

**限制单个 Agent 的并发数**
- Superset 本身不限制，但建议同时活跃的 Workspace 不超过 5-8 个
- 其余可以暂停（关闭 terminal）或归档

**使用轻量级 Agent**
- 对于简单任务，可以用 Gemini CLI 或本地小模型代替 Claude Code

### 6.3 常见问题排查

**问题 1: Setup 脚本失败**
```bash
# 查看详细日志
# Superset UI → Workspace → Logs

# 常见原因：
# - 依赖版本冲突
# - 环境变量缺失
# - 端口被占用
```

**问题 2: Agent 无响应**
- 检查 Agent 是否真的在运行（有些任务需要很长时间）
- 查看 Terminal 输出，可能卡在等待输入
- 尝试 `Ctrl+C` 中断后重新启动

**问题 3: Changes 不显示**
- 确认 Agent 确实做了修改（有些 Agent 只提供建议，不修改文件）
- 检查是否在正确的 worktree 目录里工作

---

## 十、高级技巧

### 7.1 与 CI/CD 集成

Superset 生成的分支可以直接走 CI：

```yaml
# .github/workflows/ci.yml
name: CI
on:
  push:
    branches:
      - 'feature/**'
      - 'fix/**'
      - 'refactor/**'

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Test
        run: bun test
```

这样每个 Workspace 提交后自动跑测试，结果会显示在 GitHub PR 里。

### 7.2 Workspace 模板

对于重复性任务，可以创建模板：

```bash
# 创建一个基础 workspace，配置好所有 setup
# 然后在 Superset 里 "Duplicate" 它
```

### 7.3 快捷键自定义

Superset 支持自定义快捷键：

```
Settings → Keyboard Shortcuts (⌘/)

推荐配置：
⌘⇧1-9: 快速切换到对应 workspace
⌘⇧R: 重新运行 setup 脚本
⌘⇧D: 删除当前 workspace
```

---

## 十一、完整 Workflow 示例

**任务：做一个 notification 系统**

| Agent | 任务 | 分支 |
|-------|------|------|
| Agent 1 | DB schema | `feature/notification-db` |
| Agent 2 | Backend API | `feature/notification-api` |
| Agent 3 | React 组件 | `feature/notification-ui` |
| Agent 4 | 集成测试 | `test/notification` |
| Agent 5 | 文档 | `docs/notification` |

**30 分钟后：**

```bash
git merge feature/notification-db
git merge feature/notification-api
git merge feature/notification-ui
# ...
```

完成。

---

## 十二、常见错误

### 1. Agent 太多

> 5 agents ≈ 最佳

超过你的 review 能力 = 质量下降。

### 2. 任务太大

一个 agent 写 1000 行代码 = 灾难。

### 3. 没有测试

**必须有：**

```
Agent A → 写功能
Agent B → 写测试
```

---

## 十三、总结

Superset 的核心价值不是 "能同时开多个 Agent"，而是 **结构化地管理并行开发任务**。

用好它的关键：
1. **理解 Git worktree** —— 知道文件隔离的原理
2. **配置好 setup/teardown** —— 让创建/销毁 workspace 零成本
3. **合理拆分任务** —— 一个 workspace 只做一件事
4. **建立 review 流程** —— Agent 的产出必须经过人工检查

最后提醒：Agent 是加速器，不是替代品。最终的责任和判断还是在你。

---

**核心思想总结：**

> 把 AI agent 当成**并行工程团队**，而不是 Copilot。

**你的角色：** Architect / Tech Lead  
**AI 的角色：** 10 个 Junior Engineers

**开发节奏：**

| 阶段 | 占比 |
|------|------|
| 设计 | 10% |
| 并行开发 | 80% |
| Review | 10% |

而不是：写代码 70%。

---

**参考链接**：
- Superset 官网：https://superset.sh/
- GitHub 仓库：https://github.com/superset-sh/superset
- 官方文档：https://docs.superset.sh/
