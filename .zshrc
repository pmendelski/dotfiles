#!/bin/bash

# Load local zsh dotfiles
for file in ~/.bash_{exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
for file in ~/.zsh_{exports,prompt,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
unset file

# zsh_plugins=(jvm mvn-color) # ...load them all
source ~/.zsh/index.zsh

# Scripts folder is for user custom scipts
export PATH="$PATH:$HOME/Scripts"
