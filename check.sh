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
    -not -path "*/deps/*" \
    -not -path "*/plugins/*" \
    -not -path "*/tmp/*" \
    -not -path "./_init/*/templates/*")"
  echo -e "\n>>> Running ShellCheck"
  shellcheck $files
}

checkLuaScripts() {
  expectCommand luacheck
  local -r files="$(find . -type f -name "*.lua" -not -path "*/deps/*" -not -path "*/tmp/*")"
  echo -e "\n>>> Running Luacheck"
  luacheck $files --globals vim TreeExplorer --exclude-files "**/packer_compiled.lua"
}

checkLuaScripts
checkBashScripts
