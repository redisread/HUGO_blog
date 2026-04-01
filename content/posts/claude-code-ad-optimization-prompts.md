---
title: "30 个神级 Claude Code 广告优化 Prompts"
date: 2026-03-30T21:36:00+08:00
draft: false
tags: ["claude-code", "ai", "marketing", "prompts"]
categories: ["tech"]
description: "来自 tenten.co 的 30 个 Claude Code 广告优化神级指令，涵盖 Google Ads、Meta Ads、GA4、GSC 等多平台数据分析和优化策略"
image: "https://cos.jiahongw.com/images/2026/03/claude-code-ad-optimization-prompts-cover.png"
---

{{< img src="https://cos.jiahongw.com/images/2026/03/claude-code-ad-optimization-prompts-cover.png" title="Claude Code 广告优化" >}}

最近看到 tenten.co 分享了一篇超实用的 Claude Code 广告优化 Prompts 合集，30 个神级指令覆盖了从跨平台分析到自动化报表的完整 workflow。整理了一下分享给大家。

<!--more-->

## 为什么用 Claude Code 做广告优化？

传统广告优化依赖人工导出数据、做 Excel 透视表、写公式计算 ROAS... 效率低还容易出错。Claude Code 的优势在于：

- **直接读取数据文件**：CSV、JSON、API 响应都能处理
- **跨平台关联分析**：把 Google Ads、Meta Ads、GA4 数据打通
- **自动化生成洞察**：不只是数字，还能给出可执行的优化建议
- **批量生成内容**：广告文案、SEO 文章、报表都能一键产出

## 30 个神级 Prompts 分类速览

### 跨平台分析（4 个）

**1. 全局 ROAS 对比**
> 比较过去 30 天 Google Ads 和 Meta Ads 的 ROAS，找出哪个平台的每一块钱回报更高，并建议预算重新分配比例

**2. 归因交叉比對**
> 从 GA4 拉出所有转换事件，对比 Google Ads 和 Meta Ads 各自回报的转换数，找出归因落差最大的 campaign

**3. 全漏斗分析**
> 用 GSC 的曝光数据 + GA4 的 session 数据 + Google Ads 的转换数据，画出从搜寻曝光到最终转换的完整漏斗，找出流失最严重的环节

**4. 平台重叠**
> 分析 Google Ads 和 Meta Ads 是否在相同受众上重复花费，找出两个平台 overlap 最高的 campaign 并建议去重策略

---

### Google Ads 优化（6 个）

**5. 否定关键字**
> 分析过去 60 天所有 search term report，找出花费超过 $50 但零转换的搜寻词，产出否定关键字清单并按 campaign 分组

**6. 预算浪费**
> 找出所有 CPA 高于帐户平均值 2 倍以上的 ad group，计算如果暂停它们可以省下多少预算，以及把这些预算转移到表现最好的 ad group 预期能多带来多少转换

**7. 品质分数**
> 列出所有 Quality Score 低于 5 的关键字，分析是 landing page、ad relevance 还是 expected CTR 拖低了分数，并给出逐一修正建议

**8. 出价策略**
> 比较我帐户中使用 Target CPA、Maximize Conversions 和 Manual CPC 的 campaign 表现差异，建议哪些 campaign 应该切换出价策略

**9. 广告文案 A/B**
> 分析所有 responsive search ads 中哪些 headline 和 description 组合的 CTR 最高，根据赢家模式帮我写 5 组新的 headline + description

**10. 时段优化**
> 拉出过去 90 天按小时和星期几拆分的转换数据，找出转换成本最低的时段和最贵的时段，建议 ad schedule 调整方案

---

### Meta Ads 优化（5 个）

**11. 受众疲劳**
> 分析所有 active ad set 的 frequency，找出 frequency 超过 3 且 CTR 持续下降的 ad set，建议是否该换受众或刷新素材

**12. Lookalike 比较**
> 比较所有 Lookalike Audience 的表现（1%、2%、5%），找出最佳 seed audience 和最佳 lookalike 比例组合

**13. 素材类型分析**
> 对比过去 30 天 image ads vs video ads vs carousel ads 的 CPA 和 ROAS，告诉我应该把更多预算放在哪种素材格式

**14. Placement 优化**
> 按 placement（Feed、Stories、Reels、Audience Network）拆分所有 ad set 的绩效，找出 CPA 最低的 placement 并建议排除哪些

**15. 新 Campaign 建议**
> 根据目前表现最好的 ad set 的受众特征和素材风格，帮我规划一个新的 OUTCOME_SALES campaign，包含 3 个 ad set 和每个 ad set 各 2 个 ad 的完整设定

---

### GA4 洞察（5 个）

**16. Landing Page 诊断**
> 找出 GA4 中 bounce rate 最高的前 20 个 landing page，交叉比对这些页面在 Google Ads 的花费，算出因为 landing page 品质差而浪费的广告预算

**17. 转换路径**
> 分析 GA4 的转换路径，找出从第一次接触到转换平均经过几个 touchpoint，以及 Google Ads 和 Meta Ads 分别在路径中扮演什么角色（first-click vs last-click）

**18. 装置差异**
> 比较 desktop vs mobile vs tablet 的转换率和 session duration，如果 mobile 转换率明显低于 desktop，分析可能的原因并建议修正方向

**19. 事件漏斗**
> 追踪从 page_view → add_to_cart → begin_checkout → purchase 的漏斗，找出每一步的流失率，标记流失最严重的步骤

**20. 流量品质**
> 比较 Google Ads 和 Meta Ads 带来的流量在 GA4 中的 engagement rate、pages per session 和 average session duration，判断哪个平台带来的流量品质更高

---

### GSC / SEO + 广告协同（4 个）

**21. Quick Wins**
> 从 GSC 找出排名在 4-15 且每月曝光超过 1,000 的关键字，这些都是 SEO quick wins；同时检查这些关键字是否已经在 Google Ads 投放，如果有，计算 SEO 排上去后可以省下多少广告费

**22. 自然 vs 付费重叠**
> 列出同时出现在 GSC 自然搜寻和 Google Ads 付费搜寻的关键字，分析哪些已经自然排名前 3 却还在花广告费，建议可以停掉哪些付费关键字

**23. 内容缺口**
> 从 GSC 找出曝光高但没有对应 landing page 的搜寻意图，再从 GA4 确认这些主题的潜在转换价值，产出一份内容行事历建议

**24. CTR 优化**
> 从 GSC 找出排名前 5 但 CTR 低于该位置平均值的页面，分析 title tag 和 meta description 的问题，帮我重写 5 个高 CTR 版本

---

### 内容生成（3 个）

**25. 广告文案批量生成**
> 根据过去 30 天 Google Ads 中 CTR 前 10 名的 headline 模式，帮我批量生成 20 组新的 responsive search ad headline + description，涵盖促销、功能、社会证明三种角度

**26. Meta 文案矩阵**
> 根据 Meta Ads 中 ROAS 最高的 3 个 ad 的文案风格，帮我产出一个 3×3 文案矩阵：3 种 hook（问题、数据、故事）× 3 种 CTA（限时、免费、独家）

**27. SEO 文章**
> 根据 GSC 的 Quick Wins 关键字清单，挑出搜寻量最高的 3 个，为每个关键字写一篇 1,500 字的 SEO 文章大纲，包含 H2/H3 结构和建议的内部连结

---

### 自动化与排程（3 个）

**28. 每日健检 Prompt**
> 执行每日广告健检：(1) 检查所有 active campaign 的昨日花费是否超过日预算 120%，(2) 找出 CTR 比 7 日均值下降超过 20% 的 ad，(3) 找出 CPA 比目标高 50% 以上的 ad group，把结果整理成一份摘要传到 Slack

**29. 周报生成**
> 生成本周跨平台广告周报：包含 Google Ads 和 Meta Ads 的总花费、总转换、平均 CPA、ROAS，与上周对比的涨跌百分比，以及 top 3 表现最好和最差的 campaign，最后附上下周的 3 项优化建议

**30. 月度策略**
> 综合分析 GSC（自然搜寻趋势）+ GA4（网站行为）+ Google Ads + Meta Ads 过去 30 天的所有数据，产出一份月度策略报告：(1) 预算分配建议，(2) 应新增的关键字/受众，(3) 应暂停的低效 campaign，(4) 下个月的内容生成计划，(5) 预估 KPI 目标

---

## 使用技巧

1. **数据准备**：先把各平台的 report 导出成 CSV，放在同一个文件夹让 Claude Code 读取
2. **分阶段执行**：不要一次丢 30 个 prompts，按优先级分批处理
3. **结果验证**：AI 给的数字建议还是要人工 double-check，特别是涉及预算调整的
4. **建立模板**：把常用的 prompts 存成模板，下次直接套用

## 总结

这 30 个 prompts 基本覆盖了广告投放的全生命周期：从数据分析、问题诊断、优化执行到自动化报表。关键是把 Claude Code 当成一个**能读懂数据的智能助手**，而不是单纯的文案生成器。

原文参考：[30 God-tier Claude Code Ad Optimization Prompts](https://tenten.co/learning/30-god-tier-claude-code-ad-optimization-prompts/)
