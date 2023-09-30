#!/bin/zsh

function __loadZshPlugin() {
  local -r plugin="$1"
  local -r name="$(basename "$1")"

  if [ -r "$plugin/plugin.zsh" ]; then
    source "$plugin/plugin.zsh";
  elif [ -r "$plugin/$name.plugin.zsh" ]; then
    source "$plugin/$name.plugin.zsh";
  elif [ -r "$plugin" ]; then
    source "$plugin";
  else
    echo "Plugin not found: $plugin // $name"
  fi
}

function __loadZshPlugins() {
  local -r DIR="$1"
  [ ! -d "$DIR" ] && return;
  find "$DIR" -mindepth 1 -maxdepth 1 -not -name "setup.*" -print0 |
    while read -r -d $'\0' plugin; do
      __loadZshPlugin "$plugin"
    done
}

function __loadLocalZshFiles() {
  for file in $HOME/.zsh_{exports,aliases,functions,prompt}; do
    [ -r "$file" ] && source "$file"
  done
  for file in $HOME/.bash_{exports,aliases,functions,prompt}; do
    [ -r "$file" ] && source "$file"
  done
}

function __loadZsh() {
  source "$HOME/.bash/index.sh"
  source "$HOME/.bash/exports.sh"
  sourceOptional "$HOME/.dotfiles-ext/bash/exports.sh"
  source "$HOME/.zsh/exports.zsh"
  sourceOptional "$HOME/.dotfiles-ext/zsh/exports.zsh"
  source "$HOME/.bash/aliases.sh"
  sourceOptional "$HOME/.dotfiles-ext/bash/aliases.sh"
  source "$HOME/.zsh/aliases.zsh"
  sourceOptional "$HOME/.dotfiles-ext/zsh/aliases.zsh"
  __loadPath
  __loadLocalBashFiles
  __loadLocalZshFiles
  __loadZshPlugins "$HOME/.zsh/lib"
  __loadZshPlugins "$HOME/.dotfiles-ext/zsh/lib"
  # zsh-syntax-highligting must be loaded before others
  __loadZshPlugin "$HOME/.zsh/plugins/zsh-syntax-highlighting.zsh"
  __loadBashPlugins "$HOME/.bash/plugins"
  __loadBashPlugins "$HOME/.dotfiles-ext/bash/plugins"
  __loadZshPlugins "$HOME/.zsh/plugins"
  __loadZshPlugins "$HOME/.dotfiles-ext/zsh/plugins"
  __loadZshPlugins "$HOME/.zsh/ohmyzsh"
}

__loadZsh
