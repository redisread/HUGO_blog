---
title: "当顶级工程师放下键盘：Karpathy 的 AI 狂热症与软件业的结构性重组"
subtitle: "OpenAI 共同創辦人 Andrej Karpathy 從 2025 年 12 月起就沒再親手寫過一行程式碼"
date: 2026-03-31 01:30:00
publishDate: 2026-03-31 01:30:00
aliases: []
description: "OpenAI 共同創辦人 Andrej Karpathy 把八成以上的編碼工作交給 AI Agent，這不只是個人的工作方式轉變，而是整個軟體工程行業正在經歷的結構性重組的最前線切片。"
image: "https://cos.jiahongw.com/rss-daily/20260331/cover.png"
draft: false
hideToc: false
enableToc: true
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
authorImageUrl:
tocLevels: ["h2", "h3", "h4"]
libraries: []
tags: [AI, 编程, Claude, Agent, 技术趋势]
series: []
categories: [技术]
---

> OpenAI 共同創辦人 Andrej Karpathy 從 2025 年 12 月起就沒再親手寫過一行程式碼。這位前 Tesla AI 總監把八成以上的編碼工作交給 AI Agent，自己則處於一種他稱之為「AI 狂熱症」的狀態。這不只是個人的工作方式轉變，而是整個軟體工程行業正在經歷的結構性重組的最前線切片。

<!--more-->

![AI 指揮家概念圖](https://cos.jiahongw.com/rss-daily/20260331/img-01.png)

## 核心觀點：從演奏者到指揮家

Karpathy 在 [No Priors Podcast](https://www.youtube.com/c/NoPriorsPodcast) 上描述的工作方式，已經跟多數人理解的「寫程式」完全不同。他在大螢幕上同時跑多個 AI 編碼代理（主要是 Claude Code 和 Codex），每個代理被分配一個大約 20 分鐘能處理完的任務。他自己則在這些平行工作流之間快速切換，負責拆解任務、下達指令、審核輸出。

這種模式類似於交響樂團的指揮——以前工程師是拉小提琴的樂手，每天在練指法、磨音準；現在系統要你放下琴，站上指揮台，去統領一整個虛擬樂團。能力需求從「寫出好程式碼」變成「拆解問題、分配任務、審核產出」。

Peter Steinberger（OpenClaw 前身 Clawdbot 的開發者）的工作模式更極端。他同時指揮十幾個代理進行高強度並行開發，每個代理就像一個不會累的初階工程師。這種工作強度甚至讓他必須暫時退出來顧及心理健康。

## 深度分析：五個維度的行業重組

### 1. 焦慮的性質變了：從缺算力到缺人類頻寬

過去十年，頂尖工程師最缺的是算力。搶顯示卡、排隊等 GPU 叢集、為 server 資源焦慮，這是常態。但現在的情況倒過來了。

如果你訂閱了高階 AI 服務（像 Claude Max 或 ChatGPT Pro），理論上你有接近無限的推理能力。真正的瓶頸變成了「吞吐量」——你一天能讓 AI 為你生成多少行程式碼、處理多少個任務。這群頂尖開發者的邏輯是：如果一天結束時你的 token 消耗量不夠大，代表你沒有充分利用 AI 的產能。

系統裡唯一的效能瓶頸，變成了那個需要睡覺、吃飯、反應速度有限的人類大腦。

### 2. Dobby 家庭管家：AI 接管物理空間的預演

![智能家居 AI 助手](https://cos.jiahongw.com/rss-daily/20260331/img-02.png)

Karpathy 把代理能力從軟體開發延伸到了日常生活。他建了一個家庭 AI 管家，取名 Dobby（對，就是哈利波特裡那個家庭小精靈）。

一個具體例子：Karpathy 隨口問了一句「Dobby 你能找到我家的 Sonos 音響嗎？」AI 沒有叫他打開手機 APP 或輸入 IP 位址。它直接在後台寫了一段 Python 腳本，掃描整個家庭區域網路，找到音響，發現它沒有密碼保護，然後自動從網路上爬取開發文件，逆向工程找出所有控制 API。等 Karpathy 反應過來的時候，音樂已經在書房響起了。

這指向一個更大的趨勢：如果 AI 可以透過底層 API 直接操控所有智慧裝置，那我們手機裡那幾百個功能單一、佔記憶體、還得學怎麼用的 APP，有多少是冗餘的？

### 3. 自動研究：人類變成 AI 進化的最大瓶頸

Karpathy 在微調大模型時遇到一個讓他衝擊很大的經驗。所謂超參數調優（hyperparameter tuning），比如權重衰減（weight decay）、Adam 優化器步長這些控制旋鈕，傳統上被認為是頂尖高手的「玄學手感」，靠的是多年經驗和直覺。

然後他把這個任務交給了 Auto Research 系統。AI 在整個參數空間裡跑了幾千幾萬次實驗，第二天早上交出了一組人類沒發現過、從人類邏輯看有些反直覺，但結果更好的參數組合。

這直接催生了一個組織設計的推演：如果科研過程本身可以被自動化，那未來的研究機構、甚至商業公司，其核心是什麼？Karpathy 提出了「終極 Program」的概念——用一份邏輯嚴密的 Markdown 文件來定義目標、評價指標、資源上限和邊界規則，然後交給成千上萬個 AI 代理去無止盡地執行、試錯、迭代。

### 4. AI 的「參差不齊」：超級天才與常識遲鈍兒童的共存

同一個能在幾秒內寫出高難度底層優化程式碼的 AI，你讓它講笑話，它還在講五年前的爛梗。這種能力的極度割裂，學術界稱為 AI 的「jagged frontier」（參差不齊的前沿）。

背後的原因跟強化學習的機制有關。強化學習需要明確、客觀、可自動驗證的回饋信號。寫程式碼有這個——跑得通就是跑得通，損失函數降了就是降了。但幽默感、文化語境、藝術神韻呢？這些沒有編譯器，沒有標準答案，強化學習的齒輪在這裡咬合不上。

這引出了一個路線問題：各大科技巨頭嘗試打造的全知全能單體超級大模型，把所有技能塞進一個大腦的做法，方向對嗎？自然界沒有在所有領域都完美的動物。獵豹跑得快但力量不足，大象力大但不敏捷。未來的 AI 生態也可能出現類似生物界的物種分化。

### 5. 傑文斯悖論：AI 不會消滅程式設計師，但會徹底改變這份工作

![軟體工程演進](https://cos.jiahongw.com/rss-daily/20260331/img-03.png)

很多人看到 AI 能寫程式碼就斷言程式設計師要失業了。但經濟學中的傑文斯悖論（Jevons Paradox）提供了另一個視角。

1865 年，英國經濟學家 William Stanley Jevons 觀察到，瓦特蒸汽機讓煤炭使用效率大幅提升後，煤炭的總消耗量不減反增。原因是效率提升讓更多產業覺得划算、開始使用煤炭，需求暴漲。

ATM 自動提款機的歷史也是同樣的模式。1970 年代 ATM 出現時，所有人都預言銀行櫃員要失業了。但根據 IMF 2015 年的分析，ATM 讓每家分行需要的櫃員從 21 人降到 13 人，降低了營運成本，結果銀行瘋狂擴張網點，城市地區分行數量增加了 43%。從 1980 年到 2010 年，銀行櫃員的總人數反而增加了。

套用在 AI 編碼上：當編寫軟體的成本逼近於零，過去那些「不值得用昂貴人力去解決」的瑣碎需求會被釋放出來。GitHub 2025 年的資料顯示，每月合併的 pull request 達到 4,300 萬個，年增 23%；Apple App Store 新增 557,000 個 APP，年增 24%。如果 AI 真的在「取代」開發者，這些數字應該下降才對。

## 可實踐建議

| 場景 | 建議行動 | 預期效果 |
|------|----------|----------|
| **個人開發者** | 開始使用 Claude Code 或 Codex 處理重複性編碼任務，把時間留給架構設計 | 提升 3-5 倍產出 |
| **團隊管理者** | 重新定義工程師 KPI，從「寫了多少行程式碼」轉向「拆解了多少複雜問題」 | 更準確衡量 AI 時代貢獻 |
| **初階工程師** | 加強系統思維和程式碼審核能力，這是 AI 目前最弱的環節 | 建立不可替代的競爭優勢 |
| **企業決策者** | 評估哪些業務流程可以用 AI Agent 自動化，從「人對人」轉向「人對 AI 對人」 | 降低 50% 以上重複性工作成本 |

## 數據背後的警訊

史丹佛數位經濟實驗室 2025 年 8 月發表的研究，分析了 ADP 數百萬筆薪資紀錄，發現 22 到 25 歲軟體開發者的就業人數自 2022 年底以來下降了將近 20%。美國勞工統計局的資料則顯示，2023 到 2025 年間程式設計師整體就業人數下降了 27.5%。

初階和 junior 開發者職缺降了約 40%，但電腦科學畢業生人數還在增加。這意味著什麼？AI 沒有消滅程式設計師這個職業，但它正在消滅「只會寫程式碼」的程式設計師。

## 一句話總結

> **未來的頂尖工程師不是寫程式最快的人，而是最能駕馭 AI Agent 交響樂團的指揮家。**

---

## 參考連結

1. **原文來源**：[Tenten - OpenAI 共同創辦人 Karpathy 不再寫程式](https://tenten.co/learning/openai-karpathy-ai-agents-take-over/)
2. **Karpathy 訪談**：[No Priors Podcast](https://www.youtube.com/c/NoPriorsPodcast)
3. **史丹佛研究**：[Stanford Digital Economy Lab - AI and Labor Markets](https://digitaleconomy.stanford.edu/news/ai-and-labor-markets-what-we-know-and-dont-know/)
4. **Claude Code 官方文件**：[Anthropic Claude Code Overview](https://docs.anthropic.com/en/docs/claude-code/overview)
5. **Karpathy Micrograd 專案**：[GitHub - karpathy/micrograd](https://github.com/karpathy/micrograd)
6. **傑文斯悖論**：[Wikipedia - Jevons Paradox](https://en.wikipedia.org/wiki/Jevons_paradox)
7. **GitHub 2025 報告**：[GitHub State of the Octoverse](https://github.blog/news-insights/octoverse/)

---

*RSS Daily 精選報導 | 2026-03-31*
