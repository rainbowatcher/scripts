#!/usr/bin/env bash

alias gaa='git add .'
alias gba='git branch -a'
alias gbd='git branch --delete'
alias gbrn='git branch -m'

alias gc='git commit -m'
alias gca='git commit -am'
alias gcam='git commit --amend --no-edit'

alias gcat='git cat-file'

alias gcf='git config -l'

alias gcl1='git clone --depth 1'
alias gcl='git clone'

alias gcln='git clean -xdf'
alias gdf='git difftool'
alias gho='git hash-object'

alias gl='git log --oneline --cherry'
alias gll='git log --graph --cherry --pretty=format:"%h <%an> %ar %s"'

alias gtl='git tag -l'
alias gtd='git tag -d'

alias gp='git push'
alias gpl='git pull'
alias gs='git switch'
alias gsl='git shortlog'
# current git repo's status in concisely
alias gst='git status -s'

# soft reset current branch to last commit
alias gundo='git reset --soft HEAD^'