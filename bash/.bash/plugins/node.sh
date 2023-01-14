#!/usr/bin/env bash
# shellcheck disable=SC2030,SC2031

# Node.js
export NODE_REPL_HISTORY="$HOME/.node_history" # Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY_SIZE="32768"          # Allow 32^3 entries; the default is 1000.
export NODE_REPL_MODE="sloppy"                 # Use sloppy mode by default, matching web browsers.

# Running locally installed npm executables
# http://www.2ality.com/2016/01/locally-installed-npm-executables.html
function npmbin {
  (
    PATH=$(npm bin):$PATH
    eval "$*"
  )
}

# Use binaries from local node_modules
export PATH="./node_modules/.bin:$PATH"

# Set NODE_ENV to development
export NODE_ENV="development"

# Easy way to reinstall npm dependencies
alias npm-please="rm -rf node_modules && rm -rf package-lock.json && npm i"

# Easy way to update all npm dependencies
function npm-modules-update {
  if ! command -v ncu; then
    npm i -g npm-modules-update
  fi
  ncu -u && npm-please
}
