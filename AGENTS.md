# HUGO_blog

## 内容约定

- 原创内容放在 `content/zh/`，按类型选择目录，见 [内容结构](docs/content-structure.md)。主题功能页保持原用途。
- 新文章的 front matter 参考 [archetypes/](archetypes/)，仅按需启用 `libraries` 中的渲染库。
- 默认使用标准 Markdown；需要主题 shortcode 时，先读 [用法与限制](.claude/rules/hugo-shortcodes.md)。
- 生成文章链接时遵循 [站点配置](config/_default/config.toml) 的 `Permalinks`：日期取 `date`，路径末段取文件名。

## 图片

- 封面使用 `image` 字段：远程图片填写公开 URL；统一使用远程图片 URL（必要上传到远程 cos ），不要使用本地图片。
- 正文图片优先使用图床；上传到 cos 时，先读 [r2-uploader](.agents/skills/r2-uploader/SKILL.md)，按技能执行并使用返回的公开 URL。

## 验证与部署

- 构建、主题和部署入口见 [技术栈](docs/tech-stack.md)；Hugo 版本以 [CI 工作流](.github/workflows/hugo-blog-ci.yml) 为准。
- 交付前执行 `hugo --gc --minify` 和 `git diff --check`。
- `public/` 是构建产物，除非明确要求，否则不手工修改。
- 凭证通过环境变量提供，不写入内容或配置。
