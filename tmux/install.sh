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
  installPlugin "logging" "git@github.com:tmux-plugins/tmux-logging.git"
  installPlugin "prefix-highlight" "git@github.com:tmux-plugins/tmux-prefix-highlight.git"
  installPlugin "open" "git@github.com:tmux-plugins/tmux-open.git"
  installPlugin "copycat" "git@github.com:tmux-plugins/tmux-copycat.git"
  installPlugin "yank" "git@github.com:tmux-plugins/tmux-yank.git"
}

installPlugins
