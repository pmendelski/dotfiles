#!/usr/bin/env bash

declare -r DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"

curl -s \
    -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker \
    -o "$DIR/_docker" && echo "Installed docker completion"

curl -s \
    -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose \
    -o "$DIR/_docker-compose" && echo "Installed docker-compose completion"

if command -v rustup &>/dev/null; then
  rustup completions zsh > "$DIR/_rustup" && echo "Installed rustup completion"
fi
