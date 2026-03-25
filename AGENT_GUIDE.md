# Hugo 博客 —— Agent 创建文章操作指南

## 项目概览

VictorHong 的技术博客，基于 Hugo + zzo-dev 主题，部署在 https://hugo.jiahongw.com

### 项目路径

```
/root/projects/HUGO_blog/
```

### 关键文件

| 文件 | 用途 |
|------|------|
| `content/zh/posts/` | **文章目录**。所有博客文章存放于此 |
| `workspace/` | 草稿工作区，创作阶段使用 |
| `archetypes/default.md` | 文章模板 |
| `config/_default/` | Hugo 配置文件 |
| `themes/zzo-dev/` | 主题（git 子模块） |

---

## 创建文章的完整步骤

### 第 1 步：准备文章信息

收集以下信息：

| 字段 | 说明 | 示例 |
|------|------|------|
| `title` | 文章标题 | `"OpenClaw 企业导入指南"` |
| `filename` | 文件名（英文短横线连接） | `openclaw-enterprise-guide` |
| `category` | 分类目录 | `思考` / `技术` / `工具折腾` |
| `description` | 文章描述/摘要 | 一句话概括内容 |
| `image` | 封面图 URL（可选） | `https://cos.jiahongw.com/xxx.jpg` |
| `tags` | 标签列表（可选） | `["AI", "OpenClaw"]` |

### 第 2 步：创建文章

```bash
cd /root/projects/HUGO_blog

# 创建新文章（自动使用模板）
hugo new posts/分类/文件名.md

# 示例
hugo new posts/思考/openclaw-enterprise-guide.md
```

### 第 3 步：编辑 Front Matter

打开生成的文件，编辑头部信息：

```yaml
---
title: "OpenClaw 企业导入指南"
date: 2026-03-22T18:00:00+08:00
publishDate: 2026-03-22T18:00:00+08:00
description: "企业 AI Agent 导入的冷思考与实践建议"
image: "https://cos.jiahongw.com/cover.jpg"  # 可选
draft: false
author: VictorHong
authorEmoji: 🪶
tags: ["AI", "OpenClaw", "企业"]
categories: ["思考"]
---
```

### 第 4 步：写入正文内容

在 `---` 下方写入 Markdown 正文。

### 第 5 步：构建验证

```bash
# 本地预览
hugo server -D

# 构建生产版本
hugo
```

构建成功标志：
- 无报错输出
- `public/` 目录生成静态文件

### 第 6 步：提交部署

```bash
# 添加文件
git add content/zh/posts/分类/文件名.md

# 提交
git commit -m "添加文章: 文章标题"

# 推送（触发 GitHub Actions 自动部署）
git push origin master
```

---

## Front Matter 字段说明

| 字段 | 必填 | 说明 |
|------|------|------|
| `title` | ✅ | 文章标题 |
| `date` | ✅ | 创建时间（ISO 8601 格式） |
| `publishDate` | ✅ | 发布时间 |
| `description` | ✅ | 文章描述，用于 SEO 和摘要 |
| `image` | ❌ | 封面图 URL |
| `draft` | ✅ | `false` 表示发布，`true` 表示草稿 |
| `author` | ✅ | 作者名（固定 VictorHong） |
| `authorEmoji` | ✅ | 作者表情（固定 🪶） |
| `tags` | ❌ | 标签数组 |
| `categories` | ❌ | 分类数组 |
| `aliases` | ❌ | URL 别名 |
| `hideToc` | ❌ | `true` 隐藏目录 |
| `enableToc` | ❌ | `true` 启用目录 |

---

## 图片处理

### 封面图

1. 生成/获取封面图
2. 上传至 R2：`cos.jiahongw.com`
3. 在 front matter 中填入完整 URL

### 文章内图片

使用短代码插入：

```markdown
{{< img src="https://cos.jiahongw.com/image.jpg" title="图片说明" >}}
```

---

## 分类目录结构

```
content/zh/posts/
├── 思考/          # 思考、观点类文章
├── 技术/          # 技术教程、开发相关
├── 工具折腾/      # 工具配置、使用心得
├── 书籍/          # 读书笔记、书评
├── weekly/        # 周报
└── ...
```

---

## 快速检查清单

发布前确认：

- [ ] 文件名使用英文短横线格式
- [ ] `title` 已填写
- [ ] `description` 已填写
- [ ] `draft: false`
- [ ] `date` 和 `publishDate` 已设置
- [ ] 正文内容已写入
- [ ] `hugo` 构建成功无报错
- [ ] 已 `git commit` 和 `git push`

---

## CI/CD 说明

- 推送到 `master` 分支自动触发 GitHub Actions
- 构建使用 Hugo 0.110.0 extended
- 部署到 `redisread/redisread.github.io`
- 域名 https://hugo.jiahongw.com

---

## 常用命令速查

```bash
# 进入项目
cd /root/projects/HUGO_blog

# 创建文章
hugo new posts/分类/文件名.md

# 本地预览
hugo server -D

# 构建
hugo

# 更新主题
git submodule update --recursive --remote
```
