#!/bin/zsh

# Load zsh-syntax-highlighting.
source $DIR/bundle/syntax-highlighting/zsh-syntax-highlighting.zsh

# Load zsh-autosuggestions.
source $DIR/bundle/autosuggestions/autosuggestions.zsh

# Enable autosuggestions automatically.
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init

AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1
AUTOSUGGESTION_HIGHLIGHT_CURSOR=1
if [[ $(echotc Co) -gt 8 ]];then
    AUTOSUGGESTION_HIGHLIGHT_COLOR="fg=238"
else
    AUTOSUGGESTION_HIGHLIGHT_COLOR="fg=5"
fi
