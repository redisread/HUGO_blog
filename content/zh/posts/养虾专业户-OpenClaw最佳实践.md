---
title: 养虾🦞专业户：OpenClaw 使用最佳实践
date: 2026-03-25
coverImage: https://cos.jiahongw.com/agent/20260325/cover.png
tags:
  - OpenClaw
  - AI
  - 教程
---

# 养虾🦞专业户：OpenClaw 使用最佳实践

![养虾专业户封面](https://cos.jiahongw.com/agent/20260325/cover.png)

> 搞懂这些，你的虾才算养活了。

---

## 引言：为什么养虾？

OpenClaw 是一个**带记忆的 AI 助手**。这不是在说"它记得你上一句话"那种记得——是真正记住你这个人、你的项目、你的偏好，跨会话、跨时间、跨设备。

🦞 Claw = 虾钳 → 养虾 = 用好 OpenClaw

跟其他 AI 助手比，OpenClaw 有三个杀手锏：

1. **持续记忆**：不是每次都从零开始，它记得上周你说了什么
2. **工具调用**：能执行命令、读写文件、调 API、发消息——是真正干活
3. **多渠道接入**：Discord、Telegram、WhatsApp、网页……一个大脑，多端接入

但你得会养。养不好，就是个大号聊天机器人。养好了，它是你的数字分身。

---

## 第一章：虾池搭建（环境配置）

![环境配置](https://cos.jiahongw.com/agent/20260325/01-env-setup.png)

养虾先养水。环境配置不对，后面全是白搭。

### 1.1 核心配置文件

OpenClaw 的工作区（默认在 `~/.openclaw/workspace/`）里有几个关键文件：

| 文件 | 作用 | 什么时候改 |
|------|------|-----------|
| `MEMORY.md` | 长期记忆 | 记住重要的事：项目、目标、API Key、偏好 |
| `SOUL.md` | 人格定义 | 调整语气、风格、边界 |
| `USER.md` | 用户画像 | 你的名字、背景、关注点 |
| `TOOLS.md` | 工具配置 | API Key、路径偏好、工具选择 |
| `HEARTBEAT.md` | 心跳任务 | 定义定期执行的任务 |

这些文件就是你虾池的水质参数。搞错了，虾就死。

### 1.2 目录结构最佳实践

```
~/.openclaw/workspace/
├── AGENTS.md              # 工作区规则（别动，系统文件）
├── MEMORY.md              # 长期记忆（重要！）
├── SOUL.md                # 人格（调性格用）
├── USER.md                # 用户画像（让 AI 认识你）
├── TOOLS.md               # 工具配置（API Key 等）
├── HEARTBEAT.md           # 心跳任务（定期检查）
├── BOOTSTRAP.md           # 初始化文件（第一次启动后删掉）
└── memory/                # 日记本
    ├── 2026-03-25.md
    ├── 2026-03-24.md
    └── ...
```

`memory/` 目录是日记本，每次会话结束 OpenClaw 会往里写东西。`MEMORY.md` 是提炼后的精华——你的项目背景、长期目标、关键配置。

### 1.3 常见坑

**❌ 坑一：在 `SOUL.md` 里写具体任务**

`SOUL.md` 定义人格，不是任务列表。如果你写"每天早上8点提醒我开会"，OpenClaw 每次对话都会看到这句话——但它不会自动执行。

正确做法：把任务写进 `HEARTBEAT.md` 或用 `cron` 设置定时任务。

**❌ 坑二：API Key 硬编码在对话里**

你跟 OpenClaw 说"我的 OpenAI Key 是 sk-xxx"，它这次记住了。但：

1. 对话历史可能被清理
2. 新会话不会自动继承
3. 安全隐患大

正确做法：写进 `TOOLS.md` 或 `~/.bashrc`：

```bash
# ~/.bashrc
export OPENAI_API_KEY="sk-xxx"
export TAVILY_API_KEY="tvly-xxx"
```

**❌ 坑三：心跳任务写太重**

`HEARTBEAT.md` 里写一堆检查，每次心跳都触发 → token 烧得飞快。

正确做法：轮询检查 + 智能判断。比如邮件检查，只在有未读时才通知，别每次都汇报"你邮箱很干净"。

---

## 第二章：养虾日常（日常工作流）

![心跳与定时任务](https://cos.jiahongw.com/agent/20260325/02-heartbeat.png)

环境搭好了，日常怎么用？

### 2.1 记忆管理

OpenClaw 有两层记忆：

**短期记忆（日记本）**：`memory/YYYY-MM-DD.md`
- 每天一个文件
- 记录当天发生的事、决策、反思
- 自动写入，你不用管

**长期记忆（精华）**：`MEMORY.md`
- 你是谁、你的目标、你的项目
- API Key、配置、技能列表
- 手动维护，定期提炼

**关键原则：写下来才算记住。**

你说"记住这个"，OpenClaw 会往 `memory/` 里写。但如果你想要长期记住，得往 `MEMORY.md` 里加。建议每隔几天手动提炼一下——把日记里的精华挪到长期记忆。

### 2.2 心跳任务（HEARTBEAT）

心跳是 OpenClaw 的主动行为。它会定期检查你定义的任务，然后决定要不要通知你。

**适合心跳的任务：**
- 检查邮件（有未读时通知）
- 检查日历（近期有会议时提醒）
- 检查 subagent 状态（长时间任务完成时通知）
- 检查天气（可能下雨时提醒带伞）

**心跳示例（`HEARTBEAT.md`）：**

```markdown
# HEARTBEAT.md

## 每轮心跳执行
1. 检查 Gmail 未读邮件（用 gog CLI）
2. 按优先级分类（紧急/重要/普通）
3. 有紧急邮件时通过 Discord 通知
4. 检查 subagent 状态
```

**智能静默原则：**

别每次心跳都汇报"一切正常"。只有在需要你注意的时候才说话。OpenClaw 会在晚上（你睡觉时）保持安静——除非真有急事。

### 2.3 定时任务（Cron）

心跳是软性的、有上下文的。Cron 是硬性的、精确时间的。

**用 Cron 的场景：**
- 每天 8:00 发送 RSS 日报
- 每周一 9:00 提醒周会
- 定时清理临时文件

**用心跳的场景：**
- 检查有没有新邮件
- 检查 subagent 任务是否完成
- 根据上下文决定是否通知

**区别总结：**

| 特性 | 心跳 | Cron |
|------|------|------|
| 执行时机 | 大约每 30 分钟 | 精确到秒 |
| 上下文 | 能看到最近对话 | 隔离执行 |
| 模型 | 主会话模型 | 可指定不同模型 |
| 适用 | 检查类、上下文相关 | 固定时间、独立任务 |

---

## 第三章：虾兵蟹将（技能与子代理）

![技能与子代理](https://cos.jiahongw.com/agent/20260325/03-skills-subagent.png)

单打独斗不如团队作战。OpenClaw 有两套"扩编"机制：Skills（技能）和 Subagent（子代理）。

### 3.1 Skills 技能系统

Skill 是预定义的能力模块。比如：

- `github` - PR/Issue 管理，CI 查询
- `notion` - Notion 数据库操作
- `youtube-transcript` - 获取视频字幕并总结
- `article-images-gen` - 为文章生成配图

**安装技能：**

```bash
clawhub install github
```

或者让 OpenClaw 自己装：

```
帮我安装 youtube-transcript 技能
```

**技能在哪：**

- 官方技能库：`/usr/lib/node_modules/openclaw/skills/`
- 用户技能：`~/.openclaw/workspace/skills/`
- ClawHub 在线市场：https://clawhub.com

**常用技能推荐：**

| 技能 | 用途 |
|------|------|
| `github` | 管理 PR、Issue、CI |
| `notion` | Notion API 操作 |
| `gog` | Gmail、Calendar、Drive 操作 |
| `youtube-transcript` | 视频总结 |
| `article-images-gen` | 文章配图 |
| `weather` | 天气查询 |

### 3.2 子代理（Subagent）

有些任务太复杂，不适合在主会话里跑：

- 跑 10 分钟的编译任务
- 需要沙盒环境的测试
- 大规模代码重构

这时候就该上子代理了。

**什么时候用子代理：**
- 任务耗时长（超过几分钟）
- 需要隔离环境（测试、实验）
- 会产生大量中间输出
- 可能出错需要重试

**子代理的特点：**
- 独立记忆（不污染主会话）
- 独立模型（可以指定不同的模型）
- 独立工作目录
- 完成后自动通知你

**使用方式：**

直接告诉 OpenClaw：

```
用子代理跑一下 npm test，把结果告诉我
```

或者更精确：

```
spawn 一个子代理，用 Claude 模型，重构 /src/utils 目录
```

### 3.3 ACP 编码代理

ACP（Agent Communication Protocol）是专门为编码任务设计的代理模式。

**特点：**
- 可以用 Codex、Claude Code、Gemini 等专业编码模型
- 支持长时间、复杂的多文件修改
- 可以绑定到 Discord 线程（`thread: true`）

**使用场景：**
- 大型重构
- PR Review
- 新功能开发
- Bug 修复

**示例：**

```
用 Claude Code 帮我重构这个项目，把所有 callback 改成 async/await
```

---

## 第四章：虾言虾语（沟通技巧）

![沟通技巧](https://cos.jiahongw.com/agent/20260325/04-communication.png)

跟 OpenClaw 沟通，有些技巧能让效率翻倍。

### 4.1 提问的艺术

**❌ 糟糕的提问：**

```
帮我写个脚本
```

OpenClaw 会问你：什么脚本？什么语言？做什么用？输出到哪？

**✅ 好的提问：**

```
用 Python 写一个监控网站 SSL 证书过期的脚本，提前 7 天发邮件到 admin@example.com，用 Discord 消息通知我
```

一次说清：
- 语言/工具
- 功能
- 输出方式
- 约束条件

### 4.2 上下文管理

**给文件而不是粘贴代码：**

❌ "这是我项目的代码：[粘贴 500 行代码]……"

✅ "项目在 `/root/projects/myapp`，帮我看下 src/main.py"

**用 MEMORY.md 存储项目背景：**

如果你经常问关于某个项目的问题，把项目背景写进 `MEMORY.md`：

```markdown
## 项目：MyApp

- **路径**：/root/projects/myapp
- **技术栈**：Python + FastAPI + PostgreSQL
- **当前阶段**：开发中，准备上线
- **关注点**：性能优化、安全性
```

之后每次对话，OpenClaw 都知道这些背景。

### 4.3 多渠道接入

OpenClaw 可以接入多个渠道：Discord、Telegram、WhatsApp、网页等。

**群聊礼仪：**

OpenClaw 在群里不是你，也不是你的秘书。它是参与者：

- 别让它每条消息都回复
- 需要它的时候 @它
- 它会判断什么值得说、什么不值得

**私信 vs 群聊：**

| 私信 | 群聊 |
|------|------|
| 更隐私，适合敏感话题 | 更开放，适合协作 |
| 上下文更干净 | 可能有噪音 |
| 可以深入讨论 | 快速问答 |

**会话隔离：**

每个渠道/群都是独立会话。你在群里说的，私信里的 OpenClaw 不知道——除非你在 `MEMORY.md` 里写了。

---

## 第五章：虾之大忌（常见错误）

养虾有坑，提前知道能省不少麻烦。

### 5.1 记忆幻觉

**症状：** OpenClaw 编造不存在的记忆，比如"你上周说要去日本"（但你从没说过）。

**原因：**
- `MEMORY.md` 信息过时或冲突
- 日记内容太多，提炼不准确

**解决：**
- 定期清理 `MEMORY.md`，删除过时信息
- 重要信息明确写，别模糊
- 发现幻觉时及时纠正，让 OpenClaw 更新记录

### 5.2 心跳过载

**症状：** 每 30 分钟收到一条消息"检查完成，一切正常"。

**原因：** `HEARTBEAT.md` 没写静默逻辑。

**解决：**

在心跳任务里加判断：

```markdown
## 心跳任务

1. 检查邮件
   - 有未读 → 通知
   - 无未读 → 静默（HEARTBEAT_OK）

2. 检查 subagent
   - 有完成 → 通知
   - 无完成 → 静默
```

OpenClaw 会根据逻辑决定是否通知你。

### 5.3 技能冲突

**症状：** 同一个命令，不同 skill 有不同行为，或者命令不生效。

**原因：** 多个 skill 定义了相同的关键词。

**解决：**
- 检查已安装技能：`clawhub list`
- 明确指定技能名称
- 删除冲突的技能

### 5.4 权限问题

**症状：** 工具调用失败，报 "permission denied" 或 "auth failed"。

**常见原因：**
- API Key 未配置或过期
- 环境变量未加载
- 服务未授权

**解决：**

```bash
# 检查环境变量
echo $OPENAI_API_KEY

# 检查 Google 服务授权
gog auth list

# 检查 GitHub CLI 授权
gh auth status
```

---

## 第六章：养虾进阶（高级技巧）

基础掌握后，可以玩点高级的。

### 6.1 多模型切换

OpenClaw 支持多个模型，可以根据任务选择：

```
/model glm-5      # 切换到 GLM-5（推理强）
/model kimi-k2.5  # 切换到 Kimi（日常用）
```

**使用场景：**
- 复杂推理、代码审查 → GLM-5
- 日常对话、快速任务 → Kimi
- 创意写作 → 不同模型有不同风格

### 6.2 工作区隔离

如果你有多个项目，可以用不同的 workspace：

```bash
# 项目 A
export OPENCLAW_WORKSPACE=/root/.openclaw/workspace-project-a

# 项目 B
export OPENCLAW_WORKSPACE=/root/.openclaw/workspace-project-b
```

每个 workspace 有独立的 `MEMORY.md`、`SOUL.md`、`TOOLS.md`。

**或者在 `AGENTS.md` 里定义项目特定规则：**

```markdown
# 项目 A 专用规则

- 所有 PR 必须经过 review
- 提交信息格式：[type] description
- 测试覆盖率要求 80%+
```

### 6.3 自定义 Skills

如果官方技能不够用，可以自己写。

**Skill 目录结构：**

```
my-skill/
├── SKILL.md        # 技能说明（必需）
├── README.md       # 详细文档
└── scripts/        # 脚本文件
    └── main.sh
```

**SKILL.md 示例：**

```markdown
# my-skill

## Description
做某事的技能。

## Usage
用户说"帮我做某事"时触发。

## Steps
1. 检查环境
2. 执行脚本
3. 返回结果
```

**发布到 ClawHub：**

```bash
clawhub publish my-skill/
```

### 6.4 与外部服务集成

**Gmail + Google Calendar：**

```bash
# 授权
gog auth login

# 检查未读邮件
gog mail list --unread

# 查看今日日程
gog calendar list --today
```

**Notion 数据库：**

```
把这个链接保存到 Notion 工具箱：https://example.com
```

OpenClaw 会自动调用 Notion API，提取链接信息并保存。

**微信公众号发布：**

```
把这篇文章发布到公众号：/path/to/article.md
```

需要先配置 `~/.baoyu-skills/.env`：

```bash
WECHAT_APP_ID=your-app-id
WECHAT_APP_SECRET=your-app-secret
```

---

## 结语：虾无止境

OpenClaw 是活的。

你的 `MEMORY.md` 会越来越厚，`SOUL.md` 会越来越贴合你的风格，技能库会越来越丰富。今天觉得最优的做法，下个月可能就过时了。

**持续迭代：**
- 每周回顾 `MEMORY.md`，删除过时信息
- 每月检查已安装技能，删除不用的
- 有新想法就加到 `HEARTBEAT.md`

**社区资源：**
- 官方文档：https://docs.openclaw.ai
- ClawHub 技能市场：https://clawhub.com
- Discord 社区：https://discord.com/invite/clawd
- GitHub：https://github.com/openclaw/openclaw

**最后一句：**

养虾没有标准答案。你的工作流、你的习惯、你的风格，决定你怎么用 OpenClaw。这篇只是起点——真正的最佳实践，是你在日常使用中摸索出来的。

去养你的虾吧。🦞