#!/usr/bin/env bats

load './test_helper.bash'

@test "main.zsh 重复加载不会重复注册 fpath" {
  run_repo_zsh '
    source "$1/main.zsh" >/dev/null 2>&1
    first=${#fpath}
    source "$1/main.zsh" >/dev/null 2>&1
    second=${#fpath}

    if [[ $first -eq $second ]]; then
      print -- stable
    else
      print -- "$first:$second"
    fi
  '

  [ "$status" -eq 0 ]
  [ "$output" = "stable" ]
}

@test "main.zsh 会初始化 npm completion" {
  run_repo_zsh '
    source "$1/main.zsh" >/dev/null 2>&1
    whence -w compdef
    print -- "${_comps[npm]-missing}"
  '

  [ "$status" -eq 0 ]
  [[ "$output" == *"compdef: function"* ]]
  [[ "$output" != *"missing"* ]]
}

@test "缺少可选依赖时 alias 会安全降级" {
  run_repo_zsh '
    export PATH=/nonexistent
    source "$1/main.zsh" >/dev/null 2>&1
    alias ls 2>/dev/null || true
    alias rm 2>/dev/null || true
  '

  [ "$status" -eq 0 ]
  [[ "$output" == *"ls='ls --color'"* ]]
  [[ "$output" != *"eza"* ]]
  [[ "$output" != *"trash"* ]]
}

@test "只暴露规范命名的 bun 全局升级函数" {
  run_repo_zsh '
    source "$1/main.zsh" >/dev/null 2>&1
    whence -w upgrade_bun_global_pkg
    whence -w upgrade_bun_grobal_pkg || true
  '

  [ "$status" -eq 0 ]
  [[ "$output" == *"upgrade_bun_global_pkg: function"* ]]
  [[ "$output" == *"upgrade_bun_grobal_pkg: none"* ]]
}
