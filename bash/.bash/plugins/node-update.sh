export NODE_BASE_MODULES="tldr webpack eslint http-server livereload yarn npm-check-updates";

node-update() {
    local version="${1:-stable}"
    nvm install $version
    nvm reinstall-packages node
    nvm alias default $(node -v)
    npm install npm@latest -g
    npm install -g $NODE_BASE_MODULES
}


nvmrc-create() {
    echo "${1:-$(node -v)}" > .nvmrc
}

nvmrc-create-lts() {
    echo "lts/*" > .nvmrc
}
