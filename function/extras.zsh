#!/usr/bin/env zsh

# git ignore template downloader
function gi() {
  if [[ $# == 1 ]]; then
    curl -sfLw '\n' https://www.toptal.com/developers/gitignore/api/$1 -o .gitignore
    judge "$1.gitignore download"
  else
    curl -sfL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
  fi
}

# get major version number
# $1: software
function major() {
  local software=$1
  if cmd_exists $software; then
    if [[ $software == "java" ]]; then
      eval "$software -version 2>&1 | head -1 | awk '{print \$3}' | sed 's/\"//g' | awk -F'.' '{print \$1}'"
    elif [[ $software == "go" ]]; then
      eval "$software version | awk '{print \$3}' | sed 's/go//' | awk -F'.' '{print \$1}'"
    elif [[ $software == "python" ]]; then
      eval "$software --version | awk '{print \$2}' | awk -F'.' '{print \$1}'"
    else
      warn "can't get major version number of $software, use `$software --version` instead."
      eval "$software --version"
    fi
  else
    error "$software not found."
  fi
}

function zsh_time() {
    local times=${1:-5}
    for i in $(seq $times); do
        /usr/bin/time /bin/zsh -i -c exit
    done
}

function cht() {
    local query=$1
    local idx=0
    for item in $@; do
        if test $idx -eq 0; then
            idx=$(expr $idx + 1)
            continue
        fi
        query="$query+$item"
    done
    echo "curl cht.sh/$query"
    curl "cht.sh/$query"
}