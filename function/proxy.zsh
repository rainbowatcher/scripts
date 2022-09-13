#!/usr/bin/env bash

function set_npm_proxy() {
  echo "proxy=$HTTP_PROXY_ADDR" >> "$HOME/.npmrc"
  echo "https-proxy=$HTTP_PROXY_ADDR" >> "$HOME/.npmrc"
}

function unset_npm_proxy() {
  sed -ie '/^proxy/d' "$HOME/.npmrc"
  sed -ie '/^https-proxy/d' "$HOME/.npmrc"
  judge "unset npm proxy"
}

function set_npm_mirror() {
  sed -ie 's$home=.*$home=https://npmmirror.com$g' $HOME/.npmrc
  sed -ie 's$registry=.*$registry=https://registry.npmmirror.com/$g' $HOME/.npmrc
  judge "set npm mirror"
}

function reset_npm_mirror() {
  sed -ie 's$home=.*npmmirror.com$home=https://www.npmjs.com$g' "$HOME/.npmrc"
  sed -ie 's$registry=.*npmmirror.com$registry=https://registry.npmjs.org$g' "$HOME/.npmrc"
  judge "reset npm mirror"
}

function set_cli_proxy() {
  export http_proxy=$HTTP_PROXY_ADDR
  export https_proxy=$HTTP_PROXY_ADDR
  judge "set cli proxy"
}

function unset_cli_proxy() {
  unset http_proxy
  unset https_proxy
  judge "unset cli proxy"
}

function set_git_proxy() {
  git config --global http.proxy $HTTP_PROXY_ADDR
  git config --global https.proxy $HTTP_PROXY_ADDR
  judge "set git proxy"
}

function unset_git_proxy() {
  git config --global --unset http.proxy
  git config --global --unset https.proxy
  judge "unset git proxy"
}

function set_pip_mirror() {
  echo "index-url = https://pypi.tuna.tsinghua.edu.cn/simple" >>~/.config/pip/pip.conf
  judge "set pip mirror"
}

function reset_pip_mirror() {
  sed -ie '/^index-url/d' ~/.config/pip/pip.conf
  judge "reset pip mirror"
}

function proxy() {
  if [[ $(export | grep -c 'http[s]*?_proxy') -lt 2 ]]; then
    set_cli_proxy
  else
    info "cli proxy has already set"
  fi

  if [ ! $(git config --get http.proxy) ]; then
    set_git_proxy
  else
    info "git proxy has already set"
  fi

  local npm_proxy npm_mirror
  npm_proxy=$(cat $HOME/.npmrc | grep ^proxy)
  npm_mirror=$(cat $HOME/.npmrc | grep ^registry)
  if [[ $npm_proxy == '' ]]; then
    set_npm_proxy
  else
    info "npm proxy has already set"
  fi

  if [[ $npm_mirror =~ 'npmmirror' ]]; then
    reset_npm_mirror
  else
    info "npm mirror has already reset"
  fi

  if cat ~/.config/pip/pip.conf | grep tsinghua >/dev/null 2>&1; then
    reset_pip_mirror
  else
    info "pip mirror has already reset"
  fi
}

function unproxy() {
  if [[ $(export | grep -c 'http[s]*?_proxy') -ne 0 ]]; then
    unset_cli_proxy
  else
    info "cli proxy has already unset"
  fi
  if [ $(git config --get http.proxy) ]; then
    unset_git_proxy
  else
    info "git proxy has already unset"
  fi

  local npm_proxy npm_mirror
  npm_proxy=$(cat $HOME/.npmrc | grep ^proxy)
  npm_mirror=$(cat $HOME/.npmrc | grep ^registry)
  if [[ $npm_proxy =~ 'http' ]]; then
    unset_npm_proxy
  else
    info "npm proxy has already unset"
  fi

  if [[ $npm_mirror =~ 'npmjs.org' ]]; then
    set_npm_mirror
  else
    info "taobao mirror has already use"
  fi

  if cat ~/.config/pip/pip.conf | grep tsinghua >/dev/null 2>&1; then
    info "pip mirror has already set"
  else
    set_pip_mirror
  fi
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