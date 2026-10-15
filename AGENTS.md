# AGENTS.md — kairos-skills

本文件为在此代码仓库中工作的 AI Coding Assistant（Claude Code、Codex、Antigravity、Amp 等）提供开发和维护准则。

---

## 仓库定位与设计哲学

`kairos-skills` 维护内容发布生态及可独立复用的通用 Skill：
1. **单一事实来源 (Single Source of Truth)**：所有与 pipeline、Milkdown 排版、自动化发文相关的 Skill 必须以本仓库为唯一权威源文件，禁止在各个客户端目录直接分叉拷贝。
2. **零硬编码绝对路径**：Skill 必须可移植至任意用户的机器上运行，文档和命令示例中严禁硬编码本机私有路径（如 `/Users/xxx/...`），统一使用 `{workspace}` 占位符或环境变量 `ZZHUB_PIPELINE_WORKSPACE_ROOT`。
3. **结构标准化**：每个 Skill 均在 `skills/<skill-name>/` 下独立维护，必须具备规范的 `SKILL.md`（含完整 YAML frontmatter）。更复杂的规则应抽离至 `references/` 子目录，多 Agent 平台适配配置放置于 `agents/`。

---

## 目录结构契约

```text
kairos-skills/
├── README.md               # 技能总览、各 Skill 简介与全局安装指引
├── AGENTS.md               # 本规范文档
├── LICENSE                 # MIT 许可
├── scripts/
│   └── link-skills.sh      # 一键链接技能到各全局目录的 Shell 脚本
└── skills/
    ├── milkdown-writing/   # Milkdown 自定义语法与微信导出规则
    │   ├── SKILL.md
    │   ├── agents/
    │   └── references/
    ├── zzhub-publish/      # zzhub-pipeline CLI 状态机编排
    │   ├── SKILL.md
    │   └── references/
    └── auto-ai-daily/      # AI 日报无人值守自动化流水线
        └── SKILL.md
```

---

## ⚠️ 核心注意事项与 Agent 强制行为规范

### 1. 全局目录链接

> [!IMPORTANT]
> 新增、重命名或迁移 Skill 时检查以下全局入口。用户已经要求安装、迁移或持续同步时直接执行，不重复确认；已有正确软链接的内容更新自然生效，无需重新链接。未获授权时询问是否安装：
> - `~/.agents/skills/`（Amp、统一 Agent 中枢）
> - `~/.codex/skills/`（Codex CLI / OpenAI）
> - `~/.claude/skills/`（Claude Code）
> - `~/.gemini/config/skills/`（Antigravity / Gemini CLI）
>
> 软链接规范：
> 1. `~/.agents/skills/<name>` 作为主要落脚点，软链接至 `<repo_root>/skills/<name>`。
> 2. `~/.gemini/config/skills/`、`~/.claude/skills/`、`~/.codex/skills/` 软链接至对应技能目录。
> 3. 只处理本次目标。遇到非软链接的已有目录先比较并保全，不用 `ln -sf` 假装已经替换目录；有冲突停止。无冲突的新入口可直接创建软链接。

### 2. 新增与维护 Skill 的核验清单

- [ ] `SKILL.md` 的 YAML frontmatter 包含简明准确的 `name` 与 `description`。
- [ ] 详细长文与对照表拆入 `references/*.md`，避免 `SKILL.md` 体积过大影响 Agent 效率。
- [ ] 检查全文是否有绝对路径硬编码，确保示例命令可泛化。
- [ ] 同步在 `README.md` 中的「技能清单」更新条目与概括说明。
- [ ] 废弃不再需要的 Skill 时，需同步移除全局目录中对应的软链接，避免留下悬空断链（dangling symlink）。
- [ ] 公共协议不包含私有知识内容、真实用户路径、账号或凭据；个人与组织策略留在各自Vault。
- [ ] 每次完成本次变更都检查差异、明确暂存路径、创建commit并推送；不纳入其他会话的已有修改，不强推或amend他人提交。
