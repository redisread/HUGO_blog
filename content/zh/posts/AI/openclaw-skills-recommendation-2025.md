---
title: "OpenClaw Skills 精选推荐：9 大工作场景的最佳技能包"
date: 2025-03-30T09:44:00+08:00
draft: false
tags: ["openclaw", "ai-agent", "skills", "productivity", "automation"]
categories: ["ai"]
description: "从 3000+ 个 OpenClaw Skills 中精选出最值得安装的 9 大场景技能包，涵盖开发、DevOps、研究、创业、个人助理、营销、设计、项目管理和销售。"
image: "https://cos.jiahongw.com/openclaw-skills-2025.png"
---

OpenClaw（原名 Clawdbot）是 2025 年底发布的开源 AI Agent 框架，3 个月内累积超过 20 万 GitHub Stars。它的核心机制是 Skills——模块化的扩展能力，每个 Skill 本质上是一份包含 YAML frontmatter 的 Markdown 文件，定义 Agent 如何与外部服务、工具或 API 互动。

<!--more-->

截至 2025 年 3 月，ClawHub 上已有数千个社区 Skills。面对这个数字，多数人的问题不是「有什么可装」，而是「哪些值得装」。这篇文章依照 9 个实际工作场景，整理出每个领域最值得优先安装的 OpenClaw Skills。

---

## 场景一：程序开发 / 软件构建

开发场景在 ClawHub 的 Skill 数量最多。以下是实际开发流程里用途最高的几个：

**GitHub Skill**（`clawhub install github`）——开发者的基本配备。它通过 gh CLI 管理 Repo、Issue、PR、CI 流程，支持 JQ 过滤的进阶 API 查询。让 Agent 自动建 Issue、开 PR、追踪 CI 失败步骤，省下反复切换浏览器的时间。

**Database Query**（`clawhub install database-query`）——支持 PostgreSQL、MySQL、SQLite 的自然语言查询。用「上周新增多少用户」这种问法，它帮你转成 SQL 执行后格式化回传。建议用 read-only 连接字符串，别让 Agent 碰到生产数据库的写入权限。

**Agent Browser**（`clawhub install agent-browser`）——ClawHub 上最高评分的网页自动化 Skill。它让 Agent 操作浏览器、填表单、撷取数据。跟单纯的 web scraping 不同，它能处理需要登录或多步骤互动的网页。

**Code Review**（`/review`）——触发方式简单，让 Agent 针对特定 commit 或 PR 跑代码审查，标出潜在问题和改善建议。

---

## 场景二：运维 / DevOps

DevOps & Cloud 类别有数百个 Skill，以下是核心推荐：

**n8n Workflow Automation**——把 OpenClaw Agent 接上本地 n8n 实例，用对话方式建立、管理和触发多步骤工作流程，搭配 cron job 排程。整个流程跑在本地端，数据不外传。

**Docker / Deployment Skills**——让 Agent 管理容器部署，搭配 OpenClaw 原生支持的 Docker、Podman、Nix 安装方式，在 VPS 上建立自动化部署流程。

**Security Check**——安全稽核 Skill，在安装其他 Skill 之前先跑一轮安全扫描，检查配置文件里有没有暴露的密钥或过度的权限授予。

---

## 场景三：研究

Search & Research 类有数百个 Skill，适合深度研究场景：

**Tavily**（`clawhub install tavily`）——专为 AI Agent 设计的搜索引擎 Skill。跟一般搜索引擎不同，它回传的是结构化摘要结果而非链接列表。可以把搜索到行动之间的来回次数从 3-4 轮降到 1 轮。

**Felo Search**——ClawHub 上安装量第二高的 Skill，回传附来源引用的 AI 合成答案，多语言支持是明确的差异化优势。

**Abstract Searcher**——学术场景的 Skill，从 arXiv、Semantic Scholar、CrossRef 搜索论文摘要并自动补进 .bib 文件。适合需要定期追踪学术文献的研究者。

---

## 场景四：创业者 / 商业运营

**GOG — Google Workspace CLI**（`clawhub install gog`）——最受欢迎的开发者 Skill 之一。它把 Gmail、Calendar、Drive、Contacts、Sheets、Docs 六大 Google 服务统一成一个命令行界面。让 Agent 帮你「检查本周行事历冲突，草拟改期信件」这种跨服务串接变成一句指令。

**Daily Briefing**（`/briefing`）——彙整未读讯息、行事历、优先事项和天气预报成一份晨间简报。多数用户排在早上 7 点透过 Telegram 接收，省下大约 15 分钟手动巡视各 App 的时间。

**Expense Tracker**（`/expense`）——用自然语言记账（「/expense $12.50 午餐寿司」），自动分类、月度汇总和预算追踪。Agent 的持久记忆让它随时间学习你的消费分类。

**Felo SuperAgent**——多工具创意工作台，包含实时 SSE 串流、LiveDoc 画布、6 种内置工具（图片生成、深度研究报告、文件建立、PPT 生成、HTML 页面、X/Twitter 搜索）和 3 种专门模式。对一人公司或小团队创业者来说，这等于用一个 Skill 取代了 3-4 个独立工具。

---

## 场景五：个人助理

**Capability Evolver**（`clawhub install capability-evolver`）——ClawHub 下载量第一名。它让 AI Agent 在运作过程中自动演化自己的能力，概念接近自我优化。适合需要长时间运行 Agent 的场景。

**Self-Improving Agent**——ClawHub 上社群评分最高的 Skill，它让 Agent 从互动中学习并持续优化回应质量。

**Summarize**（`clawhub install summarize`）——内容摘要 Skill。对每天要消化大量文件、邮件、会议记录的人来说，让 Agent 自动产出重点摘要可以节省大量阅读时间。

**Home Assistant 整合**——让 Agent 连接本地 Home Assistant，用自然语言控制智能家居设备，整个流程在本地端执行，不经云端。

---

## 场景六：营销

Marketing & Sales 类有上百个 Skill：

**SEO Research**——自动化关键词研究、SERP 分析和竞品内容监测。Agency 使用案例是用它取代每周 3-4 小时的手动 SEO 监测，改成每周一早上的 WhatsApp 简报。

**Social Scheduler**——处理社群内容排程和规划，串接主流社群平台。

**Campaign Orchestrator**——多通路跟进行销 Skill，可以编排跨 Email、社群、即时通讯的营销序列。

**Citedy SEO Agent**——把 Agent 连接到 Citedy 的 SEO 内容平台，适合需要把 AI Agent 嵌入既有 SEO 工具链的营销团队。

---

## 场景七：设计

Image & Video Generation 类有上百个 Skill：

**Felo Slides**（`clawhub install felo-slides`）——让 Agent 用描述生成 PPTX 简报，每个元素可独立编辑（不是把每页做成扁平图片）。回传 PPTX 下载链接和 LiveDoc 编辑网址。适合快速产出会议简报、提案 Deck 和培训材料。

**PixVerse AI**——支持从文字描述生成图片和视频。对需要快速产出社群素材的设计和营销团队有帮助。

**ElevenLabs Agent**（`clawhub install elevenlabs-agent`）——提供文字转语音功能，让 Agent 朗读回复、生成音频内容或配音。

---

## 场景八：项目管理

Productivity & Tasks 类有数百个 Skill：

**Todoist 整合**——让 Agent 管理任务、待办事项和提醒。

**Trello 整合**——透过 Trello REST API 管理看板、清单和卡片，适合习惯 Kanban 式项目管理的团队。

**Agent Team Orchestration**——多 Agent 团队协调 Skill，定义角色、任务生命周期、交接协议和审查工作流程。对需要多个 Agent 分工合作的复杂项目特别有用。

**Standup Report**（`/standup`）——自动汇总团队成员的工作进度、阻碍事项和今日计划，产出每日站会报告。

---

## 场景九：业务开发 / 销售

**Apollo 整合**（`clawhub install apollo`）——串接 Apollo.io REST API，支持人物/组织数据富集、搜索和清单管理。对做 outbound 开发的业务团队来说，这让数据收集和初步筛选自动化。

**Business Development Skill**——覆盖合作伙伴外展、市场研究和竞品分析。

**Alibaba Supplier Outreach**——找到阿里巴巴供应商、发送优化过的外展讯息、追踪回复。对做跨境电商或供应链开发的团队有直接价值。

**CRM 整合**（HubSpot、Pipedrive、Salesforce）——可以透过 Maton 或 Composio 这类中间层平台串接，让 Agent 在不需要为每个 CRM 写客制化整合的情况下管理客户数据。

---

## 安装建议

安装任何 Skill 之前，建议遵循「100/3 规则」：下载量超过 100、上架超过 3 个月的 Skill 相对安全。另外注意：

1. 到 ClawHub 页面确认安全扫描结果显示「Benign」
2. 看发布者的 GitHub 账号是否有其他公开项目和 commit 纪录
3. 检查 Skill 请求的权限是否跟功能相符
4. Skill 名称跟知名 Skill 只差一个字母的（例如 clawhubb vs clawhub），直接跳过

---

## 总结

OpenClaw 的 Skills 生态正在快速成长。这 9 大场景的推荐覆盖了从开发到销售的全链路需求。建议从自己最常用的场景开始，逐步扩展 Agent 的能力边界。

如果你已经在使用 Claude Code 或 Cursor，ClawHub 上的 Skills 可以作为参考架构，部分 Skill 依赖 OpenClaw 的 Gateway 和 Session 机制，跨平台移植需要调整。

---

*参考来源：[ClawHub 精选 Claw Skills 推荐](https://tenten.co/learning/clawhub-skills-pick/)*
