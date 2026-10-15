# 初始化与检查

仅在用户要求初始化、迁移或检查知识系统时使用。已有结构和项目约定优先于本文默认值。

## 注册表

位置由 `AGENT_KNOWLEDGE_REGISTRY` 覆盖，默认 `~/.config/agent-knowledge/vaults.yaml`；注册的Vault路径必须是本地绝对路径。示例的ID、名称和路径都需按用户环境设置，不作为Skill固定值。

```yaml
version: 1
vaults:
  - id: personal
    display_name: 个人知识库
    path: /absolute/path/to/personal
    scope: personal
    sensitivity: private
    summary: 个人项目、组件、服务和运行手册。
    write_policy: auto-draft
    promotion_policy: auto-verified
    access:
      preferred: obsidian-cli
      vault_name: personal
      fallback: filesystem
  - id: company
    display_name: 公司业务知识库
    path: /absolute/path/to/company
    scope: company
    sensitivity: confidential
    summary: 公司业务流程、权限、决策和运营知识。
    write_policy: explicit
    promotion_policy: auto-verified
    access:
      preferred: obsidian-cli
      vault_name: company
      fallback: filesystem
```

### 字段规范

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | string，必填 | Vault 唯一标识符，用作知识 ID 前缀（如 `personal.project.xxx`） |
| `display_name` | string，必填 | 面向用户的显示名称 |
| `path` | string，必填 | 本地绝对路径，必须实际存在且不与其他 Vault 嵌套 |
| `scope` | enum，必填 | `personal`（个人）或 `company`（组织/公司）。用于 Vault 选择时按任务上下文匹配，也标识隔离边界 |
| `sensitivity` | enum，必填 | `private`：私有，仅向有权访问者披露。`confidential`：组织机密，仅在组织批准的上下文和环境使用。`internal`：组织内部使用，不等于允许公开；具体披露规则见下文与Vault约定 |
| `summary` | string，必填 | 一句话描述该 Vault 的内容范围，辅助 Vault 选择 |
| `write_policy` | enum，必填 | `read-only`：只读。`explicit`：需要用户当前任务授权或已有明确持续授权才可写入。`auto-draft`：本 Skill 因持久知识任务触发后，可自动记录本次相关耐久事实（即"可自动写入"，不限于草稿——搭配 `auto-verified` 时可直接更新正式页） |
| `promotion_policy` | enum，必填 | `explicit`：候选晋升为正式知识需要用户明确授权。`auto-verified`：来源稳定、目标唯一、无实质冲突时允许自动晋升 |
| `access.preferred` | enum，必填 | `obsidian-cli`：优先使用 Obsidian CLI（需 Obsidian 运行中）。`filesystem`：直接文件系统读写 |
| `access.vault_name` | string | 当 preferred 为 `obsidian-cli` 时必填，值为 Obsidian 中注册的 Vault 名称 |
| `access.fallback` | enum | `filesystem`：CLI 不可用或报错时回退到文件系统。不声明则 CLI 失败时停止操作 |

### 披露与同步边界

- 在获授权的当前对话中，可向有权访问者回答并引用完成任务所需的最少原文；不因标为private就禁止本人查看自己的知识。confidential/internal仍须符合组织的访问和环境规则。
- 已批准的私有Git远端可按该库授权同步，不为每次推送重复确认。sensitivity本身不授予推送权限；不能据此上传到其他服务、公共仓库或新的远端。用户授权也不能替代组织权限。
- 跨库转存的原文、摘要、实体名称、ID和链接都属于披露，须有明确跨库授权并符合来源库策略。改写或只保留引用不自动解除边界；不得把个人库的持续授权套到公司库。

文件系统权限才是访问控制。初始化和每次写入前解析所有注册根目录的真实路径：必须存在、相互唯一且不得嵌套；写入目标解析后必须仍位于所选根目录内。

## 最小结构

仅为全新 Vault 创建：

```text
vault-root/
├── .obsidian/       # 仅 Obsidian 模式需要
├── KNOWLEDGE.md     # 用途、所有权、边界与本地策略
├── INDEX.md         # 按主题路由正式知识
├── AGENTS.md        # 可选，库自己的维护/Git规则
├── TODO.md          # 用户需要任务/交接管理时创建
├── knowledge/       # 正式派生知识；项目知识放 projects/<project-id>/（见 project.md）
├── sources/         # 不可变证据或可检索旁注
├── inbox/           # 候选与晋升审计记录
└── log.md           # 只追加操作日志
```

不要预建复杂分类，也不要在初始化时扫描或导入资产。

### KNOWLEDGE.md 最小模板

```markdown
# <Vault 显示名称>

## 范围
<!-- 收录什么、不收录什么 -->

## 所有权与边界
<!-- 谁维护、敏感边界、哪些内容不落值只记引用 -->

## 权威来源
<!-- 事实以什么为准：代码、PRD、用户确认等 -->

## 策略
- write_policy: <与注册表一致>
- promotion_policy: <与注册表一致>

## 访问方式
- preferred: <obsidian-cli / filesystem>
- vault_name: <Obsidian 中的 Vault 名称>（如适用）

## Git
<!-- 远端仓库、分支策略、推送规则；无 Git 则注明 -->
```

策略字段与注册表保持一致，KNOWLEDGE.md 中可补充更具体的规则说明（如"架构页必须经团队确认后才更新"）。

### INDEX.md 最小示例

```markdown
# 知识索引

## 项目
| 项目 ID | 摘要 | 项目卡 |
|---------|------|--------|
| personal.project.my-app | 个人工具应用 | [PROJECT.md](knowledge/projects/personal.project.my-app/PROJECT.md) |

## 知识主题
| 主题 | 入口 |
|------|------|
| OAuth 接入模式 | [oauth-patterns.md](knowledge/oauth-patterns.md) |

## 复用资产
| 资产 | 位置 |
|------|------|
| 品牌色板 | [brand-colors.md](knowledge/brand-colors.md) |
```

INDEX.md 是路由表而非内容副本。项目条目链接到项目卡，知识主题链接到正式页，复用资产链接到资产描述。不在此复制任务明细（TODO.md 是独立入口）。

### log.md 格式

```markdown
# 操作日志

- <YYYY-MM-DD> | <操作类型：create/update/promote/archive> | <目标页路径> | <一句话说明> | <commit 短哈希（如有）>
```

每次写入操作追加一条，同一次操作涉及多个文件合并为一条。不记录纯查询。

Obsidian 模式按 [obsidian.md](obsidian.md) 验证注册；基础能力不依赖社区插件。Git内容同步排除整个`.obsidian/`、缓存和本机状态；初始化Git/创建远端需用户授权，已有持续提交/推送规则则按 [git.md](git.md) 执行，不重复询问。

## 检查

确定性问题只有在用户要求修复时才自动处理，例如唯一目标明确的坏链接、可推导的索引项、缺失的必填元数据和越界路径。语义冲突、疑似过期、可能重复、候选能否晋升属于判断问题，只报告或按 [写入与自动晋升](write.md) 的硬条件处理。

查询不初始化、不检查积压，也不写日志。保持纯文件方案，不依赖数据库、Embedding、MCP Server或后台守护进程。周期回顾复用用户已授权的外部调度，按 [tasks.md](tasks.md) 检查任务与资产；调度配置留在Vault外，不改变读写或发布权限。通用Skill不包含某个用户的时间、时区和Vault名。

## 跨 Agent 接入

不支持 Skill 的 Agent 可以采用以下最小规则：

> 通过注册表选择最小相关Vault，读其AGENTS/KNOWLEDGE/INDEX。查询只读；已核验更新按策略直接写正式页，存疑结论留Inbox，在途工作留TODO；写后按库规则提交同步。保留来源、禁止密钥，个人与公司物理隔离。
