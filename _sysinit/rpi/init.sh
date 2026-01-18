#!/usr/bin/env bash
set -euf -o pipefail

mkdir -p ~/.local/bin
mkdir -p ~/.local/app

echo -e "\n>>> Terminal"
sudo apt install -y \
  tmux \
  zsh \
  tree \
  ripgrep \
  htop \
  zoxide \
  fzf \
  dtrx

# better find
sudo apt install -y fd-find
if [ ! -f ~/.local/bin/fd ]; then
  ln -s "$(which fdfind)" ~/.local/bin/fd
fi

# cat with highlighting
sudo apt install -y bat
if [ ! -f ~/.local/bin/bat ]; then
  ln -s "$(which batcat)" ~/.local/bin/bat
fi

echo -e "\n>>> Vim"
sudo apt install -y vim

echo -e "\n>>> GIT"
sudo apt install -y git lazygit

echo -e "\n>>> Network tools"
sudo apt install -y \
  curl \
  wget \
  dnsutils \
  apache2-utils

echo -e "\n>>> Eza"
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt update
sudo apt install -y eza

echo -e "\n>>> Nvim"
sudo apt install cmake gettext ninja-build unzip curl git build-essential -y
(
  NVIM_BUILD_DIR="$(mktemp -d -t nvim-XXX)"
  cd "$NVIM_BUILD_DIR"
  git clone https://github.com/neovim/neovim
  cd neovim
  git checkout stable
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  sudo make install
  rm -rf "$NVIM_BUILD_DIR"
)
