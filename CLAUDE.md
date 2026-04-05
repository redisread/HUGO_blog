# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 提供项目工作指南。

## 项目概览

**VictorHong's Blog** — 基于 Hugo 的中文博客，托管于 https://hugo.jiahongw.com
- **主题**: zzo-dev（hugo-theme-zzo 分支）
- **语言**: 中文（zh）
- **工作流**: Obsidian + QuickAdd 插件 + Claude Code

## 常用命令

```bash
# 本地开发
hugo server -D                    # 启动预览服务器 http://localhost:1313
hugo server -D --bind 0.0.0.0     # 局域网可访问

# 创建内容
hugo new posts/tech/文章名.md      # 创建技术文章
hugo new weekly/weekly-log-YYYY-WW.md  # 创建周报
hugo new daily/tech-ai-insights-daily-YYYY-MM-DD.md  # 创建日报

# 构建与部署
hugo                              # 构建（输出到 public/）
hugo --gc --minify               # 生产构建（清理缓存+压缩）

# 主题维护
git submodule update --recursive --remote  # 更新主题子模块
```

## 项目结构

```
content/
├── zh/                          # 中文内容（主内容目录）
│   ├── posts/                   # 博客文章
│   │   ├── tech/               # 技术文章（AI、编程、工具等）
│   │   ├── 技术实践/            # 技术实践笔记
│   │   ├── 专业领域/            # 专业领域知识
│   │   ├── AI编程/             # AI 编程相关
│   │   ├── 思考/               # 思考与随笔
│   │   ├── 生活/               # 生活记录
│   │   ├── 书籍/               # 读书笔记
│   │   └── 工具折腾/            # 工具配置与折腾
│   ├── daily/                  # AI 日报/每日摘要
│   ├── weekly/                 # 周报
│   ├── talks/                  # 演讲/资源收集
│   ├── gallery/                # 相册
│   │   ├── life/              # 生活照片
│   │   ├── movie/             # 影视
│   │   ├── beijing/           # 北京
│   │   ├── chuanxi/           # 川西
│   │   └── tailand/           # 泰国
│   ├── presentation/           # 幻灯片
│   ├── showcase/               # 展示/作品集
│   ├── about/                  # 关于页面
│   ├── archive/                # 归档页
│   ├── now/                    # 现在/动态
│   ├── contact/                # 联系页面
│   └── resume/                 # 简历
├── posts/                      # 英文/默认语言文章（较少使用）
├── tags/                       # 标签分类页面
└── categories/                 # 分类页面

config/_default/                # 配置文件
├── config.toml                # 主配置
├── params.toml                # 主题参数
├── menus.zh.toml              # 中文菜单
└── languages.toml             # 语言配置

archetypes/                     # 文章模板
├── default.md                 # 默认模板
├── weekly.md                  # 周报模板
├── presentation.md            # 幻灯片模板
├── resume.md                  # 简历模板
├── showcase.md                # 展示模板
└── Obsidian_Hugo_Blog_Template.md  # Obsidian 快速模板

themes/zzo-dev/                 # 主题（git 子模块）
workspace/                      # 草稿工作区（不参与构建）
static/                         # 静态资源
├── images/                    # 图片资源
└── css/, js/                  # 自定义样式脚本
assets/                         # 构建时处理的资源
public/                         # 构建输出（GitHub Pages 部署）
```

## Front Matter 规范

### 标准文章模板

```yaml
---
title: "文章标题"
subtitle: "副标题（可选）"
date: 2026-04-05T10:00:00+08:00      # 创建时间
publishDate: 2026-04-05T10:00:00+08:00  # 发布时间
description: "文章描述，用于 SEO 和摘要"
image: "https://cos.jiahongw.com/path/to/image.png"  # 封面图 URL
aliases: []                         # URL 别名
draft: false                        # false=发布，true=草稿
hideToc: false                      # 是否隐藏目录
enableToc: true                     # 是否启用目录
tocPosition: inner                  # inner/outer
tocLevels: ["h2", "h3", "h4"]       # 目录包含的标题层级
author: VictorHong
authorEmoji: 🪶
libraries: []                       # 加载的库：[katex, mermaid, chart, ...]
tags: ["AI", "Claude", "效率"]       # 标签
categories: ["技术"]                 # 分类
series: []                          # 系列文章
---
```

### 关键字段说明

| 字段 | 说明 | 建议 |
|------|------|------|
| `title` | 文章标题 | 简洁明确，包含关键词 |
| `subtitle` | 副标题 | 补充说明，可选 |
| `description` | 描述 | 120字以内，用于 SEO |
| `image` | 封面图 | 使用 R2/CDN 外链，推荐 1200x630 |
| `tags` | 标签 | 3-5 个相关标签 |
| `categories` | 分类 | 选择最相关的一个分类 |
| `date` | 创建时间 | ISO 8601 格式 |
| `draft` | 草稿状态 | 发布前设为 false |

## 写作工作流

### 方式一：Obsidian + QuickAdd（推荐）

1. **新建文章**：使用 QuickAdd 模板创建草稿
2. **本地编辑**：在 Obsidian 中编写内容
3. **移动发布**：完成后复制到 `content/zh/posts/分类/`
4. **提交部署**：Git push 触发自动部署

### 方式二：Claude Code 辅助写作

```bash
# 1. 创建新文章
hugo new posts/tech/文章名.md

# 2. 编辑内容（Claude 辅助）
# 使用 /edit 修改文件
# 使用 /read 查看结构

# 3. 本地预览
hugo server -D

# 4. 提交发布
git add .
git commit -m "add: 文章标题"
git push origin master
```

### 方式三：Workspace 草稿模式

1. 在 `workspace/` 目录下创建草稿
2. 使用 Claude 协助完善内容
3. 完成后移动到 `content/zh/posts/` 对应分类
4. 设置 `draft: false` 发布

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

### 代码高亮

使用标准 Markdown 代码块，支持语言：
```markdown
```python
print("Hello")
```
```

## CI/CD 部署

GitHub Actions 配置在 `.github/workflows/hugo-blog-ci.yml`

**部署流程**：
1. Push 到 `master` 分支触发
2. Hugo 0.110.0 extended 构建
3. 部署到 `redisread/redisread.github.io`
4. 通过 GitHub Pages 访问

**手动部署**（备用）：
```bash
hugo --gc --minify
cd public
# 手动推送到部署仓库
```

## SEO 与优化

### 文章优化清单

- [ ] 标题包含关键词，长度 20-30 字
- [ ] description 清晰描述内容（120 字内）
- [ ] 添加 3-5 个相关标签
- [ ] 选择合适的分类
- [ ] 添加封面图（1200x630）
- [ ] 文章首段包含关键词
- [ ] 使用 H2/H3 结构化内容
- [ ] 添加内部链接（相关文章）

### URL 规范

- 使用 `-` 连接单词：`claude-code-best-practices`
- 避免中文 URL，使用拼音或英文
- 保持简洁：`/posts/tech/article-name/`

## 主题自定义

### 自定义 CSS

编辑 `assets/scss/custom.scss`：
```scss
// 自定义样式
.custom-class {
  color: #333;
}
```

### 自定义 JS

编辑 `assets/js/custom.js`：
```javascript
// 自定义脚本
console.log('Custom script loaded');
```

## 常见问题

### 本地预览失败

```bash
# 清除缓存重试
hugo server -D --gc

# 检查配置
hugo config
```

### 主题更新

```bash
git submodule update --recursive --remote
# 如有冲突，手动合并主题更新
```

### 图片不显示

- 检查图片 URL 是否可访问
- 确认图片域名在 config.toml 的 `[imaging]` 允许列表
- 本地图片放入 `static/images/`

### 文章不显示

- 检查 `draft: false`
- 确认在正确语言目录 `content/zh/`
- 检查 front matter 格式是否正确（YAML）

## 资源与参考

- **主题文档**: `themes/zzo-dev/README.md`
- **Hugo 文档**: https://gohugo.io/documentation/
- **项目仓库**: https://github.com/redisread/HUGO_blog
- **在线地址**: https://hugo.jiahongw.com

## 快速命令速查

```bash
# 创建与编辑
hugo new posts/tech/$(date +%Y%m%d)-title.md
hugo new daily/tech-ai-insights-daily-$(date +%Y-%m-%d).md

# 预览与构建
hugo server -D
hugo server -D --bind 0.0.0.0
hugo --gc --minify

# Git 操作
git add content/zh/posts/tech/new-post.md
git commit -m "add: 文章标题"
git push origin master

# 主题维护
git submodule update --recursive --remote
```
