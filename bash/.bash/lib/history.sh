#!/usr/bin/env bash

# Bash History
# https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html
export HISTTIMEFORMAT='%F %T  ' # Add timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
export HISTCONTROL="ignoreboth" # Omit duplicates and commands that begin with a space from history.
export HISTSIZE=32768           # Increase Bash history size. Allow 32^3 entries; the default is 500.
export HISTFILESIZE="${HISTSIZE}"
export HISTFILE="$BASH_TMP_DIR/.history"

# History options
shopt -s histappend # Append to the history file, don't overwrite it
