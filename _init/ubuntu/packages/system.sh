#!/usr/bin/env bash
set -e

echo ""
echo ">>>"
echo ">>> SYSTEM"
echo ">>>"

echo -e "\n>>> Terminal"
sudo apt install -y \
  tmux \
  zsh \
  fzf \
  fd-find \
  tree \
  ripgrep \
  htop \
  zoxide \
  ranger \
  exa

sudo apt install -y fd-find
if [ ! -f ~/.local/bin/fd ]; then
  mkdir -p ~/.local/bin
  ln -s "$(which fdfind)" ~/.local/bin/fd
fi
# sudo apt install -y -o Dpkg::Options::="--force-overwrite" bat ripgrep

# cat with highlighting
sudo apt install -y bat
if [ ! -f ~/.local/bin/bat ]; then
  mkdir -p ~/.local/bin
  ln -s "$(which batcat)" ~/.local/bin/bat
fi

# Install gogh - theme switcher for terminal
if [ -d "$HOME/.gogh" ]; then
  cd "$HOME/.gogh"
  git fetch
  git reset --hard @{u}
  cd themes
else
  cd "$HOME"
  git clone https://github.com/Mayccoll/Gogh.git .gogh
  cd .gogh/themes
fi
# ./atom.sh
./tokyo-night.sh

echo -e "\n>>> Vim & Neovim"
sudo apt install -y vim
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update
sudo apt install -y neovim

echo -e "\n>>> Rar/zip"
sudo apt install -y \
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
  alien \
  gzip \
  dtrx

echo -e "\n>>> Build tools"
sudo apt install -y \
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
  ninja-build \
  dh-make \
  libtool \
  autoconf \
  shellcheck \
  gcc

echo -e "\n>>> GIT"
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt update
sudo apt install -y \
  git \
  gitk \
  gitg

# Lazygit
(! command -v lazygit &>/dev/null) && (
  echo "Installing lazygit"
  version="$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')"
  tmpdir="$(mktemp -d -t lazygit-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz" &&
      tar xf lazygit.tar.gz -C ~/.local/bin lazygit
  )
  rm -rf "$tmpdir"
) || echo "lazygit already installed"

# Cheat
(! command -v cheat &>/dev/null) && (
  echo "Installing cheat"
  version="$(curl -s "https://api.github.com/repos/cheat/cheat/releases/latest" | grep -Po '"tag_name": "\K[^"]*')"
  tmpdir="$(mktemp -d -t cheat-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo cheat.gz "https://github.com/cheat/cheat/releases/download/${version}/cheat-linux-amd64.gz" &&
      gunzip cheat.gz &&
      chmod u+x cheat &&
      sudo mv cheat-linux-amd64 /usr/local/bin/cheat
  )
  rm -rf "$tmpdir"
) || echo "cheat already installed"

echo -e "\n>>> Network tools"
sudo apt install -y \
  dnsutils \
  iperf3 \
  curl \
  apache2-utils

echo -e "\n>>> CLI parsers"
sudo apt install -y jq yq

echo -e "\n>>> Penetration testing tools"
sudo apt install -y \
  aircrack-ng \
  john \
  macchanger

echo -e ">>> gcloud"
[ ! -d "$HOME/.gcloud" ] && (
  GCLOUD_VERSION="$(
    curl -s "https://hub.docker.com/v2/repositories/google/cloud-sdk/tags/?page_size=1000" |
      jq '.results | .[] | .name' -r |
      sed 's/latest//' |
      grep -E "^[0-9]+.[0-9]+.[0-9]+$" |
      sort --version-sort |
      tail -n 1
  )"
  echo "Downloading gcloud v$GCLOUD_VERSION"
  cd "$(mktemp -d -t gcloud-XXX)" &&
    wget -O "gcloud.tar.gz" "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-$GCLOUD_VERSION-linux-$(uname -m).tar.gz" &&
    echo "Extracting gcloud v$GCLOUD_VERSION..." &&
    tar -xf "gcloud.tar.gz" &&
    mv ./google-cloud-sdk "$HOME/.gcloud" &&
    cd "$HOME/.gcloud" &&
    ./install.sh --usage-reporting false --install-python false --command-completion false --path-update false
  gcloud components install alpha
  gcloud components install beta
  gcloud components install cloud-run-proxy
) || echo "Already installed"

echo -e "\n>>> Rust"
if ! command -v rustup &>/dev/null; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  export PATH="$PATH:~/.cargo/bin"
fi

# echo -e "\n>>> Haskell"
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org |
#   BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh

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
# GUI for GnuPG
sudo apt install -y seahorse seahorse-nautilus
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
