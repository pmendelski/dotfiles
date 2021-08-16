#!/bin/zsh

# Defaults
: ${TMUX_FORCE:="$([ -x "$(command -v tmux)" ] && echo '1' || echo '0')"}
: ${ZSH_PROMPT:=flexi}

# Force tmux
if [ "$USER" != "root" ] && [ "$TMUX_FORCE" = 1 ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ]; then
  exec tmux && exit;
fi

# zsh_plugins=(jvm) # By default all plugins are loaded
# zsh_plugins=(!someplugin)   # Skip some plugins with '!'
source ~/.zsh/index.zsh

# Local variables
for file in $HOME/.{bash,zsh}_exports; do
  [ -r "$file" ] && source "$file"
done

# Load prompt
autoload -U promptinit && promptinit
prompt -l | tail -1 | tr ' ' '\n' | grep -q $ZSH_PROMPT \
  && prompt $ZSH_PROMPT \
  || echo "Could not load zsh prompt: \"$ZSH_PROMPT\""

if [ -e "$HOME/.sdkvm/init.sh" ]; then
  source "$HOME/.sdkvm/init.sh";
fi
