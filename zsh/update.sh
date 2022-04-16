#!/usr/bin/env bash
set -euf -o pipefail

updatePlugins() {
  local -r dotfileDirs="$(find "$HOME/.zsh/deps" -mindepth 1 -maxdepth 1 -type d | sort)"
  for dir in $dotfileDirs; do
    if [ -d "$dir/.git" ]; then
      (cd "$dir" && git fetch --all && git reset --hard origin/master)
    fi
  done
}

updatePlugins
