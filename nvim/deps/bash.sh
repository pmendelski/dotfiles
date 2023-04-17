#!/usr/bin/env bash
set -euf -o pipefail

result=0

if command -v npm &>/dev/null; then
  npm i -g bash-language-server
else
  echo "Missing command: npm" >&2
  echo "Skipped: bash-language-server"
  result=1
fi

if command -v go &>/dev/null; then
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
else
  echo "Missing command: go" >&2
  echo "Skipped: shfmt"
  result=1
fi

exit $result
