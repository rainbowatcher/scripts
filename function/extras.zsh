#!/usr/bin/env zsh

# update your node version
function update_node() {
  if cmd_exists nvm; then
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
  elif cmd_exists fnm; then
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

function update_node_global_pkg() {
  info "start update npm global packages"
  if cmd_exists npm && cmd_exists ncu; then
    local outdated
    outdated=$(ncu -ug)
    eval $(echo $outdated | grep "npm -g install")
  elif cmd_exists npm; then
    npm update -g
  fi

  info "start update yarn global packages"
  cmd_exists yarn && yarn global upgrade -s

  info "start update pnpm global packages"
  cmd_exists pnpm && pnpm update -g
}

function global_update() {
  step "set proxy"
  cmd_exists proxy && proxy

  step "update homebrew packages"
  cmd_exists brew && brew update && brew upgrade

  step "update node version"
  update_node

  step "update rust packages"
  cmd_exists rustup && rustup update

  step "update python packages"
  if cmd_exists python && cmd_exists pip; then
    python -m pip install --upgrade pip
    pip list -u --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
  fi

  step "update node packages"
  update_node_global_pkg

  step "update sheldon packages"
  cmd_exists sheldon && sheldon lock --update

  step_end
}

function clean_maven() {
  if cmd_exists fd; then
    fd ".*lastUpdated.*?" ~/.m2/repository -x echo delete {} \; -x rm {} \;
    fd '.*\$.*' ~/.m2/repository -x echo delete {} \; -x rm -r {} \;
  else
    find ~/.m2/repository -type d -name "*\${*" -exec echo {} \; -exec rm -r {} \;
    find ~/.m2/repository -type f -name "*lastUpdated*" -exec echo {} \; -exec rm -r {} \;
  fi
}

function clean_aira2() {
  if cmd_exists fd; then
    fd ".*\\.aria2" ~/Downloads -x echo delete {} \; -x rm {} \;
  else
    find ~/Downloads -type f -name "**\\.aria2" -exec echo {} \; -exec rm -r {} \;
  fi
}

function global_clean() {
  step "clean brew"
  brew cleanup
  brew autoremove

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

  step "clean \"Open With\" menu"
  /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder
  step_end
}

function clear_downloads() {
  local downloads="$HOME/Downloads"
  local files=$(list_files $downloads)

  move_by_suffix() {
    local suffixes=$1
    local target_dir=$2
    local current_shell=$(get_shell)
    if [[ "$current_shell" = "zsh" ]];then
      local suffixes_arr=(${=suffixes})
    elif [[ "$current_shell" == "bash" ]];then
      local suffixes_arr=($suffixes)
    fi
    for suffix in ${suffixes_arr[@]}; do
      local matched_files=($(echo $files | awk -v p="$suffix\$" '$0 ~ p {gsub(/ /,"∞™≠∞"); print}'))
      for file in ${matched_files[@]}; do
        local file=$(echo $file | awk '{gsub("∞™≠∞"," ");print}')
        local file_name=$(basename "$file")
        if [ -f "$file" ]; then
          if [ ! -e "$target_dir/$file_name" ]; then
            mv -v "$file" "$target_dir/$file_name"
            # echo "$file" "$target_dir/$file_name"
          else
            warn "target file exists: $target_dir/$file_name"
          fi
        else
          error "can't move $file to $target_dir/$file_name"
        fi
      done
    done
  }

  step "handle documents"
  local doc_suffixes=".doc .docx .xlsx .pdf .md .html"
  move_by_suffix "$doc_suffixes" "$downloads/document"

  # image
  step "handle images"
  local img_suffixes=".jpg .png .drawio .vsdx .gif .jpeg .svg"
  move_by_suffix "$img_suffixes" "$downloads/image"

  step "handle packages"
  local pkg_suffixes=".pkg .dmg .exe .msi"
  move_by_suffix "$pkg_suffixes" "$downloads/package"

  step "handle compress file"
  local compress_suffixes=".zip .gz .gz2 .rar .7z"
  move_by_suffix "$compress_suffixes" "$downloads/compress"

  step "handle jars"
  move_by_suffix ".jar" "$downloads/jars"

  step "handle system mirror"
  local mirror_suffixes=".iso .ISO"
  move_by_suffix "$mirror_suffixes" "$downloads/mirrors"

  step "handle scripts"
  local script_suffixes=".sh .bat .zsh .js .ts .jsx .zx"
  move_by_suffix "$script_suffixes" "$downloads/scripts"

  step "handle chrome extensions"
  move_by_suffix ".crx" "$downloads/chromeExtensions"

  step "handle data files"
  local data_suffixes=".csv .json .xml .txt .dat"
  move_by_suffix "$data_suffixes" "$downloads/data"

  # echo "剩下的文件移动到others："

  step_end 'clear up Downloads'
}

# git ignore template downloader
function gi() {
  if [[ $# == 1 ]]; then
    curl -sfLw '\n' https://www.toptal.com/developers/gitignore/api/$1 -o .gitignore
    judge "$1.gitignore download"
  else
    curl -sfL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n"
  fi
}
