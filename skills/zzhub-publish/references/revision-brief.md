# 内容修订 Brief 构建指南

当 `next_action.action` 为 `revise-content` 时，按 `next_action.params.feedback` 修订。`redo.style` 可能只有用户的文风要求而没有审核反馈；结合原始需求处理，缺少实质要求时才询问。可委派也可由主 Agent 完成。

## 构建修订 Brief

主 Agent 读取 `source_body_path` 的正文，与 `feedback` 一起构建修订 Brief。

Brief 应包含：
- 原始正文内容
- 具体的修改意见（来自 `feedback`）
- 用户确认的风格、改写权限和本次涉及的 [语法要求](../../milkdown-writing/SKILL.md)，保留事实与不确定程度，不自动追加导读、引流或封面关键词行。

## Spawn Sub-agent

有可用且允许的委派能力时，仅传原文、反馈、必要事实来源和格式要求；否则直接执行修订，不引入工具依赖。

## 交稿流程

检查修改覆盖反馈点且不夹带交稿元信息，将正文保存为文件再挂载；标题或封面词变化单独在后续 `prepare` 更新：

```bash
zzp attach-body --state "{state_path}" --body "{revised_body_md}"
zzp status --state "{state_path}" --view agent
```

`attach-body` 会使格式化、审核和渲染结果失效；下一步通常先 `prepare`，再按审核策略继续，不能跳过状态输出直接 finalize。
