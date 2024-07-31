#!/usr/bin/env bash

function set_npm_proxy() {
  local npm_proxy npm_mirror
  npm_proxy=$(cat $HOME/.npmrc | grep ^proxy)
  npm_mirror=$(cat $HOME/.npmrc | grep ^registry)
  if [[ $npm_proxy == '' ]]; then
    echo "proxy=$HTTP_PROXY_ADDR" >>"$HOME/.npmrc"
    echo "https-proxy=$HTTP_PROXY_ADDR" >>"$HOME/.npmrc"
    judge "set npm proxy to \"$HTTP_PROXY_ADDR\""
  else
    info "npm proxy has already set"
  fi
}

function unset_npm_proxy() {
  local npm_proxy npm_mirror
  npm_proxy=$(cat $HOME/.npmrc | grep ^proxy)
  npm_mirror=$(cat $HOME/.npmrc | grep ^registry)
  if [[ $npm_proxy =~ 'http' ]]; then
    sed -ie '/^proxy/d' "$HOME/.npmrc"
    sed -ie '/^https-proxy/d' "$HOME/.npmrc"
    judge "unset npm proxy"
  else
    info "npm proxy has already unset"
  fi
}

function set_npm_mirror() {
  local npm_proxy npm_mirror
  npm_proxy=$(cat $HOME/.npmrc | grep ^proxy)
  npm_mirror=$(cat $HOME/.npmrc | grep ^registry)
  if [[ $npm_mirror =~ 'npmjs.org' ]]; then
    sed -ie 's$home=.*$home=https://npmmirror.com$g' $HOME/.npmrc
    sed -ie 's$registry=.*$registry=https://registry.npmmirror.com/$g' $HOME/.npmrc
    judge "set npm mirror to \"https://registry.npmmirror.com/\""
  else
    info "taobao mirror has already use"
  fi
}

function reset_npm_mirror() {
  local npm_proxy npm_mirror
  npm_proxy=$(cat $HOME/.npmrc | grep ^proxy)
  npm_mirror=$(cat $HOME/.npmrc | grep ^registry)
  if [[ $npm_mirror =~ 'npmmirror' ]]; then
    sed -ie 's$home=.*npmmirror.com$home=https://www.npmjs.com$g' "$HOME/.npmrc"
    sed -ie 's$registry=.*npmmirror.com$registry=https://registry.npmjs.org$g' "$HOME/.npmrc"
    judge "reset npm mirror to \"https://registry.npmjs.org\""
  else
    info "npm mirror has already reset"
  fi
}

function set_cli_proxy() {
  if [[ $(export | grep -Eic 'HTTP[S]?_PROXY') -lt 2 ]]; then
    export HTTP_PROXY=$HTTP_PROXY_ADDR
    export HTTPS_PROXY=$HTTP_PROXY_ADDR
    judge "set cli proxy to \"$HTTP_PROXY_ADDR\""
  else
    info "cli proxy has already set"
  fi
}

function unset_cli_proxy() {
  if [[ $(export | grep -Eic 'HTTP[S]?_PROXY') -ne 0 ]]; then
    unset HTTP_PROXY
    unset HTTPS_PROXY
    judge "unset cli proxy"
  else
    info "cli proxy has already unset"
  fi
}

function set_git_proxy() {
  if [ ! $(git config --get http.proxy) ]; then
    git config --global http.proxy $HTTP_PROXY_ADDR
    git config --global https.proxy $HTTP_PROXY_ADDR
    judge "set git proxy to \"$HTTP_PROXY_ADDR\""
  else
    info "git proxy has already set"
  fi
}

function unset_git_proxy() {
  if [ $(git config --get http.proxy) ]; then
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    judge "unset git proxy"
  else
    info "git proxy has already unset"
  fi
}

function set_pip_mirror() {
  if cat ~/.config/pip/pip.conf | grep tsinghua >/dev/null 2>&1; then
    info "pip mirror has already set"
  else
    echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >>~/.config/pip/pip.conf
    judge "set pip mirror to \"https://pypi.tuna.tsinghua.edu.cn/simple\""
  fi
}

function reset_pip_mirror() {
  if cat ~/.config/pip/pip.conf | grep tsinghua >/dev/null 2>&1; then
    sed -ie '/^index-url/d' ~/.config/pip/pip.conf
    judge "reset pip mirror"
  else
    info "pip mirror has already reset"
  fi
}

function set_docker_mirror() {
  echo "there no mirror useable without proxy"
}

function set_rustup_mirror() {
  if [[ $(export | grep -c RUSTUP_UPDATE_ROOT) -lt 1 ]]; then
    export RUSTUP_UPDATE_ROOT=https://mirrors.tuna.tsinghua.edu.cn/rustup/rustup
    export RUSTUP_DIST_SERVER=https://mirrors.tuna.tsinghua.edu.cn/rustup
    judge "set rustup mirror to \"https://mirrors.tuna.tsinghua.edu.cn/rustup\""
  else
    info "rustup mirror has already set"
  fi
}

function reset_rustup_mirror() {
  if [[ $(export | grep -c RUSTUP_UPDATE_ROOT) -lt 1 ]]; then
    info "rustup mirror has already unset"
  else
    unset RUSTUP_UPDATE_ROOT RUSTUP_DIST_SERVER
    judge "reset rustup mirror"
  fi
}

function set_cargo_proxy() {
  if [[ $(cat "$HOME/.cargo/config.yaml" | grep -c proxy) -eq 1 ]]; then
    info "cargo proxy has already set"
  else
    echo "[http]\nproxy=\"${HTTP_PROXY_ADDR:7}\"" >>"$HOME/.cargo/config.yaml"
    judge "set cargo proxy to \"${HTTP_PROXY_ADDR:7}\""
  fi
}

function unset_cargo_proxy() {
  if [[ $(cat "$HOME/.cargo/config.yaml" | grep -c proxy) -eq 1 ]]; then
    sed -ie '/^proxy/d' "$HOME/.cargo/config.yaml"
    sed -ie '/^\[http/d' "$HOME/.cargo/config.yaml"
    judge "unset cargo proxy"
  else
    info "cargo proxy has already unset"
  fi
}

function set_cargo_mirror() {
  if [[ $(cat ~/.cargo/config.yaml | grep -c source.mirror) -eq 1 ]]; then
    info "cargo mirror has already set"
  else
    echo "\n[source.crates-io]\nreplace-with = 'mirror'\n\n[source.mirror]\nregistry = \"sparse+https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/\"" >>$HOME/.cargo/config.yaml
    judge "set cargo mirror to https://mirrors.tuna.tsinghua.edu.cn/crates.io-index/"
  fi
}

function reset_cargo_mirror() {
  if [[ $(cat "$HOME/.cargo/config.yaml" | grep -c "registry") -eq 1 ]]; then
    sed -ie '/^$/d' "$HOME/.cargo/config.yaml"
    sed -ie '/^\[source/d' "$HOME/.cargo/config.yaml"
    sed -ie '/mirror/d' "$HOME/.cargo/config.yaml"
    judge "unset cargo mirror"
  else
    info "cargo mirror has already set"
  fi
}

function proxy() {
  set_cli_proxy

  set_git_proxy

  set_npm_proxy

  set_cargo_proxy

  reset_cargo_mirror
  
  reset_npm_mirror

  reset_pip_mirror

  reset_rustup_mirror

  # reset_docker_mirror
}

function unproxy() {
  unset_cli_proxy

  unset_git_proxy

  unset_npm_proxy

  unset_cargo_proxy

  set_cargo_mirror

  set_npm_mirror

  set_pip_mirror

  set_rustup_mirror

  # set_docker_mirror
}

function reset_brew_mirror() {
  # brew 程序本身，Homebrew / Linuxbrew 相同
  unset HOMEBREW_BREW_GIT_REMOTE
  git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew

  # 以下针对 macOS 系统上的 Homebrew
  unset HOMEBREW_CORE_GIT_REMOTE
  BREW_TAPS="$(
    BREW_TAPS="$(brew tap 2>/dev/null)"
    echo -n "${BREW_TAPS//$'\n'/:}"
  )"
  for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
    if [[ ":${BREW_TAPS}:" == *":homebrew/${tap}:"* ]]; then # 只复原已安装的 Tap
      brew tap --custom-remote "homebrew/${tap}" "https://github.com/Homebrew/homebrew-${tap}"
    fi
  done

  judge "reset homebrew mirror"
}

function set_brew_mirror() {
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  brew tap --custom-remote --force-auto-update homebrew/core https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
  brew tap --custom-remote --force-auto-update homebrew/cask https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
  brew tap --custom-remote --force-auto-update homebrew/cask-fonts https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-fonts.git
  brew tap --custom-remote --force-auto-update homebrew/cask-drivers https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-drivers.git
  brew tap --custom-remote --force-auto-update homebrew/cask-versions https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask-versions.git
  brew tap --custom-remote --force-auto-update homebrew/command-not-found https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-command-not-found.git
  judge "set homebrew mirror"
}

