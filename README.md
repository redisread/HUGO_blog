# VictorHong's Blog 🪶

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/redisread/HUGO_BLOG/.github/workflows/hugo-blog-ci.yml?branch=master&HUGO_CI?label=hugo_CI)](https://github.com/redisread/HUGO_BLOG/actions)
[![Hugo](https://img.shields.io/badge/Hugo-%5E0.110.0-orange)](https://gohugo.io/)

> 个人数字花园，记录技术探索、阅读思考与生活碎片。

## 🌐 在线访问

**https://hugo.jiahongw.com**

## ✨ 博客定位

这是一个由 Hugo 驱动的中文博客，专注于：

- **AI 与编程** - AI 工具、编程实践、工程思维
- **技术深度** - 架构设计、工具链、最佳实践
- **阅读与思考** - 读书笔记、行业观察、个人成长
- **生活记录** - 旅行相册、日常随笔、周记回顾

## 📂 内容结构

| 目录 | 内容 |
|------|------|
| `posts/技术/` | AI、编程、架构等技术文章 |
| `posts/AI/` | AI 工具、模型评测、应用实践 |
| `posts/books/` | 读书笔记与书评 |
| `posts/thoughts/` | 随笔与思考 |
| `daily/` | 每日精选（自动化生成） |
| `weekly/` | 周记回顾 |
| `gallery/` | 旅行与生活相册 |
| `talks/` | 演讲与分享资料 |

## 🛠 技术栈

- **构建**: Hugo 0.110.0 extended
- **主题**: zzo-dev（基于 hugo-theme-zzo 定制）
- **部署**: GitHub Actions → GitHub Pages
- **图床**: Cloudflare R2 + 腾讯云 COS

## 📝 快速开始

### 新建文章

```bash
# 技术文章
hugo new posts/technology/my-post.md

# AI 相关
hugo new posts/AI/my-post.md

# 每日/周记
hugo new daily/$(date +%Y-%m-%d).md
hugo new weekly/weekly-log-$(date +%Y-%W).md
```

### 本地预览

```bash
hugo server -D
# 访问 http://localhost:1313
```

### 构建与部署

```bash
hugo --gc --minify
git add content/
git commit -m "发布: 文章标题"
git push origin master
```

推送到 `master` 后，GitHub Actions 自动构建并部署。

## 🎨 主题特性

- 深色/浅色主题切换
- 内置全文搜索
- 响应式设计
- 图片画廊支持
- 代码高亮与复制
- KaTeX/MathJax 数学公式
- Mermaid 图表渲染

## 📄 License

MIT License © 2026 VictorHong
