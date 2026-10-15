# Changelog

本 Skill 的方法论变更记录。规则与流程见 SKILL.md 与 references/；本文件只记"为什么改、改了什么"。

## 2026-10-15 通用开源维护与简单更新

- 保留单一Skill，通过独立Vault和策略隔离个人/组织；真实路径、名称、账号及调度计划留在用户环境。
- 来源已核验的小更新可按auto-verified直接维护正式页；消除“只读应用必须写入”和“所有更新必先进Inbox”的矛盾。
- 新增Git闭环与TODO/handoff规则，补查相关工作区漂移；在途阶段与正式结论分开，允许逐步沉淀。
- 用户授权的Skill修订走源码仓差异、校验和Git提交；不再为每次已授权修订增加元候选审批。
- 触发证据：实际使用中发现知识页已要求提交但Skill流程未衔接，正在开发的内容缺少交接位置，重复候选流程增加日常成本。旧记录保留为历史方法，不再是现行流程。

方法参考：[Astro-Han/karpathy-llm-wiki](https://github.com/Astro-Han/karpathy-llm-wiki) 的来源与派生知识分离、渐进检索和持续维护思想。此Skill为重新组织的访问/维护协议，不声称直接fork或已知某个上游修订；原始结构约束参考skill-creator方法。

## 2026-08-28 知识应用模式（元候选首次自更新）

- 新增 `references/apply.md` 与 SKILL.md"应用与复用"操作模式：开工前从 INDEX → 相关项目卡加载复用资产、既定约定、决策经验；沿用要显式注明出处，偏离必须给理由；任务产出闭环沉淀。
- 触发证据：用户实际沉淀一个项目的设计资产后发现，Skill 只有查询与写入两种模式，"新开项目时如何借助知识库保证符合以往要求"没有指引（查询只回答"是什么"，不回答"这次该怎么做"）。

## 2026-08-28 项目沉淀规范与 Skill 自更新机制

- 新增 `references/project.md`：项目知识三层结构（PROJECT.md 项目卡、business/ 业务页、architecture/ 架构页）、渐进读取规则、各层字段清单、代码锚点（`路径::符号名` + pinned commit drift check）、个人/公司 Vault 差异表、项目沉淀流程。
- `references/write.md` 新增"项目沉淀"入口与"元候选与 Skill 自更新"：方法论问题以 target `<vault前缀>.meta.knowledge-vault` 进 inbox，晋升目标为 Skill 文件本身，经 skill 补丁 + CHANGELOG + vault log 完成；涉及不变量/路由/跨库边界的修改必须显式授权。
- `SKILL.md`：操作模式接入 project.md；不变量补充 Skill 文件在自更新时是被修订对象而非证据。
- `references/init.md`：最小结构注明项目知识位于 `knowledge/projects/`。

触发背景：实际沉淀需求中发现 Skill 只规定流程协议，缺少"项目该写什么"的模板；架构层内容量大，需要渐进读取避免白占上下文；方法论改进此前没有出口，全靠 Agent 自觉。
