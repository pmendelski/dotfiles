#!/usr/bin/env bash
set -euf -o pipefail

if command -v npm &>/dev/null; then
  npm i -g dockerfile-language-server-nodejs
else
  echo "Missing command: npm" >&2
  echo "Skipped: dockerfile-language-server-nodejs"
  exit 1
fi
