#!/usr/bin/env bash
set -euf -o pipefail

if command -v npm &>/dev/null; then
  npm i -g pyright
else
  echo "Missing command: npm" >&2
  echo "Skipped: pyright"
fi
