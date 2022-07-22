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

  go install github.com/mattn/efm-langserver@latest \
    && echo "Installed EFM language server" \
    || echo "Could not install EFM language server"

  code --install-extension vadimcn.vscode-lldb \
    && echo "Installed VS Code based debug extension for rust debugging" \
    || echo "Could not install VS Code based debug extension for rust debugging"

  installLuaLangServer \
    && echo "Installed LUA language server" \
    || echo "Could not install Lua language server"
}

installLuaLangServer() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless 2>&1 -u NONE)"
  local -r luaDir="$dataDir/lang-servers/lua-language-server"
  if [ -d "$luaDir" ]; then
    cd "$luaDir"
    git fetch
    if [ $(git rev-parse HEAD) == $(git rev-parse @{u}) ]; then
      # up to date
      return
    fi
    git pull
  else
    git clone  --depth=1 https://github.com/sumneko/lua-language-server "$luaDir"
    cd "$luaDir"
  fi
  git submodule update --depth 1 --init --recursive
  cd 3rd/luamake
  ./compile/install.sh
  cd ../..
  ./3rd/luamake/luamake rebuild
}

installPlugins() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless 2>&1 -u NONE)"
  local -r configDir="$(nvim --cmd ":echo stdpath('config')" --cmd "qall" --headless 2>&1 -u NONE)"
  local -r packerDir="$dataDir/site/pack/packer/start/packer.nvim"
  if [ ! -d "$packerDir" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packerDir"
    echo "Installed Packer - Nvim Package manager"
    nvim --headless --cmd 'autocmd User PackerComplete quitall' -cmd 'PackerSync' -u "$configDir/lua/plugins.lua" \
      && echo "Installed Plugins" \
      || echo "Could not install plugins"
  fi
}
