#!/usr/bin/env zsh

# fpath 只在这里扩展，好让 sheldon 把它排在 `mise activate` 之前：
# mise 的 hook-env 里会跑 compinit，看不到本仓库的 completions/ 就永远不注册。
# 函数和 alias 仍留在 main.zsh，排在 mise 之后加载，这样 alias 里的
# `type <tool>` 判断才能看到 mise 装的可执行文件。
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# 两个文件都会被 source，用 -U 去重，谁先来谁生效
typeset -U fpath
fpath=(
    # N 让空目录展开为空字符串而不再报错
    "${0:h}"/functions/**/*(N/)
    "${0:h}"/completions
    $fpath
)
