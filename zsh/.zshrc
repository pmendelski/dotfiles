#!/bin/bash

# zsh_plugins=(jvm mvn-color) # By default all plugins are loaded
# zsh_plugins=(!someplugin)   # Skip some plugins with '!'
source ~/.zsh/index.zsh

# Local variables
for file in $HOME/.{bash,zsh}_exports; do
  [ -r "$file" ] && source "$file"
done

# Defaults
: ${TMUX_FORCE:="$([ -x "$(command -v tmux)" ] && echo '1' || echo '0')"}
: ${ZSH_PROMPT:=flexi}

# Force tmux
[ $TMUX_FORCE = 1 ] && [ -z "$TMUX" ] && export TERM=xterm-256color && exec tmux;

# Load prompt
autoload -U promptinit && promptinit
prompt -l | tail -1 | tr ' ' '\n' | grep -q $ZSH_PROMPT \
  && prompt $ZSH_PROMPT \
  || echo "Could not load zsh prompt: \"$ZSH_PROMPT\""
