#!/usr/bin/env zsh

[ ! cmd_exists docker ] && return

alias dps="docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'"
alias dip="docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'"
alias dstart="docker start"
alias dstop="docker stop"