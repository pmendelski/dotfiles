#!/bin/bash

# Directories
export BASH_DIR="$HOME/.bash"
export BASH_TMP_DIR="$BASH_DIR/tmp"
export FLEXI_PROMPT_DIR="$BASH_DIR/prompts/flexi"

# Internationalization
export LANG="en_US.UTF-8";                  # Prefer US English and use UTF-8.
export LC_ALL="en_US.UTF-8";

# Custom Globals
export EDITOR="vim"                         # Make vim the default editor.
export DEV="$HOME/Development"

# Added by wine
export WINEARCH=win32

export PATH="$PATH:$BASH_DIR/scripts"
