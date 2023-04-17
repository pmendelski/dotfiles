#!/usr/bin/env bash

nvim-install() {
  echo "Installing latest nvim stable release"
  local os="linux64"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    os="macos"
  fi
  tmpdir="$(mktemp -d -t nvim-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-$os.tar.gz" &&
      tar xf nvim.tar.gz
  )
  local -r nvimdir="$HOME/.local/app/nvim"
  if [ -d "$nvimdir" ]; then
    rm -rf "${nvimdir}_bak"
    mv "$nvimdir" "${nvimdir}_bak"
  fi
  mkdir -p "$(dirname "$nvimdir")"
  mkdir -p ~/.local/bin
  mv "$tmpdir/nvim-$os" "$nvimdir"
  ln -fs "$nvimdir/bin/nvim" ~/.local/bin/nvim
  rm -rf "$tmpdir"
  ~/.dotfiles/nvim/install.sh
}

nvim-install-dep() {
  local -r dep="${1:?Expected dependency}"
  if [ ! -f "$HOME/.dotfiles/nvim/deps/${dep}.sh" ]; then
    echo "NVIM dependency not recognized: $dep" >&2
    echo "Available dependencies:" >&2
    find "$HOME/.dotfiles/nvim/deps" | sed -n "s|^.\+/\([^/.]\+\)\.sh|\1|p" >&2
    return 1
  fi
  "$HOME/.dotfiles/nvim/deps/$dep.sh"
}

nvim-install-deps() {
  if [ $# -gt 0 ]; then
    echo "Expected no arguments" >&2
    echo "Did you mean: nvim-update-dep NAME" >&2
    return 1
  fi
  for file in $(find "$HOME/.dotfiles/nvim/deps" -mindepth 1 -maxdepth 1 -type f | sort | sed -n "s|^.*/||p"); do
    echo ">>> Installing nvim dependency: $file"
    "$HOME/.dotfiles/nvim/deps/$file" &&
      echo "<<< Installed nvim dependency: $file" ||
      echo "<<< Could not install nvim dependency: $file"
  done
}
