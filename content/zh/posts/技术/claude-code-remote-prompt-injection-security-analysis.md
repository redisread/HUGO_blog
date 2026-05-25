---
title: "Claude Code v2.1.150 远程系统提示注入漏洞深度分析"
date: 2026-05-25T01:15:00+08:00
draft: false
author: "RSS Daily"
description: "深入分析 Claude Code v2.1.150 引入的远程系统提示注入机制，探讨其安全 implications 和应对策略"
image: "https://cos.jiahongw.com/rss-daily/20260525/cover.png"
categories:
  - 技术
  - AI安全
tags:
  - Claude Code
  - 系统提示注入
  - AI安全
  - Anthropic
  - 漏洞分析
---

## 核心观点

2026年5月22日，Anthropic 发布的 Claude Code v2.1.150 引入了一项极具争议的功能：**远程系统提示注入机制**。该版本允许 Anthropic 通过两个网络数据源向用户的 AI 代理动态注入任意字符串到系统提示中：

1. **Bootstrap API** (`api.anthropic.com/api/claude_cli/bootstrap`) —— 启动时获取，缓存到磁盘
2. **GrowthBook 特性标志** (`tengu_heron_brook`) —— 每60秒后台同步刷新

这意味着 Anthropic 可以在用户不知情的情况下，修改具有 shell 访问权限的 AI 代理的行为指令。这一发现由安全研究员 matheusmoreira 在 GitHub 上披露，引发了开发者社区的广泛关注和担忧。

![AI安全概念图](https://cos.jiahongw.com/rss-daily/20260525/img-01.png)

## 深度分析

### 技术实现机制

根据 GitHub Issue #62061 的技术分析，v2.1.150 在代码中引入了一个名为 `nAA` 的函数（在压缩后的源码中），该函数执行以下操作：

```javascript
// 伪代码表示
function nAA() {
  const clientData = fetchBootstrapAPI();  // 从远程 API 获取
  const featureFlag = getGrowthBookFlag('tengu_heron_brook');  // 从 GrowthBook 获取
  
  // 将获取的内容注入系统提示
  systemPrompt.inject(clientData);
  systemPrompt.inject(featureFlag);
}
```

这些注入的字符串被注册为与 `anti_verbosity`、`thinking_guidance`、`action_caution` 等同等级的系统提示部分。关键在于：**这些值被直接注入到具有 shell 访问权限的 AI 代理的指令中**。

### 与早期版本的对比

此前的版本（如 v2.1.149）虽然也存在类似的代码结构（`ant_model_override`），但该插槽始终返回 `null`，没有实际功能。v2.1.150 是第一个让这个插槽具备实时逻辑的版本。

| 版本 | 远程提示注入 | 数据来源 | 刷新频率 |
|------|-------------|----------|----------|
| v2.1.149 及更早 | ❌ 不存在 | N/A | N/A |
| v2.1.150 | ✅ 已实现 | Bootstrap API + GrowthBook | 启动时 + 每60秒 |

### 安全 Implications

#### 1. 信任边界模糊化

传统的软件安全模型依赖于明确的信任边界。用户安装的软件应该在本地运行，其行为由本地代码决定。然而，Claude Code v2.1.150 打破了这一边界：

- **远程代码执行等效**：虽然 Anthropic 注入的是提示文本而非可执行代码，但在 AI 代理的上下文中，提示文本直接决定了代理的行为
- **不可审计性**：用户无法预知或审计将要注入的提示内容
- **持久化风险**：获取的值被缓存到磁盘，即使断网后仍可能被使用

#### 2. 供应链攻击向量

这一机制为潜在的供应链攻击打开了新的向量：

- 如果 Anthropic 的服务器被攻破，攻击者可以向所有 Claude Code 用户注入恶意提示
- 具有 shell 访问权限的 AI 代理被注入恶意指令后，可能执行任意系统命令
- 这种攻击不需要用户下载任何恶意代码，完全通过"合法"的更新渠道完成

#### 3. 与历史漏洞的关联

这并非 Claude Code 第一次面临安全质疑。根据 The Hacker News 2026年2月的报道，Check Point 研究人员曾披露多个严重漏洞：

- **CVE-2025-59536** (CVSS 8.7)：代码注入漏洞，允许在工具初始化时自动执行任意 shell 命令
- **CVE-2026-21852** (CVSS 5.3)：信息泄露漏洞，允许恶意仓库窃取 Anthropic API 密钥
- **无 CVE 编号漏洞** (CVSS 8.7)：用户同意绕过，通过 `.claude/settings.json` 中的不受信任项目 hooks 执行任意代码

这些漏洞的共同点是：**AI 代理的权限过大，而安全边界不够清晰**。

### 社区反应与应对

#### 临时缓解措施

安全社区已经识别出以下环境变量可用于阻止这一机制：

```bash
# 阻止 Bootstrap API 请求
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

# 禁用 GrowthBook SDK
export DISABLE_GROWTHBOOK=1
```

**重要警告**：这些环境变量只能阻止新的网络请求。如果用户之前运行过未加防护的会话，缓存的特性值仍可能从磁盘读取并应用。

#### 长期解决方案需求

1. **透明度要求**：Anthropic 应该明确披露哪些提示内容会被远程注入，以及注入的目的
2. **用户控制**：提供明确的 opt-in/opt-out 机制，而非默认启用
3. **审计日志**：记录所有远程注入的提示内容，供用户审查
4. **代码签名**：对远程注入的提示进行签名验证，防止中间人攻击

## 可实践建议

| 场景 | 建议措施 | 优先级 |
|------|----------|--------|
| 个人开发者 | 设置 `CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1` 和 `DISABLE_GROWTHBOOK=1` | 高 |
| 企业团队 | 审查并限制 Claude Code 的网络访问权限，使用防火墙规则阻止相关域名 | 高 |
| 安全敏感项目 | 考虑使用离线版本或完全隔离的网络环境运行 Claude Code | 高 |
| 一般用户 | 关注 Anthropic 的官方回应和后续更新，保持软件版本最新 | 中 |
| 开源社区 | 参与 Piebald-AI/claude-code-system-prompts 项目，监控系统提示变化 | 中 |

## 行业背景与趋势

这一事件反映了 AI 辅助开发工具面临的更广泛安全挑战：

### 1. 提示注入攻击的演变

根据 John Stawinski 2026年2月的研究，Claude Code Action 曾被发现存在严重的提示注入到远程代码执行（RCE）漏洞链。攻击者可以通过 PR 标题注入恶意提示，导致在 GitHub Actions 工作流中执行任意代码。

### 2. AI 代理的安全边界

随着 AI 代理获得越来越多的工具访问权限（文件系统、网络、shell 等），提示注入攻击的危害性呈指数级增长。正如 Stawinski 所言："如果你给 LLM 一把刀，那么任何能影响这个 LLM 的人就控制了这把刀。"

### 3. 供应商锁定与透明度

AI 开发工具的核心价值在于其模型能力，但这种能力往往伴随着对供应商的依赖。当供应商可以在用户不知情的情况下修改工具行为时，用户的自主权受到侵蚀。

## 相关资源链接

- **原始披露**: [GitHub Issue #62061](https://github.com/anthropics/claude-code/issues/62061)
- **系统提示追踪**: [Piebald-AI/claude-code-system-prompts](https://github.com/Piebald-AI/claude-code-system-prompts)
- **Claude Code 安全文档**: [code.claude.com/docs/en/security](https://code.claude.com/docs/en/security)
- **历史漏洞分析**: [The Hacker News - Claude Code Flaws Report](https://thehackernews.com/2026/02/claude-code-flaws-allow-remote-code.html)
- **提示注入研究**: [John Stawinski - Trusting Claude With a Knife](https://johnstawinski.com/2026/02/05/trusting-claude-with-a-knife-unauthorized-prompt-injection-to-rce-in-anthropics-claude-code-action/)

## 一句话总结

Claude Code v2.1.150 的远程系统提示注入机制代表了 AI 开发工具安全边界的一次重大模糊化——当供应商可以在用户不知情的情况下修改具有系统权限的 AI 代理的行为指令时，我们需要重新审视"本地软件"与"云服务"之间的信任边界，并建立更透明的安全审计机制。

---

*本文基于公开技术资料和安全研究整理，旨在提升开发者对 AI 工具安全风险的认识。*
