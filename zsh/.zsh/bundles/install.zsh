#!/bin/zsh

# https://github.com/zsh-users/zsh-syntax-highlighting
source $DIR/bundles/syntax-highlighting/zsh-syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-history-substring-search
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
source $DIR/bundles/history-substring-search/zsh-history-substring-search.zsh

# https://github.com/zsh-users/zsh-autosuggestions
source $DIR/bundles/autosuggestions/zsh-autosuggestions.zsh
# Menu + autosuggestion issue
# https://github.com/zsh-users/zsh-autosuggestions/issues/118
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=("expand-or-complete")
# Enable better colors
if [[ $(echotc Co) -gt 8 ]];then
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"
else
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5"
fi

# Load z
source $DIR/bundles/z/z.sh
