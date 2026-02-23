# VictorHong's Blog 🪶

[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/redisread/HUGO_BLOG/.github/workflows/hugo-blog-ci.yml?branch=master&HUGO_CI?label=hugo_CI)](https://github.com/redisread/HUGO_BLOG/actions)
[![Hugo](https://img.shields.io/badge/Hugo-%5E0.110.0-orange)](https://gohugo.io/)

> VictorHong 的技术博客，记录技术分享、生活随笔和学习笔记。

## 🌐 博客地址

- **主站**: https://hugo.jiahongw.com

## 📚 项目介绍

这是一个基于 Hugo 搭建的多语言博客项目，使用自定义主题 `zzo-dev`。


### 内容分类

| 分类 | 说明 |
|------|------|
| **Posts** | 技术文章、学习笔记 |
| **Talks** | 演讲资料、分享资源 |
| **Gallery** | 生活、影视、旅行相册 |
| **Publication** | 出版物、书籍笔记 |
| **Archive** | 文章归档 |

### 主要主题

- **AI** - 人工智能、机器学习相关
- **dev** - 软件开发（设计模式、算法等）
- **Hugo** - 博客搭建相关

## 🛠 技术栈

| 技术 | 版本/说明 |
|------|-----------|
| Hugo | 0.110.0 |
| 主题 | zzo-dev (基于 hugo-theme-zzo) |
| 部署 | GitHub Actions + GitHub Pages |
| 编辑 | Obsidian/任何 Markdown 编辑器 |

## 📝 使用方法

### 新建文章

在 `content/zh` 目录下自动创建对应文件：

```bash
hugo new posts/your-post-name.md
```

### 本地开发

```bash
hugo server -D
```

访问 `http://localhost:1313` 预览博客。

### 构建生产版本

```bash
hugo
```

构建后的文件位于 `public/` 目录。

## 🎨 主题特性

- 多皮肤支持（深色/浅色/Solarized）
- 内置搜索功能
- 响应式设计
- 图片画廊
- 代码高亮
- 数学公式支持（KaTeX/MathJax/Mermaid）
- 多语言支持

## 📂 目录结构

```
HUGO_blog/
├── config/_default/          # 配置文件
│   ├── config.toml          # 主配置
│   ├── languages.toml       # 多语言配置
│   └── menus.*.toml         # 多语言菜单
├── content/zh/              # 中文内容
│   ├── posts/               # 博客文章
│   ├── talks/               # 演讲资源
│   ├── gallery/             # 相册
│   ├── archive/             # 归档
│   └── publication/         # 出版物
├── themes/zzo-dev/          # 主题
├── archetypes/              # 文章模板
├── assets/                  # 静态资源
└── .github/workflows/       # CI/CD
```

## 🔧 CI/CD

使用 GitHub Actions 自动化部署：

1. 推送到 `master` 分支自动触发构建
2. 使用 Hugo 0.110.0 extended 版本
3. 部署到 `redisread/redisread.github.io`

## 📄 License

MIT License

## 👤 Author

**VictorHong** - © 2026-present
