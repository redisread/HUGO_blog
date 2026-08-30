---
name: r2-uploader
description: 将本地图片上传到本博客的 Cloudflare R2 存储桶并返回公开链接。用户要求上传图片到 R2、图床或 cos.jiahongw.com 时使用；不处理远程 URL、批量上传或对象管理。
---

# R2 图片上传

使用 `scripts/r2-upload` 上传一个本地图片文件，成功时将公开 URL 返回给用户。

## 固定配置

- Bucket：`hugo-blog`
- 公开域名：`https://cos.jiahongw.com`
- Account ID：`e3afbb613458022947cd9dc9f5bd6334`
- 鉴权：环境变量 `CLOUDFLARE_API_TOKEN`

API Token 只能从环境变量读取。不要将 Token 写入仓库、技能文件、命令输出或回复。

## 上传

仅在用户明确要求上传某个图片文件时执行外部写入。先确定准确的本地文件路径，再运行：

```bash
bash .agents/skills/r2-uploader/scripts/r2-upload <图片路径> [对象键或目录前缀]
```

- 未指定对象键时，使用 `images/YYYYMMDD/<原文件名>`。
- 第二个参数以 `/` 结尾时，将原文件名附加到该目录前缀。
- 成功时脚本的标准输出只有图片公开 URL；将该 URL 原样返回给用户。
- 失败时报告脚本的标准错误，不要猜测或构造链接。

脚本只接受 MIME 类型为 `image/*` 且不超过 300 MB 的普通文件。若 `CLOUDFLARE_API_TOKEN` 未设置，停止并提示用户先在当前 shell 中导出该变量。

上传使用 Cloudflare R2 Upload Object API：<https://developers.cloudflare.com/api/resources/r2/subresources/buckets/subresources/objects/methods/upload/>
