#!/usr/bin/env bats

load './test_helper.bash'

@test "scripts/gen-readme.sh 可以生成中文 README" {
  run bash "$REPO_ROOT/scripts/gen-readme.sh"

  [ "$status" -eq 0 ]
  grep -Fq '个人 zsh 插件' "$REPO_ROOT/README.md"
  grep -Fq 'eval "$(sheldon source)"' "$REPO_ROOT/README.md"
  grep -Fq '## 函数' "$REPO_ROOT/README.md"
  grep -Fq 'upgrade_node' "$REPO_ROOT/README.md"
}
