#!/bin/bash

# Node.js
export NODE_REPL_HISTORY="$HOME/.node_history"; # Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY_SIZE="32768";      # Allow 32^3 entries; the default is 1000.
export NODE_REPL_MODE="sloppy";             # Use sloppy mode by default, matching web browsers.

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Add local bin modules to path
export PATH=$PATH:./node_modules/.bin

# Running locally installed npm executables
# http://www.2ality.com/2016/01/locally-installed-npm-executables.html
function npmbin { (PATH=$(npm bin):$PATH; eval $@;) }

# Set NODE_ENV to development
export NODE_ENV="development"

# Easy way to reinstall npm dependencies
alias npm-please="rm -rf node_modules && rm -rf package-lock.json && npm i"
# Easy way to update all npm dependencies
alias npm-update-dependencies="ncu && npm-please"

node-update() {
  local version=${1:---lts}
  nvm install $version
  nvm use $(node -v)
  npm install -g npm@latest
  npm install -g webpack http-server livereload yarn npm-check-updates
}


nvmrc-create() {
  echo "${1:-$(node -v)}" > .nvmrc
}

nvmrc-create-lts() {
  echo "lts/*" > .nvmrc
}
