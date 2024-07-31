#!/usr/bin/env zsh

# update your node version using node version manager
function update_node() {
  if cmd_exists nvm; then
    local latest_version=$(nvm ls-remote --lts 16 | tail -1 | grep -o "v(\d{1,2}\.){2}\d{1,2}")
    local current_version=$(nvm current)
    if [[ $latest_version == $current_version ]]; then
      info "latest node version $latest_version is installed"
    else
      nvm install --lts
      # use pnpm to install global packages
      # nvm reinstall-packages $current_version
      # nvm use $latest_version
      # nvm uninstall $current_version
    fi
  elif cmd_exists fnm; then
    local remote_latest_version=$(fnm ls-remote | grep -o ".*)$" | awk '{print $1}' | tail -1)
    local current_version=$(fnm current)
    local local_latest_version=$(fnm ls | awk '{print $2}' | grep -e 'v.*' | tail -1)
    if [[ $remote_latest_version == $local_latest_version ]]; then
      info "latest node version [$remote_latest_version] is installed"
    else
      info "local latest node version is $local_latest_version"
      if gum confirm "install latest node version $remote_latest_version ?"; then
        fnm install --lts
        fnm default $local_latest_version
      else
        info "skip update node version"
      fi
    fi
  fi
}

# update node global packages
function update_node_global_pkg() {
  info "start update npm global packages"
  if cmd_exists npm && cmd_exists ncu; then
    local outdated
    outdated=$(ncu -g)
    eval $(echo $outdated | grep "npm -g install")
  elif cmd_exists npm; then
    npm update -g
  fi

  info "start update yarn global packages"
  cmd_exists yarn && yarn global upgrade -s

  info "start update pnpm global packages"
  cmd_exists pnpm && pnpm update -g
}

function update_rust() {
  cmd_exists rustup && rustup update
}

function update_python() {
  # python is recommended to install package by using pipx
  if cmd_exists pipx; then
    pipx upgrade-all
  fi
}

function global_update() {
  step "set proxy"
  cmd_exists proxy && proxy

  step "update homebrew packages"
  cmd_exists brew && brew update && brew upgrade

  step "update node version"
  update_node

  step "update rust packages"
  update_rust

  step "update python packages"
  update_python

  step "update node packages"
  update_node_global_pkg

  step "update sheldon packages"
  cmd_exists sheldon && sheldon lock --update

  step "update sdkman"
  cmd_exists sdk && sdk selfupdate

  step_end
}