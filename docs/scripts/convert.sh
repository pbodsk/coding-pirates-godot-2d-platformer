#!/usr/bin/env sh
set -euo pipefail

SOURCE_DIR="../markdown"
OUTPUT_DIR="../2dplatformer"

# Copy assets to HTML folder
ASSETS_DIR="$SOURCE_DIR/assets"

if [ -d "$ASSETS_DIR" ]; then
  cp -R "$ASSETS_DIR" "$OUTPUT_DIR/"
fi

# Convert markdown files to HTML
find "$SOURCE_DIR" -name "*.md" -type f | while read -r file; do
    relative_path="${file#$SOURCE_DIR}"
    output_path="$OUTPUT_DIR/${relative_path%.md}.html"
    output_folder=$(dirname "$output_path")

    relative_output_dir=$(dirname "${relative_path%.md}")

    if [ "$relative_output_dir" = "." ]; then
        depth=0
    else
        depth=$(awk -F/ '{print NF-1}' <<< "$relative_output_dir")
    fi

    css_prefix=""
    for ((i = 0; i < depth; i++)); do
        css_prefix="../$css_prefix"
    done

    pandoc "$file" \
        --from=gfm \
        --to=html5 \
        --standalone \
        --css="${css_prefix}style/github-markdown.css" \
        --css="${css_prefix}style/style.css" \
        --lua-filter=../scripts/wrap-markdown-body.lua \
        -o "$output_path"
done