#!/bin/sh
# 把当前窗格的「目录 · 分支」推给 herdr 侧栏（自定义字段 $loc）。
# 复制到 ~/.config/herdr/report-location.sh 并 chmod +x。
# 在 herdr 窗格内运行（读取 HERDR_PANE_ID），或传入：report-location.sh [pane_id] [目录]
pane="${HERDR_PANE_ID:-$1}"
dir="${2:-$PWD}"
[ -n "$pane" ] || exit 0

name=$(basename "$dir")
branch=$(git -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null || git -C "$dir" rev-parse --short HEAD 2>/dev/null)
loc="$name"
[ -n "$branch" ] && loc="$name · $branch"

herdr pane report-metadata "$pane" --source location --token "loc=$loc"
