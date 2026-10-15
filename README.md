# kairos-skills

Official Agent Skills for the Kairos & `zzhub-pipeline` publishing ecosystem.

本仓库汇集了与 Kairos 内容发布流水线（[`@akairos/pipeline`](https://github.com/k7airos/zzhub-pipeline)）、[myno 正文工作台](https://github.com/k7airos/myno)、[Typeset Studio 图片渲染器](https://github.com/k7airos/typeset-studio)、[Milkdown 语法插件](https://github.com/k7airos/milkdown-article-plugins)和[正文样式](https://github.com/k7airos/milkdown-article-style)配套使用的 AI Agent 技能。

也维护可独立使用的通用知识库协议；公共 Skill 不包含用户知识、真实路径、账号或私有配置。

---

## 📦 技能清单 (Skills Catalog)

| Skill | 目录 | 适用场景与主要功能 |
| :--- | :--- | :--- |
| **`knowledge-vault`** | [`skills/knowledge-vault/`](skills/knowledge-vault/SKILL.md) | 通用 Markdown / Obsidian 知识库检索、复用和渐进沉淀。以独立 Vault 策略隔离个人与组织，支持简单更新、Git 内容同步、TODO / handoff 和已授权的周期回顾；真实注册表与知识内容留在用户环境。 |
| **`milkdown-writing`** | [`skills/milkdown-writing/`](skills/milkdown-writing/SKILL.md) | **Milkdown 写作排版规范**<br>按当前 Nezus / Pipeline 接入的 Milkdown 扩展语法撰写与校验 Markdown。涵盖篇章导读卡片（`[!INTRO]`）、文末引流/互动卡片（`[!CTA]`）、标准提示块（`NOTE`/`TIP`/`WARNING` 等）、行内高亮（`==文本==`）、快捷键徽章（`[[kbd:Cmd]]`）、彩色标签（`[badge:brand\|文本]`）以及微信 HTML 安全导出规则。 |
| **`zzhub-publish`** | [`skills/zzhub-publish/`](skills/zzhub-publish/SKILL.md) | **内容发布流水线编排**<br>编排 `zzhub-pipeline` CLI 状态机完成微信公众号图文（article）、图文消息贴图（newspic）与博客的多目标发布。**深度联动 `milkdown-writing` 扩展排版语法与 `typeset-studio` 视觉合成插件**，指导 Agent 处理多子 Agent 协作写稿、内容审核（Review）、修改建议反馈（Revision）、图片渲染及草稿发布。 |
| **`auto-ai-daily`** | [`skills/auto-ai-daily/`](skills/auto-ai-daily/SKILL.md) | **全自动每日 AI 日报发文流水线**<br>无人值守自动化流水线。从 AIHOT API 实时抓取今日热门前五条，扩写为 1000-1200 字客观纪实报道，应用 `humanizer-zh` 彻底去除 AI 腔调，并调用 pipeline 直接发布至指定微信公众号。 |

---

## 🚀 安装与使用 (Installation)

各 AI Agent 环境（Amp、Claude Code、Codex、Antigravity / Gemini CLI）通过软链接引用本仓库的技能，保持**单一事实来源（Single Source of Truth）**。

### 一键链接到所有全局 Agent 目录

先克隆公开仓库，再在仓库根目录运行配套脚本。脚本会更新各全局目录中的技能软链接；已有同名目录时，先比较并保全，或按下文只安装单个技能：

```bash
git clone https://github.com/k7airos/kairos-skills.git
cd kairos-skills
./scripts/link-skills.sh
```

已有正确软链接的内容更新会直接生效，不必重新安装。手动安装单个技能时可使用下面的方式；若目标已经存在，先比较并保全，不用 `ln -sf` 覆盖目录：

```bash
REPO_ROOT="$(pwd)"
mkdir -p ~/.agents/skills
ln -s "$REPO_ROOT/skills/zzhub-publish" ~/.agents/skills/zzhub-publish
# 按所使用的 Agent 选择其入口，例如 Codex
mkdir -p ~/.codex/skills
ln -s ~/.agents/skills/zzhub-publish ~/.codex/skills/zzhub-publish
```

---

## 🛠️ 生态与使用者 (Ecosystem)

本仓库的使用者是加载这些 Skill 的 Agent；Skill 是说明和编排规则，不提供模型、不启动发布服务，也不是任何应用的 npm 依赖。

| 项目 | 关系与选择 |
| --- | --- |
| [zzhub-pipeline](https://github.com/k7airos/zzhub-pipeline) | `zzhub-publish` 实际调用的 CLI；用户需安装 Bun 与 `@akairos/pipeline`，按状态机推进。微信 publish 创建/更新草稿，不群发 |
| [myno](https://github.com/k7airos/myno) | 独立编辑、调样式和复制富文本，也可通过 `plugins.markdownRenderer` 接入 Pipeline；不需要 Skill 即可手动使用 |
| [Typeset Studio](https://github.com/k7airos/typeset-studio) | 封面和贴图的可选 `imageRenderer`，Agent 负责准备正文和选择模板，插件负责确定性 PNG 渲染 |
| [Milkdown Article Plugins](https://github.com/k7airos/milkdown-article-plugins) | `milkdown-writing` 语法规则的实现来源，供 myno 和 Pipeline 复用 |
| [Milkdown Article Style](https://github.com/k7airos/milkdown-article-style) | 共用正文 CSS 与变量；Skill 负责遵守语法，具体样式由包和用户配置控制 |
| [Obsidian 微信发布插件](https://github.com/k7airos/obsidian-wechat-publish) | 同一个本机 Pipeline 的 GUI 消费方；正常一键发布不要求 Agent 或本仓库 |

写稿、审核需要 Agent 自己的模型和上下文；已确认正文可直接由 CLI 或私有 Worker 执行。公开包与说明不包含私有应用凭据，不要求访问私有仓库。

---

## 📄 开源许可 (License)

[MIT License](LICENSE)
