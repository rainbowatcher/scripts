#!/usr/bin/env bats

load './test_helper.bash'

@test "clean_downloads 会移动匹配后缀的文件" {
  mkdir -p "$TMP_HOME/Downloads"
  printf 'dummy\n' >"$TMP_HOME/Downloads/report.pdf"

  run_repo_zsh_with_home '
    source "$1/main.zsh" >/dev/null 2>&1
    clean_downloads >/dev/null
    if [[ -f "$HOME/Downloads/document/report.pdf" && ! -f "$HOME/Downloads/report.pdf" ]]; then
      print -- moved
    fi
  '

  [ "$status" -eq 0 ]
  [ "$output" = "moved" ]
}

@test "clean_downloads 在目标文件已存在时保留源文件" {
  mkdir -p "$TMP_HOME/Downloads/document"
  printf 'source\n' >"$TMP_HOME/Downloads/report.pdf"
  printf 'target\n' >"$TMP_HOME/Downloads/document/report.pdf"

  run_repo_zsh_with_home '
    source "$1/main.zsh" >/dev/null 2>&1
    clean_downloads >/dev/null
    if [[ -f "$HOME/Downloads/report.pdf" && -f "$HOME/Downloads/document/report.pdf" ]]; then
      print -- preserved
    fi
  '

  [ "$status" -eq 0 ]
  [ "$output" = "preserved" ]
}
