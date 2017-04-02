# Syntax highligting is loaded by other plugins
: ${ZSH_SYNTAX_HIGHLIGHTING_LOADED:=0}

if [ -z $zsh_plugins ] || [[ " ${zsh_plugins[@]} " =~ " syntax-highlighting " ]] \
    && [ $ZSH_SYNTAX_HIGHLIGHTING_LOADED = 0 ]; then
    # https://github.com/zsh-users/zsh-syntax-highlighting
    source $ZSH_DIR/bundles/syntax-highlighting/zsh-syntax-highlighting.zsh
    ZSH_SYNTAX_HIGHLIGHTING_LOADED=1
fi
