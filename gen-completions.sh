#!/usr/bin/env bash

COMPLETIONS_DIR="completions"

trash -r "./$COMPLETIONS_DIR"/*


# codegpt completion zsh > "$COMPLETIONS_DIR/_codegpt" # not work now
fnm completions --shell zsh > "$COMPLETIONS_DIR/_fnm"
npm completion > "$COMPLETIONS_DIR/_npm_completion"
pip completion --zsh > "$COMPLETIONS_DIR/__pip"
pnpm completion zsh > "$COMPLETIONS_DIR/_pnpm_completion"
delta --generate-completion zsh > "$COMPLETIONS_DIR/_delta"