# Quick Start

三个典型场景的端到端步骤。假设已安装Skill；访问方式由注册表决定，文件系统模式不要求安装Obsidian。示例名称均为占位，不能代替用户实际配置。

## 场景 1：首次搭建双 Vault

用户说："帮我初始化个人和公司两个知识库"

1. 从 `AGENT_KNOWLEDGE_REGISTRY` 或默认 `~/.config/agent-knowledge/vaults.yaml` 检查现有注册表，按用户提供的路径和名称补充（参考 [init.md](init.md)）。校验根目录不重复、不嵌套，不覆盖已有注册项或库内容。
2. 已有Vault先读其 `AGENTS.md`、`KNOWLEDGE.md` 和 `INDEX.md`；仅为新Vault创建最小结构：`KNOWLEDGE.md`、`INDEX.md`、`knowledge/`、`sources/`、`inbox/`、`log.md`。
3. 新Vault按KNOWLEDGE.md模板填写范围、边界和策略；已有文件只补本次必要内容，不用模板覆盖。
4. Obsidian模式按 [obsidian.md](obsidian.md) 核对注册路径；CLI不可用时仅按已声明的fallback回退，路径不匹配则停止。
5. 如用户授权Git：沿用已有仓库或初始化新仓，配置 `.gitignore` 排除整个 `.obsidian/`；只有明确授权创建远端才创建，已有提交/同步策略按 [git.md](git.md) 执行。

完成后报告两个库的状态，不预建项目目录或导入内容。

## 场景 2：查询已有知识

用户说："我之前 OAuth 是怎么接的？用的什么方案？"

1. 读注册表，按任务上下文判断 scope——OAuth 接入可能在个人项目也可能在公司项目，无法确定时询问用户。
2. 确定目标后（假设个人库），校验访问路径，先读已有 `AGENTS.md`、`KNOWLEDGE.md`，再从 `INDEX.md` 查找OAuth相关条目。
3. 定位到项目卡 `knowledge/projects/personal.project.example-app/PROJECT.md`，读取技术栈和模块清单。
4. 如需细节，按渐进读取读 `business/user-auth.md`，到此为止回答用户。

全程只读，不写日志，不检查积压，不触发任何写入流程。

## 场景 3：沉淀新项目知识

用户说："把刚做完的 example-app 项目的鉴权模块沉淀到公司知识库"

1. 读注册表，选择匹配的公司库，校验访问路径；先读已有 `AGENTS.md`、`KNOWLEDGE.md`、`INDEX.md`，查看项目与权限约定。
2. 检查 `write_policy`：read-only不写入；explicit要求本次请求或已有持续授权覆盖写入。本例用户已要求沉淀，无需为同一写入重复确认；若来源涉及另一个Vault，仍须检查跨库授权。
3. 检查 `promotion_policy` 与来源：auto-verified且证据稳定、无冲突时可直接更新正式页；explicit只有本次请求或已有授权明确覆盖正式知识更新时才直接写，否则保留候选等待晋升授权。未提交实现或存疑结论按 [write.md](write.md) 留在Inbox，在途进度按 [tasks.md](tasks.md) 记录。
4. 满足正式写入条件后，合并已有项目卡；不存在时创建 `knowledge/projects/company.project.example-app/PROJECT.md`。按模块实际需要补充 `business/user-auth.md` 和 `architecture/user-auth.md`，记录代码锚点及已核验的稳定commit，不预建空页。
5. 路由或摘要变化时更新 `INDEX.md`，本次操作追加一条 `log.md`。
6. 回读变更文件，检查相关链接和来源。
7. 按 [git.md](git.md) 检查暂存区，根据库规则提交本次相关文件并按授权推送；无Git约定时不擅自初始化、提交或创建远端。

报告变更页清单和提交状态，不逐条输出审计过程。
