#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/../bash/.bash/util/terminal.sh"

installPlugin() {
  local -r name="${1:?Expected name}"
  local -r url="${2:?Expected url}"
  if [ ! -d "$HOME/.tmux/deps/${name}" ]; then
    git clone "$url" "$HOME/.tmux/deps/${name}"
    echo "Tmux dependency installed: $name"
  else
    echo "Tmux dependency already installed: $name"
  fi
}

installPlugins() {
  mkdir -p ".tmux/deps"
  installPlugin "tmux-logging" "https://github.com:tmux-plugins/tmux-logging.git"
  installPlugin "tmux-prefix-highlight" "https://github.com:tmux-plugins/tmux-prefix-highlight.git"
  installPlugin "tmux-open" "https://github.com:tmux-plugins/tmux-open.git"
  installPlugin "tmux-copycat" "https://github.com:tmux-plugins/tmux-copycat.git"
  installPlugin "tmux-yank" "https://github.com:tmux-plugins/tmux-yank.git"
  installPlugin "tmux-fzf-url" "https://github.com:junegunn/tmux-fzf-url.git"
}

if command -v tmux &>/dev/null; then
  installPlugins
  printSuccess "Installed: tmux"
else
  printInfo "Skipped installation: tmux. Command not found."
fi
