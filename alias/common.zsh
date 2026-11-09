alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

if type eza &>/dev/null; then
    alias ls='eza --group-directories-first'
else
    alias ls='ls --color'
fi

alias lt='ls -lhF --time-style long-iso -s time'
alias ll='ls -lhF --time-style long-iso'
alias lg='ls -lbGahF --time-style long-iso'
alias lx='ls -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'
alias lsa='ls -a'

# rm 走废纸篓。优先指向全局 rm shim（~/.local/bin/rm，非交互式 shell 与 agent
# 也通过 PATH 命中它），shim 保留 rm 语义：-f 对不存在的文件返回 0、缺操作数报错、
# -i 交互确认；裸 trash 不具备这些行为。shim 缺失时才退回 trash。
if type trash &>/dev/null; then
    if [[ -x "$HOME/.local/bin/rm" ]]; then
        alias rm="$HOME/.local/bin/rm"
    else
        alias rm='trash'
    fi
fi

# list whats inside packed file
alias -s zip="unzip -l"
alias -s rar="unrar l"
alias -s tar="tar -tf"
alias -s tar.gz="tar -tf"
alias -s gz="gunzip -l"


# CORRECTION
alias cp="nocorrect cp -i"
alias man="nocorrect man"
alias mkdir="nocorrect mkdir"
alias mv="nocorrect mv -i"
alias sudo="nocorrect sudo"
alias su="nocorrect su"

alias grep='grep --color'
