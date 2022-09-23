#!/usr/bin/env zsh

# Colors
FONT='\033[0m'
GREEN="\033[1;32m"
RED='\033[1;31m'
YELLOW='\033[1;33m'
HIGHLIGHT='\033[1;36m'

function info() {
  echo "${GREEN}[INFO]${FONT} $@"
}

function warn() {
  echo "${YELLOW}[WARN]${FONT} $@"
}

function error() {
  echo "${RED}[ERROR]${FONT} $@"
}

function step() {
  if [ $STEP_NUM ]; then
    STEP_NUM=$(($STEP_NUM + 1))
    echo "${HIGHLIGHT}[STEP - $STEP_NUM]${FONT} $@"
  else
    STEP_NUM=0
    step $@
  fi
}

function step_end() {
  unset STEP_NUM
}

function judge() {
  [[ 0 -eq $? ]] && info "$@ ${GREEN}Done${FONT}" || error "$@ ${RED}Fail${FONT}"
}

function command_exists() {
  if [ ! "$(command -v $1)" ]; then
    return 1
  fi
}

function file_exists() {
  if [ ! -f "$1" ]; then
    return 1
  fi
}

function dir_exists() {
  if [ ! -d "$1" ]; then
    return 1
  fi
}

# mkdir if directory not exists
function make_dir() {
  local dir=$1
  if dir_exists "$dir"; then
    mkdir -p "$dir"
  fi
}

function move_file() {
  local source_file=$1
  local target_folder=$2

  if [ -f "$source_file" ]; then
    mv -v "$source_file" "$target_folder/"
  else
    warn "can't mv file - $source_file"
  fi
}

function list_files() {
  find "$1" -d 1 -type f | awk '{gsub(" ","\\ ");print}'
}
