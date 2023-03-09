#!/bin/zsh

# Defaults
: ${TERM:="xterm-256color"}
: ${TMUX_FORCE:="$([ -x "$(command -v tmux)" ] && echo '1' || echo '0')"}
: ${ZSH_PROMPT:="flexi"}

# Force tmux
if [ "$USER" != "root" ] \
  && [ "$TMUX_FORCE" = 1 ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ] \
  && [ -z "$INTELLIJ_ENVIRONMENT_READER" ] \
  && [ -z "$VSCODE_PID" ] \
  && [ -z "$VSCODE_INJECTION" ]; then
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
if [ -f "$HOME/.bashrc_local" ]; then source "$HOME/.bashrc_local"; fi
if [ -f "$HOME/.zshrc_local" ]; then source "$HOME/.zshrc_local"; fi
if [ -f "$HOME/.sdkvm/init.sh" ]; then source "$HOME/.sdkvm/init.sh"; fi
if [ -f "$HOME/.ghcup/env" ]; then source "$HOME/.ghcup/env"; fi
if [ -f "$HOME/.gcloud/path.zsh.inc" ]; then source "$HOME/.gcloud/path.zsh.inc"; fi
if [ -f "$HOME/.gcloud/completion.zsh.inc" ];then source "$HOME/.gcloud/completion.zsh.inc"; fi
