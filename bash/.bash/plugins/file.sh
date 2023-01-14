#!/usr/bin/env bash

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$_" || exit
}

# Determine size of a file or total size of a directory
function fs() {
  if du -b /dev/null >/dev/null 2>&1; then
    local arg=-sbh
  else
    local arg=-sh
  fi
  if [ -n "$*" ]; then
    du $arg -- "$@"
  else
    du $arg .[^.]* -- *
  fi
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
function tre() {
  tree -aC -I '.git|node_modules|bower_components|build' --dirsfirst "$@" | less -FRNX
}
