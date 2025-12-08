#!/usr/bin/env zsh

# ref: https://github.com/zdharma-continuum/fast-syntax-highlighting/blob/master/fast-syntax-highlighting.plugin.zsh#L37
# Standarized way of handling finding plugin dir,
# regardless of functionargzero and posixargzero,
# and with an option for a plugin manager to alter
# the plugin directory (i.e. set ZERO parameter)
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

FONT='\033[0m'
GREEN="\033[1;32m"
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'

source "${0:h}"/config/rc.zsh

# add folder in functions to fpath
fpath=(
    # / for directory, N for empty folder to empty string
    "${0:h}"/functions/**/*(N/)
    "${0:h}"/completions
    $fpath
)

# load functions
for __auto_laod_func_file in "${0:h}"/functions/**/*(.); do
    autoload -Uz "${__auto_laod_func_file:t}"
done

# load completions,alias,config
for __script_file in "${0:h}"/alias/*(.); do
    source "${__script_file}"
done
