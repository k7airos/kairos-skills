---
name: zzhub-publish
description: 编排 zzhub-pipeline CLI 状态机，准备文章或贴图、审核修订并创建或更新微信公众号草稿，也支持博客同步、多目标发布和任务恢复。需要执行或管理发布任务时使用；仅写作语法用 milkdown-writing，仅调样式或导出配置不必创建发布任务。
---

# zzhub-publish — 发布任务编排

Pipeline 负责确定性的状态、渲染和发布，Agent 负责正文、事实核验、审核与修订。微信 `publish` 创建或更新草稿，不群发；博客路由执行配置的发布命令。执行到用户指定的终点：只预览时不调用 `publish`，已有发布授权不重复询问。

## 环境与工作区

- CLI 使用 Bun：`bun add -g @akairos/pipeline`。先用 `zzp --version` / `zzp --help` 核对已安装能力；本指南以 Pipeline 0.19.0 为基线。源码命令与全局安装包可能不同。
- 工作区优先采用用户指定路径，再查 `ZZHUB_PIPELINE_WORKSPACE_ROOT`、`zzp config --key paths.workspaceRoot`；无法确定才询问。示例中的 `{workspace}`、`{state_path}` 必须替换为实际路径并加引号。
- 使用已确认的账号键，按需读取 `wx.defaultAccount` 和账号显示名。不要把“大号/小号”硬编码到某个个人账号，也不要输出凭据或使用 `config --raw` 探查配置。
- 微信写草稿依赖兼容的 `/api/v1/wx/*` 中转服务、账号凭据和 PAT；Pipeline 不直连微信官方 API。仅本地排版不需要微信凭据。

## 核心循环

1. 用户给出 state 或 handoff 时使用它；否则 `zzp find-run --workspace "{workspace}" --active --view agent` 查找相关任务。无匹配会报 `No matching task found`，不是返回空列表；多个候选用 `tasks` 和账号/标题过滤定位，不接续无关任务。
2. 没有对应任务才 `init`；已有交接 JSON 用 `ingest-handoff`。
3. `zzp status --state "{state_path}" --view agent`，读取 `next_action`、`gaps`、`blockers`。
4. 只执行当前动作；每步后重新 `status`。`prepare-finalize` 后使用返回的规范 `state_path`，正文存于 `asset_path/post.md`。
5. 达到用户终点或 `complete` 时报告结果；遇到缺少素材或未解决的失败，保留原 run 和原因。

不手写 `workflow-state.json`，也不靠猜测串行执行整套命令。CLI 不内置 LLM，`review` 只记录判断。`params.spawn` 是编排建议；有可用且获准的委派能力时可交给子代理，否则主 Agent 按相同要求执行。

## 当前动作

| 动作 | 处理方式 |
| --- | --- |
| `attach-body` | 已有正文直接挂载文件；需写作时读 [写稿参考](references/writing-brief.md)，按 `worker_mode`、调研与改写权限生产正文 |
| `prepare` / `prepare-finalize` / `render` / `publish` | 执行 `next_action.command`；填实占位符。标题和封面词在 `prepare` 传入，模板与样式见 [排版接入](references/rendering.md) |
| `review-content` | 读 [审核参考](references/content-review.md)，核验正文后记录 `passed` 或具体的 `needs_revision` 反馈；明确的 `trust_user` 策略按状态输出处理 |
| `revise-content` | 读 [修订参考](references/revision-brief.md)，按 feedback 修改并重新挂载；之后通常先 `prepare` 再审核，以状态为准 |
| `attach-body-images` | 读取 `required_inputs`，已有真实素材可直接挂载；缺失时向用户取得，不编造图片路径 |
| `reset-or-repair` / `resolve-handoff` / `checkpoint` | 先执行只读 `checkpoint` 诊断，再按失败阶段恢复，见下文 |
| `complete` | 报告标题、账号/路由、规范 state 路径及各目标结果；微信成功项给出 `external_id`（草稿 media_id） |

写作或修订微信公众号正文时参考 [milkdown-writing](../milkdown-writing/SKILL.md)。组件按内容需要使用，不强制每篇加入导读、引流、徽章或高亮；文风服从用户。用户要求润色时可用当前环境可用的文风技能，不为流程自动安装新技能。

## 创建与交接

从用户已有需求提取内容、账号与目标；仅缺少必要信息才询问。

```bash
zzp init --workspace "{workspace}" --task-kind publish \
  --content-form article --content-origin user --targets wechat \
  --account "{account}" --intent-text "{用户需求}"
zzp status --state "{state_path}" --view agent
```

外部素材用 `--content-origin external`；仅整理稿件用适合的非 publish 任务类型。贴图用 `--content-form newspic`，按需在 render 前 `attach-newspic-spec`。博客-only 路由跳过 render。可选参数：

- `--article-theme "{style_json_or_theme_dir}"`：正文样式，与发布账号分离。
- `--existing-draft-media-id "{media_id}"`：更新已确认的现有草稿。
- `--note-id "{note_id}"`：关联调用方笔记标识；不是所有宿主都提供回调。

已有正文文件时可写交接 JSON；`body_path` 使用实际绝对路径，`target_account` 替换为已确认的配置键：

```json
{
  "workflow_handoff": {
    "mode": "new",
    "content_form": "article",
    "body_path": "/abs/path/body.md",
    "target_account": "ACCOUNT_KEY",
    "title": "文章标题",
    "user_intent_text": "将这篇文章写入指定公众号草稿箱",
    "review_policy": "required"
  }
}
```

```bash
zzp ingest-handoff --workspace "{workspace}" --file "{handoff_json}"
zzp status --state "{state_path}" --view agent
```

从 `accepted_handoff.state_path` 或 `summary.state_path` 取得 ingest 后的实际路径，不假定所有命令都在 JSON 顶层返回 `state_path`。

`trust_user` 只用于调用方明确批准的正文，不因来自用户或为了绕过阻塞而自行启用。它不省略 `prepare`。继续原任务用 `workflow_handoff.mode="resume"` 和 `state_path`；正文、标题或路由改变会使派生结果失效，重新读状态。原 `publish_handoff` 简化格式仍支持，但字段契约不同，先核对已安装版本。

## 恢复与验证

- 确定性的本地错误（文件、字体、模板、插件缺失）修好后读状态；图片 render 失败可 `reset --mode render`，正文修改重新 `attach-body`。不要自动切模板、改插件或清空数据。
- 发布超时、`WX_RESULT_UNKNOWN`、Worker `interrupted` 或网络断连时，先查原 run 的结果和目标草稿箱。不能认定失败就没有写入，不能自动换幂等键或创建新任务。
- `reset --mode publish` 会更新请求幂等身份，只能在核对草稿并确认重试后使用。`reset --mode full` 是放弃原任务，不是通用修复；放弃需符合用户意图。
- 任务完成不等于每个外部目标都已验收。需要真实验收时，从微信草稿箱回读标题/内容，并分别报告本地产物、草稿写入与回读结果。

```bash
zzp wx-drafts --account "{account}" --limit 10
zzp wx-drafts --account "{account}" --media-id "{media_id}"
# 仅在用户要求清理指定草稿时执行
zzp wx-draft-delete --account "{account}" --media-id "{media_id}"
```

不因完成测试自动删草稿；草稿管理命令不依赖创建发布任务。

## 多目标与追加发布

创建多目标任务时使用真实账号键：

```bash
zzp init --workspace "{workspace}" --task-kind publish \
  --content-form article --content-origin user \
  --targets "wechat-article@{account_a},wechat-article@{account_b},blog@{blog_account}"
```

已有产物且审核通过后，可用 `republish` 追加目标；按 route+account 和产物版本做幂等过滤，结果写入 `publish.results`，不改变原 mode。它不是修改正文后的重新排版入口。带 `existing_draft_media_id` 的任务不能把该草稿 ID 用到另一个微信目标。

```bash
zzp republish --state "{state_path}" --account "{other_account}" --dry-run
zzp republish --state "{state_path}" --account "{other_account}"
```

## 云端边界

自托管 Worker 是 Pipeline 源码仓库中的独立服务，不包含在 npm CLI 包内。应用后端提交已确认的 `article/newspic` 正文，Worker 串行执行支持的 CLI 动作；它不替 Agent 调研、写稿或修订。后端负责用户与账号归属，服务令牌不下发浏览器。轮询有步骤、结果和可选当前动作进度；本机 Monitor 的 HTTP/SSE 是另一套接口。接入或部署时查 [Worker 契约](https://github.com/k7airos/zzhub-pipeline/blob/main/services/cloud-worker/README.md)，单纯发文不改生产配置或部署。
