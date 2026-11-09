#!/usr/bin/env bash

set -euo pipefail

SCRIPTS_ROOT="$(
  cd "$(dirname "$0")/.."
  pwd
)"
README_FILE="$SCRIPTS_ROOT/README.md"

emit_aliases() {
  local alias_file section_name

  for alias_file in "$SCRIPTS_ROOT"/alias/*.zsh; do
    section_name="$(basename "$alias_file" .zsh)"
    printf '### %s\n\n' "$section_name"
    awk '
      /^alias / {
        if ($0 ~ /^alias -s /) {
          next
        }
        line = $0
        sub(/^alias[[:space:]]+/, "", line)
        split(line, parts, "=")
        name = parts[1]
        value = substr(line, index(line, "=") + 1)
        gsub(/^["'\''"]|["'\''"]$/, "", value)
        printf("- %s: `%s`\n", name, value)
      }
    ' "$alias_file"
    printf '\n'
  done
}

emit_completions() {
  local completion_file name

  for completion_file in "$SCRIPTS_ROOT"/completions/*; do
    name="$(basename "$completion_file")"
    name="${name#_}"
    name="${name#_}"
    name="${name%_completion}"
    printf -- '- %s\n' "$name"
  done
  printf '\n'
}

emit_functions() {
  local function_dir function_file section_name

  for function_dir in "$SCRIPTS_ROOT"/functions/*; do
    [[ -d "$function_dir" ]] || continue

    section_name="$(basename "$function_dir")"
    printf '### %s\n\n' "$section_name"

    for function_file in "$function_dir"/*; do
      [[ -f "$function_file" ]] || continue
      printf -- '- %s\n' "$(basename "$function_file")"
    done
    printf '\n'
  done
}

cat >"$README_FILE" <<'EOF'
# Rainbow Watcher 的个人 zsh 插件

> 此文件由 `scripts/gen-readme.sh` 自动生成。

## 快速开始

### Sheldon

先把本地插件配置到 `~/.config/sheldon/plugins.toml`：

```toml
# fpath 必须排在 mise 前面：mise 的 hook-env 会跑 compinit，
# 那时不在 fpath 里的补全不会被注册
[plugins.scripts-fpath]
local = "~/path/to/scripts"
use = ["fpath.zsh"]

[plugins.mise]
inline = 'eval "$(mise activate zsh)"'

# 函数和 alias 排在 mise 后面，alias 里的 `type <tool>` 才看得到 mise 装的工具
[plugins.scripts]
local = "~/path/to/scripts"
use = ["main.zsh"]
```

没装 mise 的话只配 `[plugins.scripts]` 即可，`main.zsh` 会自己 source `fpath.zsh`。

然后在 `~/.zshrc` 中启用 `sheldon`：

```zsh
eval "$(sheldon source)"
```

## 说明

- 目标环境是 `macOS + zsh + Homebrew`。
- 代理相关函数会在定义了 `HTTP_PROXY_ADDR` 时读取该值。

## 别名

EOF

emit_aliases >>"$README_FILE"

cat >>"$README_FILE" <<'EOF'
## 补全

EOF

emit_completions >>"$README_FILE"

cat >>"$README_FILE" <<'EOF'
## 函数

EOF

emit_functions >>"$README_FILE"
