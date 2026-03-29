---
title: "Claude Code Channels 深度解析：手机远程操控 AI 编码 Agent 的革命性突破"
date: 2026-03-27T01:25:00+08:00
draft: false
categories: ["技术"]
tags: ["Claude Code", "AI", "Anthropic", "MCP", "Telegram", "Discord", "远程开发"]
image: "https://cos.jiahongw.com/rss-daily/20260327/cover.png"
description: "2026年3月20日，Anthropic 发布 Claude Code Channels，让开发者可以通过 Telegram 和 Discord 直接向正在运行的 Claude Code session 发送指令。本文深度解析其技术架构、安全机制、使用场景及与 OpenClaw 的对比。"
---

2026年3月20日，Anthropic 以 research preview 形式发布了 Claude Code Channels——一项让开发者可以通过 Telegram 和 Discord 直接向正在运行的 Claude Code session 发送指令的功能。这项功能建立在 Anthropic 的 MCP（Model Context Protocol）开放标准之上，将 AI 编码助手从「坐在终端机前等回应」的同步模式，推向「随时随地用手机传讯息给 AI 同事」的非同步协作模式。

对于每天花大量时间跑长时间任务的开发者来说，Channels 消除了一个真实的工作流瓶颈：你不再需要盯着屏幕等 build 跑完。

![Claude Code Channels 封面图](https://cos.jiahongw.com/rss-daily/20260327/cover.png)

## 为什么 Channels 出现在这个时间点

OpenClaw 让使用者通过 iMessage、Telegram、WhatsApp、Discord 和 Slack 传讯息给 AI agent，agent 可以自主完成从写程式到管理社群媒体的各种任务。到 2026 年初，不少开发者甚至专门买一台 Mac Mini 24 小时跑 OpenClaw。

Anthropic 显然观察到了这个需求。VentureBeat 在报导中直接用了「OpenClaw killer」来形容 Channels。AI 内容创作者 Matthew Berman 的评价更直接：「他们把 OpenClaw 做进去了。」开发者 BentoBoi 在社群上表示，有了 Channels，不再需要为跑 AI agent 另外买硬件。

差别在于安全性。OpenClaw 给 AI agent 深度的档案系统和个人资讯存取权限，衍生出不少资安疑虑，后来催生了 NanoClaw 等强调沙箱隔离的替代方案。Channels 走的是原生整合路线：Anthropic 品牌背书、三层安全机制、企业级管控选项，开箱即用。

## Channels 的技术架构

一个 Channel 就是一台跑在你本机的 MCP 服务器。Claude Code 把它当子程序启动，透过 stdio 通讯。架构很简洁：

| 元件 | 角色 |
|------|------|
| Channel Plugin（如 Telegram） | 本地轮询 Telegram Bot API，收到讯息后推送到 Claude Code session |
| Claude Code session | 接收 channel 事件，执行任务（写程式、跑测试、改 bug），用 reply 工具回覆 |
| Bun runtime | 所有官方 channel plugin 的执行环境，以 JavaScript 高速执行著称 |
| --channels flag | 启动时指定要监听哪些 channel plugin |

重点是双向通讯。你从 Telegram 传讯息，Claude 在本地环境处理（完整的档案系统、git、所有 MCP 工具），结果回传到 Telegram。你的程式码不会离开你的电脑。

另一个关键是推送模式。传统的 MCP 工具是「Claude 决定什么时候呼叫」，Channel 则反过来：外部事件主动进入 session，不管 Claude 有没有预期。这让 CI 失败通知、监控警报等场景成为可能。

![技术架构图](https://cos.jiahongw.com/rss-daily/20260327/img-02.png)

## 三层安全机制

Anthropic 在安全设计上下了功夫，这也是跟 OpenClaw 最大的差异：

**第一层是 plugin 白名单**。research preview 期间，--channels flag 只接受 Anthropic 核准的 plugin。想载入自己开发的 channel，得用 --dangerously-load-development-channels flag，从名称就看得出 Anthropic 对此的态度。

**第二层是 pairing code 认证**。你第一次传讯息给 bot 时，bot 回覆一组一次性配对码。你在 Claude Code 终端机输入这组码，才完成绑定。之后只有你的 platform user ID 能通过，其他人的讯息会被静默丢弃。

**第三层是架构面**：channel plugin 在本地跑，主动向外轮询 API，没有任何 inbound connection。不需要暴露 URL，不需要部署服务器。

Team 和 Enterprise 帐号有额外的管控：管理员必须在 claude.ai Admin settings 里手动启用 Channels，否则个人设定多完美都没用。

![三层安全机制](https://cos.jiahongw.com/rss-daily/20260327/img-01.png)

## Channels vs Remote Control vs OpenClaw

| 比较项目 | Channels | Remote Control | OpenClaw |
|----------|----------|----------------|----------|
| 介面 | Telegram / Discord / 自订 | claude.ai Web UI / Claude 手机 App | iMessage / Telegram / WhatsApp / Discord / Slack |
| 设定难度 | 中等（需建 bot） | 低（一个指令） | 高（需自行架设 server） |
| 推送 vs 拉取 | 推送：外部事件主动进入 session | 拉取：你主动连线操控 | 推送 |
| Webhook 支援 | 有（CI、监控等） | 无 | 有限 |
| 权限提示处理 | 需回到终端机操作 | 可在 App 内操作 | 需回到终端机 |
| 安全模型 | 三层（白名单 + 配对码 + 无 inbound） | Anthropic 官方 | 开发者自负，有资安风险 |
| 企业管控 | 有（channelsEnabled 设定） | 有 | 无 |
| 硬件需求 | 无额外硬件 | 无额外硬件 | 常见做法是买 Mac Mini 24/7 跑 |

Anthropic 工程师 Thariq 在发布讨论串中说得很清楚：「我们想给你很多不同的远端操控方式。Channels 更偏向想要 hackable 方案的开发者。」

如果你想要的是从手机看 Claude Code 介面、处理权限提示，Remote Control 更适合。如果你想要 CI/CD 警报直接推送给 Claude、或让团队成员透过 Discord 查询 Claude 的工作状态，那是 Channels 的场景。

## 实际使用场景

深度实测显示，用 Telegram Channels 跑了几个场景：

- 从 iPhone 透过 Telegram 传讯息给 Claude Code，用 xcodebuild 编译并无線部署 iOS 专案到手上的 iPhone
- 让 Claude Code 用 Readwise Reader CLI 工具，整理出 83 篇带有 "NPC" 标签的文章
- 启动 Claude Code skill 转录 podcast 音讯，最后把 TXT、SRT 和 Markdown 报告传回 iPhone

结论是：能从 iPhone 操作 Mac 上才有的工具，「感觉像超能力」。

其他常见使用场景包括：

**CI/CD 整合**：GitHub Actions 或 Jenkins 的 webhook 直接推送到 Claude Code session，build 失败时 Claude 已经载入了你的 codebase，不需要重新 clone、不需要补充上下文，直接开始修。

**On-call 事件回应**：监控系统推送警报到 Claude Code，Claude 先做初步诊断，你在手机上看到结果后决定下一步。

**非开发者场景**：如果你把 Claude Code 设定成通用 AI 助手（管行事历、写行销邮件、整理试算表），Channels 让你在会议间的空档用手机传讯息给 AI，跟传讯息给真人助理一样。

![使用场景](https://cos.jiahongw.com/rss-daily/20260327/img-03.png)

## 你该知道的限制

Channels 目前有几个实务上的限制，做决策前要考虑：

**session 必须保持开启才能收到讯息**。关掉终端机，离线期间传的讯息就消失了。解法是用 tmux 或 screen 让 session 在背景持续运行。DEV Community 的一位开发者分享，他第一天就因为这个问题丢了三则讯息。

**权限提示无法远端处理**。Claude Code 需要你同意某个操作时，session 会暂停，你得回到终端机操作。如果你接受风险，可以加 --dangerously-skip-permissions flag 跳过所有权限提示，但这等于让 AI 在你的系统上自由行动。

**Telegram 不支援语音讯息，图片传送会被压缩**。如果需要原始档案，要用「以文件传送」的方式。Telegram bot 也没办法主动抓取历史讯息，只能收到 bot 运行期间的新讯息。

功能正在逐步推出中，部分帐号即使更新了 Claude Code 版本也可能还用不了。遇到这种情况只能等。

## 社群怎么看

这个功能上线才五天，开发者社群的反应相当一致。Substack 上有一篇报导提到：「Reddit 上宣布 Channels 的讨论串里，满满都是开发者说『我上周才自己做了一个一样的东西』。」

早期使用者的共识是：Anthropic 成功把开源社群最受欢迎的功能（跨平台讯息推送、持久性 session）内化到官方产品里，同时保持了大公司的可靠度和安全性。

Tenten 的实测报告指出，Channels 和 OpenClaw 其实瞄准不同用户：偶尔想从手机控制、重视安全的人适合 Channels；需要 24/7 多平台整合、iMessage 和 WhatsApp 是刚需的人，OpenClaw 的平台广度仍是优势。

Ethan Mollick（华顿商学院教授、AI 研究者）在 X 上的评论点出了更大的图景：Claude Code 团队从 OpenClaw 这类专案学习再快速实作的能力，对于 AI 驱动的开发团队来说，是核心竞争力的体现。

## 可实践建议

| 场景 | 建议方案 |
|------|----------|
| 偶尔手机控制 + 高安全性 | Claude Code Channels |
| 24/7 多平台 + iMessage/WhatsApp | OpenClaw |
| 纯远端操控 + 权限管理 | Claude Remote Control |
| CI/CD 整合 | Channels + Webhook |
| 团队协作监控 | Channels Discord Bot |

## 一句话总结

Claude Code Channels 代表着 AI 编码工具从「同步等待」到「异步协作」的范式转移——开发者终于可以把 AI 同事带在身上，随时随地继续未完成的工作。

---

**参考链接**：
- [Claude Code Channels 官方发布](https://tenten.co/learning/claude-code-channels/)
- [Anthropic MCP 协议文档](https://tenten.co/learning/what-is-mcp/)
- [OpenClaw 项目](https://github.com/OpenClaw)
- [Claude Code 完整指南](https://tenten.co/learning/claude-code-guide/)
- [VentureBeat 报道](https://venturebeat.com)
