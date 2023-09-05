#!/usr/bin/env bash
set -euf -o pipefail

installTaplo() {
  local os="linux"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    os="darwin"
  fi
  local arch="x86_64"
  if [ "$(uname -m)" == "arm64" ]; then
    arch="aarch64"
  fi
  mkdir -p ~/.local/bin
  curl -fL "https://github.com/tamasfe/taplo/releases/latest/download/taplo-full-$os-$arch.gz" |
    gunzip -c - >~/.local/bin/taplo
  chmod +x ~/.local/bin/taplo
}

installTaplo
