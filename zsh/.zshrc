#!/bin/zsh

# Local variables
[ -r "$HOME/.bash/exports.sh" ] && source "$HOME/.bash/exports.sh"
[ -r "$HOME/.zsh/exports.zsh" ] && source "$HOME/.zsh/exports.zsh"
[ -r "$HOME/.bash_exports" ] && source "$HOME/.bash_exports"
[ -r "$HOME/.zsh_exports" ] && source "$HOME/.zsh_exports"
[ -r "$HOME/.dotfiles-ext/bash/exports.sh" ] && source "$HOME/.dotfiles-ext/bash/exports.sh"
[ -r "$HOME/.dotfiles-ext/zsh/exports.zsh" ] && source "$HOME/.dotfiles-ext/zsh/exports.zsh"

if [ -t 0 ]; then
  # Interactive mode

  # Defaults
  : ${TERM:="xterm-256color"}
  : ${TMUX_FORCE:="$([ -x "$(command -v tmux)" ] && echo '1' || echo '0')"}
  : ${ZSH_PROMPT:="flexi"}

  # Detect ide mode
  if [ -n "$IDE_MODE" ]; then
    export __FLEXI_PROMPT_SHLVL_MODIF=$((1 + __FLEXI_PROMPT_SHLVL_MODIF))
  fi

  # Force tmux
  if [ "$USER" != "root" ] &&
    [ "$TMUX_FORCE" = 1 ] && [ -z "$TMUX" ] && [ -z "$SSH_TTY" ] &&
    [ -z "$IDE_MODE" ]; then
    export __FLEXI_PROMPT_SHLVL_MODIF=$((1 + __FLEXI_PROMPT_SHLVL_MODIF))
    tmux new-session -A -s main
    # exec tmux new-session -A -s main
    echo "Exited TMUX. To reattach use: tmux new-session -A -s main"
  fi

  source ~/.zsh/index.zsh

  # Load prompt
  autoload -U promptinit && promptinit
  prompt -l | tail -1 | tr ' ' '\n' | grep -q $ZSH_PROMPT &&
    prompt $ZSH_PROMPT ||
    echo "Could not load zsh prompt: \"$ZSH_PROMPT\""
else
  # Non-interactive mode
  source ~/.zsh/index.zsh
fi

# Init scripts
if [ -f "$HOME/.dotfiles-ext/zsh/.zshrc" ]; then source "$HOME/.dotfiles-ext/zsh/.zshrc"; fi
if [ -f "$HOME/.zshrc_local" ]; then source "$HOME/.zshrc_local"; fi
if [ -f "$HOME/.initrc" ]; then source "$HOME/.initrc"; fi
if [ -f "$HOME/.initrc_local" ]; then source "$HOME/.initrc_local"; fi
if command -v mise &>/dev/null; then
  eval "$(mise activate --shims zsh)"

  mise-env() {
    eval "$(command mise env -s zsh "$@")"
  }
fi


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/mc mc
