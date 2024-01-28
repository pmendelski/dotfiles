#!/usr/bin/env bash
set -euf -o pipefail

if command -v npm &>/dev/null; then
  npm i -g \
    svelte-language-server \
    typescript \
    typescript-language-server \
    vls \
    stylelint-lsp \
    eslint \
    vscode-langservers-extracted \
    @tailwindcss/language-server
else
  echo "Missing command: npm" >&2
  echo "Skipped: typescript, eslint and more..."
  exit 1
fi
