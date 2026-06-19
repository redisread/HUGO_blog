# HUGO_blog

## Project

Personal Hugo blog.

- Path: `/Users/victor/Desktop/project/github/HUGO_blog`
- Theme: `zzo-dev` based on hugo-theme-zzo
- Production: `https://hugo.jiahongw.com`
- Deploy: GitHub Actions to `redisread/redisread.github.io`
- Default language: Chinese (`zh`)
- Required Hugo: extended `0.110.0+`

## Commands

```bash
hugo version
hugo server -D
hugo --gc --minify
```

Use Hugo native creation commands:

```bash
hugo new posts/technology/my-article.md
hugo new posts/AI/my-article.md
hugo new daily/$(date +%Y-%m-%d).md
hugo new weekly/weekly-log-$(date +%Y-%W).md
```

## Content Paths

| Type | Path |
|---|---|
| Blog posts | `content/zh/posts/<category>/` |
| Daily notes | `content/zh/daily/` |
| Weekly notes | `content/zh/weekly/` |
| Talks | `content/zh/talks/` |
| Gallery | `content/zh/gallery/` |

Existing post categories include:

```text
AI, ai-programming, books, life, professional, tech,
technical-practice, technology, thoughts, tooling, 技术
```

## Front Matter

New articles should follow the archetype shape:

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

Only enable `katex` or `mermaid` when the article actually needs them.

## Images

Cover image:

- Put the file next to the article bundle.
- Use only the filename in front matter: `image: "cover.png"`.

Body images:

- Prefer R2 bucket `hugo-blog`.
- Public domain: `https://cos.jiahongw.com`.
- Use the `r2-uploader` workflow/skill for uploads.

Example:

```bash
r2-upload ./my-image.png hugo-blog/images/
```

## Shortcodes

Use normal Markdown by default. For zzo theme shortcodes, see:

- `.Codex/rules/hugo-shortcodes.md`

## Publish Flow

```bash
hugo --gc --minify
git add content/
git commit -m "发布: 文章标题"
git push origin master
```

Push to `master` triggers `.github/workflows/hugo-blog-ci.yml`.

## Review Rules

- Do not edit generated `public/` unless the task explicitly requires generated output.
- Preserve UTF-8 Chinese text.
- Keep all authored content under `content/zh/`; do not add root `content/*.md` or other language directories.
- Keep article assets close to the article when they are part of the bundle.
- Do not put secrets or Cloudflare credentials in content or config.

Keep this file short. Move long shortcode examples or theme-specific notes into `.Codex/rules/` or docs.
