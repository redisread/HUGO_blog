# 技术栈

| 环节 | 技术 | 配置入口 |
| --- | --- | --- |
| 构建 | Hugo extended | [CI 工作流](../.github/workflows/hugo-blog-ci.yml)，查看构建版本 |
| 主题 | zzo-dev，基于 hugo-theme-zzo 定制 | [站点配置](../config/_default/config.toml)、[主题仓库](../.gitmodules) |
| 部署 | GitHub Actions → GitHub Pages | [CI 工作流](../.github/workflows/hugo-blog-ci.yml)，推送到 `master` 后发布至 `redisread/redisread.github.io` |
| 图床 | Cloudflare R2 | 公共域名：`https://cos.jiahongw.com` |

## Hugo 0.168 migration

The theme now uses Dart Sass 1.105.2 and the modern Hugo template layout. Runtime versions are pinned in `themes/zzo-dev/scripts/toolchain.env`; CI installs them through the theme installer. Pull requests build production output and run isolated browser checks before merging; only pushes to master deploy.

Local setup: run `themes/zzo-dev/scripts/install-tools.sh`, add `.build/toolchain` and `.build/toolchain/dart-sass` to PATH, then run `hugo --gc --minify --panicOnWarning`. See the theme migration guide for override paths and rollback.
