# Rainbow Watcher's personal scripts

## Quick Start 

Write it to your `~/.zshrc` to enable those scripts.

```shell
SCRIPTS_ROOT="/path/to/project/location"
# if you want to enable proxy
HTTP_PROXY_ADDR=http://127.0.0.1:12345
source $SCRIPTS_ROOT/main.zsh all
```

## :exclamation: Attension

- Remember to change the proxy port number to you own.
- You better install [zoxide](https://github.com/ajeetdsouza/zoxide), exa, ripgrep, fnm, node, jq, gum through below command.

```shell
brew install zoxide exa ripgrep fnm node jq gum
```

## Alias

### cli

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
- ip: `dig +short myip.opendns.com @resolver1.opendns.com`
- localip: `ipconfig getifaddr en0`
- ips: `ifconfig -a \| grep -o inet6? (addr:)?\s?((([0-9]+.){3}[0-9]+)\|[a-fA-F0-9:]+) \| awk {sub(/inet6? (addr:)? ?/, \\); print}`

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
- gsl: `git shortlog`
- gdf: `git difftool`
- gca: `git commit -am`
- gc: `git commit -m`
- gcam: `git commit --amend --no-edit`
- gcl1: `git clone --depth 1`
- gcl: `git clone`

### mac

- showfiles: `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder`
- hidefiles: `defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder`
- spotlightoff: `sudo mdutil -a -i off`
- spotlighton: `sudo mdutil -a -i on`

## Completions

- npm

- pip

## Functions

### extras

1. update_node
2. update_node_global_pkg
3. update_rust
4. update_python
5. global_update
6. clean_maven
7. clean_aira2
8. clean_ds_store
9. global_clean
10. clear_downloads
11. gi

### fe

1. install_node_package
2. setup_eslint_config
3. init_tsconfig

### net

1. get_status_code

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
11. set_docker_mirror
12. proxy
13. unproxy
14. reset_brew_mirror
15. set_brew_mirror
16. set_v2ray_route

