# Hugo Shortcodes

Use these zzo theme shortcodes when they improve article readability. Keep normal Markdown as the default.

## Boxes

```markdown
{{< boxmd >}}
This is **boxmd** content with Markdown.
{{< /boxmd >}}

{{< box >}}
Plain text box content.
{{< /box >}}
```

## Tabs

```markdown
{{< tabs Windows MacOS Ubuntu >}}
  {{< tab >}}
  Windows content
  {{< /tab >}}
  {{< tab >}}
  MacOS content
  {{< /tab >}}
  {{< tab >}}
  Ubuntu content
  {{< /tab >}}
{{< /tabs >}}
```

Each tab body must be different because tab IDs are generated from content hashes.

## Expand

```markdown
{{< expand "点击展开" >}}
Hidden content.
{{< /expand >}}
```

## Alerts and Notices

```markdown
{{< alert theme="warning" >}}
**警告** 内容
{{< /alert >}}

{{< notice info >}}
info text
{{< /notice >}}
```

Themes commonly used: `info`, `warning`, `success`, `danger` / `error`.

## Images

```markdown
{{< img src="https://example.com/image.jpg"
       title="图片标题"
       caption="图片描述"
       alt="alt 文本"
       width="700px"
       position="center" >}}

{{< featuredImage >}}
```

## Buttons and Embeds

```markdown
{{< button href="https://hugo.jiahongw.com" color="primary" >}}访问博客{{< /button >}}
{{< iframe src="https://example.com/embed" >}}
```

## Front Matter Libraries

```yaml
libraries: [katex]
libraries: [mermaid]
```
