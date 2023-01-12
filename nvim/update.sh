#!/usr/bin/env bash
set -euf -o pipefail

declare -r DIR
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/shared.sh"

installDependencies
installPlugins
