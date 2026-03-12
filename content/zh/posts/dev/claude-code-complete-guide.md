---
title: Claude Code 完全指南：从聊天工具到 AI 工程环境
date: 2026-03-12T17:50:00+08:00
description: 深入解析 Claude Code 的四层架构（CLAUDE.md、Skills、Hooks、Agents），解锁从基础代码生成到生产级 AI 工程环境的完整能力
draft: false
hideToc: false
enableToc: true
enableTocContent: false
authorEmoji: 🤖
image: https://images.unsplash.com/photo-1677442136019-21780ecad995?w=1200
libraries: []
tags: [Claude, AI, 开发工具, 编程效率, Agent]
series:
categories: [开发工具]
---

> 参考 r/promptingmagic 社区精华，结合个人实践，解锁 Claude Code 的隐藏能力

## 为什么你只用到了 Claude Code 的 10%

大多数开发者打开 Claude Code，问它生成代码，然后关闭。这没问题，但完全浪费了它的潜力。

经过几周深度实验，我发现 Claude Code 背后是一个**四层架构的 AI 工程环境**。理解这个架构，是从"基础输出"迈向"生产级结果"的关键。

---

## 四层架构：Claude Code 的核心设计

```
┌─────────────────────────────────────┐
│  L4 - Agents (智能代理层)            │
│  自主执行复杂工作流                    │
├─────────────────────────────────────┤
│  L3 - Hooks (安全钩层)               │
│  确定性规则与安全闸门                  │
├─────────────────────────────────────┤
│  L2 - Skills (技能层)                │
│  可复用知识包，自动触发                │
├─────────────────────────────────────┤
│  L1 - CLAUDE.md (大脑层)             │
│  项目持久记忆，每次会话加载            │
└─────────────────────────────────────┘
```

---

## L1 - CLAUDE.md：项目的"大脑"

这是**最重要的文件**，没有之一。

CLAUDE.md 是项目根目录下的 Markdown 文件，每次会话启动时自动加载。它告诉 Claude：

- 技术栈和架构
- 常用命令和脚本
- 项目目标和约束
- 代码风格规范

### CLAUDE.md 模板

```markdown
# Project: MyAwesomeApp

## Tech Stack
- Frontend: Next.js 14 + Tailwind + shadcn/ui
- Backend: Node.js + Express + PostgreSQL
- AI: OpenAI API + LangChain

## Architecture
- Clean Architecture / Hexagonal
- Domain-driven design
- Repository pattern for data layer

## Commands
- `npm run dev` - Start dev server
- `npm run test` - Run test suite
- `npm run lint` - Check code style

## Constraints
- Always use TypeScript strict mode
- Prefer functional components
- Use React Server Components where possible
- Never expose API keys in client code
```

---

## L2 - Skills：可复用的"超能力"

Skills 是自动触发的知识包。当 Claude 检测到对话内容与某个 skill 描述匹配时，会自动调用。

### Skill 文件结构

`.claude/skills/testing.md`:

```markdown
---
name: Testing Best Practices
description: When writing tests, use this skill to ensure quality and coverage
---

## Testing Guidelines

1. **Unit Tests**
   - Test one thing per test
   - Use descriptive test names: `should_do_something_when_condition`
   - Arrange-Act-Assert pattern

2. **Integration Tests**
   - Test real database interactions
   - Mock external services only
   - Clean up test data after each test

3. **Coverage**
   - Aim for 80%+ coverage on business logic
   - Don't chase 100% coverage for coverage's sake
```

### 常用 Skill 类型

| Skill | 触发场景 |
|-------|---------|
| `code-review.md` | 代码审查时自动加载规范 |
| `api-design.md` | 设计 API 端点时触发 |
| `security.md` | 涉及安全敏感操作时 |
| `performance.md` | 优化性能时提供指导 |

---

## L3 - Hooks：安全与自动化的"闸门"

Hooks 是确定性规则，在特定时机执行代码。

### Hook 类型

**PreToolUse Hook**: 工具使用前检查

```javascript
// .claude/hooks/pre-tool-use.js
module.exports = {
  beforeToolUse: async (tool, args) => {
    // 检查敏感操作
    if (tool === 'Bash' && args.command.includes('rm -rf')) {
      return {
        allow: false,
        message: '⚠️ 危险操作检测：删除命令需要手动确认'
      };
    }
    return { allow: true };
  }
};
```

**PostToolUse Hook**: 工具执行后处理

```javascript
// .claude/hooks/post-tool-use.js
module.exports = {
  afterToolUse: async (tool, args, result) => {
    // 自动记录文件修改
    if (tool === 'Write' || tool === 'Edit') {
      console.log(`📝 文件修改: ${args.file_path}`);
    }
    return result;
  }
};
```

**Notification Hook**: 发送通知

```javascript
// .claude/hooks/notification.js
module.exports = {
  onLongRunningTask: async (task) => {
    // 长时间任务完成时发送通知
    await sendDiscordNotification(`✅ 任务完成: ${task.description}`);
  }
};
```

---

## L4 - Agents：自主执行的"智能体"

Agents 是最高层，能够自主规划和执行复杂工作流。

### Agent 配置

`.claude/agents/feature-agent.md`:

```markdown
---
name: Feature Development Agent
description: Use this agent for implementing new features from spec to PR
---

## Workflow

1. **Understand**: Read the feature spec and ask clarifying questions
2. **Plan**: Create a detailed implementation plan
3. **Research**: Check existing code patterns and dependencies
4. **Implement**: Write code following project conventions
5. **Test**: Write unit tests and integration tests
6. **Review**: Self-review against checklist
7. **Document**: Update README and API docs

## Checklist

- [ ] All new code has tests
- [ ] No console.log left in production code
- [ ] Error handling is comprehensive
- [ ] TypeScript types are correct
- [ ] Documentation is updated
```

### 启动 Agent

```
/claude agent feature-agent.md
> Implement user authentication with JWT tokens
```

Agent 会自主执行完整工作流，从理解需求到生成 PR。

---

## 推荐项目结构

```
my-project/
├── CLAUDE.md              # L1: 项目大脑
├── .claude/
│   ├── skills/            # L2: 可复用知识
│   │   ├── testing.md
│   │   ├── api-design.md
│   │   └── security.md
│   ├── hooks/             # L3: 安全闸门
│   │   ├── pre-tool-use.js
│   │   └── post-tool-use.js
│   └── agents/            # L4: 智能代理
│       ├── feature-agent.md
│       └── refactor-agent.md
├── src/
└── tests/
```

---

## 日常工作流模式

### 模式 1：快速原型

```
"Create a React component for a dashboard widget"
→ Claude uses CLAUDE.md tech stack info
→ Generates code following project conventions
```

### 模式 2：代码审查

```
/claude skill code-review.md
"Review this PR for security issues"
→ Skill auto-loads security checklist
→ Claude systematically checks each item
```

### 模式 3：复杂功能开发

```
/claude agent feature-agent.md
"Implement Stripe payment integration"
→ Agent creates plan
→ Researches existing code
→ Implements with tests
→ Self-reviews
→ Generates PR description
```

---

## 记忆层级：Claude 如何"记住"

| 层级 | 持久性 | 范围 | 使用场景 |
|------|--------|------|---------|
| Session | 当前对话 | 临时上下文 | 当前任务的细节 |
| CLAUDE.md | 永久 | 项目级 | 技术栈、架构、规范 |
| Skills | 永久 | 跨项目可复用 | 特定领域的最佳实践 |
| Hooks | 永久 | 项目级 | 安全规则、自动化 |
| Agents | 永久 | 跨项目可复用 | 完整工作流模板 |

---

## 立即行动：5 分钟配置

1. **创建 CLAUDE.md**: 复制上面的模板，填入你的项目信息
2. **创建第一个 Skill**: 从 `testing.md` 或 `code-review.md` 开始
3. **添加一个 Hook**: 用 PreToolUse 防止危险操作
4. **测试**: 开始新会话，观察 Claude 自动加载配置

---

## 总结

Claude Code 不是聊天工具，而是一个**可编程的 AI 工程环境**。

- **CLAUDE.md** 给它记忆
- **Skills** 给它知识
- **Hooks** 给它规则
- **Agents** 给它自主性

四层协同，Claude 从"代码生成器"进化为"工程伙伴"。

---

## 参考

- [r/promptingmagic 社区精华](https://www.reddit.com/r/promptingmagic/)
- [Claude Code 官方文档](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)
- 作者: u/Beginning-Willow-801
