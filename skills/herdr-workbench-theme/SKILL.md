---
name: herdr-workbench-theme
description: >-
  配置 herdr TUI 的工作台主题：akairos-design 品牌紫配色（深色，可选跟随明暗）、
  侧栏 agent / 空间行布局、侧栏中的「目录 · 分支」自定义字段、标签栏、通知、
  弹窗快捷键，并让 Ghostty 配色与之一致。用户要美化或调整 herdr 界面、
  统一 herdr 与终端配色、让多会话侧栏更易看管时使用。
  只在 macOS + Ghostty 上测试过，其他终端和系统未验证。
  不用于通过 herdr CLI 控制窗格或 agent（那是 herdr skill）。
---

# herdr 工作台主题

把 herdr 配成「中性黑白灰 + 品牌紫」的多会话看管工作台，并让 Ghostty 与之同色。

> [!IMPORTANT]
> **测试范围**：本配置只在 **macOS + Ghostty 1.4.0 + herdr 0.9.5** 上测试过。
> 其他终端（iTerm2、WezTerm、Kitty 等）、Linux、Windows 均未验证；
> 颜色令牌在界面中的具体位置、部分行为（见 `references/tokens-and-limits.md`「未验证」）也只是推断。
> 在其他环境使用时，先告知用户这一点，并让用户目测确认。

## 何时使用

- 用户要改 herdr 配色、侧栏、标签栏、通知或快捷键
- 用户希望 herdr 与 Ghostty（或其他终端）看起来是一套
- 用户同时开很多 agent 会话，想一眼看出每个会话在哪个目录、哪个分支

## 前置检查

1. `herdr --version`。本配置按 0.9.5 验证；版本差异大时，以 `herdr --default-config` 的输出为准，它是当前版本配置项的权威来源。
2. 配置文件是 `~/.config/herdr/config.toml`。**修改前一律先备份**，文件名带时间戳。
3. 热加载用 `herdr server reload-config`，返回 `"diagnostics":[]` 表示配置被接受。
   这条命令会改变用户正在看的界面，在 herdr 窗格内才执行；不在窗格内时，告诉用户自己执行。
4. 不要运行不带子命令的 `herdr`（会启动或附着 TUI），不要 `herdr server stop`。

## 配置流程

按顺序做，每一步都先备份、改完热加载、让用户看效果，再进下一步。

### 1. 颜色（herdr）

把 `references/herdr-config.toml` 的 `[theme]` 与 `[theme.custom]` 合并进用户配置。

- `auto_switch = false` 时**只有顶层 `[theme.custom]` 生效**，`[theme.custom.dark]` / `[theme.custom.light]` 会被忽略。
  默认就是固定深色；用户要跟随系统明暗，改 `auto_switch = true`，此时顶层作深色基础，`[theme.custom.light]` 叠加浅色。
- 令牌共 19 个，取值与来源见 `references/tokens-and-limits.md`。
- 不要覆盖用户已有的无关配置（如 `onboarding`、已有 `[keys]`）。

### 2. 界面结构（herdr）

合并模板的 `[ui]` 与 `[ui.sidebar.*]`：

- 窗格：`pane_borders = "always"`、`status_indicators = "symbols"`
- 侧栏加宽到 40（最小 30、最大 52），给「目录 · 分支」留位置
- 标签栏：**始终显示**（`hide_tab_bar_when_single_tab = false`）。隐藏后单标签空间没有「+ new tab」入口，界面不一致，不推荐隐藏。
- agent 行三行：`状态图标 + 项目名 + 状态文字` / `$loc` / `终端标题`
- 空间行两行：`状态图标 + 项目名` / `分支 + git 状态`（`git_status` 仅在有改动或领先落后时才出现）
- 通知：`delivery = "herdr"`，只在 herdr 内弹提示

herdr 的 `rows` 只能决定每行放哪些字段，**没有靠右对齐**，状态文字只能跟在项目名后面。

### 3. 侧栏「目录 · 分支」（可选，需用户同意）

内置字段只显示工作区创建时的目录，同一空间内多个 tab 切到别的目录后不会更新。解决方式是用自定义字段 `$loc` 给**每个窗格**单独上报。

1. 把 `references/report-location.sh` 复制到 `~/.config/herdr/report-location.sh` 并 `chmod +x`。
2. 手动在一个窗格里运行一次，`herdr agent get <pane_id>` 能看到 `"tokens":{"loc":"目录 · 分支"}` 即通。
3. **向用户展示** `references/zshrc-hook.zsh` 的内容，**获得同意后**才追加到 `~/.zshrc`（先备份 `.zshrc`）。
   钩子只在 `HERDR_ENV=1` 时生效，对其他终端无影响。
4. 提醒用户：钩子只对**之后新开的 shell** 生效；已有窗格要 `source ~/.zshrc` 或重开。

限制：钩子在回到提示符时触发。进入 Codex / Claude 等 agent 之后在其内部切目录，侧栏不会更新。

### 4. 去掉 Codex 标题里的目录后缀（可选，需用户同意）

Codex 默认把项目名写进终端标题，侧栏第三行会出现 `任务标题 | 项目名`，被截断时很碍眼，且与 `$loc` 重复。
在 `~/.codex/config.toml` 的 `[tui]` 下加：

```toml
terminal_title = ["thread-title"]
```

- 只对**新开的 Codex 会话**生效。
- 改后用 `codex doctor` 确认 `config loaded`。注意 macOS 没有 `timeout` 命令，别用它包裹。
- 可选项名取自 Codex 程序内部（`thread-title`、`project-name`、`current-dir`、`git-branch` 等），没有官方文档；只用最保守的 `thread-title`。

### 5. Ghostty 配色（macOS + Ghostty 已验证）

把 `references/ghostty-colors.conf` 追加到 `~/.config/ghostty/config`（先备份）。
窗格里的内容由终端的配色决定，herdr 管不到；不同步的话，窗格背景与侧栏会有色差。

- 校验：`/Applications/Ghostty.app/Contents/MacOS/ghostty +validate-config`，无输出即通过。
- 生效：在 Ghostty 里按 `Cmd+Shift+,` 重载。
- 用其他终端的用户，按同样的 16 色与背景/前景/光标/选区值自行转写；本 skill 没有验证过。

### 6. 弹窗快捷键（可选）

模板里有 `lazygit`、`btop` 两个 `[[keys.command]]` 弹窗示例（`prefix+alt+g`、`prefix+alt+b`）。
需要用户已安装对应工具，且路径按本机调整（Apple Silicon 的 Homebrew 在 `/opt/homebrew/bin`）。**这两个弹窗只验证了配置被接受，没有实际按键试过。**

## 验证

1. `herdr server reload-config` 的 `diagnostics` 为空。
2. 让用户目测：侧栏配色、行布局、分支是否被截断、没有 `$loc` 的旧会话那一行是空着还是消失。
3. 不要宣称视觉验收通过；以用户确认为准。

## 回滚

每次修改前的备份文件 `config.toml.backup-<时间戳>` 直接复制回原文件，再 `herdr server reload-config`。
撤掉「目录 · 分支」：删除 `~/.zshrc` 末尾钩子，并把 herdr 配置里的 `["$loc"]` 行去掉。

## 参考

- `references/herdr-config.toml` — herdr 配置模板（颜色、结构、通知、快捷键）
- `references/ghostty-colors.conf` — Ghostty 配色片段
- `references/report-location.sh` — 「目录 · 分支」上报脚本
- `references/zshrc-hook.zsh` — zsh 钩子
- `references/tokens-and-limits.md` — 令牌表、侧栏可用字段、已知限制与未验证项
- 配色来源：npm 包 `@akairos/design`（品牌紫 `#750EE4` 浅色 / `#AD7AEE` 深色）
