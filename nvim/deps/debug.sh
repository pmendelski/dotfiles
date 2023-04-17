#!/usr/bin/env bash
set -euf -o pipefail

if command -v code &>/dev/null; then
  # vscode plugins used by nvim to debug
  code --install-extension vadimcn.vscode-lldb
else
  echo "Missing command: code" >&2
  echo "Skipped: vadimcn.vscode-lldb"
  exit 1
fi
