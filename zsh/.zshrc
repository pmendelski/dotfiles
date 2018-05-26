#!/bin/bash

# To change default shell use:
#    chsh -s $(which zsh)
# ... and relogin

# zsh_plugins=(jvm mvn-color)
# ...or load them all
# zsh_plugins=(!someplugin) # Skip someplugin
source ~/.zsh/index.zsh

# Force tmux
: ${TMUX_FORCE:="$([ -x "$(command -v tmux)" ] && echo '1' || echo '0')"}
[ $TMUX_FORCE = 1 ] && [ -z "$TMUX" ] && export TERM=xterm-256color && exec tmux;

# Load prompt
export PROMPT_DEFAULT_USERHOST="pablo@pablo-dell-7720"
: ${ZSH_PROMPT:=flexi}
autoload -U promptinit && promptinit
prompt -l | tail -1 | tr ' ' '\n' | grep -q $ZSH_PROMPT \
    && prompt $ZSH_PROMPT \
    || echo "Could not load zsh prompt"

# dailyhello || echo "No daily hello:("
