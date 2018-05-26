#!/bin/bash

function __loadBashFiles() {
  local -r DIR="$1"
  local -r NAMES=$2
  [ ! -d "$DIR" ] && return;

  if [ -z $NAMES ]; then
    for file in $DIR/*.sh; do
      source $file
    done
  else
    for plugin in ${NAMES[@]}; do
      [ ${plugin:0:1} -ne "!" ] \
        && [ -r "$DIR/$plugin.sh" ] \
        && source $DIR/$plugin.sh
    done
    unset plugin
  fi
  unset file
}

function __loadLocalBashFiles() {
  for file in $HOME/.bash_{exports,aliases,functions,prompt}; do
    [ -r "$file" ] && source "$file"
  done
  if [ -d "$HOME/.bash_plugins" ]; then
    for file in $HOME/.bash_plugins/*.sh; do
      [ -r "$file" ] && source "$file"
    done
  fi
  unset file
}

function bashChangePrompt() {
  local -r defaultPrompt="${BASH_PROMPT:-flexi}"
  local -r promptName="${1:-$defaultPrompt}"
  local promptFile="$theme"
  [ ! -f "$promptFile" ] && promptFile="$BASH_DIR/prompts/$promptName.sh"
  [ ! -f "$promptFile" ] && promptFile="$BASH_DIR/prompts/$promptName/index.sh"
  if [ -f "$promptFile" ]; then
    source "$promptFile"
    if [ -z "$__LOAD_BASH_PROMPT_NEXT_CHANGE" ]; then
      __LOAD_BASH_PROMPT_NEXT_CHANGE="1"
    else
      echo "Switched to prompt: $promptFile"
      echo "To save prompt set: \$BASH_PROMPT=\"$promptName\""
    fi
  else
    echo "Could not locate prompt: $promptName"
    echo "Checked locations:"
    echo "  $promptName"
    echo "  $BASH_DIR/prompts/$promptName.sh"
    echo "  $BASH_DIR/prompts/$promptName/prompts.sh"
  fi
}

function __loadBash() {
  source "$HOME/.bash/exports.sh"
  source "$HOME/.bash/aliases.sh"
  __loadLocalBashFiles
  __loadBashFiles "$HOME/.bash/plugins" $bash_plugins
  # Lib should be loaded by bash only
  [ -n "$BASH_VERSION" ] && __loadBashFiles "$HOME/.bash/lib"
  # Bash propmpt should be loaded by bash only
  [ -n "$BASH_VERSION" ] && bashChangePrompt
}

__loadBash
