#!/bin/zsh

# Directories
BASH_DIR="$HOME/.bash"
ZSH_DIR="$HOME/.zsh"
ZSH_TMP_DIR="$ZSH_DIR/tmp"

# ZSH functions
fpath=($ZSH_DIR/functions $ZSH_DIR/completions $fpath)

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
