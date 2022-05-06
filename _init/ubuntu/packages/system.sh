#!/usr/bin/env bash
set -e

echo ""
echo ">>>"
echo ">>> SYSTEM"
echo ">>>"

echo -e "\n>>> Terminal"
mkdir -p ~/.local/bin
sudo apt-get install -y \
  tmux \
  zsh \
  fzf \
  fd-find \
  tree \
  ripgrep
ln -s $(which fdfind) ~/.local/bin/fd
sudo snap install fasd --beta
sudo apt install -o Dpkg::Options::="--force-overwrite" bat ripgrep
# cat with highlighting
sudo apt install bat
if command -v batcat &> /dev/null; then
  ln -s $(which batcat) ~/.local/bin/bat
fi
# htop
sudo apt-get install htop
# Lazygit
# Replace with gitui when it's in apt-get/snap
sudo add-apt-repository -y ppa:lazygit-team/release
sudo apt-get update
sudo apt-get install -y lazygit
# tmux
# https://gist.github.com/indrayam/ebf53ba970241694865e1dd2b1313945
# https://github.com/tmux/tmux/wiki/Installing#building-dependencies

echo -e "\n>>> Neovim"
sudo snap install nvim --classic

echo -e "\n>>> Rar/zip"
sudo apt-get install -y \
  unace \
  unrar \
  zip \
  unzip \
  p7zip-full \
  p7zip-rar \
  sharutils \
  rar \
  uudeview \
  mpack \
  arj \
  cabextract \
  file-roller \
  unp \
  alien

echo -e "\n>>> Build tools"
sudo apt-get install -y \
  build-essential \
  automake \
  make \
  checkinstall \
  dpatch \
  patchutils \
  autotools-dev \
  debhelper \
  quilt \
  fakeroot \
  xutils \
  lintian \
  cmake \
  dh-make \
  libtool \
  autoconf

echo -e "\n>>> C"
sudo apt-get install -y \
  gcc \
  g++ \
  gobjc

echo -e "\n>>> GIT"
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get install -y \
  git \
  gitk \
  gitg

echo -e "\n>>> HTTP clients"
sudo apt-get install -y \
  curl \
  httpie \
  dnsutils

echo -e "\n>>> HTTP perf test tools"
sudo apt-get install -y \
  nghttp2-client \
  apache2-utils

echo -e "\n>>> JSON parser"
sudo apt-get install -y \
  jq

echo -e "\n>>> Penetration testing tools"
sudo apt-get install -y \
  aircrack-ng \
  john \
  macchanger

# Docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt -y update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker "${USER}"
# Docker compose https://docs.docker.com/compose
docker_compose_version="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)"
sudo curl -L "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose

echo -e "\n>>> Rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo -e "\n>>> Other"
# Mounting remote file system by ssh
sudo apt-get install -y sshfs
# Copy to clipboard
sudo apt-get install -y xclip xsel
# Utils like: sponge
sudo apt-get install -y moreutils tree
# Listen to file changes
sudo apt-get install -y inotify-tools
# GUI for GnuPG
sudo apt-get install -y seahorse seahorse-nautilus
# Looking for files inside packages
# Example: apt-file search /usr/lib/jvm/java-6-openjdk/jre/lib/i386/xawt/libmawt.so
# See: https://www.howtoforge.com/apt_file_debian_ubuntu
sudo apt-get install -y apt-file
sudo apt-file update
# Quote of the day
sudo apt-get install -y fortune
# Funny creatures
# fortune | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1)
# for f in `cowsay -l | tac | head -n -1 | tac | tr ' ' '\n' | sort`; do
#     cowsay -f $f "Hello from $f"
# done
sudo apt-get install -y cowsay
# Ascii art
# figlet -f slant <Some Text>
sudo apt-get install -y figlet

# sdkvm
git clone git@github.com:pmendelski/sdkvm.git "$HOME/.sdkvm"
