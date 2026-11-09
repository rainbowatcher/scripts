#!/usr/bin/env zsh

# ref: https://github.com/zdharma-continuum/fast-syntax-highlighting/blob/master/fast-syntax-highlighting.plugin.zsh#L37
# Standarized way of handling finding plugin dir,
# regardless of functionargzero and posixargzero,
# and with an option for a plugin manager to alter
# the plugin directory (i.e. set ZERO parameter)
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

if [[ -n ${RAINB_SCRIPTS_LOADED:-} ]]; then
    return 0 2>/dev/null || exit 0
fi
typeset -g RAINB_SCRIPTS_LOADED=1

FONT='\033[0m'
GREEN="\033[1;32m"
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE='\033[1;36m'

source "${0:h}"/config/rc.zsh

# add folder in functions and completions to fpath
# （fpath.zsh 会先被 sheldon 加载一次，这里再走一遍是为了单独 source 本文件时也成立）
source "${0:h}"/fpath.zsh

# mise 已经在 hook-env 里跑过 compinit 了；-i 而非 -C，好让新增的补全文件
# 在下一次启动时被发现
if ! (( $+functions[compdef] )); then
    autoload -Uz compinit
    compinit -i -d "${ZDOTDIR:-$HOME}/.zcompdump"
fi

# load functions
for __auto_laod_func_file in "${0:h}"/functions/**/*(.); do
    autoload -Uz "${__auto_laod_func_file:t}"
done

# load completions,alias,config
for __script_file in "${0:h}"/alias/*(.); do
    source "${__script_file}"
done
