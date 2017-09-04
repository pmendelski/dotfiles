node-update() {
    nvm install stable
    nvm reinstall-packages node
    npm install npm@latest -g
    npm install yarn -g
    npm install -g npm-check-updates
}
alias node-update="node-update"
