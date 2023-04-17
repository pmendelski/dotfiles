#!/usr/bin/env bash
set -euf -o pipefail

if command -v npm &>/dev/null; then
  npm i -g \
    vscode-langservers-extracted \
    prettier \
    diagnostic-languageserver
else
  echo "Missing command: npm" >&2
  echo "Skipped: prettier, diagnostics and more..."
  exit 1
fi
