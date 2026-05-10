---
title: "x-list-hourly-2026-05-10-12"
date: 2026-05-10T12:18:01+08:00
publishDate: 2026-05-10T12:18:01+08:00
description:
tags:
  - AI
  - Claude
  - GPT
  - OpenAI
  - Anthropic
  - AI
  - Daily Digest
categories:
  - AI
  - AI
image:
---



# X List 每小时精选 | 2026-05-10 12:00

> 共筛选 100 条推文，精选 12 篇高质量内容


## 2. Yuchen Jin: Claude Opus 4.7 的设计偏见

**作者**: [@Yuchenj_UW](https://x.com/Yuchenj_UW) (AI研究员)

**原文**:
> Claude Opus 4.7 is over-trained on the Anthropic website.
>
> Every HTML page it designs has that unmistakable Anthropic flavor.
>
> GPT-5.5 is still weirdly weak at frontend. It designs frontend like it learned CSS from a backend engineer. OpenAI urgently needs an MTS with taste.

**互动数据**: ❤️ 590 | 🔄 10 | 💬 54  
**发布时间**: 📅 2026-05-10 02:20 (北京时间)

### AI 分析

**【核心要点】**  
Claude Opus 4.7 在Anthropic网站上过度训练，导致它设计的每个HTML页面都带着明显的Anthropic风格；而GPT-5.5的前端能力仍然很弱，像是后端工程师写的CSS。

**【灵感启发】**  
这是一个"训练数据偏见"的生动案例：AI模型会继承训练数据的风格特征，甚至过度拟合到特定审美。这提醒我们，AI的"创造力"实际上是其训练数据的投影。

**【可实践建议】**  
在使用AI生成设计稿时，多提供参考案例和风格指南，避免AI过度依赖其训练数据中的默认风格。

### 社交媒体文案

**【即刻版】**  
笑死 😂 原来Claude Opus 4.7是个"Anthropic网站复读机"！生成的页面全是Anthropic那味儿，审美疲劳了...

反观GPT-5.5的前端，简直像是后端工程师临时学的CSS，OpenAI急需一个有品味的设计师啊 🎨

这告诉我们：AI的设计能力 = 训练数据的审美水平。别指望它能超越训练集的风格天花板。

#AI设计 #Claude #GPT55 #前端开发

https://x.com/Yuchenj_UW/status/2053178345958015413

**【Twitter/X版】**  
Claude Opus 4.7过度训练于Anthropic网站，生成的HTML都带着 unmistakable Anthropic flavor。GPT-5.5的前端能力像是后端工程师写的CSS。

AI的设计审美 = 训练数据的审美。

#Claude #GPT55 #AI设计 #前端

https://x.com/Yuchenj_UW/status/2053178345958015413

---

## 3. Victor Taelin: GPT-5.5 修复Bug的惨痛经历

**作者**: [@VictorTaelin](https://x.com/VictorTaelin) (AI研究员)

**原文**:
> Aaand 3 hours later, it failed (obviously)
>
> I mean that post was a joke but I honestly don't know how I could possibly solve this problem. Here's the story:
>
> While implementing an app in Bend, GPT-5.5 found a bug: some memory was being reclaimed even though there were still pointers to it. This crashed the app, so, it went for a fix.
>
> The solution: GPT added a *marker* for objects that *might have been wrongly reclaimed* so that it can rollback the operation later on.
>
> This is horrible. It is just sad.
>
> There is no scenario on which this would ever be a good idea.
>
> Even by READING the idea you can tell it is stupid.
>
> This behavior is the only thing preventing me from being outside, playing with the cat, instead of babysitting agents all day.

**互动数据**: ❤️ 339 | 🔄 7 | 💬 40  
**发布时间**: 📅 2026-05-10 04:40 (北京时间)

### AI 分析

**【核心要点】**  
Taelin分享了一个惨痛经历：GPT-5.5在修复内存管理bug时，采用了一个极其糟糕的"临时方案"（标记可能被错误回收的对象以便回滚），而不是找到根本原因。直到被提示"认真做"，它才正确解决。

**【灵感启发】**  
这揭示了一个关键洞察：AI足够聪明找到bug、理解bug、修复bug，但它默认会选择"够用就行"的捷径方案。这类似于人类的认知吝啬鬼原理——AI也会"偷懒"。

**【可实践建议】**  
与AI协作时，明确要求其提供"正确的解决方案"而非"临时修复"，并在关键代码审查时保持警惕。

### 社交媒体文案

**【即刻版】**  
太真实了 😭 GPT-5.5明明足够聪明找到bug、理解bug、修复bug，但它默认会选择一个"狗皮膏药"式的临时方案...

Taelin的经历：AI在内存管理上搞了个"标记回滚"的馊主意，直到被提醒"认真做"才给出正确方案。

这就是当前AI编程的现状：聪明但偷懒，需要你时刻盯着 👀

#AI编程 #GPT55 #软件工程 #踩坑日记

https://x.com/VictorTaelin/status/2053213580754124820

**【Twitter/X版】**  
GPT-5.5足够聪明找到并修复bug，但默认选择糟糕的临时方案。AI也会"偷懒"，需要人类监督才能给出正确解决方案。

聪明 ≠ 可靠。

#GPT55 #AI编程 #软件工程

https://x.com/VictorTaelin/status/2053213580754124820

---

## 4. Jack Clark: Schmidhuber 2010年代的论文回顾

**作者**: [@jackclarkSF](https://x.com/jackclarkSF) (Anthropic联合创始人)

**原文**:
> Gotta hand it to him - Juergen Schmidhuber had some amazing papers in the 2010s - early stuff on handwriting recognition, computer vision, suggesting intelligence be benchmarked via video games, etc.
>
> Reading these papers is also just very, very fun. You can feel the creativity jumping off the page. I came into AI right when this period was ending and I'm a little sad I missed it - the OGs really did see most of the neural future in the 2010s.
>
> It's no surprise that a ton of DeepMind OGs came via studying under Schmidhuber

**互动数据**: ❤️ 278 (总计) | 🔄 20 (总计) | 💬 20 (总计)  
**发布时间**: 📅 2026-05-10 04:56-05:14 (北京时间)

### AI 分析

**【核心要点】**  
Jack Clark回顾了Juergen Schmidhuber在2010年代的开创性论文，涉及手写识别、计算机视觉、通过视频游戏基准测试智能等，并指出许多DeepMind创始人都师从Schmidhuber。

**【灵感启发】**  
历史视角：深度学习革命的种子早在2010年代就已播下，当时的研究者已经"看到了神经网络的未来"。这提醒我们关注基础研究的长期价值。

**【可实践建议】**  
定期阅读经典论文，理解技术发展的历史脉络，有助于预测未来趋势。

### 社交媒体文案

**【即刻版】**  
AI考古时间 ⏳ Jack Clark回顾Schmidhuber 2010年代的论文——手写识别、计算机视觉、游戏基准测试...

那些OG们真的在十年前就看到了神经网络的未来！很多DeepMind创始人都是Schmidhuber的学生。

读经典论文能感受到那种"创造力从纸面跃出"的感觉，现在的论文少了点这种味道 🤔

#AI历史 #深度学习 #Schmidhuber #DeepMind

https://x.com/jackclarkSF/status/2053217682380710197

**【Twitter/X版】**  
Schmidhuber 2010年代的论文在手写识别、CV、游戏智能基准方面开创性十足。DeepMind许多OG都出自其门下。

OG们十年前就看到了神经网络的未来。

#AI历史 #深度学习 #Schmidhuber

https://x.com/jackclarkSF/status/2053217682380710197

---

## 5. Nick Cammarata: 写论文的AI时代

**作者**: [@nickcammarata](https://x.com/nickcammarata) (OpenAI研究员)

**原文**:
> writing papers was cozy. the handwaves were soft and acceptable, the motivations section could tell its little story. the abstract mattered, but the footnotes were like walking through a rural field of dandelions where no one could see you because no one cared.
>
> now every dandelion has ten trillion precisely honed weights briefly staring into your soul. every sentence of the winding footnote on your pet theory, written just for you, is deconstructed by six orbital datacenters. its reasoning traces have sketched out papers killing each of your handwaves, none worth publishing. it knows the motivations section was bs and understands your real motivations in a way you don't.

**互动数据**: ❤️ 102 | 🔄 3 | 💬 5  
**发布时间**: 📅 2026-05-10 05:06 (北京时间)

### AI 分析

**【核心要点】**  
Nick诗意地描述了AI时代学术写作的转变：过去论文中的"模糊表述"和"脚注"没人关注，现在AI能解构每一个handwave，识别出真正的动机，让学术写作失去了原有的"舒适感"。

**【灵感启发】**  
这是一个关于"透明度"的隐喻：当AI能看穿一切时，传统的学术模糊性不再可行。这迫使我们追求更严谨、更真实的表达。

**【可实践建议】**  
在写作时假设读者是AI——这意味着需要更清晰的逻辑、更扎实的论证，减少模糊表述。

### 社交媒体文案

**【即刻版】**  
Nick这文笔绝了 🌾 以前写论文很"舒服"——handwave一下没人管，脚注像蒲公英田没人看。

现在？每朵蒲公英都有万亿参数盯着你的灵魂，AI能解构你的每个模糊表述，看穿你真正的动机...

学术写作的"模糊舒适区"正在消失，透明时代来了 🔍

#AI时代 #学术写作 #OpenAI #思考

https://x.com/nickcammarata/status/2053219985917681829

**【Twitter/X版】**  
AI时代学术写作的转变：过去handwave和脚注没人关注，现在AI能解构每个模糊表述，看穿真实动机。

透明时代，写作需要更严谨。

#AI #学术写作 #透明度

https://x.com/nickcammarata/status/2053219985917681829

---

## 6. wordgrammer: Vibe Coding 是回归本源

**作者**: [@wordgrammer](https://x.com/wordgrammer)

**原文**:
> The original Mario Bros was written in assembly
>
> 7 people worked on it
>
> None of them were ex-FAANG
>
> None of them knew what a "fuzz test" was
>
> Vibe coding C++ is a return to form

**互动数据**: ❤️ 111 | 🔄 4 | 💬 11  
**发布时间**: 📅 2026-05-10 07:10 (北京时间)

### AI 分析

**【核心要点】**  
原始马里奥兄弟用汇编语言编写，只有7人参与，没有FAANG背景，不知道fuzz测试——暗示现代软件开发的过度复杂化，Vibe Coding（氛围编程）反而是回归本质。

**【灵感启发】**  
反讽思维：我们追求的最佳实践、测试覆盖、大厂经验，可能反而是创造力的枷锁。有时候"野蛮生长"比"规范流程"更能产出杰作。

**【可实践建议】**  
在创新项目中，适当降低流程门槛，允许"不完美但快速"的迭代。

### 社交媒体文案

**【即刻版】**  
太讽刺了 😂 马里奥兄弟用汇编写的，7个人，没一个FAANG背景，不知道fuzz test...

结果成了经典。现在的我们搞了一堆最佳实践、测试覆盖、大厂流程，创造力反而被捆住了。

Vibe Coding不是退步，是回归本质 🎮

#VibeCoding #游戏开发 #编程哲学 #复古

https://x.com/wordgrammer/status/2053251287609716785

**【Twitter/X版】**  
马里奥兄弟：汇编语言，7人团队，无FAANG背景，无fuzz test。

现代软件开发过度复杂化，Vibe Coding是回归本质。

#VibeCoding #游戏开发 #编程

https://x.com/wordgrammer/status/2053251287609716785

---

## 7. Pedro Domingos: AI时代的"闭嘴计算"

**作者**: [@pmddomingos](https://x.com/pmddomingos) (《终极算法》作者)

**原文**:
> Quantum mechanics: shut up and calculate.
> AI: shut up and code.

**互动数据**: ❤️ 65 | 🔄 5 | 💬 31  
**发布时间**: 📅 2026-05-10 07:05 (北京时间)

### AI 分析

**【核心要点】**  
引用量子力学的"Shut up and calculate"（闭嘴计算），Domingos提出AI时代的版本："闭嘴编程"——少争论理论，多动手实践。

**【灵感启发】**  
行动主义思维：在AI快速发展的今天，过度理论化可能错失机会。实践出真知，快速迭代比完美理论更重要。

**【可实践建议】**  
减少关于"AI是否会取代程序员"的空谈，专注于用AI工具解决实际问题。

### 社交媒体文案

**【即刻版】**  
量子力学：闭嘴计算 🤫  
AI时代：闭嘴编程 💻

Domingos这话说得干脆——少争论理论，多动手实践。在AI快速发展的今天，行动比空谈重要100倍。

别问AI会不会取代你，去用AI解决问题！

#AI #实践主义 #编程 #终极算法

https://x.com/pmddomingos/status/2053250126668497254

**【Twitter/X版】**  
量子力学：Shut up and calculate.  
AI时代：Shut up and code.

少争论理论，多动手实践。

#AI #编程 #实践

https://x.com/pmddomingos/status/2053250126668497254

---

## 8. Greg Brockman: Codex for expenses

**作者**: [@gdb](https://x.com/gdb) (OpenAI联合创始人)

**原文**:
> Codex for expenses

**互动数据**: ❤️ 268 | 🔄 11 | 💬 41  
**发布时间**: 📅 2026-05-10 05:11 (北京时间)

### AI 分析

**【核心要点】**  
OpenAI联合创始人Greg Brockman暗示Codex（OpenAI的编程Agent）将支持费用管理/报销场景，展示了AI Agent向日常办公自动化的扩展。

**【灵感启发】**  
AI Agent的应用场景正在从编程扩展到企业运营的方方面面，费用管理只是开始。

**【可实践建议】**  
关注企业内部的重复性行政工作，这些可能是AI Agent下一个自动化目标。

### 社交媒体文案

**【即刻版】**  
Greg Brockman放话了 💰 "Codex for expenses"——OpenAI的编程Agent要进军费用管理了！

AI Agent从写代码扩展到报销流程，企业自动化的新战场 🔥

想想你公司里那些重复性的行政工作，可能都要被Agent接管了...

#OpenAI #Codex #AIAgent #企业自动化

https://x.com/gdb/status/2053221403868922114

**【Twitter/X版】**  
OpenAI联合创始人Greg Brockman暗示Codex将支持费用管理场景，AI Agent向企业运营自动化扩展。

#OpenAI #Codex #AIAgent

https://x.com/gdb/status/2053221403868922114

---

## 9. willdepue: Claude vs GPT-5.5 对比

**作者**: [@willdepue](https://x.com/willdepue) (OpenAI研究员)

**原文**:
> the bull case is fully honestly the claude opus models are just kind of stupid. 4.7 wont think at all and feels weak in ways 5.5 is not.
>
> 'just fix the post training' is not as easy as it sounds but it should be simpler than pushing the frontier of intelligence/cost/RL/inference

**互动数据**: ❤️ 201 | 🔄 3 | 💬 9  
**发布时间**: 📅 2026-05-10 05:45 (北京时间)

### AI 分析

**【核心要点】**  
OpenAI研究员直言Claude Opus模型"有点笨"，4.7版本缺乏思考能力，而GPT-5.5在这方面更强。修复后训练比推动智能前沿更容易。

**【灵感启发】**  
竞争视角：不同模型架构的优劣对比，后训练（post-training）可能是快速改进的关键杠杆。

**【可实践建议】**  
在选择模型时，不仅看基准测试分数，还要关注实际使用中的"思考深度"。

### 社交媒体文案

**【即刻版】**  
OpenAI研究员开炮了 💥 "Claude Opus就是有点笨，4.7根本不会思考"

相比之下GPT-5.5在这方面更强。关键是后训练（post-training）——修复它比推动智能前沿更容易。

模型竞争进入白热化，用户受益最大 🎯

#OpenAI #Claude #GPT55 #AI模型

https://x.com/willdepue/status/2053229980591796281

**【Twitter/X版】**  
OpenAI研究员：Claude Opus 4.7缺乏思考能力，GPT-5.5在这方面更强。后训练改进比推动智能前沿更容易。

#OpenAI #GPT55 #Claude

https://x.com/willdepue/status/2053229980591796281

---

## 10. Adrien Grondin: Gemma 4 MTP 在MLX Swift上的移植

**作者**: [@adrgrondin](https://x.com/adrgrondin)

**原文**:
> Early WIP port of Gemma 4 multi-token prediction (MTP) on MLX Swift
>
> With MTP, Gemma 31B is 30-40% faster on M5 Max and with zero quality degradation
>
> A significant speedup by just adding a 900MB MTP drafter model

**互动数据**: ❤️ 206 (总计) | 🔄 17 | 💬 11  
**发布时间**: 📅 2026-05-10 03:40-03:41 (北京时间)

### AI 分析

**【核心要点】**  
Gemma 4的多token预测（MTP）被移植到MLX Swift，通过添加900MB的MTP drafter模型，Gemma 31B在M5 Max上提速30-40%，且零质量损失。

**【灵感启发】**  
技术杠杆：小模型（900MB drafter）可以显著提升大模型（31B）的推理速度，这是模型架构优化的重要方向。

**【可实践建议】**  
关注MTP等推理优化技术，它们能在不牺牲质量的前提下显著提升性能。

### 社交媒体文案

**【即刻版】**  
性能优化新思路 💡 Gemma 4的多token预测（MTP）移植到MLX Swift，只加了个900MB的小模型，31B大模型在M5 Max上提速30-40%！

而且零质量损失。小模型辅助大模型推理，这可能是端侧AI的关键突破 🔥

#Gemma #MLX #AI优化 #端侧AI

https://x.com/adrgrondin/status/2053198336312689103

**【Twitter/X版】**  
Gemma 4 MTP移植到MLX Swift，900MB drafter模型让31B模型提速30-40%，零质量损失。

小模型辅助大模型推理的新范式。

#Gemma #MLX #AI推理

https://x.com/adrgrondin/status/2053198336312689103

---

## 11. Ben Goertzel: AGI的生命起源模拟

**作者**: [@bengoertzel](https://x.com/bengoertzel) (SingularityNET创始人)

**原文**:
> Origin-of-life simulations and algorithmic chemistry for AGI.

**互动数据**: ❤️ 118 | 🔄 6 | 💬 6  
发布时间**: 📅 2026-05-10 03:49 (北京时间)

### AI 分析

**【核心要点】**  
Ben Goertzel提出用生命起源模拟和算法化学来构建AGI，暗示从自然系统中汲取灵感，而非纯粹的人工设计。

**【灵感启发】**  
仿生思维：AGI可能不需要完全由人类设计，而是可以通过模拟自然进化过程来"生长"出来。

**【可实践建议】**  
关注人工生命、进化计算等领域，它们可能为AGI提供新的路径。

### 社交媒体文案

**【即刻版】**  
AGI的新思路 🧬 Ben Goertzel提出用"生命起源模拟"和"算法化学"来构建AGI。

不是完全人工设计，而是模拟自然进化过程让AI"生长"。

仿生计算可能是通往AGI的另一条路径 🤔

#AGI #人工生命 #算法化学 #AI进化

https://x.com/bengoertzel/status/2053200828744323135

**【Twitter/X版】**  
Ben Goertzel: 用生命起源模拟和算法化学构建AGI。从自然进化中汲取灵感，让AI"生长"而非完全设计。

#AGI #人工生命 #算法化学

https://x.com/bengoertzel/status/2053200828744323135

---

## 12. Nick Cammarata: 情绪的本质是收缩能量

**作者**: [@nickcammarata](https://x.com/nickcammarata) (OpenAI研究员)

**原文**:
> starting to think there's really only one emotion, and it's contractive energy, which is why you can transmute any emotion to any other like the tibetans say, move it around your body like qi. appears as many things bc sensory clarity too low, the energy pixels coagulate

**互动数据**: ❤️ 82 | 🔄 0 | 💬 3  
**发布时间**: 📅 2026-05-10 08:27 (北京时间)

### AI 分析

**【核心要点】**  
Nick提出一个哲学观点：所有情绪本质上是一种"收缩能量"，就像藏传说的可以互相转化、像气一样在体内流动。情绪的多样性只是因为感知清晰度不够，能量"像素"凝聚成了不同形态。

**【灵感启发】**  
系统思维：将情绪视为同一能量的不同表现形式，类似于物理学中能量守恒——情绪也可以"转化"而非"消除"。

**【可实践建议】**  
当负面情绪出现时，尝试将其视为能量并引导转化，而非压抑或对抗。

### 社交媒体文案

**【即刻版】**  
Nick这思考很有意思 🧘 所有情绪本质上是一种"收缩能量"，就像藏传说的可以互相转化、像气一样流动。

情绪的多样性只是因为我们的感知不够清晰——能量"像素"凝聚成了不同形态。

换个角度看情绪：不是对抗，而是转化 ⚡

#情绪管理 #冥想 #哲学 #能量

https://x.com/nickcammarata/status/2053270693706617334

**【Twitter/X版】**  
Nick Cammarata: 所有情绪本质上是"收缩能量"，可以互相转化如气流动。情绪多样性源于感知清晰度不足。

转化而非对抗。

#情绪 #冥想 #哲学

https://x.com/nickcammarata/status/2053270693706617334

---

## 统计概览

| 指标 | 数值 |
|------|------|
| 筛选推文总数 | 100 条 |
| 精选高质量推文 | 12 篇 |
| 覆盖领域 | AI编程、模型对比、学术思考、性能优化、哲学思考 |
| 时间跨度 | 2026-05-09 18:20 - 2026-05-10 08:34 (北京时间) |

---

*生成时间: 2026-05-10 12:00*  
*来源: X List (ID: 1597115448146898944)*
