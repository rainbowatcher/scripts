#!/usr/bin/env zsh

set -euo pipefail

repo_root=${0:A:h:h}
typeset -a tmp_dirs=()

cleanup() {
  local tmpdir

  for tmpdir in "${tmp_dirs[@]}"; do
    [[ -n $tmpdir ]] && rm -rf "$tmpdir"
  done
}

trap cleanup EXIT

fail() {
  print -u2 -- "FAIL: $1"
  exit 1
}

assert_contains() {
  local haystack=$1
  local needle=$2
  local message=$3

  if [[ $haystack != *"$needle"* ]]; then
    fail "$message"
  fi
}

assert_not_contains() {
  local haystack=$1
  local needle=$2
  local message=$3

  if [[ $haystack == *"$needle"* ]]; then
    fail "$message"
  fi
}

assert_equals() {
  local actual=$1
  local expected=$2
  local message=$3

  if [[ $actual != $expected ]]; then
    fail "$message (expected: $expected, actual: $actual)"
  fi
}

test_main_is_idempotent() {
  local out
  out=$(zsh -fc '
    source "$1/main.zsh" >/dev/null 2>&1
    first=${#fpath}
    source "$1/main.zsh" >/dev/null 2>&1
    second=${#fpath}
    if [[ $first -eq $second ]]; then
      print -- stable
    else
      print -- "$first:$second"
    fi
  ' _ "$repo_root")

  assert_equals "$out" "stable" "main.zsh 应该避免重复注册 fpath"
}

test_completion_bootstrap() {
  local out
  out=$(zsh -fc '
    source "$1/main.zsh" >/dev/null 2>&1
    whence -w compdef
    print -- "${_comps[npm]-missing}"
  ' _ "$repo_root")

  assert_contains "$out" "compdef: function" "main.zsh 应该初始化 compdef"
  assert_not_contains "$out" "missing" "main.zsh 应该让 npm completion 可见"
}

test_aliases_degrade_gracefully_without_optional_deps() {
  local out
  out=$(zsh -fc '
    export PATH=/nonexistent
    source "$1/main.zsh" >/dev/null 2>&1
    alias ls 2>/dev/null || true
    alias rm 2>/dev/null || true
  ' _ "$repo_root")

  assert_contains "$out" "ls='ls --color'" "缺少 eza 时应该回退到 ls --color"
  assert_not_contains "$out" "eza" "缺少 eza 时不应把 ls 指向 eza"
  assert_not_contains "$out" "trash" "缺少 trash 时不应把 rm 指向 trash"
}

test_set_cli_proxy_sets_all_expected_envs() {
  local out
  out=$(zsh -fc '
    source "$1/main.zsh" >/dev/null 2>&1
    export HTTP_PROXY_ADDR=http://127.0.0.1:8899
    unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy
    set_cli_proxy >/dev/null
    print -- "$HTTP_PROXY|$HTTPS_PROXY|$http_proxy|$https_proxy"
  ' _ "$repo_root")

  assert_equals \
    "$out" \
    "http://127.0.0.1:8899|http://127.0.0.1:8899|http://127.0.0.1:8899|http://127.0.0.1:8899" \
    "set_cli_proxy 应该同时设置四个代理环境变量"
}

test_set_cargo_proxy_writes_valid_toml() {
  local tmpdir
  local out

  tmpdir=$(mktemp -d)
  tmp_dirs+=("$tmpdir")
  out=$(HOME="$tmpdir" zsh -fc '
    source "$1/main.zsh" >/dev/null 2>&1
    export HTTP_PROXY_ADDR=http://127.0.0.1:8899
    export __CARGO_CONFIG_FILE="$HOME/.cargo/config.toml"
    mkdir -p "$HOME/.cargo"
    set_cargo_proxy >/dev/null
    cat "$__CARGO_CONFIG_FILE"
  ' _ "$repo_root")

  assert_contains "$out" "[http]" "set_cargo_proxy 应该写入 TOML section"
  assert_contains "$out" 'proxy = "http://127.0.0.1:8899"' "set_cargo_proxy 应该写入完整代理 URL"
}

test_clean_downloads_moves_matching_files() {
  local tmpdir
  local out

  tmpdir=$(mktemp -d)
  tmp_dirs+=("$tmpdir")
  mkdir -p "$tmpdir/Downloads"
  print -- "dummy" >"$tmpdir/Downloads/report.pdf"

  out=$(HOME="$tmpdir" zsh -fc '
    source "$1/main.zsh" >/dev/null 2>&1
    clean_downloads >/dev/null
    if [[ -f "$HOME/Downloads/document/report.pdf" && ! -f "$HOME/Downloads/report.pdf" ]]; then
      print -- moved
    fi
  ' _ "$repo_root")

  assert_equals "$out" "moved" "clean_downloads 应该把文档文件移动到目标目录"
}

test_clean_downloads_keeps_source_when_target_exists() {
  local tmpdir
  local out

  tmpdir=$(mktemp -d)
  tmp_dirs+=("$tmpdir")
  mkdir -p "$tmpdir/Downloads/document"
  print -- "source" >"$tmpdir/Downloads/report.pdf"
  print -- "target" >"$tmpdir/Downloads/document/report.pdf"

  out=$(HOME="$tmpdir" zsh -fc '
    source "$1/main.zsh" >/dev/null 2>&1
    clean_downloads >/dev/null
    if [[ -f "$HOME/Downloads/report.pdf" && -f "$HOME/Downloads/document/report.pdf" ]]; then
      print -- preserved
    fi
  ' _ "$repo_root")

  assert_equals "$out" "preserved" "目标文件已存在时，move_by_suffix 不应覆盖目标或删除源文件"
}

test_canonical_update_function_name_is_available() {
  local out
  out=$(zsh -fc '
    source "$1/main.zsh" >/dev/null 2>&1
    whence -w upgrade_bun_global_pkg
    whence -w upgrade_bun_grobal_pkg || true
  ' _ "$repo_root")

  assert_contains "$out" "upgrade_bun_global_pkg: function" "应该暴露规范命名的升级命令"
  assert_contains "$out" "upgrade_bun_grobal_pkg: none" "旧的 typo 命令应该被删除"
}

test_main_is_idempotent
test_completion_bootstrap
test_aliases_degrade_gracefully_without_optional_deps
test_set_cli_proxy_sets_all_expected_envs
test_set_cargo_proxy_writes_valid_toml
test_clean_downloads_moves_matching_files
test_clean_downloads_keeps_source_when_target_exists
test_canonical_update_function_name_is_available

print -- "plugin smoke tests passed"
