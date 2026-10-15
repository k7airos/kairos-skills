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

不要预建复杂分类，也不要在初始化时扫描或导入资产。`KNOWLEDGE.md` 至少说明收录范围、排除项、敏感边界、权威来源、`write_policy`、`promotion_policy` 和访问方式。`INDEX.md`用于知识路由，可链接TODO但不复制任务明细。

Obsidian 模式按 [obsidian.md](obsidian.md) 验证注册；基础能力不依赖社区插件。Git内容同步排除整个`.obsidian/`、缓存和本机状态；初始化Git/创建远端需用户授权，已有持续提交/推送规则则按 [git.md](git.md) 执行，不重复询问。

## 检查

确定性问题只有在用户要求修复时才自动处理，例如唯一目标明确的坏链接、可推导的索引项、缺失的必填元数据和越界路径。语义冲突、疑似过期、可能重复、候选能否晋升属于判断问题，只报告或按 [写入与自动晋升](write.md) 的硬条件处理。

查询不初始化、不检查积压，也不写日志。保持纯文件方案，不依赖数据库、Embedding、MCP Server或后台守护进程。周期回顾复用用户已授权的外部调度，按 [tasks.md](tasks.md) 检查任务与资产；调度配置留在Vault外，不改变读写或发布权限。通用Skill不包含某个用户的时间、时区和Vault名。

## 跨 Agent 接入

不支持 Skill 的 Agent 可以采用以下最小规则：

> 通过注册表选择最小相关Vault，读其AGENTS/KNOWLEDGE/INDEX。查询只读；已核验更新按策略直接写正式页，存疑结论留Inbox，在途工作留TODO；写后按库规则提交同步。保留来源、禁止密钥，个人与公司物理隔离。
