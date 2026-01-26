#!/usr/bin/env bash

# Bash History
# https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html
export HISTTIMEFORMAT="%F %T  " # Add timestamps for later analysis. www.debian-administration.org/users/rossen/weblog/1
export HISTCONTROL="ignoreboth" # Omit duplicates and commands that begin with a space from history.
export HISTSIZE=50000           # Entries kept in-memory (available for arrow-up)
export HISTFILESIZE=100000      # Hisotry file size
export HISTFILE="$BASH_TMP_DIR/.history"

# History options
shopt -s histappend # Append to the history file, don't overwrite it
