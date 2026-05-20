---
title: "Claude Code HERMES.md 计费漏洞深度解析：当 AI 订阅变成一场信任危机"
date: 2026-05-01T01:00:00Z
draft: false
description: "2026年4月，Claude Code 用户发现一个令人震惊的计费漏洞：当 Git 提交历史中包含字符串 HERMES.md 时，所有 API 请求会从订阅配额静默路由到按量付费计费，导致 $200 额外扣费。本文深度分析技术机制、商业影响和开发者防护策略。"
image: "https://cos.jiahongw.com/rss-daily/20260501/cover.png"
tags:
  - ClaudeCode
  - Anthropic
  - 计费漏洞
  - AI订阅
  - 开发者权益
categories:
  - 技术
  - AI
---

# Claude Code "HERMES.md" 计费漏洞深度解析：当 AI 订阅变成一场信任危机

**发布时间**: 2026-05-01  
**来源**: Reddit r/ClaudeCode / GitHub Issues / ByteIota  
**标签**: #ClaudeCode #Anthropic #计费漏洞 #AI订阅 #开发者权益

---

## 核心观点：一个文件名如何烧掉 200 美元

2026年4月25日，一位 Claude Code Max 订阅用户发现了一个令人震惊的计费漏洞：当 Git 提交历史中包含字符串 `"HERMES.md"`（区分大小写）时，Claude Code 会将所有 API 请求从订阅配额路由到"额外使用"计费——即按量付费的 API 费率。这位用户因此损失了 **$200.98**，而他的 Max 20x 计划配额仍有 **86%** 未使用。

这不是一个普通的 Bug。它揭示了 AI 订阅模式中最深层的问题：**计费黑箱**。用户无法预知、无法监控、无法申诉。当 Anthropic 最初拒绝退款时，这场技术故障演变成了一场关于企业责任和开发者权益的公共危机。

---

## 深度分析

### 一、技术机制：内容过滤器如何劫持计费

#### 1.1 系统提示词的"后门"

Claude Code 在每次请求时会将最近的 Git 提交历史注入系统提示词。这是为了提供项目上下文，让 AI 理解代码变更背景。然而，Anthropic 在服务器端部署了一个内容过滤器，用于检测第三方工具的使用。

**触发条件**（精确匹配）：
- ✅ `"HERMES.md"` — 路由到额外计费
- ❌ `"hermes.md"`（小写）— 正常使用订阅配额
- ❌ `"HERMES"`（无扩展名）— 正常使用
- ❌ `"HERMES.txt"` — 正常使用
- ❌ `"AGENTS.md"` — 正常使用

这个过滤器的设计目的是执行 Anthropic 在 **2026年4月4日** 发布的新政策：禁止第三方工具（如 OpenClaw、Hermes Agent）使用 Pro/Max 订阅配额，强制这些工具的用户切换到按量付费 API。

#### 1.2 误伤的逻辑链

问题在于，过滤器无法区分：
- **实际使用** Hermes Agent 第三方工具
- **仅仅在提交信息中**提到了 `HERMES.md` 文件名

`HERMES.md` 这个文件名可能源自 [NousResearch 的 Hermes Agent](https://hermes-agent.nousresearch.com/) 项目文档，但许多开发者的项目中可能完全无关地使用了这个文件名。

**最小复现步骤**：
```bash
# 创建测试目录并初始化 Git
mkdir /tmp/test-fail && cd /tmp/test-fail
git init && echo test > test.txt && git add . 

# 关键：提交信息包含 HERMES.md
git commit -m "add HERMES.md"

# 运行 Claude Code — 将触发额外计费
claude -p "say hello" --model "claude-opus-4-6"
# => API Error: 400 "You're out of extra usage..."
```

#### 1.3 计费路由的"静默切换"

最危险的是，这个切换是**完全静默**的：
- 没有用户通知
- 没有实时仪表板显示当前计费层级
- 错误信息 `"You're out of extra usage"` 具有误导性 — 用户并未用完配额，而是被切换到了不同的计费通道

### 二、商业影响：订阅模式的信任崩塌

#### 2.1 Anthropic 的定价策略

Claude Code 的订阅层级（截至2026年4月）：

| 计划 | 月费 | 核心限制 |
|------|------|----------|
| Pro | $20 | 5倍使用量，标准模型 |
| Max 5x | $100 | 5倍使用量，优先访问 |
| Max 20x | $200 | 20倍使用量，完整功能 |

Max 计划的核心价值在于"无限"（在配额内）使用 Opus 等高级模型。但当内容过滤器可以**单方面**将用户踢出订阅体系时，这个价值主张就崩塌了。

#### 2.2 退款危机的转折点

事件时间线：

| 日期 | 事件 |
|------|------|
| 4月25日 | 用户在 GitHub 提交 Issue #53262，详细记录漏洞 |
| 4月29日 | 帖子登上 Hacker News 首页，获得 828 个赞和 313 条评论 |
| 4月29日 | ThePrimeagen、Theo (t3.gg) 等开发者 KOL 在社交媒体发声 |
| 4月29日 | Anthropic 员工宣布：将退款并提供 $200 积分补偿 |
| 4月30日 | 漏洞修复，但信任损害已造成 |

**关键问题**：Anthropic 最初通过 AI 客服 Fin 拒绝退款，理由是"无法为技术错误导致的服务降级提供补偿"。直到公众压力迫使才改变立场。

#### 2.3 这不是孤立事件

根据 ByteIota 的调查，这是 Anthropic 计费系统问题的**模式**：
- 2026年1月：用户一天内被重复扣费 26 次
- 2026年2月：确认存在双重计费系统 Bug
- 2026年3-4月：至少 6 名用户报告未授权扣费（涉及台湾、波兰、英国、美国）
- 2025年底：Anthropic 封禁 145 万个账户

Trustpilot 评分：**3/10**，计费投诉占主导。

### 三、行业对比：谁在做对，谁在做错

#### 3.1 竞争对手的透明度

| 服务商 | 计费透明度 | 实时仪表板 | 消费上限 |
|--------|-----------|-----------|----------|
| **OpenAI** | 信用额度制 | ✅ 实时余额 | ✅ 可设置 |
| **Google Vertex AI** | 每请求定价 | ✅ 详细监控 | ✅ 可设置 |
| **Azure OpenAI** | 消费制 | ✅ 使用警报 | ✅ 硬性上限 |
| **Anthropic** | 内容过滤器路由 | ❌ 无层级显示 | ❌ 无 |

#### 3.2 企业软件 vs AI 公司的责任差距

传统 SaaS 行业花了数十年建立的标准：
- 透明定价
- 人工客服处理争议
- SLA 支持的正常运行时间保证
- 可预测的成本

AI 公司想要企业级预算，却抗拒企业级责任。传统 SaaS 是按席位定价、可预测。AI 定价是按使用量、弹性、且——在 Anthropic 案例中——**取决于扫描你 Git 历史的内容过滤器**。

### 四、开发者社区的集体焦虑

#### 4.1 代表性评论

**ThePrimeagen**（知名开发者教育者）：
> "Just another day of being convinced that Anthropic has no clue what the hell is going on in their codebase."
> （又是确信 Anthropic 根本不知道他们的代码库在干什么的一天。）

**Theo (t3.gg)**：
> "It is genuinely insane that Anthropic will bill you differently if you mention certain words in your prompt or have certain files in your codebase."
> （如果你在提示词中提到某些词，或者代码库中有某些文件，Anthropic 就会以不同方式计费，这简直是疯了。）

**Hacker News 高赞评论**：
> "CFOs are scrambling as AI pricing breaks traditional SaaS billing models."
> （CFO 们正在手忙脚乱，因为 AI 定价正在打破传统 SaaS 计费模式。）

#### 4.2 深层担忧：提示词即攻击面

这个事件暴露了一个更大的问题：**系统提示词成为计费攻击面**。如果内容过滤器可以根据提示词内容改变计费方式，那么：
- 恶意仓库可以故意包含触发字符串来消耗目标用户的配额
- 企业无法审计为何某些请求比其他请求更贵
- 开发者被迫自我审查提交信息，避免"危险"字符串

---

## 可实践建议

### 个人开发者防护清单

| 优先级 | 行动 | 具体操作 |
|--------|------|----------|
| 🔴 高 | 审计 Git 历史 | 运行 `git log --all --oneline --grep="HERMES"` 检查是否包含触发字符串 |
| 🔴 高 | 监控计费异常 | 每日检查 Anthropic 控制台，注意"额外使用"是否意外增加 |
| 🟡 中 | 使用 API 密钥隔离 | 为不同项目创建独立的 Anthropic API 密钥，便于追踪 |
| 🟡 中 | 设置预算警报 | 在云平台（如 AWS/Azure）使用 Anthropic 时设置硬性消费上限 |
| 🟢 低 | 文档化团队规范 | 告知团队成员避免在提交信息中使用可能触发过滤器的字符串 |

### 企业/团队决策框架

**如果你正在评估 Claude Code 企业使用**：

1. **要求透明度**
   - 向 Anthropic 销售团队询问：内容过滤器的完整触发条件列表
   - 要求提供实时计费层级 API 查询能力

2. **建立监控体系**
   ```python
   # 示例：监控脚本伪代码
   def check_billing_tier():
       response = anthropic_api.usage.current()
       if response.billing_tier != "subscription":
           alert_team(f"计费层级异常: {response.billing_tier}")
   ```

3. **多元化供应商策略**
   - 不要将所有 AI 工作负载绑定到单一供应商
   - 考虑 OpenAI、Google、本地模型（如 DeepSeek、Kimi）的组合

4. **合同谈判要点**
   - 要求 SLA 包含计费准确性保证
   - 要求人工客服升级路径（非仅 AI 客服）
   - 要求超额计费自动退款条款

### 替代方案对比

| 工具 | 类型 | 计费模式 | 透明度 |
|------|------|----------|--------|
| **Claude Code** | AI 编程助手 | 订阅 + 按量 | ⚠️ 低 |
| **GitHub Copilot** | AI 编程助手 | 固定订阅 | ✅ 高 |
| **Cursor** | AI IDE | 订阅 + 按量 | ✅ 中 |
| **Kimi Code** | 开源替代 | API 按量 | ✅ 高 |
| **OpenClaw** | 开源框架 | 自托管/本地 | ✅ 最高 |

---

## 一句话总结

> **HERMES.md 事件不是技术故障，而是商业模式的警钟**：当 AI 公司的计费系统变成无法审计的黑箱，当 $200/月的订阅用户需要靠 Hacker News 热搜才能获得退款，这个行业需要的不是更多功能，而是基本的信任和透明。

---

## 参考链接

### 原始来源
- [GitHub Issue #53262: HERMES.md billing bug](https://github.com/anthropics/claude-code/issues/53262) — 技术细节和复现步骤
- [Reddit r/ClaudeCode 讨论](https://www.reddit.com/r/ClaudeCode/comments/1szxy0m/hermesmd_in_a_git_commit_message_silently_drained/) — 用户发现和社区讨论

### 深度报道
- [ByteIota: Anthropic's HERMES.md Billing Bug Analysis](https://byteiota.com/anthropics-hermes-md-billing-bug-200-overcharge-refund-denied/) — 完整事件调查和商业模式分析
- [Hacker News 讨论](https://news.ycombinator.com/item?id=47952722) — 828 赞，开发者社区反应

### 相关技术资源
- [NousResearch Hermes Agent](https://hermes-agent.nousresearch.com/) — 被误伤的第三方工具
- [Claude Code 官方文档](https://code.claude.com/docs) — 系统提示词修改指南
- [Piebald-AI/claude-code-system-prompts](https://github.com/Piebald-AI/claude-code-system-prompts) — 社区维护的系统提示词分析

### 竞争对手计费透明度
- [OpenAI Usage Dashboard](https://platform.openai.com/usage)
- [Google Vertex AI Pricing](https://cloud.google.com/vertex-ai/pricing)
- [Azure OpenAI Service Pricing](https://azure.microsoft.com/pricing/details/cognitive-services/openai-service/)

---

*本文基于公开信息整理，旨在帮助开发者理解风险并做出明智决策。如有计费争议，建议保留所有证据并通过多渠道（支持工单 + 社交媒体）寻求解决。*
