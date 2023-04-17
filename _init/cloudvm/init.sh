#!/usr/bin/env bash
set -euf -o pipefail

echo -e "\n>>> Terminal"
sudo apt install -y \
  tmux \
  zsh \
  fzf \
  tree \
  ripgrep \
  htop \
  zoxide

# better find
sudo apt install -y fd-find
if [ ! -f ~/.local/bin/fd ]; then
  mkdir -p ~/.local/bin
  ln -s "$(which fdfind)" ~/.local/bin/fd
fi

# cat with highlighting
sudo apt install -y bat
if [ ! -f ~/.local/bin/bat ]; then
  mkdir -p ~/.local/bin
  ln -s "$(which batcat)" ~/.local/bin/bat
fi

echo -e "\n>>> Vim & Neovim"
sudo apt install -y vim
# sudo add-apt-repository -y ppa:neovim-ppa/stable
# sudo apt update
# sudo apt install -y neovim
(! command -v nvim &>/dev/null) && (
  echo "Installing nvim"
  tmpdir="$(mktemp -d -t nvim-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo nvim.tar.gz "https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz" &&
      tar xf nvim.tar.gz -C ~/.local &&
      mkdir -p ~/.local/app/ &&
      rm -rf ~/.local/app/nvim &&
      mv ~/.local/app/nvim-linux64 ~/.local/app/nvim &&
      ln -fs ~/.local/app/nvim/bin/nvim ~/.local/bin/nvim
  )
  rm -rf "$tmpdir"
) || echo "nvim already installed"

echo -e "\n>>> Build tools"
sudo apt install -y \
  build-essential \
  make \
  shellcheck

echo -e "\n>>> GIT"
# sudo add-apt-repository -y ppa:git-core/ppa
# sudo apt update
sudo apt install -y git

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

echo -e "\n>>> Network tools"
sudo apt install -y \
  curl \
  wget \
  dnsutils \
  apache2-utils

echo -e "\n>>> CLI parsers"
sudo apt install -y jq
wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O ~/.local/bin/yq &&
  chmod +x ~/.local/bin/yq

echo -e "\n>>> gcloud"
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
) || echo "Already installed"
