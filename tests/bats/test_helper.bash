setup() {
  REPO_ROOT="$(cd "$BATS_TEST_DIRNAME/../.." && pwd)"
  TMP_HOME="$(mktemp -d)"
}

teardown() {
  rm -rf "$TMP_HOME"
}

run_repo_zsh() {
  run zsh -fc "$1" _ "$REPO_ROOT"
}

run_repo_zsh_with_home() {
  run env HOME="$TMP_HOME" zsh -fc "$1" _ "$REPO_ROOT"
}
