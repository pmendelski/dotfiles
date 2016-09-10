#!/bin/bash

# Directories
BASH_DIR="$HOME/.bash"
BASH_TMP_DIR="$BASH_DIR/tmp"

# Internationalization
export LANG="en_US.UTF-8";                  # Prefer US English and use UTF-8.
export LC_ALL="en_US.UTF-8";

# Custom Globals
export EDITOR="vim"                         # Make vim the default editor.
export DEV="$HOME/Development"

# Added by wine
export WINEARCH=win32

export PATH="$PATH:$BASH_DIR/scripts"
