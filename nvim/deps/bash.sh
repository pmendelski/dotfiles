#!/usr/bin/env bash
set -euf -o pipefail

if command -v npm &>/dev/null; then
  npm i -g bash-language-server
else
  echo "Missing command: npm" >&2
  echo "Skipped: bash-language-server"
fi

if command -v go &>/dev/null; then
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
else
  echo "Missing command: go" >&2
  echo "Skipped: shfmt"
fi
