#!/usr/bin/env zsh

# Colors
FONT='\033[0m'
GREEN_COLOR="\033[1;32m"
RED_COLOR='\033[1;31m'
BLUE_COLOR='\033[1;34m'
HIGHLIGHT='\033[1;36m'

function info() {
  echo "${GREEN_COLOR}[INFO]${FONT} $@"
}

function warn() {
  echo "${BLUE_COLOR}[WARN]${FONT} $@"
}

function error() {
  echo "${RED_COLOR}[ERROR]${FONT} $@"
}

# should set the value of INIT_STEP in the begin of invoke
function step() {
  if [ $STEP_NUM ]; then
    STEP_NUM=$(($STEP_NUM + 1))
    echo -e "${HIGHLIGHT}[STEP - $STEP_NUM]${FONT} $@"
  else
    STEP_NUM=0
    step $@
  fi
}

function step_end() {
  unset STEP_NUM
}

function judge() {
  [[ 0 -eq $? ]] && info "$@ ${GREEN_COLOR}Done${FONT}" || error "$@ ${RED_COLOR}Fail${FONT}"
}

function command_exists() {
  if ! command -v "$1" >/dev/null 2>&1; then
    info "command $1 not exists!"
    return 1
  fi
}

function file_exists() {
  if [ ! -f "$1" ]; then
    info "file $1 not exists!"
    return 1
  fi
}

function dir_exists() {
  if [ ! -d "$1" ];then
    info "directory $1 not exists!"
    return 1
  fi
}