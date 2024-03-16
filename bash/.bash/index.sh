#!/usr/bin/env bash

function __loadBashPlugins() {
  local -r DIR="$1"
  [ ! -d "$DIR" ] && return
  # shellcheck disable=SC2044
  for file in $(find "$DIR" -mindepth 1 -type f -name "*.sh"); do
    source "$file"
  done
}

function __loadLocalBashFiles() {
  for file in $HOME/.bash_{exports,aliases,functions,prompt}; do
    if [ -r "$file" ]; then
      source "$file"
    fi
  done
}

# shellcheck disable=SC2120
function bashChangePrompt() {
  local -r defaultPrompt="${BASH_PROMPT:-flexi}"
  local -r promptName="${1:-$defaultPrompt}"
  local promptFile="$promptName"
  [ ! -f "$promptFile" ] && promptFile="$BASH_DIR/prompts/$promptName.sh"
  [ ! -f "$promptFile" ] && promptFile="$BASH_DIR/prompts/$promptName/index.sh"
  if [ -f "$promptFile" ]; then
    source "$promptFile"
    if [ -z "${__LOAD_BASH_PROMPT_NEXT_CHANGE-}" ]; then
      __LOAD_BASH_PROMPT_NEXT_CHANGE="1"
    else
      echo "Switched to prompt: $promptFile"
      echo "To save prompt set: \$BASH_PROMPT=\"$promptName\""
    fi
  else
    echo "Could not locate prompt: \"$promptName\""
    echo "Checked locations:"
    echo "  $promptName"
    echo "  $BASH_DIR/prompts/$promptName.sh"
    echo "  $BASH_DIR/prompts/$promptName/prompts.sh"
  fi
}

function __loadPath() {
  if [ -f "$HOME/.path" ]; then
    local -r paths="$(grep '^[^#]' "$HOME/.path" | sort -u | tr '\n' ':')"
    export PATH="$paths:$PATH"
  fi
}

function sourceOptional() {
  local -r file="${1?Expected file}"
  if [ -f "$file" ]; then
    source "$file"
  fi
}

function __loadBash() {
  source "$HOME/.bash/exports.sh"
  sourceOptional "$HOME/.dotfiles-ext/bash/exports.sh"
  source "$HOME/.bash/aliases.sh"
  sourceOptional "$HOME/.dotfiles-ext/bash/aliases.sh"
  __loadPath
  __loadLocalBashFiles
  if [[ $- == *i* ]]; then
    # Interactive mode
    __loadBashPlugins "$HOME/.bash/lib"
  fi
  __loadBashPlugins "$HOME/.dotfiles-ext/bash/lib"
  __loadBashPlugins "$HOME/.bash/plugins"
  __loadBashPlugins "$HOME/.dotfiles-ext/bash/plugins"
  if [[ $- == *i* ]]; then
    # Interactive mode
    bashChangePrompt
  fi
}

if [ -n "$BASH_VERSION" ]; then
  __loadBash
fi
