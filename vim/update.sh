#!/usr/bin/env bash
set -euf -o pipefail

if command -v vim &>/dev/null; then
  vim -c ':PlugInstall' -c 'qa!'
  printSuccess "Updated: vim"
else
  printInfo "Skipped updating: vim. Command not found."
fi
