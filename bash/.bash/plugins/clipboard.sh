#!/usr/bin/env bash

# clipcopy - Copy data to clipboard
# Usage:
#  <command> | clipcopy  - copies stdin to clipboard
#  clipcopy <file>     - copies a file's contents to clipboard
function clipcopy() {
  local file=$1
  if [[ $OSTYPE == darwin* ]]; then
    if [[ -z $file ]]; then
      pbcopy
    else
      pbcopy <"$file"
    fi
  elif [[ $OSTYPE == cygwin* ]]; then
    if [[ -z $file ]]; then
      cat >/dev/clipboard
    else
      cat "$file" >/dev/clipboard
    fi
  else
    if which xclip &>/dev/null; then
      if [[ -z $file ]]; then
        xclip -in -selection clipboard
      else
        xclip -in -selection clipboard "$file"
      fi
    elif which xsel &>/dev/null; then
      if [[ -z $file ]]; then
        xsel --clipboard --input
      else
        xsel --clipboard <"$file"
      fi
    else
      print "clipcopy: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
      return 1
    fi
  fi
}

# clippaste - "Paste" data from clipboard to stdout
# Usage:
#   clippaste   - writes clipboard's contents to stdout
#   clippaste | <command>  - pastes contents and pipes it to another process
#   clippaste > <file>    - paste contents to a file
function clippaste() {
  if [[ $OSTYPE == darwin* ]]; then
    pbpaste
  elif [[ $OSTYPE == cygwin* ]]; then
    cat /dev/clipboard
  else
    if which xclip &>/dev/null; then
      xclip -out -selection clipboard
    elif which xsel &>/dev/null; then
      xsel --clipboard --output
    else
      print "clipcopy: Platform $OSTYPE not supported or xclip/xsel not installed" >&2
      return 1
    fi
  fi
}
