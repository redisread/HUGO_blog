---
title: "Vibe Coding 安全危机：48 个应用扫描揭露的惊人真相"
date: 2026-05-14T01:00:00+08:00
draft: false
toc: true
categories:
  - 技术
  - 安全
tags:
  - Vibe Coding
  - AI安全
  - 代码审计
  - 网络安全
  - Claude
  - Cursor
image: "https://cos.jiahongw.com/rss-daily/20260514/cover.png"
description: "Reddit 用户对 48 个 Vibe Coded 应用进行安全扫描，发现 90% 存在安全漏洞。本文深度分析 AI 生成代码的安全隐患、漏洞类型分布及防护建议。"
---

## 核心观点

**Vibe Coding 正在制造一场安全危机。**

2026 年 5 月，Reddit 用户 u/Powerful-Fly-9403 发布了一份震撼开发社区的安全审计报告：他们对 48 个使用 Lovable、Bolt、Replit 等 AI 编程工具生成的应用进行扫描，发现 **90% 存在至少一个安全漏洞**，44% 存在认证绕过问题，33% 使用了危险的 PostgreSQL `SECURITY DEFINER` 函数，25% 存在 BOLA/IDOR 访问控制漏洞。

这不是危言耸听。Georgia Tech 的研究团队同期发布的 [Vibe Security Radar](https://vibe-radar-ten.vercel.app/) 数据显示，2026 年第一季度已确认 56 个与 AI 生成代码相关的 CVE 漏洞，仅 3 月份就发现了 35 个，超过 2025 年全年的总和。

当开发者沉浸在"几分钟生成一个应用"的快感中时，安全债务正在以指数级速度累积。

![安全扫描概念图](https://cos.jiahongw.com/rss-daily/20260514/img-01.png)

<!--more-->

## 深度分析：漏洞全景扫描

### 1. 认证与授权漏洞：44% 的应用门户洞开

扫描发现的最普遍问题是**认证绕过（Authentication Bypass）**。近半数被测应用的 API 路由或页面允许未登录用户直接访问核心功能。

**典型场景：**
- AI 生成的 CRUD 接口缺少身份验证中间件
- 前端路由守卫缺失，仅依赖隐藏 UI 元素控制访问
- JWT Token 验证逻辑存在缺陷，允许过期令牌继续访问

根据 [OWASP API Security Top 10](https://owasp.org/API-Security/editions/2023/en/0xa1-broken-object-level-authorization/)，**失效的对象级授权（BOLA）** 已连续多年位居 API 安全威胁榜首。AI 工具在生成代码时，默认使用 `WHERE id = $input` 的查询模式，却忽略了添加 `AND user_id = current_user` 的权限过滤条件。

### 2. PostgreSQL SECURITY DEFINER：33% 的隐形炸弹

这是最隐蔽也最危险的漏洞类型。当 AI 工具生成 PostgreSQL 函数时，为了"解决权限错误"，会自动添加 `SECURITY DEFINER` 属性——这会让函数以创建者的超级用户权限执行，**完全绕过行级安全策略（RLS）**。

```sql
-- AI 生成的危险代码示例
CREATE FUNCTION get_user_data(user_id UUID)
RETURNS TABLE (...) AS $$
BEGIN
  RETURN QUERY SELECT * FROM users WHERE id = user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;  -- 危险！
```

攻击者只需调用这个函数，就能读取任意用户的数据，RLS 形同虚设。Reddit 用户的扫描显示，**三分之一的 vibe coded 应用在生产环境中存在此问题**。

![认证漏洞示意图](https://cos.jiahongw.com/rss-daily/20260514/img-02.png)

### 3. BOLA/IDOR：25% 的经典访问控制缺陷

**不安全的直接对象引用（IDOR）** 在 AI 生成代码中尤为常见。攻击者只需修改 URL 中的 ID 参数，就能访问其他用户的数据：

```
GET /api/orders/123    → 正常访问
GET /api/orders/124    → 成功访问他人订单！
```

AI 工具生成的代码通常缺少用户所有权验证。这不是技术难题，而是**安全意识的缺失**——AI 模型在训练数据中没有足够重视访问控制模式。

### 4. 暴露的密钥与凭证

Escape.tech 对 5,600 个公开部署的 vibe coded 应用进行扫描，发现 **400 多个暴露的密钥和凭证**，包括：
- 数据库连接字符串
- 第三方 API 密钥
- JWT 签名密钥
- 云服务访问凭证

这些密钥通常硬编码在客户端 JavaScript 中，或存储在公开的 GitHub 仓库里。

## CVE 时间线：问题正在加速恶化

根据 [Repello.ai 的 CVE 追踪](https://repello.ai/blog/vibe-coding-cve-list-2026)，2025-2026 年间已确认多个与 AI 编程工具相关的严重漏洞：

| CVE 编号 | 严重程度 | 影响工具 | 漏洞描述 |
|---------|---------|---------|---------|
| CVE-2025-52882 | CVSS 8.8 | Claude Code IDE | WebSocket 未授权连接，攻击者可读取本地文件 |
| CVE-2025-59536 | CVSS 8.8 | Claude Code | 信任对话框前执行恶意代码 |
| CVE-2026-26268 | CVSS 9.9 | Cursor | 沙箱逃逸，通过 .git 配置实现 RCE |
| CVE-2026-30615 | CVSS 8.0 | Windsurf | 零点击提示注入远程命令执行 |

**关键发现：** 这些漏洞共享同一个架构缺陷——**特权代理运行时处理对手可控内容，缺乏输入隔离**。

Georgia Tech 的 Hanqing Zhao 指出："数百万开发者使用相同的模型，意味着相同的 bug 会出现在不同项目中。找到一个模式，就能扫描数千个仓库。"

## 为什么 AI 生成代码更容易产生漏洞？

### 1. 训练数据的偏差

LLM 的训练数据主要来自公开代码库，而**安全代码往往比不安全代码更少见**。模型学会了"让代码跑起来"，但没有学会"让代码安全地跑起来"。

### 2. 上下文窗口的限制

AI 工具在生成代码时缺乏对整个应用架构的完整理解。它看不到认证流程、权限模型、数据流——只能基于局部上下文生成"看似正确"的代码片段。

### 3. 开发者的信任偏差

Andrej Karpathy 定义的 vibe coding 核心理念是"完全沉浸在 vibe 中，忘记代码的存在"。这种**不审查代码**的工作方式，与代码审计的最佳实践完全背道而驰。

### 4. 快速迭代的副作用

AI 让"几天内从想法到 MVP"成为可能。但当应用快速获得用户、代码库不断增长时，**没有人完全理解 AI 生成了什么，是否遵循了安全最佳实践**。

## 可实践的安全建议

| 风险等级 | 建议措施 | 优先级 |
|---------|---------|--------|
| 🔴 紧急 | 对所有 AI 生成代码运行自动化安全扫描（Snyk、Semgrep、CodeRabbit） | P0 |
| 🔴 紧急 | 处理认证、支付、个人数据的代码必须人工审查 | P0 |
| 🟡 重要 | 禁用 PostgreSQL SECURITY DEFINER，改用 SECURITY INVOKER | P1 |
| 🟡 重要 | 实施默认拒绝（Default Deny）的访问控制策略 | P1 |
| 🟢 推荐 | 为每个任务限制代理工具权限集，而非按会话授权 | P2 |
| 🟢 推荐 | 从代理上下文窗口中剥离 HTML 注释 | P2 |
| 🟢 推荐 | 定期运行 Comment and Control 测试套件 | P2 |

### 具体实施步骤

**1. 集成安全扫描到 CI/CD**

```yaml
# GitHub Actions 示例
- name: Security Scan
  uses: snyk/actions/node@master
  with:
    args: --severity-threshold=high
```

**2. 审查 PostgreSQL 函数**

```sql
-- 查找所有 SECURITY DEFINER 函数
SELECT n.nspname, p.proname 
FROM pg_proc p JOIN pg_namespace n ON p.pronamespace = n.oid 
WHERE p.prosecdef = true;
```

**3. 实施对象级授权检查**

```javascript
// 在 API 层统一验证资源所有权
async function getOrder(orderId, userId) {
  const order = await db.query(
    'SELECT * FROM orders WHERE id = $1 AND user_id = $2',
    [orderId, userId]  // 强制验证所有权
  );
  return order;
}
```

![安全防护概念图](https://cos.jiahongw.com/rss-daily/20260514/img-03.png)

## 行业响应：安全工具正在涌现

市场已经开始响应这一需求：

- **[Polydefender](https://www.polydefender.com/security)**：扫描 AI 生成应用中的暴露密钥、认证绕过等 21+ 种漏洞类型
- **[ShipSafe](https://ship-safe.co/)**：支持 Cursor、Lovable、Bolt、v0、Replit 项目的安全扫描
- **[AuditMyVibe](https://auditmyvibe.com/)**：专家代码审计服务，将 AI 原型转化为生产级应用
- **[Vibe Audit](https://github.com/ApacheWang/vibe-audit)**：开源安全扫描器，捕获 Cursor、Bolt、Lovable、Replit Agent 生成的漏洞

## 一句话总结

**Vibe coding 改变了构建速度，但没有改变安全规律。** 当 AI 生成的代码以指数级速度涌入生产环境时，安全审计不是可选项，而是生存必需。在第一个重大 AI 代码泄露事件登上头条之前，现在就建立你的安全防线。

---

## 参考链接

1. [Reddit 原帖：Scanned 48 vibe coded apps](https://www.reddit.com/r/vibecoding/comments/1tbxd93/scanned_48_vibecoded_apps_results_worse_than/)
2. [Forbes：Vibe Coding Has A Massive Security Problem](https://www.forbes.com/sites/jodiecook/2026/03/20/vibe-coding-has-a-massive-security-problem/)
3. [Georgia Tech：Bad Vibes - AI-Generated Code is Vulnerable](https://news.research.gatech.edu/2026/04/13/bad-vibes-ai-generated-code-vulnerable-researchers-warn)
4. [Repello.ai：2026 CVE List](https://repello.ai/blog/vibe-coding-cve-list-2026)
5. [Vibe Security Radar](https://vibe-radar-ten.vercel.app/)
6. [OWASP API Security Top 10](https://owasp.org/API-Security/editions/2023/en/0xa1-broken-object-level-authorization/)
7. [OWASP Gen AI Security Project](https://genai.owasp.org/)
8. [PostgreSQL Row Security Policies](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
9. [Escape.tech State of Security Report](https://escape.tech/state-of-security-of-vibe-coded-apps)
10. [GitHub: Vibe Audit Scanner](https://github.com/ApacheWang/vibe-audit)

---

*本文基于公开安全研究报告整理，数据截至 2026 年 5 月。安全威胁持续演变，建议定期更新安全策略。*
