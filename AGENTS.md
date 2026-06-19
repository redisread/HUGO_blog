# HUGO_blog

## 项目

个人 Hugo 博客。

- 路径：`/Users/victor/Desktop/project/github/HUGO_blog`
- 主题：`zzo-dev`（基于 hugo-theme-zzo）
- 生产环境：`https://hugo.jiahongw.com`
- 部署：GitHub Actions 到 `redisread/redisread.github.io`
- 默认语言：中文（`zh`）
- Hugo 版本要求：extended `0.110.0+`

## 常用命令

```bash
hugo version          # 查看版本
hugo server -D        # 本地预览（包含草稿）
hugo --gc --minify    # 构建（清理缓存并压缩）
```

Hugo 原生创建命令：

```bash
hugo new posts/technology/my-article.md              # 创建技术文章
hugo new posts/AI/my-article.md                      # 创建 AI 文章
hugo new daily/$(date +%Y-%m-%d).md                   # 创建每日笔记
hugo new weekly/weekly-log-$(date +%Y-%W).md          # 创建周记
```

## 内容路径

| 类型 | 路径 |
|---|---|
| 博客文章 | `content/zh/posts/<category>/` |
| 每日笔记 | `content/zh/daily/` |
| 周记 | `content/zh/weekly/` |
| 演讲/分享 | `content/zh/talks/` |
| 相册 | `content/zh/gallery/` |

现有文章分类：

```
AI, ai-programming, books, life, professional, tech,
technical-practice, technology, thoughts, tooling, 技术
```

## Front Matter 格式

新文章应遵循以下格式：

```yaml
---
title: "文章标题"
date: 2026-05-31T10:00:00+08:00
publishDate: 2026-05-31T10:00:00+08:00
draft: false
image: "cover.png"
categories: ["technology"]
tags: ["AI", "Hugo"]
libraries: [katex, mermaid]
---
```

**注意**：只有当文章确实需要时才启用 `katex` 或 `mermaid`。

## 图片处理

封面图：

- 将图片放在文章同级目录下
- front matter 中只使用文件名：`image: "cover.png"`

正文图片：

- 优先使用 R2 存储桶 `hugo-blog`
- 公共域名：`https://cos.jiahongw.com`
- 使用 `r2-uploader` workflow/skill 上传

示例：

```bash
r2-upload ./my-image.png hugo-blog/images/
```

## Shortcodes

默认使用标准 Markdown。zzo 主题的 shortcodes 请参考：

- `.Codex/rules/hugo-shortcodes.md`

## 发布流程

```bash
hugo --gc --minify          # 构建
git add content/            # 添加内容
git commit -m "发布: 文章标题"  # 提交
git push origin master      # 推送
```

推送到 `master` 分支会触发 `.github/workflows/hugo-blog-ci.yml` 自动部署。

## 审核规则

- 除非明确要求，否则不要编辑生成的 `public/` 目录
- 保留 UTF-8 中文文本
- 所有原创内容放在 `content/zh/` 下；不要在根目录 `content/*.md` 或其他语言目录添加内容
- 文章资源（图片等）与文章放在一起
- 不要在内容或配置中放置密钥或 Cloudflare 凭证

保持本文件简洁。详细的 shortcode 示例或主题相关说明请移至 `.Codex/rules/` 或文档目录。
