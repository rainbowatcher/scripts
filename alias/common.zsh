#!/usr/bin/env zsh

alias ..='cd ..'
alias ...='cd ../..'
# alias cat='bat'

if cmd_exists exa; then
    alias ls='eza --group-directories-first'
    alias lt='ls -lhF --time-style long-iso -s time'
    alias ll='ls -lhF --time-style long-iso'
    alias lg='ls -lbGahF --time-style long-iso'
    alias lx='ls -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'
else 
    alias ll='ls -lhF'
fi

alias lsa='ls -a'

if cmd_exists code; then
    alias zshrc='code ~/.zshrc'
fi

if cmd_exists trash; then
    alias rm='trash'
fi

# alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# alias grep='rg --color=auto'

if cmd_exists fd; then
    alias fdd='fd -Ht d'
    alias fdf='fd -Ht f'
fi

# list whats inside packed file
alias -s zip="unzip -l"
alias -s rar="unrar l"
alias -s tar="tar -tf"
alias -s tar.gz="tar -tf"
alias -s gz="gunzip -l"

# IP addresses
alias public_ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias local_ip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -oE 'inet6? (addr:)?\s?((([0-9]+.){3}[0-9]+)|[a-fA-F0-9:]+)' | awk '{sub(/inet6? (addr:)? ?/, \"\"); print}'"
