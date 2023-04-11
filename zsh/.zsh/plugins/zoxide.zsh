#!/bin/zsh

if [ -n "$ZSH_VERSION" ] && command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi
