#!/usr/bin/env zsh

# PROJECT_ROOT=
SCRIPTS_ROOT=${SCRIPTS_ROOT:=$(cd $(dirname $0); pwd)}

source $SCRIPTS_ROOT/common.zsh

load_all() {
  source_all "alias"
  source_all "function"
  source_all "completion"
}

source_all() {
  local LOCATION=$1
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
