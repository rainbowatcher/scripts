alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

if is_callable eza; then
    alias ls='eza --group-directories-first'
else
    alias ls='ls --color'
fi

alias lt='ls -lhF --time-style long-iso -s time'
alias ll='ls -lhF --time-style long-iso'
alias lg='ls -lbGahF --time-style long-iso'
alias lx='ls -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'
alias lsa='ls -a'

if is_callable code; then
    alias zshrc='code ~/.zshrc'
fi

if is_callable trash; then
    alias rm='trash'
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