#!/usr/bin/env bash
set -euf -o pipefail

installPlugin() {
  local -r name="${1:?Expected name}"
  local -r url="${2:?Expected url}"
  if [ ! -d "~/.zsh/bundles/${name}" ]; then
    git clone "$url" "~/.zsh/bundles/${name}"
    echo "Zsh plugin insalled: $name"
  else
    echo "Zsh plugin already insalled: $name"
  fi
}

installPlugins() {
  installPlugin "autosuggestions" "git@github.com:zsh-users/zsh-autosuggestions.git"
  installPlugin "completions" "git@github.com:zsh-users/zsh-completions.git"
  installPlugin "syntax-highlighting" "git@github.com:zsh-users/zsh-syntax-highlighting.git"
  installPlugin "history-substring-search" "git@github.com:zsh-users/zsh-history-substring-search.git"
}

installPlugins
