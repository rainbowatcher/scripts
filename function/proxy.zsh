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
  if [[ $(export | grep -c 'http[s]*?_proxy') -lt 2 ]]; then
    export http_proxy=$HTTP_PROXY_ADDR
    export https_proxy=$HTTP_PROXY_ADDR
    judge "set cli proxy to \"$HTTP_PROXY_ADDR\""
  else
    info "cli proxy has already set"
  fi
}

function unset_cli_proxy() {
  if [[ $(export | grep -c 'http[s]*?_proxy') -ne 0 ]]; then
    unset http_proxy
    unset https_proxy
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

# function reset_docker_mirror() {
#   if [ $(cat $HOME/.docker/daemon.json | jq 'has("registry-mirrors")') = 'true' ]; then
#     cat ~/.docker/daemon.json | jq 'del(."registry-mirrors")' >~/.docker/daemon.json
#     judge "reset docker mirror"
#   else
#     info "docker mirror has already reset"
#   fi
# }

function set_docker_mirror() {
  if ! test $DOCKER_MIRROR; then
    return 1
  fi

  echo "current only support manualy set mirror"
  echo '"registry-mirrors": ["https://28qb0tz2.mirror.aliyuncs.com"]'

  # local docker_daemon="$HOME/.docker/daemon.json"
  # if [ $(cat $docker_daemon | jq 'has("registry-mirrors")') = 'false' ]; then
  #   cat $docker_daemon | jq '. + { "registry-mirrors": ["https://28qb0tz2.mirror.aliyuncs.com"] }' >$docker_daemon
  #   judge "set docker mirror to \"https://28qb0tz2.mirror.aliyuncs.com\""
  # else
  #   info "docker mirror has already set"
  # fi
}

function proxy() {
  set_cli_proxy

  set_git_proxy

  set_npm_proxy

  reset_npm_mirror

  reset_pip_mirror

  # reset_docker_mirror
}

function unproxy() {
  unset_cli_proxy

  unset_git_proxy

  unset_npm_proxy

  set_npm_mirror

  set_pip_mirror

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

function set_v2ray_route() {
  step "choose v2ray install path"
  local v2ray_home=$(gum input --placeholder='/usr/local/opt/v2ray type to replace')
  v2ray_home=${v2ray_home:-"/usr/local/opt/v2ray"}
  route_path="$v2ray_home/share/v2ray"
  echo "set v2ray install path: /usr/local/opt/v2ray"

  step "backup dat files"
  geoip_file_path="$route_path/geoip.dat"
  geosite_file_path="$route_path/geosite.dat"
  [ -f "$geoip_file_path.bak" ] && rm -f "$geoip_file_path.bak"
  echo "removed $geoip_file_path.bak"
  [ -f "$geosite_file_path.bak" ] && rm -f "$geosite_file_path.bak"
  echo "removed $geosite_file_path.bak"
  [ -f "$geoip_file_path" ] && mv -v "$geoip_file_path" "$geoip_file_path.bak"
  [ -f "$geosite_file_path" ] && mv -v "$geosite_file_path" "$geosite_file_path.bak"

  step "download dat file"
  remote_ip_file="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat"
  remote_site_file="https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat"
  status_code=$(get_status_code "$remote_ip_file")
  if [ $status_code -ne 200 ]; then
    remote_ip_file="https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat"
    remote_site_file="https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat"
  fi
  gum spin --title="downloading geoip.dat" --show-output -- \
    curl -sSL "$remote_ip_file" -o "$geoip_file_path"
  gum spin --title="downloading geosite.dat" --show-output -- \
    curl -sSL "$remote_site_file" -o "$geosite_file_path"

  step "set recommended route config"
  echo "=== IP Direct ==="
  echo "223.5.5.5/32"
  echo "119.29.29.29/32"
  echo "180.76.76.76/32"
  echo "114.114.114.114/32"
  echo "geoip:cn"
  echo "geoip:private"
  echo ""
  echo "=== Domain Direct ==="
  echo "geosite:apple-cn"
  echo "geosite:cn"
  echo ""
  echo "=== IP Proxy ==="
  echo "1.1.1.1/32"
  echo "1.0.0.1/32"
  echo "8.8.8.8/32"
  echo "8.8.4.4/32"
  echo "geoip:us"
  echo "geoip:ca"
  echo "geoip:telegram"
  echo ""
  echo "=== Domain Proxy ==="
  echo "geosite:geolocation-!cn"
  echo "geosite:gfw"
  echo "geosite:greatfire"
  echo ""
  echo "=== Domain Block ==="
  echo "geosite:category-ads-all"
  echo ""
  info "you need set the route config manualy"

  step "set recommended dns config"
  info "refer: https://github.com/Loyalsoldier/v2ray-rules-dat#%E9%85%8D%E7%BD%AE%E5%8F%82%E8%80%83%E4%B8%8B%E9%9D%A2-"
  step_end
}
