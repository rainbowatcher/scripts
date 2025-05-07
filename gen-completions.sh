#!/usr/bin/env bash

_DIR="completions"

pnpm completion zsh > "$_DIR/pnpm"
# codegpt completion zsh > "$_DIR/codegpt" # not work now
fnm completions --shell zsh > "$_DIR/fnm"
npm completion > "$_DIR/npm"
pip completion --zsh > "$_DIR/pip"
pnpm completion zsh > "$_DIR/pnpm"