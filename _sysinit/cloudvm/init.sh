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
  ranger \
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

echo -e "\n>>> Vim & Neovim"
sudo apt install -y vim
# sudo add-apt-repository -y ppa:neovim-ppa/stable
# sudo apt update
# sudo apt install -y neovim
if ! command -v nvim &>/dev/null; then
  echo "Installing nvim"
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

echo -e "\n>>> Build tools"
sudo apt install -y \
  build-essential \
  make \
  shellcheck

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

echo -e "\n>>> GIT"
# sudo add-apt-repository -y ppa:git-core/ppa
# sudo apt update
sudo apt install -y git

# Lazygit
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

echo -e "\n>>> Network tools"
sudo apt install -y \
  curl \
  wget \
  dnsutils \
  apache2-utils

echo -e "\n>>> CLI parsers"
sudo apt install -y jq
if ! command -v yq &>/dev/null; then
  wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O ~/.local/bin/yq &&
    chmod +x ~/.local/bin/yq
fi
echo -e "\n>>> Linters"
sudo apt intall -y yamllint

echo -e "\n>>> Fzf"
if [ ! -d "$HOME/.fzf" ]; then
  cd
  git clone --depth 1 https://github.com/junegunn/fzf.git .fzf
  ./.fzf/install --no-update-rc --key-bindings --completion
  ln -s .fzf/bin/fzf .local/bin/fzf
fi

echo -e "\n>>> Eza"
if ! command -v eza &>/dev/null; then
  version="$(curl -s "https://api.github.com/repos/eza-community/eza/releases/latest" | grep -Po '"tag_name": "\K[^"]*')"
  tmpdir="$(mktemp -d -t eza-XXXX)"
  (
    cd "$tmpdir" &&
      curl -Lo eza.tar.gz "https://github.com/eza-community/eza/releases/download/${version}/eza_x86_64-unknown-linux-gnu.tar.gz" &&
      tar xf eza.tar.gz &&
      mv eza ~/.local/bin/eza
  )
  rm -rf "$tmpdir"
fi

# echo -e "\n>>> gcloud"
# if [ ! -d "$HOME/.gcloud" ]; then
#   GCLOUD_VERSION="$(
#     curl -s "https://hub.docker.com/v2/repositories/google/cloud-sdk/tags/?page_size=1000" |
#       jq '.results | .[] | .name' -r |
#       sed 's/latest//' |
#       grep -E "^[0-9]+.[0-9]+.[0-9]+$" |
#       sort --version-sort |
#       tail -n 1
#   )"
#   echo "Downloading gcloud v$GCLOUD_VERSION"
#   cd "$(mktemp -d -t gcloud-XXX)" &&
#     wget -O "gcloud.tar.gz" "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-$GCLOUD_VERSION-linux-$(uname -m).tar.gz" &&
#     echo "Extracting gcloud v$GCLOUD_VERSION..." &&
#     tar -xf "gcloud.tar.gz" &&
#     mv ./google-cloud-sdk "$HOME/.gcloud" &&
#     cd "$HOME/.gcloud" &&
#     ./install.sh --usage-reporting false --install-python false --command-completion false --path-update false
#   gcloud components install alpha
#   gcloud components install beta
# fi
