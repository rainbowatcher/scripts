#!/usr/bin/env zsh

function install_node_package() {
  if cmd_exists ni; then
    ni "$@"
  elif cmd_exists pnpm; then
    pnpm i "$@"
  elif cmd_exists yarn; then
    yarn add "$@"
  elif cmd_exists npm; then
    npm i "$@"
  else
    warn "no package manager found!"
    return 1
  fi
  judge "install $@"
}

function setup_eslint_config() {
  if ! file_exists package.json; then
    error "please init project first"
    return 1
  fi

  step "install dependencies"
  local package_name="@antfu/eslint-config"
  if [ "$(cat package.json | jq ".devDependencies | has(\"$package_name\") and has(\"eslint\")")" = 'true' ]; then
    info "dependencies has already installed"
  else
    install_node_package -D "$package_name" eslint
  fi

  step "config .eslintrc file"
  if file_exists .eslintrc; then
    if [ "$(cat .eslintrc | grep -c '@antfu')" -gt 0 ]; then
      info "eslintrc file already configed"
    else
      local file_content="$(cat .eslintrc)"
      echo "$file_content" | jq '. + { "extends": "@antfu" }' >.eslintrc
      judge "config .eslintrc file"
    fi
  else
    echo "{}" | jq '{ "extends": "@antfu" }' >.eslintrc
    judge "config .eslintrc file"
  fi

  step "add eslint config in package.json"
  if [ $(cat package.json | jq '.scripts| has("lint")') = 'true' ]; then
    info 'lint script has already define in the package.json'
  else
    local file_content=$(cat package.json)
    echo "$file_content" | jq '. + {"scripts": (.scripts + {"lint": "eslint .","lint:fix": "eslint . --fix" })}' >package.json
    judge "add eslint config in package.json"
  fi

  step "config settings.json"
  local settings_file_path=".vscode/settings.json"
  local settings_content='{ "prettier.enable": false, "editor.codeActionsOnSave": { "source.fixAll.eslint": true }, "editor.formatOnSave": false, }'
  if dir_exists .vscode; then
    if file_exists "$settings_file_path"; then
      if [ $(cat "$settings_file_path" | jq 'has("editor.codeActionsOnSave")') = 'true' ]; then
        info "settings.json has already configed"
      else
        local file_content="$(cat $settings_file_path)"
        echo "$file_content" | jq ". + $settings_content" >"$settings_file_path"
        judge "config setting.json"
      fi
    else
      touch "$settings_file_path"
      echo '{}' | jq "$settings_content" >"$settings_file_path"
      judge "config setting.json"
    fi
  else
    mkdir .vscode
    touch "$settings_file_path"
    echo '{}' | jq "$settings_content" >"$settings_file_path"
    judge "config setting.json"
  fi

  step_end
}

function setup_unocss() {
  echo "We will start to setup unocss for your project."
  echo "more info please refer https://github.com/unocss/unocss"

  step "check package.json exists"
  # if ! file_exists package.json; then
  #   error "please init project first"
  #   return 1
  # fi

  step "choose the presets you want use"
  local preset_list=$(gum choose --no-limit \
    "@unocss/preset-uno         - The default preset (right now it's equivalent to @unocss/preset-wind)." \
    "@unocss/preset-mini        - The minimal but essential rules and variants." \
    "@unocss/preset-wind        - Tailwind / Windi CSS compact preset." \
    "@unocss/preset-attributify - Provides Attributify Mode to other presets and rules." \
    "@unocss/preset-icons       - Use any icon as a class utility." \
    "@unocss/preset-web-fonts   - Web fonts at ease." \
    "@unocss/preset-typography  - The typography preset." \
    "@unocss/preset-tagify      - Tagify Mode for UnoCSS." \
    "@unocss/preset-rem-to-px   - Coverts rem to px for utils.")

  source $SCRIPTS_ROOT/util/case.zsh
  local preset_items=$(for item in ${preset_list[@]}; do
    name=$(echo $item | awk '{print $1}' | awk -F/ '{print $2}')
    export_name=$(to_pascal_case $name)
    echo $export_name
  done)
  local import_items=$(echo $preset_items | awk -v d=", " '{s=(NR==1?s:s d)$0} END{print s}')
  local presets=$(echo $preset_items | awk -v d=",\n        " '{s=(NR==1?s:s d)$0"()"} END{print s}')
  local preset_package_names=$(echo "${preset_list[*]}" | awk -v d=" " '{s=(NR==1?s:s d)$1} END{print s}')
  # gum spin --spinner dot --title "installing packages..." -- install_node_package "unocss ${preset_names[*]}"

  step "choose which config file you prefer to use."
  local config_file_name=$(gum choose "vite.config.ts" "vite.config.js" "unocss.config.ts" "unocss.config.js")
  local vite_config="import { defineConfig, $import_items } from 'unocss';

export default defineConfig({
    presets: [
        $presets
    ]
});"
  local uno_config="uno_config"
  case "${config_file_name}" in
  "vite.config.ts" | "vite.config.js")
    gum format --type=code $vite_config
    ;;
  "unocss.config.ts" | "unocss.config.js")
    gum format --type=code $uno_config
    ;;
  *)
    echo "default (none of above)"
    ;;
  esac

  # if file_exists $config_file_name;then

  # fi
  step_end
}

# unplugin-vue-components

function init_tsconfig() {
  if ! file_exists tsconfig.json; then
    local default_config='{ "compilerOptions": { "target": "ES2016", "module": "CommonJS", "esModuleInterop": true, "forceConsistentCasingInFileNames": true, "strict": true, "skipLibCheck": true } }'
    echo {} |
      jq ". + ${default_config}" >tsconfig.json
  else
    warn "tsconfig aleardy exists, please ensure use this command in a new project."
  fi
}
