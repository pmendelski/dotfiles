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
export FZF_DEFAULT_COMMAND='fd --type file --follow --hidden'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Bat defaults
export BAT_THEME="TwoDark"

# SDKVM - Global packages
export SDKVM_NODE_PACKAGES="neovim http-server npm-check-updates eslint eslint_d bash-language-server vscode-langservers-extracted pyright sql-language-server svelte-language-server typescript typescript-language-server yaml-language-server vls graphql-language-service-cli dockerfile-language-server-nodejs diagnostic-languageserver"
export SDKVM_GO_PACKAGES="golang.org/x/tools/gopls@latest github.com/mattn/efm-langserver@latest github.com/jesseduffield/lazygit@latest"
export SDKVM_PYTHON_PACKAGES="neovim ueberzug bpytop yamllint"
export SDKVM_RUBY_PACKAGES="neovim"
