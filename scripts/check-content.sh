#!/bin/bash
# HUGO_blog 内容发布检查
# 检查点：
# 1. 禁止在 content/ 根目录（content/zh/ 之外）新增 .md 文件
# 2. 校验所有内容文件的 frontmatter 必填字段

set -e

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONTENT_DIR="$ROOT_DIR/content"
ERRORS=0

echo "=== HUGO_blog Content Check ==="

# ============================================
# 检查 1：root content/ 不应有 .md 文件
# ============================================
echo ""
echo "[1/2] Checking root content/ for orphan .md files..."

ROOT_FILES=$(find "$CONTENT_DIR" -maxdepth 1 -name "*.md" 2>/dev/null)
if [ -n "$ROOT_FILES" ]; then
  echo "  ❌ ERROR: .md files found in content/ root:"
  echo "$ROOT_FILES" | sed 's/^/    /'
  echo "  All content must be under content/zh/"
  ERRORS=$((ERRORS + 1))
else
  echo "  ✅ No orphan files in content/ root"
fi

# ============================================
# 检查 2：frontmatter 必填字段
# ============================================
echo ""
echo "[2/2] Checking frontmatter required fields..."

REQUIRED_FIELDS=("title" "date")

while IFS= read -r -d '' file; do
  # 跳过 _index.md / _index.*.md（section config pages）
  # 跳过 index.md in publication/（theme template placeholders）
  # 跳过 _build.render: never（显式禁用渲染的占位文件）
  base=$(basename "$file")
  if [[ "$base" =~ ^_index ]]; then
    continue
  fi

  if [ "$base" = "index.md" ] && [[ "$file" == */publication/* ]]; then
    continue
  fi

  if grep -q "_build:" "$file" && grep -q "render: never" "$file"; then
    continue
  fi

  missing=""
  for field in "${REQUIRED_FIELDS[@]}"; do
    if ! grep -q "^${field}:" "$file"; then
      missing="$missing $field"
    fi
  done

  if [ -n "$missing" ]; then
    # 提取 frontmatter 块（--- 之间的内容）
    has_frontmatter=false
    if head -1 "$file" | grep -q "^---$"; then
      has_frontmatter=true
    fi

    if $has_frontmatter; then
      echo "  ❌ $file — missing:$missing"
      ERRORS=$((ERRORS + 1))
    fi
  fi
done < <(find "$CONTENT_DIR" -name "*.md" -print0)

if [ $ERRORS -eq 0 ] || [ "$(find "$CONTENT_DIR" -name "*.md" -not -name "_index.md" | wc -l | tr -d ' ')" -eq 0 ]; then
  echo "  ✅ All content files have required frontmatter"
fi

# ============================================
# 结果
# ============================================
echo ""
if [ $ERRORS -gt 0 ]; then
  echo "❌ $ERRORS error(s) found. Fix before committing."
  exit 1
else
  echo "✅ All checks passed!"
  exit 0
fi
