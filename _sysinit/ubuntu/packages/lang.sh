#!/usr/bin/env bash
set -e

echo ""
echo ">>>"
echo ">>> LANG"
echo ">>>"

echo -e "\n>>> Rust"
if ! command -v rustup &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  export PATH="$PATH:~/.cargo/bin"
fi

# echo -e "\n>>> Haskell"
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org |
#   BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh

echo -e "\n>>> Linters"
sudo apt install -y yamllint
