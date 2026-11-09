#!/usr/bin/env bash
#
# 重新生成 completions/ 下的补全脚本。
#
#   ./scripts/gen-completions.sh          生成并写入有变化的文件
#   ./scripts/gen-completions.sh --check  只比对，有差异就退出码 1（给 CI 用）
#
# 注意：compinit 只读每个补全文件的第一行，所以生成物必须以 #compdef 开头；
# 有的工具（pip、旧版 pnpm）会在前面多印空行或注释，这里统一截掉。

set -euo pipefail

REPO_ROOT="$(
  cd "$(dirname "$0")/.."
  pwd
)"
COMPLETIONS_DIR="$REPO_ROOT/completions"

check_only=0
case "${1:-}" in
--check) check_only=1 ;;
-h | --help)
  sed -n '3,9p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
  ;;
"") ;;
*)
  echo "unknown argument: $1" >&2
  exit 2
  ;;
esac

failed=()
changed=0
generated=()

# generate <名字> <命令...>
generate() {
  local name="$1"
  shift

  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'skip %-8s %s not installed\n' "$name" "$1"
    return 0
  fi

  local tmp
  tmp="$(mktemp "${TMPDIR:-/tmp}/completion.XXXXXX")"
  generated+=("_$name")

  if ! "$@" >"$tmp" 2>/dev/null || [[ ! -s $tmp ]]; then
    printf 'fail %-8s %s\n' "$name" "$*" >&2
    failed+=("$name")
    rm -f "$tmp"
    return 0
  fi

  # 从 #compdef 那行开始截取，前面的空行/注释会让 compinit 忽略整个文件
  if grep -q '^#compdef' "$tmp"; then
    sed -n '/^#compdef/,$p' "$tmp" >"$tmp.cut"
    mv "$tmp.cut" "$tmp"
  else
    printf 'warn %-8s 没有 #compdef 行，compinit 不会注册它\n' "$name" >&2
  fi

  if ! zsh -n "$tmp"; then
    printf 'fail %-8s 语法检查不通过\n' "$name" >&2
    failed+=("$name")
    rm -f "$tmp"
    return 0
  fi

  local dest="$COMPLETIONS_DIR/_$name"
  if [[ -f $dest ]] && cmp -s "$tmp" "$dest"; then
    printf 'same %-8s %s\n' "$name" "${dest##*/}"
  elif ((check_only)); then
    printf 'diff %-8s %s\n' "$name" "${dest##*/}"
    changed=1
  else
    chmod 644 "$tmp"
    mv "$tmp" "$dest"
    printf 'wrote %-8s %s\n' "$name" "${dest##*/}"
    changed=1
  fi
  rm -f "$tmp"
}

# 工具 -> 生成命令。加一个工具就加一行。
generate delta delta --generate-completion zsh
generate entire entire completion zsh
generate pnpm_completion pnpm completion zsh

# 目录里多出来的文件提醒一下（不删）：多半是已废弃的生成物，或者是手写的
# 补全——手写的最好别放在这里，重跑本脚本容易把它覆盖掉。
shopt -s nullglob
for file in "$COMPLETIONS_DIR"/_*; do
  [[ -e $file ]] || continue
  [[ " ${generated[*]} " == *" ${file##*/} "* ]] && continue
  printf 'untracked %s\n' "${file##*/}" >&2
done

if ((${#failed[@]} > 0)); then
  printf 'failed: %s\n' "${failed[*]}" >&2
  exit 1
fi

if ((check_only)) && ((changed)); then
  echo "completions are stale, run $0" >&2
  exit 1
fi
