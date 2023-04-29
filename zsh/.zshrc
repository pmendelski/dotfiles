#!/bin/zsh

# Local variables
[ -r "$HOME/.bash_exports" ] && source "$HOME/.bash_exports"
[ -r "$HOME/.zsh_exports" ] && source "$HOME/.zsh_exports"

# Defaults
: ${TERM:="xterm-256color"}
: ${TMUX_FORCE:="$([ -x "$(command -v tmux)" ] && echo '1' || echo '0')"}
: ${ZSH_PROMPT:="flexi"}

# Detect ide mode
if [ -n "$INTELLIJ_ENVIRONMENT_READER" ] ||
  [ -n "$NVIM_TERM" ] ||
  [ -n "$VSCODE_PID" ] ||
  [ -n "$VSCODE_INJECTION" ]; then
  export IDE_MODE=1
  export __FLEXI_PROMPT_SHLVL_MODIF="1$__FLEXI_PROMPT_SHLVL_MODIF"
fi

# Force tmux
if [ "$USER" != "root" ] &&
  [ "$TMUX_FORCE" = 1 ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ] &&
  [ -z "$IDE_MODE" ]; then
  exec tmux new-session -A -s main
  # tmux new-session -A -s main
  # echo "Exited TMUX"
fi

source ~/.zsh/index.zsh

# Load prompt
autoload -U promptinit && promptinit
prompt -l | tail -1 | tr ' ' '\n' | grep -q $ZSH_PROMPT &&
  prompt $ZSH_PROMPT ||
  echo "Could not load zsh prompt: \"$ZSH_PROMPT\""

# Init scripts
if [ -f "$HOME/.zshrc_local" ]; then source "$HOME/.zshrc_local"; fi
if [ -f "$HOME/.initrc" ]; then source "$HOME/.initrc"; fi
if [ -f "$HOME/.initrc_ext" ]; then source "$HOME/.initrc_ext"; fi
if [ -f "$HOME/.initrc_local" ]; then source "$HOME/.initrc_local"; fi
