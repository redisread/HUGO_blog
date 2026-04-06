# CLAUDE.md

## Shortcodes 使用

zzo 主题提供了丰富的 Shortcodes，用于增强文章表现力。

### 盒子（Box）

支持 Markdown 语法的盒子：

```markdown
{{< boxmd >}}
This is **boxmd** shortcode，支持 **粗体** 等 Markdown 语法
{{< /boxmd >}}
```

简单盒子（纯文本）：

```markdown
{{< box >}}
This is box shortcode
{{< /box >}}
```

### 选项卡（Tabs）

代码选项卡（codes）：

```markdown
{{< codes java javascript >}}
  {{< code >}}

  ```java
  System.out.println("Hello World!");
  ```

  {{< /code >}}

  {{< code >}}

  ```javascript
  console.log("Hello World!");
  ```

  {{< /code >}}
{{< /codes >}}
```

常规内容选项卡（tabs）：

```markdown
{{< tabs Windows MacOS Ubuntu >}}
  {{< tab >}}

### Windows section
Windows 相关内容

  {{< /tab >}}
  {{< tab >}}

### MacOS section
MacOS 相关内容

  {{< /tab >}}
  {{< tab >}}

### Ubuntu section
Ubuntu 相关内容

  {{< /tab >}}
{{< /tabs >}}
```

**注意**：每个 tab 的内容必须不同，因为选项卡根据内容生成唯一 ID 哈希值。

### 展开栏（Expand）

可折叠的内容区域：

```markdown
{{< expand "点击展开" >}}

### 标题

折叠的内容

{{< /expand >}}
```

### 彩色文本框（Alert）

```markdown
{{< alert theme="warning" >}}
**警告** 内容
{{< /alert >}}

{{< alert theme="info" >}}
**信息** 内容
{{< /alert >}}

{{< alert theme="success" >}}
**成功** 内容
{{< /alert >}}

{{< alert theme="danger" >}}
**危险** 内容
{{< /alert >}}
```

### 彩色注意框（Notice）

```markdown
{{< notice success >}}
success text
{{< /notice >}}

{{< notice info >}}
info text
{{< /notice >}}

{{< notice warning >}}
warning text
{{< /notice >}}

{{< notice error >}}
error text
{{< /notice >}}
```

### 图片（Image）

```markdown
{{< img src="https://example.com/image.jpg" 
       title="图片标题" 
       caption="图片描述" 
       alt="alt 文本" 
       width="700px" 
       position="center" >}}
```

显示 front matter 封面图：

```markdown
{{< featuredImage >}}
```

### 按钮（Button）

```markdown
<!-- 简单按钮 -->
{{< button href="https://hugo.jiahongw.com" >}}访问博客{{< /button >}}

<!-- 设置宽高 -->
{{< button href="https://hugo.jiahongw.com" width="100px" height="36px" >}}访问博客{{< /button >}}

<!-- 设置颜色主题 -->
{{< button href="https://hugo.jiahongw.com" width="100px" height="36px" color="primary" >}}访问博客{{< /button >}}
```

### 嵌入内容

嵌入 iframe：

```markdown
{{< iframe src="https://example.com/embed" >}}
```

### 使用建议

| Shortcode | 使用场景 |
|-----------|----------|
| `boxmd` / `box` | 提示框、注释框 |
| `codes` / `tabs` | 多平台/多语言代码对比 |
| `expand` | 折叠长内容，保持页面简洁 |
| `alert` | 需要强调的四色警示信息 |
| `notice` | 文章中的提示、警告、说明 |
| `img` | 需要标题和说明的图片 |
| `button` | 行动号召按钮、链接跳转 |

## 内容分类规范

### 分类（Categories）

| 分类 | 说明 | 示例 |
|------|------|------|
| 技术 | 技术文章、编程、工具 | AI 编程、系统架构 |
| 生活 | 日常记录、随笔 | 旅行、读书 |
| 思考 | 深度思考、观点 | 职业规划、方法论 |

### 常用标签（Tags）

- **AI/LLM**: AI, Claude, GPT, LLM, Prompt
- **编程**: Python, Java, Go, JavaScript, 架构
- **工具**: Obsidian, Docker, Git
- **效率**: 工作流, 自动化, 时间管理
- **生活**: 读书, 电影, 旅行

### 特殊内容类型

| 类型 | 路径 | 说明 |
|------|------|------|
| 日报 | `zh/daily/` | AI 每日资讯摘要 |
| 周报 | `zh/weekly/` | 周总结与计划 |
| Talks | `zh/talks/` | 演讲、资源收集 |
| Gallery | `zh/gallery/` | 相册分组 |

## 技术配置

### 启用数学公式

在 front matter 添加：
```yaml
libraries: [katex]
```

### 启用 Mermaid 图表

```yaml
libraries: [mermaid]
```