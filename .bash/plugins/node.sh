#!/bin/bash

# Node.js
export NODE_REPL_HISTORY="$HOME/.node_history"; # Enable persistent REPL history for `node`.
export NODE_REPL_HISTORY_SIZE="32768";      # Allow 32^3 entries; the default is 1000.
export NODE_REPL_MODE="sloppy";             # Use sloppy mode by default, matching web browsers.

# Added by NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
