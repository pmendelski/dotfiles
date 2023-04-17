#!/usr/bin/env bash
set -euf -o pipefail

if command -v npm &>/dev/null; then
  npm i -g graphql-language-service-cli
else
  echo "Missing command: npm" >&2
  echo "Skipped: graphql-language-service-cli"
fi
