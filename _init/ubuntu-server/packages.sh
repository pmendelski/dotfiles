#!/usr/bin/env bash
set -euf -o pipefail

# Build tools
sudo apt install -y build-essential
sudo apt install -y automake
sudo apt install -y make
sudo apt install -y checkinstall
sudo apt install -y dpatch
sudo apt install -y patchutils
sudo apt install -y autotools-dev
sudo apt install -y debhelper
sudo apt install -y quilt
sudo apt install -y fakeroot
sudo apt install -y xutils
sudo apt install -y lintian
sudo apt install -y cmake
sudo apt install -y dh-make
sudo apt install -y libtool
sudo apt install -y autoconf
sudo apt install -y gcc
sudo apt install -y ninja-build
sudo apt install -y shellcheck

# GIT
sudo add-apt-repository -y "ppa:git-core/ppa"
sudo apt-get update
sudo apt install -y git

# HTTP clients
sudo apt install -y curl
sudo apt install -y httpie

# HTTP utils like dig
sudo apt install -y dnsutils

# JSON parser
sudo apt install -y jq

# Network
sudo apt install -y apt-transport-https
sudo apt install -y ca-certificates
sudo apt install -y gnupg-agent
sudo apt install -y software-properties-common
sudo apt install -y iptables-persistent

# Docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt -y update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker "${USER}"
# Docker compose https://docs.docker.com/compose
docker_compose_version="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)"
sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L "https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose
curl -L "https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/zsh/_docker-compose" -o ~/.zsh/completion/_docker-compose

# Better terminal
mkdir -p ~/.local/bin
sudo apt install -y zsh
sudo apt install -y tmux
sudo apt install -y tree
sudo apt install -y fzf
sudo apt install -y ripgrep
sudo apt install -y fd-find
ln -s "$(which fdfind)" ~/.local/bin/fd
sudo snap install fasd --beta

# cat with highlighting
sudo apt install -y bat
if command -v batcat &>/dev/null; then
  ln -s "$(which batcat)" ~/.local/bin/bat
fi

# Compression tools
sudo apt install -y zip
sudo apt install -y unzip

# Neovim
sudo apt install -y neovim
sudo apt install -y python3-neovim

# Ascii art
# figlet -f slant <Some Text>
sudo apt install -y figlet

# Image manipulation
sudo apt install -y imagemagick

# Better terminal
mkdir -p ~/.local/bin
sudo apt install -y zsh
sudo apt install -y tmux
sudo apt install -y tree
sudo apt install -y fzf
sudo apt install -y ripgrep
sudo apt install -y fd-find
ln -s "$(which fdfind)" ~/.local/bin/fd
sudo snap install fasd --beta
