# Obsidian访问

Obsidian是可选内容适配器，文件系统中的Markdown才是存储。只有注册preferred=obsidian-cli时优先CLI，不依赖社区插件。CLI命令语法基于 Obsidian 官方 CLI（`obsidian` 命令），需 Obsidian 应用运行中；详细命令参考见 obsidian-cli skill。

首次操作核对：

```sh
obsidian vault="<vault_name>" vault info=path
obsidian vault="<vault_name>" read path="KNOWLEDGE.md"
obsidian vault="<vault_name>" read path="INDEX.md"
```

vault_name从所选注册项获得，不固定为personal/company。返回真实路径须与注册路径一致。路径不匹配立即停止；CLI不可用或命令报Error时，只有声明fallback=filesystem才回退，继续验证根目录和目标边界。

读取用精确path；搜索用限定路径与数量的当前CLI参数，不要求搜索命令使用单文件path。`Error:`即使退出码0也视为失败。不要猜CLI支持的参数，必要时查help。

多文件写入可用精确文件补丁，再回读确认；CLI可用时按精确路径回读，不能把“已发出命令”当成功。内部链接沿用Vault习惯，开新Vault或目录迁移仅在已授权任务进行。

整个`.obsidian/`、插件配置、工作区布局和缓存均为本机状态，不进入内容Git同步。换机克隆内容后由用户在Obsidian中打开，新建本机配置即可。
