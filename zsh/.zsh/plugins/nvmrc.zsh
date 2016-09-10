# See: https://github.com/creationix/nvm
load-nvmrc() {
    if [[ -f .nvmrc && -r .nvmrc ]]; then
        nvm use
    elif [[ $(nvm version) != $(nvm version default)  ]]; then
        echo "Reverting to nvm default version"
        nvm use default
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd load-nvmrc
# load-nvmrc
