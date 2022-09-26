#!/usr/bin/env zsh

# z is a shortcut for zoxide
alias cd='z'
alias ..='cd ..'
alias ...='cd ../..'
# alias cat='bat'
alias ls='exa'
alias lsa='ls -a'
alias lt='ls -lFh --time-style long-iso -s time'
alias ll='ls -laFh --time-style long-iso'
alias lg='ls -lbGaFh --time-style long-iso'
alias lx='ls -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'
alias zshrc='code ~/.zshrc'
alias dud='du -hd1 | sort --human-numeric-sort'
alias duf='du -hs * | sort --human-numeric-sort'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias grep='rg --color=auto'
alias fdd='fd -Ht d'
alias fdf='fd -Ht f'

# list whats inside packed file
alias -s zip="unzip -l"
alias -s rar="unrar l"
alias -s tar="tar -tf"
alias -s tar.gz="tar -tf"

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6? (addr:)?\s?((([0-9]+.){3}[0-9]+)|[a-fA-F0-9:]+)' | awk '{sub(/inet6? (addr:)? ?/, \"\"); print}'"
