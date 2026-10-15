# 正文样式与图片插件

核对日期：2026-10-15，基线 Pipeline 0.19.0、myno 0.3.0、Typeset Studio 0.2.6。先确认已安装版本及用户当前配置；普通发布沿用配置，不为一次发文自动切换全局插件。

## 选择入口

| 需求 | 入口与职责 |
| --- | --- |
| 写作语法、卡片与徽章 | [milkdown-writing](../../milkdown-writing/SKILL.md)，只约束 Markdown 写法 |
| 独立调正文样式、导出 JSON、复制富文本 | [myno](https://github.com/k7airos/myno)，不需要 Pipeline、微信账号或无头浏览器 |
| Pipeline 中调正文样式 | `zzp wechat-preview studio`，按已配置的 Markdown 插件选择工作台 |
| 正文导出微信 HTML | `plugins.markdownRenderer`；myno 提供浏览器资源，Pipeline 管理 Chrome、模板校验与文件输出 |
| 封面、卡片和多页 PNG | `plugins.imageRenderer`；Typeset Studio 使用原生 Canvas，不需 Chrome 或独立服务授权 |

myno 和 Typeset Studio 互不依赖；Pipeline 的两个插件分别选择，未配置或为 `null` 时保留各自内置实现。没有 `zzp run` 命令，也没有必须安装的 `typeset-studio` 同名 Skill。

## 已配置的插件

只读检查所需字段：

```bash
zzp config --key plugins.markdownRenderer
zzp config --key plugins.imageRenderer
```

用户要求启用时，将对应片段合并到现有配置，保留账号凭据和其他字段：

```json
{
  "plugins": {
    "markdownRenderer": { "module": "@akairos/myno/adapter", "options": {} },
    "imageRenderer": {
      "module": "@akairos/typeset-studio/adapter",
      "options": { "dataDir": "/absolute/path/typeset-data" }
    }
  }
}
```

Pipeline 0.19.0 可选安装 myno 0.3.0，仍需显式配置；省略可选依赖时应自行提供可解析的包。myno 的 `browser()` / `studio()` 只返回包内资源路径，不引入 Playwright/Puppeteer，不启动 Chrome 或 HTTP 服务。Pipeline 调用 Typeset Studio 的本地 npm 方法，不需要 `TYPESET_STUDIO_URL` / `TYPESET_ADMIN_KEY`，并会屏蔽这两个远程模式变量。

Typeset 的 `options.dataDir` 按配置文件目录解析，桥接到插件子进程 `TYPESET_DATA_DIR`；已有非空环境变量优先。模板、默认槽位、上传图片保存在该目录，不在 npm 包中；独立工作台使用同一目录，避免更换包后丢失个人数据。

## myno 独立与宿主模式

独立模式从源码工作台启动，npm 包没有独立 Studio CLI：

```bash
git clone https://github.com/k7airos/myno.git
cd myno
bun install
bun run dev
```

打开 `http://localhost:5173/src/studio/studio.html`。本地默认主题、语法说明与示例随包提供；可导入/导出配置和复制富文本。无宿主接口时隐藏账号保存与历史。`/api/studio/config` 成功后优先采用宿主配置；迟到配置不覆盖正在编辑的正文。剪贴板能力取决于浏览器权限与安全上下文。

Pipeline 模式执行 `zzp wechat-preview studio`，默认 `http://127.0.0.1:18765/studio`；宿主提供配置保存和历史接口。更换插件后重启已有预览服务。服务可写本机配置，不作为无鉴权公网入口。

应用只复用 `MynoEditor` 时，`styleConfig` / `applyStyleConfig()` 接受 `editorVars`、`exportTheme`、`syntaxPresets`；不代表完整支持导出 JSON 的 CSS 与页首结构，也不自动建立业务配置 API。

## 独立正文样式 JSON

工作台的「导出配置」生成不绑定账号的 `wechat-style.json`；「保存至账号」只在宿主模式写入本机账号样式。样式 JSON 不包含 AppID、AppSecret 或 PAT。

```bash
zzp article-theme --path "{style_json}"
zzp wechat-export --markdown "{body_md}" --out "{article_html}" \
  --article-theme "{style_json}" --no-preview --summary-only
```

任务创建时用 `init --article-theme`，已有任务可用 `publish --article-theme` 明确切换。账号默认使用 `wx.accounts.<account>.articleTheme`，相对路径基于配置文件目录；显式 CLI 路径相对当前目录。独立 JSON 使用自身样式，不叠加账号 `theme/customCss`，显式导出 `--custom-css` 仍可追加覆盖；目录模板保留账号覆盖顺序。账号已引用独立 JSON 时，应导出修改后的文件并替换来源，而非保存不会生效的账号覆盖。

只调样式或本地预览不创建发布任务、不上传素材、不调用 `publish`。独立 JSON 与封面模板是两套配置，不能混用字段。文件与 CSS 的离线限制以 [正文模板契约](https://github.com/k7airos/zzhub-pipeline/blob/main/ARTICLE-THEMES.md) 为准。

## 封面模板与固定素材

任务处于 render 时可按用户选择指定 Studio 模板：

```bash
zzp render --state "{state_path}" \
  --studio-cover-template "{cover_template_id}" \
  --studio-content-template "{content_template_id}" \
  --template-images-file "{image_overrides_json}"
```

只传本次需要的参数；单篇文章封面不必指定内容模板。显式模板优先于槽位默认；有效 Studio 模板样式优先于 Pipeline 封面主题。`prepare --highlight-words` 是可选封面输入，未传时 `prepare-finalize` 从标题提取；模板是否显示高亮由模板决定，不在正文追加关键词行。

图片替换文件分别使用 `cover` / `content` 对象，以 `templateAssetKey` 指定素材。固定图与普通正文配图分开，每页重复仅支持自由定位；只复制模板 JSON 不会迁移 `/uploads/...` 图片。详见 [Typeset Studio](https://github.com/k7airos/typeset-studio#readme)。

## 运行时部署包

仅在用户要求同步配置/素材时使用：

```bash
zzp typeset-assets-sync --dry-run --output "{runtime_output}"
zzp typeset-assets-sync --output "{runtime_output}"
```

此命令需要配置 Studio 数据目录和模板；不是纯 Markdown 样式的独立打包器。正式执行会上传引用素材至 COS，备份并回写模板，再收集模板槽位和账号引用的正文样式；先读 dry-run 再执行。输出不含业务凭据，不会自动部署服务器。Markdown 插件只导出 `null` 或 myno npm 入口及空 options，本机插件路径不会进入包。自托管 Worker 还需安装目标插件版本并消费运行时资产，见 [配置同步指南](https://github.com/k7airos/zzhub-pipeline/blob/main/docs/visual-studio-and-config-sync.md)。
