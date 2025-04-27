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

# add folder in functions to fpath
fpath=(
    "${0:h}"/functions/**/*(N/)
    $fpath
)

# load functions
for func_file in "${0:h}"/{functions,completions,alias}/**/*(.); do
    if [[ $func_file =~ /functions/ ]]; then
        autoload -Uz "${func_file:t}"
    else
        zsh-defer source "${func_file}"
    fi
done
