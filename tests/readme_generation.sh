#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
tmpdir="$(mktemp -d)"

cleanup() {
  rm -rf "$tmpdir"
}

trap cleanup EXIT

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

cd "$repo_root"
[[ -x scripts/gen-readme.sh ]] || fail "gen-readme.sh 应该放在 scripts/ 目录"
bash scripts/gen-readme.sh >"$tmpdir/gen-readme.out" 2>"$tmpdir/gen-readme.err" || fail "scripts/gen-readme.sh 应该可以成功执行"

grep -Fq '个人 zsh 插件' README.md || fail "README 应该使用中文标题"
grep -Fq 'eval "$(sheldon source)"' README.md || fail "README 应该描述 sheldon 入口"
grep -Fq '## 函数' README.md || fail "README 应该包含中文函数概览"
grep -Fq 'upgrade_node' README.md || fail "README 应该从真实函数生成列表"

echo "readme generation test passed"
