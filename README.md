# kairos-skills

Official Agent Skills for the Kairos & `zzhub-pipeline` publishing ecosystem.

本仓库汇集了与 Kairos 内容发布流水线（[`@akairos/pipeline`](https://github.com/aatrooox/zzhub-pipeline)）、Milkdown 排版插件（[`@akairos/milkdown-article-plugins`](https://github.com/aatrooox/milkdown-article-plugins)）、样式规范（[`@akairos/milkdown-article-style`](https://github.com/aatrooox/milkdown-article-style)）及排版工作台配套使用的 AI Agent 技能。

---

## 📦 技能清单 (Skills Catalog)

| Skill | 目录 | 适用场景与主要功能 |
| :--- | :--- | :--- |
| **`milkdown-writing`** | [`skills/milkdown-writing/`](skills/milkdown-writing/SKILL.md) | **Milkdown 写作排版规范**<br>按当前 Nezus / Pipeline 接入的 Milkdown 扩展语法撰写与校验 Markdown。涵盖篇章导读卡片（`[!INTRO]`）、文末引流/互动卡片（`[!CTA]`）、标准提示块（`NOTE`/`TIP`/`WARNING` 等）、行内高亮（`==文本==`）、快捷键徽章（`[[kbd:Cmd]]`）、彩色标签（`[badge:brand\|文本]`）以及微信 HTML 安全导出规则。 |
| **`zzhub-publish`** | [`skills/zzhub-publish/`](skills/zzhub-publish/SKILL.md) | **内容发布流水线编排**<br>编排 `zzhub-pipeline` CLI 状态机完成微信公众号图文（article）、图文消息贴图（newspic）与博客的多目标发布。指导 Agent 处理多子 Agent 协作写稿、内容审核（Review）、修改建议反馈（Revision）、图片渲染及草稿发布。 |
| **`auto-ai-daily`** | [`skills/auto-ai-daily/`](skills/auto-ai-daily/SKILL.md) | **全自动每日 AI 日报发文流水线**<br>无人值守自动化流水线。从 AIHOT API 实时抓取今日热门前五条，扩写为 1000-1200 字客观纪实报道，应用 `humanizer-zh` 彻底去除 AI 腔调，并调用 pipeline 直接发布至指定微信公众号。 |

---

## 🚀 安装与使用 (Installation)

各 AI Agent 环境（Amp、Claude Code、Codex、Antigravity / Gemini CLI）通过软链接引用本仓库的技能，保持**单一事实来源（Single Source of Truth）**。

### 一键链接到所有全局 Agent 目录

在仓库根目录下运行配套脚本：

```bash
./scripts/link-skills.sh
```

或手动创建软链接：

```bash
# 目标仓库路径
REPO_ROOT="$(pwd)"

# 1. 全局 Agent 技能中心 (~/.agents/skills)
mkdir -p ~/.agents/skills
for skill in "$REPO_ROOT"/skills/*; do
  [ -d "$skill" ] && ln -sf "$skill" ~/.agents/skills/
done

# 2. Antigravity / Gemini CLI (~/.gemini/config/skills)
mkdir -p ~/.gemini/config/skills
for skill in "$REPO_ROOT"/skills/*; do
  [ -d "$skill" ] && ln -sf ~/.agents/skills/"$(basename "$skill")" ~/.gemini/config/skills/
done

# 3. Claude Code (~/.claude/skills)
mkdir -p ~/.claude/skills
for skill in "$REPO_ROOT"/skills/*; do
  [ -d "$skill" ] && ln -sf ~/.agents/skills/"$(basename "$skill")" ~/.claude/skills/
done

# 4. Codex CLI (~/.codex/skills)
mkdir -p ~/.codex/skills
for skill in "$REPO_ROOT"/skills/*; do
  [ -d "$skill" ] && ln -sf ~/.agents/skills/"$(basename "$skill")" ~/.codex/skills/
done
```

---

## 🛠️ 生态项目关联 (Ecosystem)

- [zzhub-pipeline](https://github.com/aatrooox/zzhub-pipeline)：基于 Bun 与状态机的内容发布核心引擎与 CLI 工具。
- [milkdown-article-plugins](https://github.com/aatrooox/milkdown-article-plugins)：公众号富文本 Remark / Milkdown 语法扩展包。
- [milkdown-article-style](https://github.com/aatrooox/milkdown-article-style)：跨端统一的文章排版样式与 CSS Design Tokens。

---

## 📄 开源许可 (License)

[MIT License](LICENSE)
