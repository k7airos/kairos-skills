#!/usr/bin/env bash
set -euo pipefail

# 获取 kairos-skills 仓库根目录绝对路径
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "🔗 正在同步 kairos-skills 到全局 Agent 目录..."
echo "📂 源仓库目录: $REPO_ROOT"

# 创建目标目录
mkdir -p "$HOME/.agents/skills"
mkdir -p "$HOME/.gemini/config/skills"
mkdir -p "$HOME/.claude/skills"
mkdir -p "$HOME/.codex/skills"

count=0
for skill_dir in "$REPO_ROOT"/skills/*; do
  if [ -d "$skill_dir" ]; then
    skill_name="$(basename "$skill_dir")"
    
    # 1. ~/.agents/skills
    ln -sfn "$skill_dir" "$HOME/.agents/skills/$skill_name"
    
    # 2. ~/.gemini/config/skills
    ln -sfn "$HOME/.agents/skills/$skill_name" "$HOME/.gemini/config/skills/$skill_name"
    
    # 3. ~/.claude/skills
    ln -sfn "$HOME/.agents/skills/$skill_name" "$HOME/.claude/skills/$skill_name"
    
    # 4. ~/.codex/skills
    ln -sfn "$HOME/.agents/skills/$skill_name" "$HOME/.codex/skills/$skill_name"
    
    echo "  ✅ 已链接: $skill_name"
    count=$((count + 1))
  fi
done

echo "🎉 同步完成！共链接 $count 个技能到 ~/.agents、~/.gemini、~/.claude 与 ~/.codex。"
