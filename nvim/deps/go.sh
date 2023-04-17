#!/usr/bin/env bash
set -euf -o pipefail

installGolangciLint() {
  local -r version="$(curl -s "https://api.github.com/repos/golangci/golangci-lint/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')"
  if [ -z "$version" ]; then
    echo "Could not locate newest lua version" >&2
    return 1
  fi
  local os="linux"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    os="darwin"
  fi
  local arch="amd64"
  if [ "$(uname -m)" == "arm64" ]; then
    arch="arm64"
  fi
  tmpdir="$(mktemp -d -t golangci-lint-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo golangci-lint.tar.gz "https://github.com/golangci/golangci-lint/releases/download/v$version/golangci-lint-$version-$os-$arch.tar.gz" &&
      tar xf golangci-lint.tar.gz
  )
  local -r nvimdir="$HOME/.local/app/golangci-lint"
  if [ -d "$nvimdir" ]; then
    rm -rf "${nvimdir}_bak"
    mv "$nvimdir" "${nvimdir}_bak"
  fi
  mkdir -p "$(dirname "$nvimdir")"
  mkdir -p ~/.local/bin
  mv "$tmpdir/golangci-lint-$version-$os-$arch" "$nvimdir"
  ln -fs "$nvimdir/golanci-lint" ~/.local/bin/golangci-lint
  rm -rf "$tmpdir"
}

installGolangciLint
echo "Installed golangci-lint"

if command -v go &>/dev/null; then
  go install golang.org/x/tools/gopls@latest
  go install honnef.co/go/tools/cmd/staticcheck@latest
  go install mvdan.cc/gofumpt@latest
else
  echo "Missing command: go" >&2
  echo "Skipped: gopls, staticcheck, gofumpt"
  exit 1
fi
