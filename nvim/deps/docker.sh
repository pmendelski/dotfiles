#!/usr/bin/env bash
set -euf -o pipefail

installHadolint() {
  local -r version="$(curl -s "https://api.github.com/repos/hadolint/hadolint/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')"
  if [ -z "$version" ]; then
    echo "Could not locate newest lua version" >&2
    return 1
  fi
  local os="Linux"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    os="Darwin"
  fi
  local arch="x86_64"
  if [ "$(uname -m)" == "arm64" ]; then
    arch="arm64"
  fi
  tmpdir="$(mktemp -d -t hadolint-XXXX)"
  curl -Lo $tmpdir/hadolint "https://github.com/hadolint/hadolint/releases/download/v$version/hadolint-$os-$arch"
  local -r appdir="$HOME/.local/app/hadolint"
  if [ -d "$appdir" ]; then
    rm -rf "${appdir}_bak"
    mv "$appdir" "${appdir}_bak"
  fi
  mkdir -p "$(dirname "$appdir")"
  mkdir -p ~/.local/bin
  mv "$tmpdir" "$appdir"
  ln -fs "$appdir/hadolint" ~/.local/bin/hadolint
  chmod u+x "$appdir/hadolint"
}

installHadolint
echo "Installed hadolint"

if command -v npm &>/dev/null; then
  npm i -g dockerfile-language-server-nodejs
else
  echo "Missing command: npm" >&2
  echo "Skipped: dockerfile-language-server-nodejs"
  exit 1
fi
