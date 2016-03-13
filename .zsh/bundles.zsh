#!/bin/zsh

# Load zsh-syntax-highlighting.
source $DIR/bundle/syntax-highlighting/zsh-syntax-highlighting.zsh

# Load zsh-autosuggestions.
source $DIR/bundle/autosuggestions/zsh-autosuggestions.zsh
if [[ $(echotc Co) -gt 8 ]];then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=238"
else
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
fi
