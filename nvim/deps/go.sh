#!/usr/bin/env bash
set -euf -o pipefail

if command -v go &>/dev/null; then
  go install golang.org/x/tools/gopls@latest
  go install honnef.co/go/tools/cmd/staticcheck@latest
  go install mvdan.cc/gofumpt@latest
else
  echo "Missing command: go" >&2
  echo "Skipped: gopls, staticcheck, gofumpt"
  exit 1
fi
