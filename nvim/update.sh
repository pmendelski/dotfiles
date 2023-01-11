#!/usr/bin/env bash
set -euf -o pipefail
<<<<<<< HEAD

=======
>>>>>>> ca1cb58 (Fix nvim update script)
declare -r DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")"
source "$DIR/shared.sh"

installDependencies
installPlugins
# Update treeSitters modules
nvim -c ":TSUpdate all" -c "q" --headless 2>&1
