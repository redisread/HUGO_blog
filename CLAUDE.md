# CLAUDE.md

## 项目概况

- **路径**: `/Users/victor/Desktop/project/github/HUGO_blog`
- **主题**: `zzo-dev`（基于 hugo-theme-zzo）
- **部署**: GitHub Actions → `redisread/redisread.github.io`
- **线上地址**: https://hugo.jiahongw.com
- **Hugo 版本**: 0.110.0 extended
- **默认语言**: 中文（`zh`）

## 环境要求

本地需安装 Hugo extended 0.110.0+：
```bash
hugo version
```

## 本地开发

```bash
# 预览（包含草稿）
cd /Users/victor/Desktop/project/github/HUGO_blog
hugo server -D

# 构建生产版本
hugo
# 输出在 public/ 目录
```

## 发布流程（hugo new）

### 1. 创建新文章

使用 Hugo 原生命令创建文章：

```bash
# 创建 posts 文章（带分类）
hugo new posts/technology/my-article.md

# 创建 daily 日报
hugo new daily/2026-05-31.md

# 创建 weekly 周报
hugo new weekly/weekly-log-2026-22.md
```

### 2. 编辑文章

文章 front matter 模板会自动生成，参考 `archetypes/default.md`：
```yaml
---
title: "文章标题"
date: 2026-05-31T10:00:00+08:00
publishDate: 2026-05-31T10:00:00+08:00
draft: false
image: "cover.png"  # 封面图文件名，放在文章同级目录
categories: ["technology"]
tags: ["AI", "Hugo"]
libraries: [katex, mermaid]  # 按需启用
---
```

### 3. 图片处理

**封面图**（必须放在文章同级目录）：
```bash
# 1. 复制封面图到文章目录
cp ~/Downloads/cover.png content/zh/posts/technology/my-article/
# 或
mv ~/Pictures/cover.png content/zh/daily/2026-05-31/

# 2. front matter 中 image 填文件名
image: "cover.png"
```

**正文图片**（推荐 R2 图床）：
- 先上传到 R2 bucket: `hugo-blog`
- 使用完整 URL: `https://cos.jiahongw.com/images/xxx.png`
- 上传命令参考 `r2-uploader` skill

**R2 上传命令示例**（在终端中执行）：
```bash
# 单张图片
r2-upload ./my-image.png hugo-blog/images/

# 获取 URL
# https://cos.jiahongw.com/images/my-image.png
```

### 4. Git 提交

```bash
cd /Users/victor/Desktop/project/github/HUGO_blog
git add content/
git commit -m "发布: 文章标题"
git push origin master
```

### 5. CI 自动部署

Push 到 `master` 分支后：
1. GitHub Actions 自动触发（`.github/workflows/hugo-blog-ci.yml`）
2. Hugo 构建 `public/` 目录
3. 部署到 `redisread/redisread.github.io`
4. 线上生效（通常 1-2 分钟）

## 内容分类与路径

| 类型 | 物理路径 | 说明 |
|------|----------|------|
| 博客文章 | `content/zh/posts/<category>/` | 按分类子目录存放 |
| 日报 | `content/zh/daily/` | AI 每日资讯摘要 |
| 周报 | `content/zh/weekly/` | 周总结与计划 |
| Talks | `content/zh/talks/` | 演讲、资源收集 |
| Gallery | `content/zh/gallery/` | 相册分组 |

**现有分类目录**（posts 下）：
```bash
ls content/zh/posts/
# AI, ai-programming, books, life, professional, tech, technical-practice, technology, thoughts, tooling, 技术
```

## 常用命令速查

```bash
# 创建技术类文章
hugo new posts/technology/my-article.md

# 创建 AI 类文章
hugo new posts/AI/my-article.md

# 创建日报（建议带日期前缀）
hugo new daily/$(date +%Y-%m-%d).md

# 创建周报
hugo new weekly/weekly-log-$(date +%Y-%W).md

# 预览
hugo server -D

# 构建
hugo
```

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

## 技术配置

### 启用数学公式

在 front matter 添加：
```yaml
libraries: [katex]
```

### 启用 Mermaid 图表

在 front matter 添加：
```yaml
libraries: [mermaid]
```
