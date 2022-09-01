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
    eslint &&
    echo "Installed Node.js based language servers" ||
    echo "Could not installed Node.js based language servers"

  cargo install stylua &&
    echo "Installed stylua" ||
    echo "Could not install stylua"

  go install golang.org/x/tools/gopls@latest &&
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
  local -r luaDir="$dataDir/lang-servers/sumneko_lua"
  local -r zshrc="$(cat "$HOME/.zshrc")"
  if [ -d "$luaDir" ]; then
    cd "$luaDir"
    git fetch
    if [ "$(git rev-parse HEAD)" == "$(git rev-parse "@{u}")" ]; then
      # up to date
      return
    fi
    git pull
  else
    git clone --depth=1 https://github.com/sumneko/lua-language-server "$luaDir"
    cd "$luaDir"
  fi
  git submodule update --depth 1 --init --recursive
  cd 3rd/luamake
  ./compile/install.sh
  cd ../..
  ./3rd/luamake/luamake rebuild
  # don't you dare changing my zshrc
  echo "$zshrc" >"$HOME/.zshrc"
}

installJavaLangServer() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless -u NONE 2>&1)"
  local -r serverDir="$dataDir/lang-servers/jdtls"
  local -r version="$(
    curl -s "https://download.eclipse.org/jdtls/milestones/" |
      grep -oP "/jdtls/milestones/([0-9.]+)" | grep -oP "([0-9.]+)" |
      sort -V | tail -n 1
  )"
  local -r link="https://download.eclipse.org/$(
    curl -s "https://download.eclipse.org/jdtls/milestones/${version}/" | grep -oP "/jdtls/milestones/${version}/([^']+).tar.gz" |
      tail -n 1
  )"
  if [ ! -f "$serverDir/version" ] || [ "$(cat "$serverDir/version")" -lt "$version" ]; then
    echo "Installing Java language server: JDTLS $version"
    rm -rf "$serverDir"
    mkdir -p "$serverDir"
    local -r tmpdir="$(mktemp -d -t jdtls-XXXX)"
    (
      cd "$tmpdir" &&
        curl -sLo jdtls.tar.gz "$link" &&
        tar xf jdtls.tar.gz -C "$serverDir"
    )
    rm -rf "$tmpdir"
    echo "$version" >"$serverDir/version"
  else
    echo "Java language server (jdtls) - up to date"
  fi

}

installPlugins() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless -u NONE 2>&1)"
  local -r packerDir="$dataDir/site/pack/packer/start/packer.nvim"
  if [ ! -d "$packerDir" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packerDir"
    echo "Installed Packer - Nvim Package manager"
  fi
}

installJavaLangServer
