#!/bin/zsh

# https://github.com/zsh-users/zsh-autosuggestions
source $ZSH_DIR/deps/zsh-autosuggestions/zsh-autosuggestions.zsh

# Menu + autosuggestion issue
# https://github.com/zsh-users/zsh-autosuggestions/issues/118
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=("expand-or-complete")
# Enable better colors
if [[ $(echotc Co) -gt 8 ]];then
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"
else
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
fi
