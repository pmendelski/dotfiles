#!/bin/zsh

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"

if command -v docker &>/dev/null; then
  curl -s \
    -L https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker \
    -o "$DIR/_docker" && echo "Installed docker completion"
fi

if command -v docker-compose &>/dev/null; then
  curl -s \
    -L https://raw.githubusercontent.com/docker/compose/master/contrib/completion/zsh/_docker-compose \
    -o "$DIR/_docker-compose" && echo "Installed docker-compose completion"
fi

if command -v rustup &>/dev/null; then
  rustup completions zsh >"$DIR/_rustup" && echo "Installed rustup completion"
  rustup completions zsh cargo >"$DIR/_cargo" && echo "Installed cargo completion"
fi

if command -v kubectl &>/dev/null; then
  kubectl completion zsh >"$DIR/_kubectl" && echo "Installed kubectl completion"
fi

if command -v mise &>/dev/null; then
  mise completion zsh  >"$DIR/_mise" && echo "Installed mise completion"
fi

