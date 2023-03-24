#!/usr/bin/env bash

# Create a new directory and enter it
mkd() {
  mkdir -p "$@" && cd "$_" || exit
}

# List files and dirs by their total sizes
fsize() {
  du -csh -- * | sort -hr
}

# Bat based log file watcher
flog() {
  tail -f "$1" | bat --paging=never -l log
}

# Use colored diff when available
if hash delta &>/dev/null; then
  function diff() {
    delta "$@"
  }
elif hash git &>/dev/null; then
  function diff() {
    git diff --no-index --color-words "$@"
  }
fi
