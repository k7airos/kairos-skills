# herdr 配置项、令牌与已知限制

依据 herdr 0.9.5 的 `herdr --default-config` 与二进制内的字段名。版本变化后以 `herdr --default-config` 为准。

## 主题

- 基础主题 `name`：`catppuccin`、`terminal`（沿用终端配色）、`tokyo-night`、`dracula`、`nord`、`gruvbox`、`one-dark`、`solarized`、`kanagawa`、`rose-pine`、`vesper`。
  二进制中还有 `catppuccin-latte`、`tokyo-night-day`、`gruvbox-light`、`one-light`、`solarized-light`、`kanagawa-lotus`、`rose-pine-dawn`，默认配置注释没列，是否可直接写进 `name` 未验证；`light_name` 用 `catppuccin-latte` 已验证被接受。
- 跟随明暗：`auto_switch = true` 配合 `dark_name`、`light_name`，依赖终端上报外观。
- 颜色值：hex、颜色名、`rgb(r,g,b)`；`panel_bg = "reset"` 使用终端背景。

### 19 个自定义令牌

| 类别 | 令牌 |
| --- | --- |
| 底色 | `panel_bg`、`sidebar_bg`、`surface_dim` |
| 选中/激活 | `active_row_bg`、`selection_bg`、`accent` |
| 层级 | `surface0`、`surface1`、`overlay0`、`overlay1` |
| 文字 | `text`、`subtext0` |
| 语义色 | `red`、`green`、`yellow`、`blue`、`teal`、`peach`、`mauve` |

**各令牌画在界面的哪个位置，官方文档没写**，上表分类按命名推测。

### 与 @akairos/design 的对应

| herdr 令牌 | 深色 | 浅色 | 来源 |
| --- | --- | --- | --- |
| `accent` | `#AD7AEE` | `#750EE4` | `--brand` |
| `panel_bg` | `#0a0a0a` | `#fafafa` | 工作台中性底（`--family-bg` 的黑白灰变体） |
| `sidebar_bg` | `#111111` | `#f5f5f5` | 工作台中性面 |
| `active_row_bg` | `#291c3c` | `#f1e8fb` | `--brand-wash` |
| `selection_bg` | `#3c1777` | `#e6d3fc` | 色阶 900 / 200 |
| `text` / `subtext0` | `#ededed` / `#c4c4c4` | `#171717` / `#404040` | 文字一二级 |
| `mauve` | `#c098f0` | `#6207c5` | `--brand-strong` |
| `red` | `#ff7a80` | `#d13f45` | `--danger` |
| `green` `yellow` `blue` `teal` `peach` | 自选 | 自选 | 包内没有这些语义色 |

深色 `selection_bg` 用较重的紫，若觉得太重，可改成 `#291c3c`。

## 侧栏

- agent 行可用内置字段：`state_icon`、`state_text`、`machine`、`workspace`、`tab`、`pane`、`agent`、`terminal_title`、`terminal_title_stripped`。
  **没有时间、已空闲时长、当前目录、分支字段。** `agent` 对未命名的 agent 显示自动生成的名字（如 `codex-503c6b4c`），价值低。
- 空间行内置字段：`state_icon`、`state_text`、`workspace`、`branch`、`git_status`。空间行的目录与分支取自工作区创建时的位置，不随 tab 内 `cd` 更新。
- 自定义字段：通过 `herdr pane report-metadata <pane_id> --source ID --token NAME=VALUE`（窗格级）或 `herdr workspace report-metadata`（工作区级）上报，在 `rows` 里写 `"$NAME"` 引用。
  需要有触发更新的机制（本 skill 用 zsh `precmd` 钩子）。
- `rows` 没有靠右对齐，也没有 worktree 目录字段；分支名在多 worktree 场景下是区分会话的有效依据。

## herdr 自己的 worktree

右键菜单 / `new_worktree` 快捷键（默认 `prefix+shift+g`）对应 `herdr worktree create`，会建 git worktree 并作为链接工作区打开；默认目录 `~/.herdr/worktrees`，可用 `[worktrees] directory` 修改。
这是按 CLI 与默认配置推断的，没有实际点击验证。

## 标签栏

- `tab_bar_right` 条目类型：`zoom`、`hostname`、`datetime`（`format`）、`text`、`command`（`interval_seconds`、`timeout_seconds`）。官方没给示例，`{ type = "datetime", format = "%H:%M" }` 的写法从字段名推出，配置被接受，但屏幕上是否显示需用户确认。
- 新 tab 沿用当前窗格目录由 `new_cwd = "follow"`（默认）决定；创建时是否询问名字由 `prompt_new_tab_name`（默认 `true`）决定。
- 新建 tab：`prefix+c`（默认前缀 `Ctrl+b`）。

## 已知限制与未验证

- **测试范围**：仅 macOS + Ghostty 1.4.0 + herdr 0.9.5。
- 令牌的界面位置、自定义字段在 herdr 重启后是否保留、没有 `$loc` 的会话那一行如何显示：未验证，需用户目测。
- 在 agent（Codex / Claude）内部切目录，`$loc` 不会更新。
- 弹窗快捷键（lazygit / btop）只验证了配置被接受，没有实际按键。
- 窗格内容的颜色由终端决定，herdr 配色不影响它。
