#!/usr/bin/env bats

load './test_helper.bash'

@test "set_cli_proxy 会同时设置四个代理环境变量" {
  run_repo_zsh '
    source "$1/main.zsh" >/dev/null 2>&1
    export HTTP_PROXY_ADDR=http://127.0.0.1:8899
    unset HTTP_PROXY HTTPS_PROXY http_proxy https_proxy
    set_cli_proxy >/dev/null
    print -- "$HTTP_PROXY|$HTTPS_PROXY|$http_proxy|$https_proxy"
  '

  [ "$status" -eq 0 ]
  [ "$output" = "http://127.0.0.1:8899|http://127.0.0.1:8899|http://127.0.0.1:8899|http://127.0.0.1:8899" ]
}

@test "set_cargo_proxy 默认写入 config.toml" {
  run_repo_zsh_with_home '
    source "$1/main.zsh" >/dev/null 2>&1
    export HTTP_PROXY_ADDR=http://127.0.0.1:8899
    mkdir -p "$HOME/.cargo"
    set_cargo_proxy >/dev/null
    cat "$HOME/.cargo/config.toml"
  '

  [ "$status" -eq 0 ]
  [[ "$output" == *"[http]"* ]]
  [[ "$output" == *'proxy = "http://127.0.0.1:8899"'* ]]
}

@test "set_cargo_mirror 默认写入 config.toml" {
  run_repo_zsh_with_home '
    source "$1/main.zsh" >/dev/null 2>&1
    mkdir -p "$HOME/.cargo"
    set_cargo_mirror >/dev/null
    if [[ -f "$HOME/.cargo/config.toml" && ! -e "$HOME/.cargo/config.yaml" ]]; then
      cat "$HOME/.cargo/config.toml"
    fi
  '

  [ "$status" -eq 0 ]
  [[ "$output" == *"[source.crates-io]"* ]]
  [[ "$output" == *"replace-with = 'mirror'"* ]]
}
