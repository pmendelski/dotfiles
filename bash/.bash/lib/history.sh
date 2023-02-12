#!/usr/bin/env bash

# Bash History
# https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html
export HISTTIMEFORMAT="%F %T  " # Add timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
export HISTCONTROL="ignoreboth" # Omit duplicates and commands that begin with a space from history.
export HISTSIZE=32768           # Increase Bash history size. Allow 32^3 entries; the default is 500.
export HISTFILESIZE="${HISTSIZE}"
export HISTFILE="$BASH_TMP_DIR/.history"

# History options
shopt -s histappend # Append to the history file, don't overwrite it

# Wrapper function for history command.
historyc() {
  local -r ESC="$(printf '\033')"
  local -r HIST_COLOR_GREEN="${ESC}[0;32m"
  local -r HIST_COLOR_BLUE="${ESC}[0;34m"
  local -r HIST_COLOR_RESET="${ESC}[0m"
  local -r NUMBER_STYLE="${HIST_COLOR_GREEN}"
  local -r TIME_STYLE="${HIST_COLOR_BLUE}"
  \history "$@" | sed \
    -e "s/\(^ *[^ ]\+\)  \([^ ]\+ [^ ]\+\)  \([^ ]\+\)/${NUMBER_STYLE}\1  ${TIME_STYLE}\2  ${HIST_COLOR_RESET}\3/g"
  return "${PIPESTATUS[0]}"
}

alias h='historyc'
alias hs='historyc | grep -i --color'
