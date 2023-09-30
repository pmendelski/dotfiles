#!/usr/bin/env bash
# shellcheck disable=SC2086
set -euf -o pipefail

expectCommand() {
  local -r name="${1:?Expected command name}"
  if ! command -v "${name}" &>/dev/null; then
    echo "Missing command: ${name}"
    exit
  fi
}

checkBashScripts() {
  expectCommand shellcheck
  local -r files="$(find . -type f -name "*.sh" \
    -not -path "./.install/*" \
    -not -path "*/deps/*" \
    -not -path "*/plugins/*" \
    -not -path "*/tmp/*" \
    -not -path "*/.luarocks/*" \
    -not -path "./_sysinit/*/templates/*")"
  echo -e "\n>>> Running ShellCheck for bash"
  shellcheck $files
  echo -e "<<< ShellCheck passed\n"
}

checkLuaScripts() {
  expectCommand luacheck
  echo -e "\n>>> Running Luacheck"
  local -r files="$(find . -type f -name "*.lua" \
    -not -path "./.install/*" \
    -not -path "*/deps/*" \
    -not -path "*/.luarocks/*" \
    -not -path "*/tmp/*")"
  luacheck $files --globals vim TreeExplorer --exclude-files "**/packer_compiled.lua"
  echo -e "<<< Luacheck passed\n"
}

checkLuaScripts
checkBashScripts
