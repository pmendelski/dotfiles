#!/bin/bash

# To change default shell use:
#    chsh -s $(which zsh)
# ... and relogin

# zsh_plugins=(jvm mvn-color)
# ...or load them all
zsh_plugins=(!nvmrc) # Skip nvmrc. It's too slow
source ~/.zsh/index.zsh

# Load prompt
autoload -U promptinit && promptinit
[ -x "$(prompt -l | tail -1 | tr ' ' '\n' | grep -q myprompt)" ] \
    && prompt custom

sayhello
