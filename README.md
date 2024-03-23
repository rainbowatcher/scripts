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
- You better install [zoxide](https://github.com/ajeetdsouza/zoxide), eza, ripgrep, fnm, node, jq, gum through below command.

```shell
brew install zoxide eza ripgrep fnm node jq gum
```

## Alias

### cli

- ..: `cd ..`
- ...: `cd ../..`
- ls: `eza --icons --group-directories-first`
- lsa: `ls -a`
- lt: `ls -lhF --time-style long-iso -s time`
- ll: `ls -lhF --time-style long-iso`
- lg: `ls -lbGahF --time-style long-iso`
- lx: `ls -lbhHigUmuSa@ --time-style`
- zshrc: `code ~/.zshrc`
- rm: `trash`
- cp: `cp -i`
- mv: `mv -i`
- fdd: `fd -Ht d`
- fdf: `fd -Ht f`
- public_ip: `dig +short myip.opendns.com @resolver1.opendns.com`
- local_ip: `ipconfig getifaddr en0`
- ips: `ifconfig -a \| grep -o inet6? (addr:)?\s?((([0-9]+.){3}[0-9]+)\|[a-fA-F0-9:]+) \| awk {sub(/inet6? (addr:)? ?/, \\); print}`

### git

- gaa: `git add .`
- gba: `git branch -a`
- gbd: `git branch --delete`
- gbrn: `git branch -m`
- gc: `git commit -m`
- gca: `git commit -am`
- gcam: `git commit --amend --no-edit`
- gcat: `git cat-file`
- gcf: `git config -l`
- gcl1: `git clone --depth 1`
- gcl: `git clone`
- gcln: `git clean -xdf`
- gdf: `git difftool`
- gho: `git hash-object`
- gl: `git log --oneline --cherry`
- gll: `git log --graph --cherry --pretty`
- gp: `git push`
- gpl: `git pull`
- gs: `git switch`
- gsl: `git shortlog`
- gst: `git status -s`

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
4. install_profile_default_exts
5. setup_vscode_default_settings

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
22. set_v2ray_route

### rc


### sys

1. _calc_ram
2. ram
3. dud
4. dua
5. dun

