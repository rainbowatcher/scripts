#!/usr/bin/env zsh

FONT='\033[0m'
GREEN="\033[1;32m"
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'

# add folder in functions to fpath
fpath=(
    "$SCRIPTS_ROOT"/functions/**/*(N/)
    $fpath
)

# load functions
for func_file in "$SCRIPTS_ROOT"/{functions,completions,alias}/**/*(.); do
    if [[ $func_file =~ /functions/ ]]; then
        autoload -Uz "${func_file:t}"; 
    else
        zsh-defer source "${func_file}"
    fi
done
