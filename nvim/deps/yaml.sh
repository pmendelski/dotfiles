#!/usr/bin/env bash
set -euf -o pipefail

if command -v npm &>/dev/null; then
  npm i -g yaml-language-server
else
  echo "Missing command: npm" >&2
  echo "Skipped: yaml-language-server"
  exit 1
fi

if command -v brew &>/dev/null; then
  brew install yamllint
elif command -v apt &>/dev/null; then
  sudo apt install yamllint
else
  echo "Missing command: brew/apt" >&2
  echo "Skipped: yamllint"
  exit 1
fi
