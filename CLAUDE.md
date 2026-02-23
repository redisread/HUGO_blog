# CLAUDE.md

本文件为 Claude Code (claude.ai/code) 提供项目工作指南。

## 项目概览

这是一个基于 Hugo 的单语言博客项目（VictorHong's Blog），托管于 https://hugo.jiahongw.com。
主题使用 `zzo-dev`（`hugo-theme-zzo` 的分支），仅使用中文内容。

## 常用命令

| 命令 | 说明 |
|------|------|
| `hugo new posts/文章名.md` | 创建新博客文章 |
| `hugo server -D` | 本地开发服务器（预览地址：http://localhost:1313） |
| `hugo` | 构建生产版本（输出到 `public/` 目录） |
| `git submodule update --recursive --remote` | 更新主题子模块 |

## 项目结构

```
content/
  zh/                # 中文内容
    posts/          # 博客文章
    talks/          # 演讲/资源
    gallery/        # 相册
    archive/        # 归档页
    weekly/         # 周报
    publication/    # 出版物
    presentation/   # 演示
config/_default/     # 配置、菜单（仅使用 zh 相关配置）
themes/zzo-dev/      # 主题（git 子模块）
archetypes/          # 内容模板
```

## Front Matter（文章头部）

所有页面使用 YAML 格式的 front matter，常用字段如下：

```yaml
title:               # 页面标题
subtitle:           # 可选的副标题
date:               # 创建日期
publishDate:        # 发布日期
aliases:           # URL 别名
description:        # 页面描述
image:             # 封面图 URL
draft: false        # 是否为草稿（发布的文章应为 false）
hideToc: false      # 是否隐藏目录
enableToc: true     # 是否启用目录
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
tocLevels: ["h1","h2", "h3", "h4"]
libraries: [katex, mathjax, mermaid, chart, flowchartjs, msc, viz, wavedrom]
tags: []            # 标签列表
series: []          # 系列列表
categories: []      # 分类列表
```

## Shortcodes（短代码）

主题提供的短代码：

| 短代码 | 说明 |
|--------|------|
| `{{< img >}}` | 插入图片，支持标题、懒加载、位置控制 |
| `{{< featuredImage >}}` | 显示 front matter 中设置的封面图 |
| `{{< notice 类型 标签 >}}` | 提示块（warning/info/success） |
| `{{< iframe >}}` | 嵌入 iframe 内容 |

## CI/CD

GitHub Actions 在推送到 `master` 分支时自动构建和部署：
- 使用 Hugo 0.110.0 extended 版本
- 部署到 `redisread/redisread.github.io`
- 自动初始化子模块

## 技术栈

- **Hugo**: 0.110.0 extended
- **主题**: zzo-dev（基于 hugo-theme-zzo）
- **语言**: 中文
- **编辑器工作流**: Obsidian + QuickAdd 模板插件
- **CJK 支持**: 已启用，70 字摘要长度

## 快速开始

1. **创建文章**：运行 `hugo new posts/我的第一篇文章.md`
2. **本地预览**：运行 `hugo server -D`，访问 http://localhost:1313
3. **发布网站**：运行 `hugo` 构建，部署 `public/` 目录内容

## 注意事项

- 修改主题后需运行 `git submodule update --recursive --remote` 更新
- 所有已发布的文章 `draft` 应设为 `false`
