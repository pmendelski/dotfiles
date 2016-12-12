#!/bin/bash

# To change default shell use:
#    chsh -s $(which zsh)
# ... and relogin

# zsh_plugins=(jvm mvn-color)
# ...or load them all
zsh_plugins=(!nvmrc) # Skip nvmrc. It's too slow
source ~/.zsh/index.zsh

# Force tmux
[ -z "$TMUX" ] && export TERM=xterm-256color && exec tmux;

# Load prompt
: ${ZSH_PROMPT:=flexi}
autoload -U promptinit && promptinit
prompt -l | tail -1 | tr ' ' '\n' | grep -q $ZSH_PROMPT \
    && prompt $ZSH_PROMPT

dailyhello
