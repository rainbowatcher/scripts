#!/usr/bin/env bats

load './test_helper.bash'

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  TMP_HOME="$(mktemp -d)"
  # 脚本按 $0 定位仓库根目录，所以拷一份到临时目录里跑，不碰真实工作区
  COPY_ROOT="$TMP_HOME/repo"
  mkdir -p "$COPY_ROOT/scripts" "$COPY_ROOT/completions"
  cp "$REPO_ROOT/scripts/gen-completions.sh" "$COPY_ROOT/scripts/"
}

teardown() {
  rm -rf "$TMP_HOME"
}

@test "gen-completions 在空的 completions 目录上不会中断" {
  run bash "$COPY_ROOT/scripts/gen-completions.sh"

  [ "$status" -eq 0 ]
  [ "$(ls -A "$COPY_ROOT/completions" | wc -l | tr -d ' ')" -ge 0 ]
}

@test "gen-completions --check 在生成物缺失时报告差异并退出 1" {
  run bash "$COPY_ROOT/scripts/gen-completions.sh" --check

  [ "$status" -eq 1 ]
  [[ "$output" == *"diff"* ]]
}

@test "gen-completions 重复运行是幂等的" {
  bash "$COPY_ROOT/scripts/gen-completions.sh" >/dev/null
  before="$(ls -A "$COPY_ROOT/completions")"

  run bash "$COPY_ROOT/scripts/gen-completions.sh" --check

  [ "$status" -eq 0 ]
  [[ "$output" != *"diff"* ]]
  [ "$(ls -A "$COPY_ROOT/completions")" = "$before" ]
}

@test "gen-completions 在工具缺失时跳过而不是失败" {
  run env PATH=/usr/bin:/bin bash "$COPY_ROOT/scripts/gen-completions.sh"

  [ "$status" -eq 0 ]
  [[ "$output" == *"skip"* ]]
}
