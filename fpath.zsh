#!/usr/bin/env zsh

# fpath 只在这里扩展，好让 sheldon 把它排在 `mise activate` 之前：
# mise 的 hook-env 里会跑 compinit，看不到本仓库的 completions/ 就永远不注册。
# 函数和 alias 仍留在 main.zsh，排在 mise 之后加载，这样 alias 里的
# `type <tool>` 判断才能看到 mise 装的可执行文件。
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# homebrew 的补全目录不在 zsh 默认 fpath 上：`brew shellenv` 不带参数时不输出
# fpath，只有 `brew shellenv zsh` 才输出 fpath[1,0]。不加的话 brew 装的
# cargo/rg/fd/bat/gh/mise 等补全全是空的。
# 放在前面，好让 brew 的 _delta 盖过 zsh 自带的 _sccs（它把 delta 当 SCCS 命令）。
if [[ -z ${HOMEBREW_PREFIX:-} ]] && (( $+commands[brew] )); then
    HOMEBREW_PREFIX="$(brew --prefix 2>/dev/null)"
fi
if [[ -n ${HOMEBREW_PREFIX:-} && -d $HOMEBREW_PREFIX/share/zsh/site-functions ]]; then
    fpath=("$HOMEBREW_PREFIX"/share/zsh/site-functions $fpath)
fi

# 两个文件都会被 source，用 -U 去重，谁先来谁生效
typeset -U fpath
fpath=(
    # N 让空目录展开为空字符串而不再报错
    "${0:h}"/functions/**/*(N/)
    # 手写的补全放这里，和生成目录分开，重跑 gen-completions.sh 不会碰它
    "${0:h}"/completions.local(N/)
    "${0:h}"/completions
    $fpath
)
