#!/usr/bin/env bash
set -euf -o pipefail

installDependencies() {
  rustup component add rls rust-analysis rust-src rustfmt clippy &&
    echo "Installed rust nvim dependencies" ||
    echo "Could not install rust nvim dependencies"

  rustup +nightly component add rust-analyzer-preview &&
    echo "Installed rust nightly nvim dependencies" ||
    echo "Could not install rust nightly nvim dependencies"

  npm i -g \
    bash-language-server \
    vscode-langservers-extracted \
    vscode-langservers-extracted \
    prettier \
    pyright \
    sql-language-server \
    svelte-language-server \
    typescript \
    typescript-language-server \
    yaml-language-server \
    vls \
    graphql-language-service-cli \
    dockerfile-language-server-nodejs \
    diagnostic-languageserver \
    stylelint-lsp \
    eslint &&
    echo "Installed Node.js based language servers" ||
    echo "Could not installed Node.js based language servers"

  cargo install stylua &&
    echo "Installed stylua" ||
    echo "Could not install stylua"

  go install golang.org/x/tools/gopls@latest &&
    go install mvdan.cc/sh/v3/cmd/shfmt@latest &&
    echo "Installed GO based language servers" ||
    echo "Could not install GO based language servers"

  code --install-extension vadimcn.vscode-lldb &&
    echo "Installed VS Code based debug extension for rust debugging" ||
    echo "Could not install VS Code based debug extension for rust debugging"

  installLuaLangServer &&
    echo "Installed LUA language server" ||
    echo "Could not install Lua language server"
}

installLuaLangServer() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless -u NONE 2>&1)"
  local -r luaDir="$dataDir/lang-servers/lua_ls"
  if [ -d "$luaDir" ]; then
    cd "$luaDir"
    git fetch
    if [ "$(git rev-parse HEAD)" == "$(git rev-parse "@{u}")" ]; then
      # up to date
      return
    fi
    git pull
  else
    git clone --depth=1 https://github.com/luals/lua-language-server "$luaDir"
    cd "$luaDir"
  fi
  ./make.sh
}

installPlugins() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless -u NONE 2>&1)"
  local -r packerDir="$dataDir/site/pack/packer/start/packer.nvim"
  if [ ! -d "$packerDir" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packerDir"
    echo "Installed Packer - Nvim Package manager"
  fi
}
