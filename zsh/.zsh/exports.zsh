#!/bin/zsh

# Directories
ZSH_DIR="$HOME/.zsh"
ZSH_TMP_DIR="$ZSH_DIR/tmp"

# ZSH functions
fpath=($ZSH_DIR/prompts/setup $fpath)

# LS colors
LSCOLORS="Gxfxcxdxbxegedabagacad"

# Characters considered as part of a word.
# Default: WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
# http://zsh.sourceforge.net/Guide/zshguide04.html
WORDCHARS=''

# prevent percentage showing up
# if output doesn't end with a newline
PROMPT_EOL_MARK=''

# Default PS1
PS1="%n@%m:%~%# "

# Required by Gogh
# https://github.com/Mayccoll/Gogh#install-non-interactive-mode
if [[ "$(uname -a)" == *"Ubuntu"* ]]; then
  export TERMINAL="gnome-terminal"
fi

if [ -z "${LS_COLORS-}" ] && type "dircolors" > /dev/null; then
  eval "$(dircolors)"
fi
