#!/usr/bin/env zsh

SCRIPTS_ROOT=${SCRIPTS_ROOT:=$(cd $(dirname $0); pwd)}

source $SCRIPTS_ROOT/common.zsh
source_list=("alias" "function" "completion")

load_all() {
  for source in "${source_list[@]}"; do
  source_all "$source"
  done
}

source_all() {
  local abs_localtion="$SCRIPTS_ROOT/$1"
  local files=($(ls $abs_localtion/*))
  for item in "${files[@]}"; do
    source $item
  done
}

for arg in "$@"; do
  case "$arg" in
  "all")
    load_all
    ;;
  "completion")
    source_all "$arg"
    ;;
  "alias")
    source_all "$arg"
    ;;
  "function")
    source_all "$arg"
    ;;
  *)
    warn "option [$arg] not exists."
    ;;
  esac
done
