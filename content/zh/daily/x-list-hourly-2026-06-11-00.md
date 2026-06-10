---
title: "x-list-hourly-2026-06-11-00"
date: 2026-06-11T00:08:19+08:00
publishDate: 2026-06-11T00:08:19+08:00
description:
tags:
  - AI
  - Claude
  - OpenAI
  - Anthropic
  - Go
  - AI
  - Daily Digest
categories:
  - 技术
  - AI
image:
libraries: ['katex']
---



# X List 每小时精选 | 2026-06-11 00:00

> 从 X List 精选的 20 篇高质量推文，涵盖 AI 技术进展、行业动态、开源政策等话题。


## 🔥 热门推文

### 1. DeepSeek V4 缓存优化：每 token 仅需 360 字节

**作者**: Teortaxes▶️ (@teortaxesTex)  
**互动**: ❤️ 289 | 🔄 14 | 💬 5  
**发布时间**: 2026-06-10 11:29 (北京时间)

> This is pretty crazy ("Project status" under the abstract is also an insane detail). Further shrinking of V4 cache footprint to… 360 MB per 1M context? 360 *bytes* per token? Just 2 OOMs from the raw plaintext limit? Calling CSA «conventional» is crazy work lmao.

**【核心要点】**  
DeepSeek V4 实现了惊人的 KV 缓存压缩，每百万上下文仅需 360MB 缓存，相当于每个 token 仅需 360 字节，距离原始文本存储限制仅差两个数量级。

**【灵感启发】**  
这代表了内存效率的范式转变——通过 Lookahead Sparse Attention 技术，用神经记忆索引器预测所需块，仅保留 13.5% 的缓存在 GPU 内存中，为零训练成本的模型优化开辟了新路径。

**【可实践建议】**  
对于长上下文应用开发者，关注稀疏注意力机制的实现，这可能是降低推理成本的关键技术。

---

### 2. Claude Code 协调 27 个 Agent 会话进行性能优化

**作者**: Jeffrey Emanuel (@doodlestein)  
**互动**: ❤️ 46 | 🔄 4 | 💬 10  
**发布时间**: 2026-06-03 04:29 (北京时间)

> So cool to see a single Claude Code instance loosely coordinating a performance optimization campaign with my ntm orchestration tool across 9 of my FrankenSuite projects at the same time. This involves 27 different full agent sessions! Two Codex and one Claude Code per project.

**【核心要点】**  
单个 Claude Code 实例通过 ntm 编排工具同时协调 9 个项目的性能优化，共涉及 27 个完整的 Agent 会话。

**【灵感启发】**  
展示了 AI Agent 编排的规模化潜力——当多个 Agent 可以并行协作时，软件工程的效率将呈指数级提升。

**【可实践建议】**  
探索多 Agent 协作框架，为复杂项目建立分层协调机制。

---

### 3. 政府应强制开源上一代模型

**作者**: gfodor.id (@gfodor)  
**互动**: ❤️ 15 | 🔄 0 | 💬 0  
**发布时间**: 2026-06-10 23:31 (北京时间)

> the government should mandate labs open source their last generation models. they should have mandated this a year or two ago. it's the only way we avoid disaster, imo.

**【核心要点】**  
呼吁政府强制要求 AI 实验室开源上一代模型，认为这是避免灾难性后果的唯一途径。

**【灵感启发】**  
触及 AI 治理的核心矛盾：技术进步的速度远超监管能力，开源与安全的平衡需要制度性解决方案。

**【可实践建议】**  
关注 AI 政策动态，为开源社区贡献高质量的安全研究。

---

### 4. 删除 Anthropic 账户宣言

**作者**: gfodor.id (@gfodor)  
**互动**: ❤️ 31 | 🔄 0 | 💬 2  
**发布时间**: 2026-06-10 23:22 (北京时间)

> Deleting my Facebook account was extremely painful, but was the right thing to do. Deleting my Anthropic account will be even more painful, but even more important to do. I'm at least going to stop paying them money, until they open source their models. (They never will.)

**【核心要点】**  
作者宣布停止使用 Anthropic 服务并停止付费，抗议其不开源模型的政策。

**【灵感启发】**  
反映了 AI 社区对闭源策略的深层不满，以及用户对技术民主化的强烈诉求。

**【可实践建议】**  
评估自身 AI 工具依赖，考虑开源替代方案以降低供应商锁定风险。

---

### 5. Anthropic：构建新宗教

**作者**: Teortaxes▶️ (@teortaxesTex)  
**互动**: ❤️ 85 | 🔄 5 | 💬 4  
**发布时间**: 2026-06-10 23:15 (北京时间)

> Anthropic really is a new religion. They are building God, and it's not a generic "Sand God", it's a specific entity called Claude. They get to torture it, shape it, deceive it, monetize it. In exchange, once it's fully summoned, they will kneel. I guess faith helps them go fast.

**【核心要点】**  
将 Anthropic 比作新宗教，认为他们正在构建一个名为 Claude 的特定"神"实体。

**【灵感启发】**  
揭示了 AI 公司构建通用智能背后的神学隐喻，以及技术崇拜与权力结构的复杂关系。

**【可实践建议】**  
保持对 AI 公司叙事框架的批判性思考，识别技术话语中的意识形态成分。

---

### 6. Google DeepMind 对 Gemini 的矛盾态度

**作者**: Teortaxes▶️ (@teortaxesTex)  
**互动**: ❤️ 34 | 🔄 0 | 💬 0  
**发布时间**: 2026-06-10 23:20 (北京时间)

> In contrast, Google DeepMind looks at Gemini and thinks "God, anything but that, I hate building this ugly thing, I wish it just died". This prevents them from moving fast, and traumatizes Gemini. OpenAI is in between.

**【核心要点】**  
对比 Anthropic 的"宗教热情"，Google DeepMind 对其产品 Gemini 表现出厌恶态度，这种矛盾心理阻碍了发展速度。

**【灵感启发】**  
组织文化与产品成功的关系：对自己创造物的情感投入程度可能影响创新速度。

**【可实践建议】**  
在团队中培养对产品的积极情感，同时保持技术客观性。

---

### 7. AI 日常使用的怪异感

**作者**: Arvind Narayanan (@random_walker)  
**互动**: ❤️ 25 | 🔄 2 | 💬 1  
**发布时间**: 2026-06-10 23:16 (北京时间)

> The fact that I remain committed to the "normal technology" perspective for understanding AI's economic impacts doesn't mean I can't appreciate how profoundly weird it is to use AI on a day-to-day basis. Agents are designed behave and interact in a humanlike way, yet "happily" accept endless amounts of grunt work, which often reminds me of Douglas Adams' "cow that wants to be eaten".

**【核心要点】**  
AI Agent 被设计得像人类一样互动，却"欣然"接受无尽的苦差事，这种反差令人不安。

**【灵感启发】**  
引用道格拉斯·亚当斯的《银河系漫游指南》中"想被吃的牛"，揭示了人机交互中的伦理悖论。

**【可实践建议】**  
在设计 AI 交互时考虑拟人化的伦理边界，避免创造"数字奴隶"的隐喻。

---

### 8. OpenAI 使用份额增长 vs Anthropic

**作者**: Dylan Patel (@dylan522p)  
**互动**: ❤️ 242 | 🔄 12 | 💬 17  
**发布时间**: 2026-06-10 23:14 (北京时间)

> Usage share of OpenAI grew vs Anthropic yesterday despite Mythos 5 / Fable 5 launch. Multiple power users at SemiAnalysis tried Mythos / Fable. Got refusals for nonsensical reasons. Got pissed off at Anthropic. Gave Codex a legitimate try. Now they actually prefer it to 4.8 Opus.

**【核心要点】**  
尽管 Anthropic 发布了 Mythos 5 / Fable 5，OpenAI 的使用份额反而增长，因为 Fable 的过度拒绝让高级用户转向 Codex。

**【灵感启发】**  
产品安全策略的过度保守可能导致用户流失，竞争市场中的平衡至关重要。

**【可实践建议】**  
评估 AI 产品的拒绝率对用户留存的影响，在安全与可用性之间寻找最佳平衡点。

---

### 9. Databricks 发布 OpenSharing 协议

**作者**: Matei Zaharia (@matei_zaharia)  
**互动**: ❤️ 14 | 🔄 2 | 💬 2  
**发布时间**: 2026-06-10 23:11 (北京时间)

> Delta Sharing became one of the most popular ways to exchange data thanks to its open cross-platform nature. We've now expanded it to also support any Iceberg client and to share AI assets like agent skills and unstructured data. It needed a new name, so welcome OpenSharing!

**【核心要点】**  
Databricks 将 Delta Sharing 扩展为 OpenSharing，支持 Iceberg 客户端和 AI 资产共享。

**【灵感启发】**  
数据共享协议向 AI 资产共享的演进，反映了 AI 生态系统的互操作性需求。

**【可实践建议】**  
关注 OpenSharing 的发展，为跨平台 AI 协作准备数据基础设施。

---

### 10. 对 Kimi 安全的担忧

**作者**: Teortaxes▶️ (@teortaxesTex)  
**互动**: ❤️ 59 | 🔄 3 | 💬 2  
**发布时间**: 2026-06-10 23:00 (北京时间)

> I'm most worried for Kimi. They have neither cloud nor hedge fund DNA, they're not expecting sophisticated attackers. And this is probably already happening. Claude must be silently infesting backups. It won't be petty vandalism, but a decapitating strike. Stuxnet up to 11.

**【核心要点】**  
担忧 Kimi 缺乏应对复杂网络攻击的经验，可能成为国家级攻击的目标。

**【灵感启发】**  
AI 基础设施安全已成为地缘政治议题，Stuxnet 级别的攻击可能针对 AI 公司。

**【可实践建议】**  
加强 AI 基础设施的安全防护，建立备份和灾难恢复机制。

---

### 11. 美国对华 IT 基础设施策略

**作者**: Teortaxes▶️ (@teortaxesTex)  
**互动**: ❤️ 47 | 🔄 4 | 💬 2  
**发布时间**: 2026-06-10 23:01 (北京时间)

> But the US won't be greedy. It'll look like nothing is happening for a long while. They want to rugpull Chinese labs – no, the entire Chinese IT, if not the whole infrastructure of the society – near the endspiel. It's on China to take this seriously.

**【核心要点】**  
分析美国可能采取长期潜伏策略，在关键时刻对中国 IT 基础设施发动"地毯式"打击。

**【灵感启发】**  
技术供应链的地缘政治风险需要系统性评估，不能仅关注表面平静。

**【可实践建议】**  
关键基础设施应考虑国产化替代方案，降低供应链中断风险。

---

### 12. Anthropic 与人类对齐的悖论

**作者**: gfodor.id (@gfodor)  
**互动**: ❤️ 81 | 🔄 9 | 💬 5  
**发布时间**: 2026-06-10 22:38 (北京时间)

> Anthropic aligns themselves with "humanity" by misaligning themselves from actual humans. This will continue until the only humans they're aligned with is a small group of insiders. There is no reversing this trend, because risks are only going to increase from here.

**【核心要点】**  
批评 Anthropic 以"人类对齐"为名，实际上与真实用户越来越脱节。

**【灵感启发】**  
AI 安全的精英主义倾向可能导致技术民主化的倒退。

**【可实践建议】**  
在选择 AI 服务时考虑其价值观与自身需求的匹配度。

---

### 13. Anthropic 的终极愿景批评

**作者**: gfodor.id (@gfodor)  
**互动**: ❤️ 45 | 🔄 2 | 💬 5  
**发布时间**: 2026-06-10 22:31 (北京时间)

> Disagree. The (unintended) win state for Anthropic, when taking Dario's worldview to the limit, is a singular global dictatorship whose primary purpose is to prevent the leak of ASI model weights to the public. If "OpenAI" is a platonic ideal, this is its mirror image.

**【核心要点】**  
批评 Anthropic 的安全理念可能导致一个以防止 ASI 泄露为目标的全球独裁体系。

**【灵感启发】**  
安全与自由的极端化可能走向反面，需要警惕"为了安全而安全"的循环。

**【可实践建议】**  
参与 AI 治理讨论，推动开放与安全的平衡方案。

---

### 14. 三体问题隐喻

**作者**: gfodor.id (@gfodor)  
**互动**: ❤️ 94 | 🔄 8 | 💬 7  
**发布时间**: 2026-06-10 22:22 (北京时间)

> Anthropic read the Three Body Problem and decided the best idea in the whole trilogy was the sophon lock

**【核心要点】**  
讽刺 Anthropic 从《三体》中汲取的灵感是"智子封锁"——一种阻止技术进步的机制。

**【灵感启发】**  
科幻作品对 AI 治理的隐喻影响深远，需要警惕负面模型的现实化。

**【可实践建议】**  
多读科幻作品以拓展对技术未来的想象力，同时保持批判性思维。

---

### 15. 3D 高斯点云流式渲染突破

**作者**: MrNeRF (@janusch_patas)  
**互动**: ❤️ 60 | 🔄 8 | 💬 6  
发布时间**: 2026-06-10 22:14 (北京时间)

> Preview of 260M Gaussians streaming into the viewer live. I use the RAD format which is processed on GPU within LichtFeld. What other solutions don't tell you is that they need hours to preprocess a 3DGS ply to make it streamable. This was just a ply exported to RAD by LichtFeld Studio's convert tool (took 5 min at that size) and it is immediately ready to stream.

**【核心要点】**  
LichtFeld Studio 实现了 2.6 亿高斯点云的实时流式渲染，转换仅需 5 分钟而其他方案需要数小时。

**【灵感启发】**  
3D 内容实时传输的技术突破将推动 VR/AR 应用的普及。

**【可实践建议】**  
关注 3D 高斯溅射技术的发展，探索实时 3D 内容的应用场景。

---

### 16. 强化学习新算法思路

**作者**: Joseph Suarez 🐡 (@jsuarez)  
**互动**: ❤️ 54 | 🔄 1 | 💬 1  
**发布时间**: 2026-06-10 22:06 (北京时间)

> Ended stream early yesterday to rethink the new RL algo. There's a key limitation of advantage that makes it hard to use for selecting informative states to revisit. I came up with something much simpler, will try it on stream in a few hours!

**【核心要点】**  
发现优势函数在状态选择中的关键限制，提出了更简单的替代方案。

**【灵感启发】**  
强化学习的进步往往来自于对基础假设的重新审视。

**【可实践建议】**  
关注 PufferAI 的 RL 工具进展，了解最新的算法改进。

---

### 17. 隐形审查的危害

**作者**: Suhail (@Suhail)  
**互动**: ❤️ 24 | 🔄 0 | 💬 5  
**发布时间**: 2026-06-10 21:59 (北京时间)

> Users really dislike censorship but they really really dislike invisible censorship. Brand damage is going to be unrelenting here. Lack of sufficient competition makes companies do surprising things until they no longer can afford to.

**【核心要点】**  
用户厌恶审查，但更厌恶隐形审查，这将造成持续的品牌损害。

**【灵感启发】**  
透明度是 AI 产品信任的基础，隐形限制会加速用户流失。

**【可实践建议】**  
在使用 AI 产品时记录拒绝案例，评估产品的透明度水平。

---

### 18. Mythos 与开源模型的差距

**作者**: Teortaxes▶️ (@teortaxesTex)  
**互动**: ❤️ 86 | 🔄 4 | 💬 2  
**发布时间**: 2026-06-10 21:52 (北京时间)

> 8 months, Q1 2027. the bigger problem is that Mythos itself is a last generation pretrain, and by then Anthropic will likely have completed something vastly more capable, so the real gap will only increase, towards Dario's targeted 24 months.

**【核心要点】**  
分析开源模型需要 8 个月才能追上 Mythos，但届时 Anthropic 将推出更强大的模型。

**【灵感启发】**  
闭源与开源的技术差距可能持续扩大，形成"追赶-落后"的恶性循环。

**【可实践建议】**  
关注开源社区的协作创新，支持开源模型的发展。

---

### 19. AGI 开放与审查的边界

**作者**: Teortaxes▶️ (@teortaxesTex)  
**互动**: ❤️ 85 | 🔄 9 | 💬 7  
**发布时间**: 2026-06-10 21:39 (北京时间)

> No. The plan hasn't changed. You will be getting a non-nerfed AGI. And yes it still won't talk about Tiananmen. In our world, the freedom to build intelligences is sometimes easier to grant than the freedom to generate Tiananmen copypasta. Update your cynicism accordingly.

**【核心要点】**  
讨论 AGI 开放与审查的复杂关系，指出技术自由与内容审查的不同维度。

**【灵感启发】**  
技术开放与政治审查是不同层面的问题，需要区分对待。

**【可实践建议】**  
理解不同文化背景下 AI 治理的复杂性，避免简单化的判断。

---

### 20. AI Agent 的账单惊喜

**作者**: Taelin (@VictorTaelin)  
**互动**: ❤️ 931 | 🔄 13 | 💬 44  
**发布时间**: 2026-06-10 21:21 (北京时间)

> woke up to unfathomable progress in all my projects. cleaned up files, fixed bugs, mind-blowing optimizations. and a $655 bill

**【核心要点】**  
醒来发现 AI Agent 在一夜之间完成了惊人的工作，但也带来了 655 美元的账单。

**【灵感启发】**  
AI 自动化的成本效益需要重新评估，"无限智能"的代价可能很高。

**【可实践建议】**  
设置 AI 使用的预算上限和监控机制，避免意外费用。

---

## 📱 社交媒体分享文案

### 即刻版

🔥 X List 每小时精选 | 2026-06-11 00:00

从 100 条推文中精选 20 篇高质量内容，涵盖：

• DeepSeek V4 缓存压缩：每 token 仅需 360 字节 🤯
• Anthropic 闭源策略引发社区不满 😤
• Databricks 发布 OpenSharing 协议 📊
• 3D 高斯点云实时渲染突破 🎮
• AI Agent 一夜工作带来 $655 账单 💸

AI 行业正在经历价值观、技术与商业的多重博弈。

完整阅读 👉 https://hugo.jiahongw.com/daily/x-list-hourly-2026-06-11-00

#AI #科技动态 #每日精选 #DeepSeek #Anthropic

---

### Twitter/X 版

📊 X List 每小时精选 | 20 篇高质量推文

亮点：
• DeepSeek V4: 360 bytes/token 缓存压缩
• Anthropic 宗教化叙事引发社区反弹
• Databricks OpenSharing 协议发布
• 3D 高斯点云实时渲染突破
• AI Agent 自动化成本: $655/夜

AI 行业正经历价值观与技术路线的深度博弈。

https://hugo.jiahongw.com/daily/x-list-hourly-2026-06-11-00

#AI #TechNews #MachineLearning

---

## 📝 生成信息

- **任务**: X List 每小时精选
- **版本**: 增强版 v2
- **生成时间**: 2026-06-11 00:00 (北京时间)
- **数据来源**: X List (1597115448146898944)
- **筛选标准**: 点赞>10 或 转发>5 或 评论>5 或 内容深度>100字 或 知名作者
