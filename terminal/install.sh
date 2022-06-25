#!/usr/bin/env bash
set -euf -o pipefail

# Does not work on ubuntu
# For macos import manually from _init/macos/iterm2
if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
  if [ -d "$HOME/.gogh" ]; then
    cd "$HOME/.gogh"
    git fetch
    git reset --hard origin/master
    cd themes
  else
    cd "$HOME"
    git clone https://github.com/Mayccoll/Gogh.git .gogh
    cd .gogh/themes
  fi

  ./atom.sh
  ./tokyo-night.sh
fi
