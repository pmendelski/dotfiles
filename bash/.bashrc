#!/usr/bin/env bash

# Default bashrc: /etc/skel/.bashrc
# ~/.bashrc: executed by bash for non-login shells.
# https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/
# http://serverfault.com/questions/261802/profile-vs-bash-profile-vs-bashrc

# Login Shell Startup Files:
# 1. /etc/profile
# 2. ~/.bash_profile OR ~/.bash_login OR ~/.profile (~/.bash_profile sources ~/.bashrc)
# 3. ~/.bash_logout

# Non-Login Shell Startup Files:
# 1. /etc/bash.bashrc
# 2. ~/.bashrc

# If not running interactively just exit
case $- in
*i*) ;;
*) return ;;
esac

# Local variables
[ -r "$HOME/.bash_exports" ] && source "$HOME/.bash_exports"

# Force zsh
if [ "$USER" != "root" ] && [ "$ZSH_FORCE" == "1" ] && [ -z "$ZSH_VERSION" ]; then
  exec zsh && exit
fi

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
  exec tmux && exit
fi

# Init scripts
source "$HOME/.bash/index.sh"
if [ -f "$HOME/.bashrc_local" ]; then source "$HOME/.bashrc_local"; fi
if [ -f "$HOME/.initrc" ]; then source "$HOME/.initrc"; fi
if [ -f "$HOME/.initrc_local" ]; then source "$HOME/.initrc_local"; fi
