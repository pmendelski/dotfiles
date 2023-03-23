#!/usr/bin/env bash

# Create a new directory and enter it
mkd() {
  mkdir -p "$@" && cd "$_" || exit
}

# Use Git’s colored diff when available
if hash git &>/dev/null; then
  function diff() {
    git diff --no-index --color-words "$@"
  }
fi

# `tre` is a shorthand for `tree` with hidden files and color enabled, ignoring
# the `.git` directory, listing directories first. The output gets piped into
# `less` with options to preserve color and line numbers, unless the output is
# small enough for one screen.
tre() {
  tree -aC -I '.git|node_modules|bower_components|build' --dirsfirst "$@" | less -FRNX
}

fstat() {
  local -r name="${1:?Expected filename}"
  local -r size="$(du -sh "$name" | cut -f1)"

}

# List files and dirs by their total sizes
fsize() {
  du -csh -- * | sort -hr
}
