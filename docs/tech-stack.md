# 技术栈

| 环节 | 技术 | 配置入口 |
| --- | --- | --- |
| 构建 | Hugo extended | [CI 工作流](../.github/workflows/hugo-blog-ci.yml)，查看构建版本 |
| 主题 | zzo-dev，基于 hugo-theme-zzo 定制 | [站点配置](../config/_default/config.toml)、[主题仓库](../.gitmodules) |
| 部署 | GitHub Actions → GitHub Pages | [CI 工作流](../.github/workflows/hugo-blog-ci.yml)，推送到 `master` 后发布至 `redisread/redisread.github.io` |
| 图床 | Cloudflare R2 | 公共域名：`https://cos.jiahongw.com` |
