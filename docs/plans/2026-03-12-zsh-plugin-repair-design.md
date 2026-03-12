# Zsh 插件修复设计

## 概要

这个仓库现在按“通过 `sheldon` 加载的个人 `zsh` 插件”来维护。
仓库只负责可迁移的 shell 能力：

- alias
- autoload 函数
- completion
- 仓库内文档

机器专属的 shell 配置继续留在仓库外：

- `~/.zshrc` 负责本机 alias、跳板机命令和一次性函数
- `~/.zshenv` 负责环境变量、PATH 和代理默认值

## 已实现改动

### 加载模型

- `main.zsh` 是唯一插件入口。
- 重复 `source main.zsh` 现在是幂等的。
- 只有在 completion 尚未初始化时，`main.zsh` 才会执行 `compinit`。

### 运行时修复

- 可选依赖现在会安全降级：
  - 有 `eza` 时使用 `eza`
  - 没有 `eza` 时回退到 `ls --color`
  - 只有存在 `trash` 时才覆盖 `rm`
- 代理函数现在会先校验 `HTTP_PROXY_ADDR`，再写入配置。
- Cargo 代理配置改为写入 `~/.cargo/config.toml`，并使用受控配置块。
- `clean_downloads` 重新恢复为真实移动文件。
- bun 全局升级命令只保留规范命名 `upgrade_bun_global_pkg`。

### 文档与脚本

- 生成类脚本统一放到 `scripts/` 目录。
- `scripts/gen-readme.sh` 现在根据真实目录生成 README。
- README 改为中文，并明确以 `sheldon` 为唯一标准入口。

## 验证方式

仓库现在包含两套轻量 smoke test：

- `zsh tests/plugin_smoke.zsh`
- `bash tests/readme_generation.sh`

覆盖点包括：

- 插件入口幂等
- completion 初始化
- 可选依赖缺失时的降级行为
- 代理环境变量写入
- cargo 代理 TOML 输出
- 下载目录整理
- README 生成结果

## 后续优化建议

- 增加 `doctor` 命令，统一检查依赖、代理变量和 completion 状态。
- 进一步把可选的 macOS 初始化脚本和插件文档解耦。
- 增加一个简单的提交流程检查：先生成 README，再跑 smoke test。
