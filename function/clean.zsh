#!/usr/bin/env zsh

function clean_maven() {
  if cmd_exists fd; then
    fd ".*lastUpdated.*?" ~/.m2/repository -t f -x echo delete {} \; -x rm {} \;
    fd ".*repositories.*?" ~/.m2/repository -t f -x echo delete {} \; -x rm {} \;
    fd '.*\$.*' ~/.m2/repository -t d -x echo delete {} \; -x rm -r {} \;
  else
    find ~/.m2/repository -type f -name "*lastUpdated*" -exec echo {} \; -exec rm -r {} \;
    find ~/.m2/repository -type f -name "*repositories*" -exec echo {} \; -exec rm -r {} \;
    find ~/.m2/repository -type d -name "*\${*" -exec echo {} \; -exec rm -r {} \;
  fi
}

function clean_aira2() {
  if cmd_exists fd; then
    fd ".*\\.aria2" ~/Downloads -x echo delete {} \; -x rm {} \;
  else
    find ~/Downloads -type f -name "**\\.aria2" -exec echo {} \; -exec rm -r {} \;
  fi
}

function clean_ds_store() {
  if cmd_exists fd; then
    fd -IH ".DS_Store" . -x echo delete {} \; -x rm {} \;
  else
    find . -type f -name ".DS_Store" -exec echo {} \; -exec rm -r {} \;
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
    # due to define array is diffrent in zsh and bash
    if [[ "$current_shell" = "zsh" ]]; then
      local suffixes_arr=(${=suffixes})
    elif [[ "$current_shell" = "bash" ]]; then
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
  local compress_suffixes=".zip .gz .gz2 .rar .7z .zip"
  move_by_suffix "$compress_suffixes" "$downloads/compress"

  step "handle jars"
  move_by_suffix ".jar" "$downloads/jars"

  step "handle system mirror"
  local mirror_suffixes=".iso .ISO"
  move_by_suffix "$mirror_suffixes" "$downloads/mirrors"

  step "handle scripts"
  local script_suffixes=".sh .bat .zsh .js .ts .jsx .zx .ktr .sql"
  move_by_suffix "$script_suffixes" "$downloads/scripts"

  step "handle chrome extensions"
  move_by_suffix ".crx" "$downloads/chromeExtensions"

  step "handle data files"
  local data_suffixes=".csv .json .xml .txt .dat"
  move_by_suffix "$data_suffixes" "$downloads/data"

  step "handle configs"
  local data_suffixes=".terminal"
  move_by_suffix "$data_suffixes" "$downloads/config"

  step_end 'clear up Downloads'
}