#!/bin/bash

# To change default shell use:
#    chsh -s $(which zsh)
# ... and relogin


# Load local zsh dotfiles
for file in $HOME/.bash_{exports,aliases,functions}; do
    [ -r "$file" ] && source "$file"
done
for file in $HOME/.zsh_{exports,aliases,functions,prompt}; do
    [ -r "$file" ] && source "$file"
done
unset file

# zsh_plugins=(jvm mvn-color) # ...load them all
source ~/.zsh/index.zsh

# Scripts folder is for user custom scipts
export PATH="$PATH:$HOME/Scripts"

# Say hello
sayhello
