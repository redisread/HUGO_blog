# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hugo-based multilingual blog (VictorHong's Blog) hosted at https://hugo.jiahongw.com. The project uses the `zzo-dev` theme, a fork of `hugo-theme-zzo`.

## Common Commands

| Command | Description |
|---------|-------------|
| `hugo new posts/name.md` | Create a new blog post |
| `hugo server -D` | Local development server (preview at http://localhost:1313) |
| `hugo` | Build production version (output to `public/` directory) |
| `git submodule update --recursive --remote` | Update theme submodules |

## Project Structure

```
content/zh/           # Chinese content (main language)
  posts/             # Blog articles
  talks/             # Speech/resources
  gallery/           # Photo galleries
  archive/           # Archive page
  weekly/            # Weekly logs
  publication/       # Publications
  presentation/      # Presentations
config/_default/     # Config, languages, menus
themes/zzo-dev/      # Theme (git submodule)
archetypes/          # Content templates
```

## ContentFront Matter

All pages use YAML front matter with these common fields:

```yaml
title:               # Page title
subtitle:           # Optional subtitle
date:               # Publication date
publishDate:        # Publish date
aliases:           # URL aliases
description:        # Page description
image:             # Featured image URL
draft: false        # Whether draft (should be false for published)
hideToc: false      # Hide table of contents
enableToc: true     # Enable table of contents
enableTocContent: false
tocPosition: inner
author: VictorHong
authorEmoji: 🪶
tocLevels: ["h1","h2", "h3", "h4"]
libraries: [katex, mathjax, mermaid, chart, flowchartjs, msc, viz, wavedrom]
tags: []            # Tag list
series: []          # Series list
categories: []      # Categories list
```

## Shortcodes

Theme provides these shortcodes:

| Shortcode | Description |
|-----------|-------------|
| `{{< img >}}` | Image with caption, lazy loading, positioning |
| `{{< featuredImage >}}` | Display featured image from page front matter |
| `{{< notice type label >}}`{.notice} | Callout blocks (warning/info/success) |
| `{{< iframe >}}` | Embedded iframe content |

## Multilingual

- Default language: Chinese (`zh`)
- Other languages: English (`en`), Korean (`ko`)
- Each language has its own menu config in `config/_default/menus.{lang}.toml`
- Language directories under `content/{lang}/`

## CI/CD

GitHub Actions build and deploy on push to `master`:
- Uses Hugo 0.110.0 extended
- Deploys to `redisread/redisread.github.io`
- Submodules are automatically initialized

## Technical Stack

- **Hugo**: 0.110.0 extended
- **Theme**: zzo-dev (based on hugo-theme-zzo)
- **Languages**: Chinese (default), English, Korean
- **Editor Workflow**: Obsidian with QuickAdd template plugin
- **CJK Support**: Enabled with 70-char summary length
