#!/usr/bin/env bash
set -euf -o pipefail

if [[ "$(uname --all)" == *"Ubuntu"* ]]; then
  export TERMINAL="gnome-terminal"
fi

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
