# 内容审核 Brief 构建指南

当 `next_action.action` 为 `review-content` 时，主 Agent 应 spawn sub-agent 进行独立审核，保持审核的客观性并避免主上下文污染。

## 构建审核 Brief

主 Agent 构建审核 Brief：读取 `source_body_path`（或 `formatted_body_path`，如果存在）的正文，连同以下审核标准一起交给 sub-agent。

## Spawn Sub-agent

使用 `Agent` 工具 spawn sub-agent（类型选择 `general-purpose`），prompt 中只包含正文内容和审核标准，不包含主对话上下文。

## 审核标准

**写入 sub-agent prompt：**

1. **AI 味检测**：是否读起来像 AI 生成？警惕：过于流畅的过渡句、空洞的总结、无意义的最高级形容词、公式化的结构、缺乏具体细节或个人声音。
2. **标题质量（60% 权重）**：标题是否有悬念、冲突感或陌生感？是否让人产生好奇心？还是平淡的陈述句？好标题应该让人看完就想点进来。同时避免标题党。
3. **陌生感与讲故事**：文章是否用讲故事的方式展开？是否有场景、冲突、转折？是否把熟悉的事物用新鲜的角度呈现出来？还是平铺直叙地罗列功能？
4. **事实准确性**：文章中的说法、日期、人名、技术细节是否准确？标记任何看起来有问题的内容。
5. **微信适配**：格式是否适合微信阅读？段落是否简短？是否有微信无法渲染的 markdown？字数是否合适（文章 800-3000 字）？
6. **Markdown 结构**：是否正确使用了 `##` 标题划分章节？是否有 `**粗体**` 强调重点？列表和引用格式是否恰当？
7. **Milkdown 扩展语法合规（参考 [milkdown-writing](../../milkdown-writing/SKILL.md)）**：
   - 导读 `[!INTRO]` 与文末 `[!CTA]` 卡片内部每行是否均保持 `>` 引用标记？多段之间是否使用 `>` 空行（避免被普通空行截断为多块）？
   - 提示块（`[!NOTE]`、`[!TIP]` 等）是否使用规范标识？
   - 是否避免了微信不支持的组件（LaTeX 公式、Mermaid 图表、折叠详情块、文内锚点）？
   - 正文末尾是否输出了来自标题的高质量 `**封面高亮关键词**: 词1, 词2`？

## 交稿流程

Sub-agent 返回审核结论（passed / needs_revision）和具体反馈。

主 Agent 根据 sub-agent 返回的结论执行：

- **通过** → 执行：
```bash
zzhub-pipeline review --state {state_path} --status passed
```

- **需要修改** → 执行：
```bash
zzhub-pipeline review --state {state_path} --status needs_revision --feedback "具体修改建议..."
```

反馈必须具体可操作，用中文写，明确指出需要修改的具体段落。
