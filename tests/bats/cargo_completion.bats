#!/usr/bin/env bats

load './test_helper.bash'

setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  TMP_HOME="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_HOME"
}

# 把补全文件当函数体载入（等同 autoload），再打桩验证分发
run_cargo_dispatch() {
  local line="$1" prefix="$2" current="$3"
  run env HOME="$TMP_HOME" zsh -fc '
    autoload_body() { eval "function _cargo { $(<$1) }" }
    autoload_body "$1/completions.local/_cargo"
    _cargo >/dev/null 2>&1
    _cargo_load_official() { return 0 }
    _cargo_official() { print "OFFICIAL:${words[*]}" }
    compadd() {
      local label="" cands=()
      while (( $# )); do
        case $1 in
          -X) label=$2; shift 2 ;;
          -a) cands+=( ${(P)2} ); shift 2 ;;
          *)  cands+=( $1 ); shift ;;
        esac
      done
      print "CRATES:$label:${#cands}"
    }
    words=(${(z)2}); PREFIX=$3; CURRENT=$4
    _cargo
  ' _ "$REPO_ROOT" "$line" "$prefix" "$current"
}

@test "cargo add 会补 crate 名" {
  run_cargo_dispatch "cargo add axum" axum 3

  [ "$status" -eq 0 ]
  [[ "$output" == CRATES:* ]]
  [[ "$output" != *OFFICIAL* ]]
}

@test "cargo install 会补 crate 名" {
  run_cargo_dispatch "cargo install ripgrep" ripgrep 3

  [ "$status" -eq 0 ]
  [[ "$output" == CRATES:* ]]
}

@test "flag 位置交给官方实现" {
  run_cargo_dispatch "cargo add --dev" --dev 3

  [ "$status" -eq 0 ]
  [[ "$output" == "OFFICIAL:cargo add --dev" ]]
}

@test "其他子命令交给官方实现" {
  run_cargo_dispatch "cargo build --rel" --rel 3

  [ "$status" -eq 0 ]
  [[ "$output" == "OFFICIAL:cargo build --rel" ]]
}

@test "空前缀不查网络" {
  run_cargo_dispatch "cargo add " "" 3

  [ "$status" -eq 0 ]
  [[ "$output" == OFFICIAL:* ]]
}
