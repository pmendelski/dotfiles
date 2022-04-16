#!/usr/bin/env bash
set -euf -o pipefail

installPlugin() {
  local -r name="${1:?Expected name}"
  local -r url="${2:?Expected url}"
  if [ ! -d "$HOME/.tmux/deps/${name}" ]; then
    git clone "$url" "$HOME/.tmux/deps/${name}"
    echo "Tmux dependency insalled: $name"
  else
    echo "Tmux dependency already insalled: $name"
  fi
}

installPlugins() {
  mkdir -p ".tmux/deps"
  installPlugin "tmux-logging" "git@github.com:tmux-plugins/tmux-logging.git"
  installPlugin "tmux-prefix-highlight" "git@github.com:tmux-plugins/tmux-prefix-highlight.git"
  installPlugin "tmux-open" "git@github.com:tmux-plugins/tmux-open.git"
  installPlugin "tmux-copycat" "git@github.com:tmux-plugins/tmux-copycat.git"
  installPlugin "tmux-yank" "git@github.com:tmux-plugins/tmux-yank.git"
}

installPlugins
