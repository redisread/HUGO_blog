# AX 实践指南：如何为 Agent 设计信息格式

> Agent 的上下文窗口就是它的"屏幕空间"。每个 token 都要"挣得"它的位置。

## 一、AX 的核心原则

### 1.1 信息 + 行动（Information + Action）

**每个信息都必须包含下一步行动**

**反模式**：
```json
{
  "id": "msg_123",
  "content": "这是一条消息..."
}
```
Agent 看到后需要自己去查这是什么，做什么。

**最佳实践**：
```json
{
  "id": "msg_123",
  "snippet": "前 200 字摘要...",
  "relevance_score": 0.95,
  "action_url": "/messages/123",
  "next_actions": ["read_full", "reply", "mark_done"]
}
```
Agent 看到后知道：这是什么、有多相关、可以做什么。

### 1.2 上下文预算（Context Budget）

**每个 token 都要"挣得"它的位置**

**设计启示**：
- 人类的注意力预算 → Agent 的上下文预算
- 为注意力设计 → 为预算设计
- 舒适的 UX → 舒适的 AX

**实践建议**：
- 优先返回高相关性信息
- 使用分层返回（L1 摘要 → L2 扩展 → L3 完整）
- 提供"了解更多"的行动，而非一次性 dump

### 1.3 结构化输出（Structured Output）

**Agent 需要结构化数据，而非自由文本**

**反模式**：
```
这篇文章讲的是 AI Agent 自主调试，内容包括运行时验证、元认知层、红队 Agent 等技术...
```

**最佳实践**：
```json
{
  "title": "AI Agent 自主调试",
  "topics": ["运行时验证", "元认知层", "红队 Agent"],
  "key_insights": [
    "AI Agent 正在从被动响应进化为主动诊断",
    "元认知层是最有价值的投资"
  ],
  "relevance_score": 0.92
}
```

### 1.4 明确下一步（Clear Next Steps）

**告诉 Agent 可以做什么**

**反模式**：
```json
{
  "results": [...]
}
```

**最佳实践**：
```json
{
  "results": [...],
  "next_actions": {
    "read_more": "GET /articles/{id}",
    "filter": "POST /search/filter",
    "save": "POST /bookmarks"
  }
}
```

## 二、信息格式设计

### 2.1 搜索结果格式

**为 Agent 设计的搜索结果**：
```json
{
  "query": "如何提高代码性能",
  "total_results": 42,
  "results": [
    {
      "id": "article_123",
      "title": "性能优化的三个维度",
      "snippet": "性能优化可以从三个维度入手：算法复杂度、数据结构、系统架构...",
      "relevance_score": 0.95,
      "source": "技术博客",
      "published_at": "2026-06-15",
      "actions": {
        "read_full": "/articles/article_123",
        "get_summary": "/articles/article_123/summary",
        "get_related": "/articles/article_123/related"
      }
    }
  ],
  "filters": {
    "by_date": "/search?query=如何提高代码性能&sort=date",
    "by_relevance": "/search?query=如何提高代码性能&sort=relevance"
  }
}
```

**设计要点**：
1. **snippet**：围绕关键词构建，而非文章开头
2. **relevance_score**：帮助 Agent 判断优先级
3. **actions**：明确的下一步行动
4. **filters**：提供筛选选项

### 2.2 任务信息格式

**为 Agent 设计的任务信息**：
```json
{
  "task_id": "task_456",
  "title": "写一篇关于 AI Agent 的文章",
  "description": "深入分析 AI Agent 的核心技术和应用场景",
  "requirements": {
    "word_count": "2000-3000",
    "language": "中文",
    "tone": "专业但易懂",
    "audience": "技术开发者"
  },
  "context": {
    "related_articles": [
      {
        "id": "article_123",
        "title": "AI Agent 自主调试",
        "snippet": "前 200 字摘要...",
        "relevance": 0.88
      }
    ],
    "key_topics": ["AI Agent", "自主调试", "元认知层"]
  },
  "actions": {
    "start_writing": "/tasks/task_456/start",
    "get_outline": "/tasks/task_456/outline",
    "submit_draft": "/tasks/task_456/submit"
  },
  "constraints": {
    "deadline": "2026-07-05",
    "review_required": true,
    "max_iterations": 3
  }
}
```

**设计要点**：
1. **requirements**：明确任务要求
2. **context**：提供相关背景信息
3. **actions**：明确的执行步骤
4. **constraints**：约束条件

### 2.3 反馈信息格式

**为 Agent 设计的反馈信息**：
```json
{
  "feedback_id": "feedback_789",
  "target": "article_draft_123",
  "status": "approved",
  "reviewer": "Victor",
  "comments": [
    {
      "type": "positive",
      "text": "结构清晰，论证有力",
      "location": "全文"
    },
    {
      "type": "suggestion",
      "text": "第三章可以增加更多案例",
      "location": "第三章",
      "priority": "medium"
    }
  ],
  "metrics": {
    "readability_score": 85,
    "originality_score": 92,
    "ai_tone_score": 15
  },
  "next_actions": {
    "revise": "/articles/draft_123/revise",
    "publish": "/articles/draft_123/publish",
    "get_detailed_feedback": "/articles/draft_123/feedback"
  }
}
```

**设计要点**：
1. **status**：明确状态
2. **comments**：结构化反馈
3. **metrics**：量化指标
4. **next_actions**：明确的下一步

## 三、行动设计

### 3.1 行动类型

**1. 读取类行动**
```json
{
  "action": "read_full",
  "url": "/articles/123",
  "method": "GET",
  "expected_output": "full_article"
}
```

**2. 执行类行动**
```json
{
  "action": "submit_draft",
  "url": "/tasks/456/submit",
  "method": "POST",
  "payload": {
    "content": "文章内容...",
    "metadata": {...}
  },
  "expected_output": "submission_confirmation"
}
```

**3. 查询类行动**
```json
{
  "action": "get_related",
  "url": "/articles/123/related",
  "method": "GET",
  "parameters": {
    "limit": 5,
    "min_relevance": 0.7
  },
  "expected_output": "related_articles"
}
```

**4. 过滤类行动**
```json
{
  "action": "filter_results",
  "url": "/search/filter",
  "method": "POST",
  "payload": {
    "filters": {
      "date_range": "last_week",
      "min_relevance": 0.8
    }
  },
  "expected_output": "filtered_results"
}
```

### 3.2 行动设计原则

**1. 明确性**
- 行动名称要清晰（`read_full` 而非 `click`）
- 预期输出要明确（`full_article` 而非 `response`）

**2. 可操作性**
- 提供完整的 URL 和方法
- 提供必要的参数和 payload

**3. 可组合性**
- 行动可以组合（先 `read_full`，再 `get_related`）
- 提供 action chain

**4. 可逆性**
- 提供撤销行动（`undo`）
- 提供回滚机制

## 四、实际案例

### 案例 1：内容工厂的选题信息

**传统格式**：
```
选题 1：AI Agent 自主调试
选题 2：从 RAG 到 LLM Wiki
...
```

**AX 格式**：
```json
{
  "date": "2026-07-02",
  "topics": [
    {
      "id": "topic_001",
      "title": "AI Agent 自主调试",
      "source": "RSS - Latent.Space",
      "value_score": 0.95,
      "snippet": "AI Agent 正从执行工具进化为自主调试系统...",
      "suggested_angle": "实操经验：如何构建具备自我诊断能力的 Agent 系统",
      "references": [
        {
          "url": "https://latent.space/agent-debugging",
          "title": "AI Agent 自主调试研究",
          "relevance": 0.92
        }
      ],
      "actions": {
        "select": "/topics/topic_001/select",
        "read_source": "/topics/topic_001/source",
        "get_similar": "/topics/topic_001/similar"
      }
    }
  ],
  "filters": {
    "by_value": "/topics?sort=value",
    "by_date": "/topics?sort=date"
  }
}
```

**优势**：
- Agent 知道每个选题的价值
- Agent 知道可以做什么
- Agent 可以自主筛选和推荐

### 案例 2：代码审查的反馈信息

**传统格式**：
```
代码审查结果：
- 第 23 行：变量命名不清晰
- 第 45 行：缺少错误处理
- 整体评价：需要修改
```

**AX 格式**：
```json
{
  "review_id": "review_123",
  "pr_id": "pr_456",
  "status": "changes_requested",
  "findings": [
    {
      "id": "finding_001",
      "severity": "high",
      "line": 23,
      "file": "src/main.js",
      "message": "变量命名不清晰",
      "suggestion": "将 `data` 改为 `userProfile`",
      "action": "fix",
      "auto_fixable": true
    },
    {
      "id": "finding_002",
      "severity": "medium",
      "line": 45,
      "file": "src/main.js",
      "message": "缺少错误处理",
      "suggestion": "添加 try-catch 块",
      "action": "fix",
      "auto_fixable": false
    }
  ],
  "summary": {
    "total_findings": 2,
    "high_severity": 1,
    "medium_severity": 1,
    "auto_fixable": 1
  },
  "actions": {
    "auto_fix": "/pr/456/auto-fix",
    "view_details": "/pr/456/review",
    "request_clarification": "/pr/456/ask"
  }
}
```

**优势**：
- Agent 知道问题的严重程度
- Agent 知道哪些可以自动修复
- Agent 知道可以做什么

### 案例 3：知识管理的推荐信息

**传统格式**：
```
推荐笔记：
- 笔记 123：与当前笔记相关
- 笔记 456：可能有帮助
```

**AX 格式**：
```json
{
  "recommendation_id": "rec_789",
  "target_note": "note_012",
  "recommendations": [
    {
      "id": "note_123",
      "title": "AI Agent 架构设计",
      "relation_type": "related_concept",
      "relevance_score": 0.92,
      "snippet": "AI Agent 的核心架构包括感知、推理、执行三个模块...",
      "reason": "与当前笔记讨论的'自主调试'高度相关",
      "actions": {
        "read": "/notes/123",
        "link": "/notes/012/link/123",
        "compare": "/notes/compare/012/123"
      }
    }
  ],
  "insights": [
    {
      "type": "knowledge_gap",
      "message": "你还没有关于'元认知层'的笔记",
      "suggested_action": "create_note",
      "template": "/templates/metacognition"
    }
  ],
  "actions": {
    "apply_all_links": "/notes/012/auto-link",
    "get_more": "/notes/012/more-recommendations"
  }
}
```

**优势**：
- Agent 知道推荐的理由
- Agent 知道可以做什么
- Agent 可以发现知识缺口

## 五、最佳实践

### 5.1 分层返回策略

**L1：摘要层**（默认）
```json
{
  "id": "article_123",
  "title": "性能优化指南",
  "snippet": "前 200 字...",
  "relevance": 0.95,
  "action": "read_more"
}
```

**L2：扩展层**（按需）
```json
{
  "id": "article_123",
  "title": "性能优化指南",
  "summary": "500 字摘要...",
  "key_points": ["要点 1", "要点 2"],
  "actions": ["read_full", "get_related"]
}
```

**L3：完整层**（深度分析）
```json
{
  "id": "article_123",
  "title": "性能优化指南",
  "full_content": "完整内容...",
  "metadata": {...},
  "actions": [...]
}
```

**优势**：
- 节省上下文预算
- 按需加载详细信息
- 提高 Agent 效率

### 5.2 上下文标注

**标注信息来源**：
```json
{
  "content": "...",
  "source": {
    "type": "rss",
    "url": "https://example.com/article",
    "published_at": "2026-07-01"
  },
  "confidence": 0.95
}
```

**标注不确定性**：
```json
{
  "content": "...",
  "uncertainty": {
    "type": "incomplete_data",
    "missing": ["第 3 章内容"],
    "suggestion": "read_full_article"
  }
}
```

**优势**：
- Agent 知道信息的可靠性
- Agent 可以做出更好的决策
- 减少错误判断

### 5.3 行动优先级

**按优先级排序行动**：
```json
{
  "actions": {
    "primary": {
      "action": "read_full",
      "url": "/articles/123"
    },
    "secondary": [
      {
        "action": "get_related",
        "url": "/articles/123/related"
      },
      {
        "action": "save",
        "url": "/bookmarks/add/123"
      }
    ]
  }
}
```

**优势**：
- Agent 知道最重要的行动
- 减少决策负担
- 提高效率

### 5.4 错误处理

**提供清晰的错误信息**：
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "文章不存在",
    "suggestions": [
      {
        "action": "search_similar",
        "url": "/search?q=性能优化"
      },
      {
        "action": "browse_category",
        "url": "/categories/performance"
      }
    ]
  }
}
```

**优势**：
- Agent 知道发生了什么
- Agent 知道可以做什么
- 减少失败率

## 六、给开发者的建议

### 建议 1：从 Agent 的视角设计

**不要问**："我想给 Agent 什么信息？"
**要问**："Agent 需要什么信息才能完成任务？"

**实践**：
- 模拟 Agent 的上下文窗口
- 考虑 Agent 的 token 预算
- 测试 Agent 的理解能力

### 建议 2：提供足够的上下文

**不要**：给 Agent 一个 ID，让它自己去查
**要**：给 Agent 完整的上下文，让它直接行动

**实践**：
- 包含 snippet 而非只有 title
- 包含 relevance score 而非只有 results
- 包含 next actions 而非只有 data

### 建议 3：保持结构化

**不要**：给 Agent 自由文本
**要**：给 Agent 结构化数据

**实践**：
- 使用 JSON 格式
- 定义清晰的 schema
- 提供类型信息

### 建议 4：测试和迭代

**不要**：假设 Agent 能理解
**要**：测试 Agent 的理解能力

**实践**：
- 让 Agent 解释它看到的信息
- 让 Agent 描述它会做什么
- 根据反馈调整格式

### 建议 5：保持简洁

**不要**：dump 所有信息
**要**：提供必要的信息

**实践**：
- 使用分层返回
- 优先高相关性信息
- 提供"了解更多"的行动

## 七、结语：AX 是新的 UX

在 AI 时代，我们不仅要为人类设计 UX，还要为 Agent 设计 AX。

**AX 的核心**：
- 信息 + 行动
- 上下文预算
- 结构化输出
- 明确下一步

**AX 的目标**：
- 让 Agent 高效地"消费"信息
- 让 Agent 准确地理解意图
- 让 Agent 正确地执行任务

**AX 的未来**：
- AX 将成为产品设计的重要组成部分
- AX 设计师将成为新的职业
- AX 将重新定义人机协作

AX 不是 UX 的替代品，而是 UX 的延伸。在 AI 时代，我们需要同时考虑人类用户和 Agent 用户的需求，为两者都提供优秀的体验。

---

**参考资料**：
- "A Comfortable AX for Agent Search" - @zty0826
- 个人 AI 产品开发经验
- 行业最佳实践

---

*本文约 3000 字，深入分析了 AX（Agent UX）的实践指南，包括四个核心原则、三种信息格式、四种行动类型、三个实际案例、四个最佳实践和五个建议。核心观点：AX 是新的 UX，我们需要为 Agent 设计信息格式，让 Agent 高效地"消费"和"生产"信息。*
