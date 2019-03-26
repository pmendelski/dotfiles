#!/bin/zsh

function __loadZshPlugin() {
  local -r PLUGIN="$1"
  if [ -r "$PLUGIN/plugin.zsh" ]; then
    source "$PLUGIN/plugin.zsh";
    fpath=("$PLUGIN" $fpath);
  elif [ -r "$PLUGIN.zsh" ]; then
    source "$PLUGIN.zsh";
  elif [ -r "$PLUGIN" ]; then
    source "$PLUGIN";
  else
    echo "Plugin not found: $PLUGIN"
  fi
}

function __loadZshPlugins() {
  local -r DIR="$1"
  local -r NAMES=$2
  [ ! -d "$DIR" ] && return;

  if [ -z $NAMES ]; then
    for plugin in $DIR/*; do
      __loadZshPlugin "$plugin"
    done
  else
    for plugin in ${NAMES[@]}; do
      if [ "${plugin:0:1}" != "!" ]; then
        __loadZshPlugin "$DIR/$plugin"
      fi
    done
  fi
}

function __loadLocalZshFiles() {
  for file in $HOME/.zsh_{exports,aliases,functions,prompt}; do
    [ -r "$file" ] && source "$file"
  done
  if [ -d "$HOME/.zsh_plugins" ]; then
    for file in $HOME/.zsh_plugins/*.zsh; do
      [ -r "$file" ] && source "$file"
    done
  fi
  unset file
}

function __loadZsh() {
  source "$HOME/.bash/index.sh"
  source "$HOME/.zsh/exports.zsh"
  source "$HOME/.zsh/aliases.zsh"
  __loadLocalZshFiles
  __loadZshPlugins "$HOME/.zsh/plugins" $zsh_plugins
  __loadZshPlugins "$HOME/.zsh/lib"
}

__loadZsh
