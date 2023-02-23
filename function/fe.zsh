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
    install_node_package -D "$package_name" eslint --prefer-offline
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

# unplugin-vue-components

function init_tsconfig() {
  if ! file_exists tsconfig.json; then
    local default_config='{ "compilerOptions": { "forceConsistentCasingInFileNames": true, "target": "es2018", "module": "esnext", "lib": [ "ESNext", "DOM" ], "moduleResolution": "node", "esModuleInterop": true, "strict": true, "strictNullChecks": true, "resolveJsonModule": true, "skipLibCheck": true, "skipDefaultLibCheck": true } }'
    echo {} |
      jq ". + ${default_config}" >tsconfig.json
  else
    warn "tsconfig aleardy exists, please ensure use this command in a new project."
  fi
}

