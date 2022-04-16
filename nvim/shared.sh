#!/usr/bin/env bash
set -euf -o pipefail

installDependencies() {
  rustup component add rls rust-analysis rust-src rustfmt clippy \
    && echo "Installed rust nvim dependencies" \
    || echo "Could not install rust nvim dependencies"

  rustup +nightly component add rust-analyzer-preview \
    && echo "Installed rust nightly nvim dependencies" \
    || echo "Could not install rust nightly nvim dependencies"

  npm i -g \
    bash-language-server \
    vscode-langservers-extracted \
    pyright \
    sql-language-server \
    svelte-language-server \
    typescript typescript-language-server \
    yaml-language-server \
    vls \
    graphql-language-service-cli \
    dockerfile-language-server-nodejs \
    diagnostic-languageserver \
    eslint \
    && echo "Installed Node.js based language servers" \
    || echo "Could not installed Node.js based language servers"

  go install golang.org/x/tools/gopls@latest \
    && echo "Installed GO based language servers" \
    || echo "Could not install GO based language servers"
}

installPlugins() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless 2>&1)"
  local -r configDir="$(nvim --cmd ":echo stdpath('config')" --cmd "qall" --headless 2>&1)"
  local -r packerDir="$dataDir/site/pack/packer/start/packer.nvim"
  if [ ! -d "$packerDir" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packerDir"
    echo "Installed Packer - Nvim Package manager"
    nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync' -u "$configDir/lua/plugins.lua" \
      && echo "Installed Plugins" || echo "Could not install plugins"
  fi
}
