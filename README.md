# Rainbow Watcher's personal scripts

## Quick Start 

Write it to your `~/.zshrc` to enable those scripts.

```shell
# if you want to enable proxy
HTTP_PROXY_ADDR=http://127.0.0.1:12345
source /path/to/project/location/main.zsh
```

> [!NOTE]
>
> - Remember to change the proxy port number to you own.
> - this repository used some third-party packages: `zoxide`, `eza`, `ripgrep`, `fnm`, `node`, `jq`, `gum`...etc
> 
> ```shell
> brew install zoxide eza ripgrep fnm node jq gum
> ```

## Alias

### common

- ..: `cd ..`
- ...: `cd ../..`
- lsa: `ls -a`
- cp: `cp -i`
- mv: `mv -i`
- public_ip: `dig +short myip.opendns.com @resolver1.opendns.com`
- local_ip: `ipconfig getifaddr en0`
- ips: `ifconfig -a \| grep -oE inet6? (addr:)?\s?((([0-9]+.){3}[0-9]+)\|[a-fA-F0-9:]+) \| awk {sub(/inet6? (addr:)? ?/, \\); print}`
- cp: `nocorrect cp`
- man: `nocorrect man`
- mkdir: `nocorrect mkdir`
- mv: `nocorrect mv`
- sudo: `nocorrect sudo`
- su: `nocorrect su`

### docker

- dps: `docker ps -a --format table {{.Names}}\t{{.Image}}\t{{.Status}}`
- dip: `docker inspect -f {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}`
- dstart: `docker start`
- dstop: `docker stop`

### git

- gaa: `git add .`
- gc: `git commit -m`
- gca: `git commit -am`
- gcam: `git commit --amend --no-edit`
- gp: `git push`
- gpl: `git pull`
- gcl: `git clone`
- gcl1: `git clone --depth 1`
- gl: `git log --oneline --cherry`
- gll: `git log --graph --cherry --pretty`
- gsl: `git shortlog`
- gtl: `git tag -l`
- gtd: `git tag -d`
- gba: `git branch -a`
- gbd: `git branch --delete`
- gbrn: `git branch -m`
- gs: `git switch`
- gst: `git status -s`
- gcat: `git cat-file`
- gcf: `git config -l`
- gcln: `git clean -xdf`
- gdf: `git difftool`
- gho: `git hash-object`
- gundo: `git reset --soft HEAD^`

### mac

- showfiles: `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder`
- hidefiles: `defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder`
- spotlightoff: `sudo mdutil -a -i off`
- spotlighton: `sudo mdutil -a -i on`

## Completions

- npm

- pip

## Functions

### clean

1. clean_maven
2. clean_aira2
3. clean_ds_store
4. global_clean
5. clear_downloads

### extras

1. gi
2. major
3. zsh_time
4. cht

### fzf


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
12. set_rustup_mirror
13. reset_rustup_mirror
14. set_cargo_proxy
15. unset_cargo_proxy
16. set_cargo_mirror
17. reset_cargo_mirror
18. proxy
19. unproxy
20. reset_brew_mirror
21. set_brew_mirror

### rc


### sys

1. _calc_ram
2. ram
3. dud
4. dua
5. dun
6. port
7. pid

### update

1. update_node
2. update_node_global_pkg
3. update_rust
4. update_python
5. global_update

