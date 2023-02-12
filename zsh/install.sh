#!/usr/bin/env bash
set -euf -o pipefail

installPlugin() {
  local -r name="${1:?Expected name}"
  local -r url="${2:?Expected url}"
  if [ ! -d "$HOME/.zsh/deps/${name}" ]; then
    git clone "$url" "$HOME/.zsh/deps/${name}"
    echo "Zsh dependency insalled: $name"
  else
    echo "Zsh dependency already insalled: $name"
  fi
}

installPlugins() {
  mkdir -p "$HOME/.zsh/deps"
  installPlugin "zsh-autosuggestions" "git@github.com:zsh-users/zsh-autosuggestions.git"
  installPlugin "zsh-completions" "git@github.com:zsh-users/zsh-completions.git"
  installPlugin "zsh-syntax-highlighting" "git@github.com:zsh-users/zsh-syntax-highlighting.git"
  installPlugin "zsh-history-substring-search" "git@github.com:zsh-users/zsh-history-substring-search.git"
  installPlugin "ohmyzsh" "git@github.com:ohmyzsh/ohmyzsh.git"
}

installPlugins
