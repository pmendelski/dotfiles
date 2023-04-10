#!/usr/bin/env bash
set -euf -o pipefail

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

cargo install stylua
installLuaLangServer
