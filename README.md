# Rainbow Watcher's personal scripts

## Quick Start

Write it to your `~/.zshrc` to enable those scripts.

```shell
SCRIPTS_ROOT="/path/to/your/scripts"
# if you want to enable proxy
HTTP_PROXY_ADDR=http://127.0.0.1:8889
source $SCRIPTS_ROOT/main.zsh all
```

## :exclamation: Attension

- Remember to change the proxy port number to you own.
- You must install zoxide, exa, ripgrep, fnm, npm, jq in you compute.

## Alias

### cli

- cd: `z`
- ..: `cd ..`
- ...: `cd ../..`
- ls: `exa`
- lsa: `ls -a`
- lt: `ls -lFh --time-style long-iso -s time`
- ll: `ls -laFh --time-style long-iso`
- lg: `ls -lbGaFh --time-style long-iso`
- lx: `ls -lbhHigUmuSa@ --time-style`
- zshrc: `code ~/.zshrc`
- dud: `du -hd1 \| sort --human-numeric-sort`
- duf: `du -hs * \| sort --human-numeric-sort`
- rm: `rm -i`
- cp: `cp -i`
- mv: `mv -i`
- grep: `rg --color`
- fdd: `fd -Ht d`
- fdf: `fd -Ht f`

### git

- gst: `git status`
- gl: `git log --oneline --cherry`
- gll: `git log --graph --cherry --pretty`
- gp: `git push`
- gpl: `git pull`
- gcf: `git config -l`
- gaa: `git add .`
- gcf: `git config --list`
- gba: `git branch -a`
- gbd: `git branch --delete`
- gbrn: `git branch -m`
- gho: `git hash-object`
- gcat: `git cat-file`
- gs: `git switch`

### mac

- showfiles: `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder`
- hidefiles: `defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder`
- spotlightoff: `sudo mdutil -a -i off`
- spotlighton: `sudo mdutil -a -i on`
- o: `open .`

## Completions

- npm

- pip

## Functions

### extras

1. update_node
2. update_node_global_packages
3. global_update
4. clean_maven
5. clean_aira2
6. global_clean
7. gi

### fe

1. install_node_package
2. eslint_config

### proxy

1. set_npm_proxy
2. unset_npm_proxy
3. set_npm_mirror
4. reset_npm_mirror
5. set_cli_proxy
6. unset_cli_proxy
7. set_git_proxy
8. unset_git_proxy
9. set_pip_mirror
10. reset_pip_mirror
11. proxy
12. unproxy
13. reset_brew_mirror
14. set_brew_mirror
