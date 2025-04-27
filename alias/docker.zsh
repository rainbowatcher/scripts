#!/usr/bin/env zsh

if ! cmd_exists docker; then
    return
fi

alias dps="docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'"
alias dip="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
alias dstart="docker start"
alias dstop="docker stop"