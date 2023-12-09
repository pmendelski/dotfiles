#!/usr/bin/env bash
set -e

echo ""
echo ">>>"
echo ">>> SYSTEM"
echo ">>>"

mkdir -p ~/.local/bin
mkdir -p ~/.local/app

echo -e "\n>>> Build tools"
sudo apt install -y \
  build-essential \
  make \
  shellcheck

echo -e "\n>>> Network tools"
sudo apt install -y \
  dnsutils \
  iperf3 \
  curl \
  apache2-utils

echo -e "\n>>> Rar/zip"
sudo apt install -y \
  unace \
  unrar \
  zip \
  unzip \
  gzip \
  dtrx

echo -e "\n>>> GIT"
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
sudo apt install -y \
  git \
  gitk \
  gitg

if ! command -v lazygit &>/dev/null; then
  echo "Installing lazygit"
  version="$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')"
  tmpdir="$(mktemp -d -t lazygit-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz" &&
      tar xf lazygit.tar.gz -C ~/.local/bin lazygit
  )
  rm -rf "$tmpdir"
fi

echo -e "\n>>> Terminal"
sudo apt install -y \
  tmux \
  zsh \
  tree \
  ripgrep \
  htop \
  zoxide \
  ranger \
  exa

sudo apt install -y fd-find
if [ ! -f ~/.local/bin/fd ]; then
  ln -s "$(which fdfind)" ~/.local/bin/fd
fi

# cat with highlighting
sudo apt install -y bat
if [ ! -f ~/.local/bin/bat ]; then
  ln -s "$(which batcat)" ~/.local/bin/bat
fi

if ! command -v cheat &>/dev/null; then
  echo "Installing cheat"
  version="$(curl -s "https://api.github.com/repos/cheat/cheat/releases/latest" | grep -Po '"tag_name": "\K[^"]*')"
  tmpdir="$(mktemp -d -t cheat-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo cheat.gz "https://github.com/cheat/cheat/releases/download/${version}/cheat-linux-amd64.gz" &&
      gunzip cheat.gz &&
      chmod u+x cheat &&
      mv cheat ~/.local/bin/cheat
  )
  rm -rf "$tmpdir"
fi

if [ ! -d "$HOME/.fzf" ]; then
  echo "Installing fzf"
  cd
  git clone --depth 1 https://github.com/junegunn/fzf.git .fzf
  ./.fzf/install --no-update-rc --key-bindings --completion
  ln -s .fzf/bin/fzf .local/bin/fzf
fi

if ! command -v cheat &>/dev/null; then
  echo "Installing: cheat"
  version="$(curl -s "https://api.github.com/repos/cheat/cheat/releases/latest" | grep -Po '"tag_name": "\K[^"]*')"
  tmpdir="$(mktemp -d -t cheat-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo cheat.gz "https://github.com/cheat/cheat/releases/download/${version}/cheat-linux-amd64.gz" &&
      gunzip cheat.gz &&
      chmod u+x cheat &&
      sudo mv cheat /usr/local/bin/cheat
  )
  rm -rf "$tmpdir"
fi

echo -e "\n>>> Vim & Neovim"
sudo apt install -y vim
# sudo add-apt-repository -y ppa:neovim-ppa/stable
# sudo apt update
# sudo apt install -y neovim
if ! command -v nvim &>/dev/null; then
  echo "Installing: nvim"
  tmpdir="$(mktemp -d -t nvim-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz" &&
      tar xf nvim.tar.gz -C ~/.local &&
      rm -rf ~/.local/app/nvim &&
      mv ~/.local/nvim-linux64 ~/.local/app/nvim &&
      ln -fs ~/.local/app/nvim/bin/nvim ~/.local/bin/nvim
  )
  rm -rf "$tmpdir"
fi

echo -e "\n>>> CLI parsers"
sudo apt install -y jq
if ! command -v yq &>/dev/null; then
  wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O ~/.local/bin/yq &&
    chmod +x ~/.local/bin/yq
fi

echo -e "\n>>> Other"
# Another package installer
sudo apt install -y gdebi
# Mounting remote file system by ssh
sudo apt install -y sshfs
# Copy to clipboard
sudo apt install -y xclip xsel
# Utils like: sponge
sudo apt install -y moreutils tree
# Listen to file changes
sudo apt install -y inotify-tools
# Looking for files inside packages
# Example: apt-file search /usr/lib/jvm/java-6-openjdk/jre/lib/i386/xawt/libmawt.so
# See: https://www.howtoforge.com/apt_file_debian_ubuntu
sudo apt install -y apt-file
sudo apt-file update
# Quote of the day
sudo apt install -y fortune
# Funny creatures
# fortune | cowsay -f $(ls /usr/share/cowsay/cows/ | shuf -n1)
# for f in `cowsay -l | tac | head -n -1 | tac | tr ' ' '\n' | sort`; do
#     cowsay -f $f "Hello from $f"
# done
sudo apt install -y cowsay
# Ascii art
# figlet -f slant <Some Text>
sudo apt install -y figlet
