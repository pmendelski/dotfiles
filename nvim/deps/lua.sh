#!/usr/bin/env bash
set -euf -o pipefail

installLuaLangServer() {
  local -r dataDir="$(nvim --cmd ":echo stdpath('data')" --cmd "qall" --headless -u NONE 2>&1)"
  local -r luaDir="$dataDir/lang-servers/lua_ls"
  local -r version="$(curl -s "https://api.github.com/repos/LuaLS/lua-language-server/releases/latest" | grep -Po '"tag_name": "\K[^"]*')"
  if [ -z "$version" ]; then
    echo "Could not locate newest lua version" >&2
    return 1
  fi
  local os="linux"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    os="darwin"
  fi
  local arch="x64"
  if [ "$(uname -m)" == "arm64" ]; then
    arch="arm64"
  fi
  tmpdir="$(mktemp -d -t lua-XXXX)"
  echo "$tmpdir"
  (
    cd "$tmpdir" &&
      curl -Lo lua.tar.gz "https://github.com/LuaLS/lua-language-server/releases/download/$version/lua-language-server-$version-$os-$arch.tar.gz" &&
      tar xf lua.tar.gz
  )
  if [ -d "$luaDir" ]; then
    rm -rf "${luaDir}_bak"
    mv "$luaDir" "${luaDir}_bak"
  fi
  mkdir -p "$dataDir/lang-servers"
  mv "$tmpdir" "$luaDir"
}

installLuaLangServer
echo "Installed lua language server"

if command -v cargo &>/dev/null; then
  cargo install stylua
else
  echo "Missing command: cargo"
  echo "Skipped: stylua"
  exit 1
fi
