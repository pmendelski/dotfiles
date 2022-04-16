#!/usr/bin/env bash
set -euf -o pipefail
source "./shared.sh"

linkConfig() {
  local -r configDir="$(nvim --cmd ":echo stdpath('config')" --cmd "qall" --headless 2>&1)"
  mkdir -p "$(dirname "$configDir")"
  if [ ! -L "$configDir" ]; then
    ln -s ~/.nvim "$configDir"
  fi
}

linkConfig
installDependencies
installPlugins
