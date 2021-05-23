#!/usr/bin/env bash

# Directories
export BASH_DIR="$HOME/.bash"
export BASH_TMP_DIR="$BASH_DIR/tmp"

# Internationalization
# Prefer US English and use UTF-8
export LANG="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";

# Custom Globals
# Make vim the default editor
export EDITOR="vim"

# FZF defaults
export FZF_DEFAULT_OPTS='--height 60% --layout=reverse --inline-info'
export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# SDKVM - Global packages
export SDKVM_NODE_PACKAGES="neovim http-server npm-check-updates eslint"
export SDKVM_PYTHON_PACKAGES="neovim"
export SDKVM_RUBY_PACKAGES="neovim"
