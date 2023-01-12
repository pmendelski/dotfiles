#!/bin/zsh

# Defaults
: ${TERM:="xterm-256color"}
: ${TMUX_FORCE:="$([ -x "$(command -v tmux)" ] && echo '1' || echo '0')"}
: ${ZSH_PROMPT:="flexi"}

# Force tmux
if [ "$USER" != "root" ] && [ "$TMUX_FORCE" = 1 ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ] && [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
  exec tmux && exit;
fi

# Local variables
[ -r "$HOME/.bash_exports" ] && source "$HOME/.bash_exports"
[ -r "$HOME/.zsh_exports" ] && source "$HOME/.zsh_exports"

# zsh_plugins=(jvm) # By default all plugins are loaded
# zsh_plugins=(!someplugin)   # Skip some plugins with '!'
source ~/.zsh/index.zsh

# Load prompt
autoload -U promptinit && promptinit
prompt -l | tail -1 | tr ' ' '\n' | grep -q $ZSH_PROMPT \
  && prompt $ZSH_PROMPT \
  || echo "Could not load zsh prompt: \"$ZSH_PROMPT\""

# Init scripts
[ -f "$HOME/.bashrc_local" ] && source "$HOME/.bashrc_local"
[ -f "$HOME/.zshrc_local" ] && source "$HOME/.zshrc_local"
[ -f "$HOME/.sdkvm/init.sh" ] && source "$HOME/.sdkvm/init.sh"
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
