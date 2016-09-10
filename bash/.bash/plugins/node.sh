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
