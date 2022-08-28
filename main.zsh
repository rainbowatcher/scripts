#!/usr/bin/env bash

SCRIPTS_HOME=${SCRIPTS_HOME-$(cd $(dirname $0);pwd)}

source $SCRIPTS_HOME/common.zsh

load_all() {
  ALL=($(ls "$SCRIPTS_HOME/bash/"))
  for item in "${ALL[@]}"; do
    source "$SCRIPTS_HOME/bash/${item}"
  done
}

for arg in "$@"; do
  case "$arg" in
  all)
    load_all
    ;;
  proxy)
    source bash/proxy.sh
    ;;
  git)
    command_exists git && source bash/git-alias.sh
    ;;
  mac)
    source bash/mac-alias.sh
    ;;
  alias)
    source bash/alias.sh
    ;;
  extras)
    source bash/extras.sh
    ;;
  *)
    warn "option [$arg] not exists."
    ;;
  esac
done
