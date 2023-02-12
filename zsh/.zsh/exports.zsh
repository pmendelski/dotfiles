#!/bin/zsh

# Directories
export ZSH_DIR="$HOME/.zsh"
export ZSH_TMP_DIR="$ZSH_DIR/tmp"

# ZSH functions
export fpath=($ZSH_DIR/prompts/setup $fpath)

# Characters considered as part of a word.
# Default: WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
# http://zsh.sourceforge.net/Guide/zshguide04.html
export WORDCHARS=''

# prevent percentage showing up
# if output doesn't end with a newline
export PROMPT_EOL_MARK=''

# Default PS1
PS1="%n@%m:%~%# "

# Required by Gogh
# https://github.com/Mayccoll/Gogh#install-non-interactive-mode
if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
  export TERMINAL="gnome-terminal"
fi
