#!/usr/bin/env zsh

SCRIPTS_ROOT=${SCRIPTS_ROOT:=$(cd $(dirname $0); pwd)}

source $SCRIPTS_ROOT/common.zsh
SOURCE_LIST=("alias" "function" "completion")

load_all() {
  for SOURCE in "${SOURCE_LIST[@]}"; do
  source_all "$SOURCE"
  done
}

source_all() {
  local ABS_LOCALTION="$SCRIPTS_ROOT/$1"
  local FILES=($(ls $ABS_LOCALTION/*))
  for ITEM in "${FILES[@]}"; do
    source $ITEM
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
