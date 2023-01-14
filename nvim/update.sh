#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/shared.sh"

installDependencies
installPlugins
nvim -c ":TSUpdate all" -c "q" --headless 2>&1
