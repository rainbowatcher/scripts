[ ! is_callable git ] && return

# region: MARK: commit
alias gaa='git add .'
alias gc='git commit -m'
alias gca='git commit -am'
alias gcam='git commit --amend --no-edit'
alias gp='git push'
alias gpl='git pull'
# endregion


# region MARK: clone
alias gcl='git clone'
alias gcl1='git clone --depth 1'
# endregion


# region MARK: log
alias gl='git log --oneline --cherry'
alias gll='git log --graph --cherry --pretty=format:"%h <%an> %ar %s"'
alias gsl='git shortlog'
# endregion


# region MARK: tag
alias gtl='git tag -l'
alias gtd='git tag -d'
# endregion


# region MARK: branch
alias gba='git branch -a'
alias gbd='git branch --delete'
alias gbrn='git branch -m'
alias gs='git switch'
# endregion


# region MARK: other
# current git repo's status in concisely
alias gst='git status -s'

alias gcat='git cat-file'
alias gcf='git config -l'
alias gcln='git clean -xdf'
alias gdf='git difftool'
alias gho='git hash-object'

# soft reset current branch to last commit
alias gundo='git reset --soft HEAD^'
# endregion
