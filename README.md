# kairos-skills

Official Agent Skills for the Kairos & `zzhub-pipeline` publishing ecosystem.

本仓库汇集了与 Kairos 内容发布流水线（[`@akairos/pipeline`](https://github.com/k7airos/zzhub-pipeline)）、[myno 正文工作台](https://github.com/k7airos/myno)、[Typeset Studio 图片渲染器](https://github.com/k7airos/typeset-studio)、[Milkdown 语法插件](https://github.com/k7airos/milkdown-article-plugins)和[正文样式](https://github.com/k7airos/milkdown-article-style)配套使用的 AI Agent 技能。

也维护可独立使用的通用知识库协议；公共 Skill 不包含用户知识、真实路径、账号或私有配置。

---

## 📦 技能清单 (Skills Catalog)

| Skill | 目录 | 适用场景与主要功能 |
| :--- | :--- | :--- |
| **`knowledge-vault`** | [`skills/knowledge-vault/`](skills/knowledge-vault/SKILL.md) | 通用 Markdown / Obsidian 知识库检索、复用和渐进沉淀。以独立 Vault 策略隔离个人与组织，支持简单更新、Git 内容同步、TODO / handoff 和已授权的周期回顾；真实注册表与知识内容留在用户环境。 |
| **`milkdown-writing`** | [`skills/milkdown-writing/`](skills/milkdown-writing/SKILL.md) | **正文语法与微信导出规则**<br>按 myno / Pipeline 共享语法写作和整理 Markdown，按需使用导读、互动卡、Callout、高亮、快捷键与徽章；与样式配置、封面渲染和发布操作分工明确。 |
| **`zzhub-publish`** | [`skills/zzhub-publish/`](skills/zzhub-publish/SKILL.md) | **内容发布任务编排**<br>按 `status → next_action` 准备正文、审核修订、渲染并写入草稿箱，也支持博客和多目标。包含 myno 可选正文插件、独立样式 JSON、Typeset 本地插件、运行时素材及失败恢复说明。 |
| **`auto-ai-daily`** | [`skills/auto-ai-daily/`](skills/auto-ai-daily/SKILL.md) | **AI 资讯自动草稿流程**<br>使用 AIHOT v1 API 获取最近 24 小时最多五条精选，基于可核验来源写稿，自检后按状态机串行写入指定公众号草稿箱；不创建定时任务、不群发。 |

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
