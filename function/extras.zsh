#!/usr/bin/env zsh

update_node() {
  if command_exists nvm; then
    local latest_version current_version
    latest_version=$(nvm ls-remote --lts 16 | tail -1 | grep -o "v(\d{1,2}\.){2}\d{1,2}")
    current_version=$(nvm current)
    if [[ $latest_version == $current_version ]]; then
      info "latest node version $latest_version is installed"
    else
      nvm install --lts
      # use pnpm to install global packages
      # nvm reinstall-packages $current_version
      # nvm use $latest_version
      # nvm uninstall $current_version
    fi
  elif command_exists fnm; then
    local latest_version current_version
    latest_version=$(fnm ls-remote | grep -o ".*\)$" | awk '{print $1}' | tail -1)
    current_version=$(fnm current)
    if [[ $latest_version == $current_version ]]; then
      info "latest node version $latest_version is installed"
    else
      fnm install --lts
      fnm default $latest_version
      # Due to i'm in use pnpm that installed by homebrew
      corepack disable pnpm
    fi
  fi
}

update_node_global_packages() {
  info "start update npm global packages"
  if command_exists npm && command_exists ncu; then
    local outdated
    outdated=$(ncu -ug)
    eval $(echo $outdated | grep "npm -g install")
  elif command_exists npm; then
    npm update -g
  fi

  info "start update yarn global packages"
  command_exists yarn && yarn global upgrade -s

  info "start update pnpm global packages"
  command_exists pnpm && pnpm update -g
}

global_update() {
  INIT_STEP=0
  step "set proxy"
  command_exists proxy && proxy

  step "update homebrew packages"
  command_exists brew && brew update && brew upgrade

  step "update node version"
  update_node

  step "update rust packages"
  command_exists rustup && rustup update

  step "update python packages"
  if command_exists python && command_exists pip; then
    python -m pip install --upgrade pip
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U
  fi

  step "update node packages"
  update_node_global_packages

  step "update sheldon packages"
  command_exists sheldon && sheldon lock --update
}

clean_maven() {
  if command_exists fd; then
    fd ".*lastUpdated.*?" ~/.m2/repository -x echo delete {} \; -x rm {} \;
    fd '.*\$.*' ~/.m2/repository -x echo delete {} \; -x rm -r {} \;
  else
    find ~/.m2/repository -type d -name "*\${*" -exec echo {} \; -exec rm -r {} \;
    find ~/.m2/repository -type f -name "*lastUpdated*" -exec echo {} \; -exec rm -r {} \;
  fi
}

clean_aira2() {
  if command_exists fd; then
    fd ".*\\.aria2" ~/Downloads -x echo delete {} \; -x rm {} \;
  else
    find ~/Downloads -type f -name "**\\.aria2" -exec echo {} \; -exec rm -r {} \;
  fi
}

global_clean() {
  INIT_STEP=0
  step "clean brew"
  brew cleanup

  step "clean maven"
  clean_maven

  step "clean pnpm store"
  pnpm store prune

  # step "clean npm cache"
  # npm cache clean --force

  step "clean yarn cache"
  yarn cache clean

  step "clean *.aria2"
  clean_aira2
}

# git ignore template downloader
gi() {
  if [[ $# == 1 ]]; then
    curl -sfLw '\n' https://www.toptal.com/developers/gitignore/api/$1 -o .gitignore
    judge "$1.gitignore download"
  else
    curl -sfL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
  fi
}
