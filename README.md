# Rainbow Watcher 的个人 zsh 插件

> 此文件由 `scripts/gen-readme.sh` 自动生成。

## 快速开始

### Sheldon

先把本地插件配置到 `~/.config/sheldon/plugins.toml`：

```toml
[plugins.scripts]
local = "~/path/to/scripts"
use = ["main.zsh"]
```

然后在 `~/.zshrc` 中启用 `sheldon`：

```zsh
eval "$(sheldon source)"
```

## 说明

- 目标环境是 `macOS + zsh + Homebrew`。
- 代理相关函数会在定义了 `HTTP_PROXY_ADDR` 时读取该值。

## 别名

### btm

- btme: `btm -e --process_memory_as_value --process_command`

### common

- ..: `cd ..`
- ...: `cd ../..`
- ....: `cd ../../..`
- lt: `ls -lhF --time-style long-iso -s time`
- ll: `ls -lhF --time-style long-iso`
- lg: `ls -lbGahF --time-style long-iso`
- lx: `ls -lbhHigUmuSa@ --time-style=long-iso --git --color-scale`
- lsa: `ls -a`
- cp: `nocorrect cp -i`
- man: `nocorrect man`
- mkdir: `nocorrect mkdir`
- mv: `nocorrect mv -i`
- sudo: `nocorrect sudo`
- su: `nocorrect su`
- grep: `grep --color`

### dir

- i: `cd $HOME/WorkSpace/private`
- p: `cd $HOME/WorkSpace/public`
- tmp: `cd $HOME/WorkSpace/temp`

### docker

- dps: `docker ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'`
- dip: `docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'`
- dstart: `docker start`
- dstop: `docker stop`

### fd

- fdd: `fd -Ht d`
- fdf: `fd -Ht f`

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
- gll: `git log --graph --cherry --pretty=format:"%h <%an> %ar %s"`
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

### hyperfine

- hf: `hyperfine`
- hf5: `hf -r5 -w5`

### just

- j: `just`
- jc: `just --choose`

### mac

- showfiles: `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder`
- hidefiles: `defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder`
- spotlightoff: `sudo mdutil -a -i off`
- spotlighton: `sudo mdutil -a -i on`

### net

- public_ip: `dig +short myip.opendns.com @resolver1.opendns.com`
- local_ip: `ipconfig getifaddr en0`
- ips: `ifconfig -a | grep -oE 'inet6? (addr:)?\s?((([0-9]+.){3}[0-9]+)|[a-fA-F0-9:]+)' | awk '{sub(/inet6? (addr:)? ?/, \"\"); print}'`
- status_code: `curl -LI -m 10 -o /dev/null -s -w '%{http_code}'`

### nodejs

- nio: `ni --prefer-offline`
- nid: `ni -D`
- nido: `ni -D --prefer-offline`
- nidw: `ni -wD`
- niw: `ni -w`
- d: `nr dev`
- s: `nr start`
- b: `nr build`
- c: `nr clean`
- l: `nr lint`
- t: `nr test`

### sys

- pid: `pgrep -lf`

## 补全

- pip
- delta
- fnm
- npm
- pnpm

## 函数

### clean

- clean_aria2
- clean_downloads
- clean_ds_store
- clean_maven
- clean_open_with
- clean_zcompdump

### common

- zsh_load_time

### echo

- error
- info
- judge
- o
- step
- step_end
- warn

### git

- gi
- grename

### helper

- cht

### path

- dir
- dua
- dud

### proxy

- proxy
- reset_brew_mirror
- reset_cargo_mirror
- reset_npm_mirror
- reset_rustup_mirror
- set_brew_mirror
- set_cargo_mirror
- set_cargo_proxy
- set_cli_proxy
- set_git_proxy
- set_npm_mirror
- set_npm_proxy
- set_rustup_mirror
- unproxy
- unset_cargo_proxy
- unset_cli_proxy
- unset_git_proxy
- unset_npm_proxy

### sys

- cmd_exists
- port
- ram

### update

- upgrade_bun
- upgrade_bun_global_pkg
- upgrade_node
- upgrade_sdkman
- upgrade_sheldon_plugin

