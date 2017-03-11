#!/bin/zsh

# Must be loaded after syntax-highlighting
source $ZSH_DIR/plugins/syntax-highlighting.zsh

# https://github.com/zsh-users/zsh-history-substring-search
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
source $ZSH_DIR/bundles/history-substring-search/zsh-history-substring-search.zsh
