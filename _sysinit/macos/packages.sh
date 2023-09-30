#!/usr/bin/env bash
set -euf -o pipefail

# Install brew
if [[ $(command -v brew) == "" ]]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew update
brew upgrade

# Install dependencies
brew install coreutils
brew install moreutils
brew install findutils
brew install binutils
brew install diffutils
brew install watch
brew install ninja
brew install wget
brew install wdiff
brew install gawk
brew install gnu-indent
brew install gnu-sed
brew install gnu-tar
brew install gnu-which
brew install cmake
brew install grep
brew install gzip
brew install zlib
brew install less
brew install gnupg
brew install neovim
brew install httpie
brew install iperf3
brew install openssh
brew install git
brew install vim
brew install git-lfs
brew install imagemagick
brew install lua
brew install lynx
brew install p7zip
brew install pv
brew install ssh-copy-id
brew install tree
brew install vbindiff
brew install cowsay
brew install figlet
brew install jq
brew install yq
brew install tmux
brew install zsh
brew install bash
brew install bash-completion2
brew install fd
brew install ripgrep
brew install bat
brew install git-delta
brew install lazygit
brew install htop
brew install transmission
brew install shellcheck
brew install zoxide
brew install cheat
brew install ranger
brew install dtrx
brew install exa

# Mpeg thumnails
brew install ffmpegthumbnailer

# PDF
brew install poppler

# Rust
brew install rustup-init
rustup-init -y --no-modify-path

# Haskell
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org |
  BOOTSTRAP_HASKELL_INSTALL_STACK=1 BOOTSTRAP_HASKELL_INSTALL_HLS=1 BOOTSTRAP_HASKELL_NONINTERACTIVE=1 sh

# Docker
brew install --cask docker
brew install docker-compose
brew install dive
brew install ctop
brew install hadolint

# link zsh completion files
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion /usr/local/share/zsh/site-functions/_docker || echo "Completion file _docker exists"
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.zsh-completion /usr/local/share/zsh/site-functions/_docker-machine || echo "Completion file _docker-machine exists"
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion /usr/local/share/zsh/site-functions/_docker-compose || echo "Completion file _docker-compose exists"

# UI apps
brew install --cask iterm2
brew install --cask github
brew install --cask visual-studio-code
brew install --cask dropbox
brew install --cask keepassx
brew install --cask spotify
brew install --cask transmission
brew install --cask robo-3t
brew install --cask opera
brew install --cask intellij-idea
brew install --cask intellij-idea-ce
brew install --cask insomnia
brew install --cask sublime-text
brew install --cask google-chrome
brew install --cask firefox
brew install --cask dbeaver-community
brew install --cask unnaturalscrollwheels
brew install --cask rectangle
brew install --cask hiddenbar
brew tap homebrew/cask && brew install --cask gimp
brew install --cask inkscape

# gcloud
# https://cloud.google.com/sdk/docs/install#mac
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
    wget -O "gcloud.tar.gz" "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-$GCLOUD_VERSION-darwin-arm.tar.gz" &&
    echo "Extracting gcloud v$GCLOUD_VERSION..." &&
    tar -xf "gcloud.tar.gz" &&
    mv ./google-cloud-sdk "$HOME/.gcloud" &&
    cd "$HOME/.gcloud" &&
    ./install.sh --usage-reporting false --install-python false --command-completion false --path-update false
  gcloud components install alpha
  gcloud components install beta
  gcloud components install cloud-run-proxy
) || echo "Already installed"

# Fonts
brew tap homebrew/cask-fonts
brew install font-inconsolata
brew install font-fira-code
brew install font-fira-mono
brew install font-fira-sans
installNerdFonts() {
  mkdir -p ~/Library/Fonts
  local -r version="$(curl -sL https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest |
    jq -r ".tag_name")"
  local -r dir="$(pwd)"
  local -r tmpdir="$(mktemp -d -t nerd-fonts-XXXXX)"
  cd "$tmpdir"
  for font in "$@"; do
    wget -O "$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/$version/$font.zip" &&
      unzip -o "$font.zip" -d ~/Library/Fonts &&
      echo "Installed nerd font: $font"
  done
  rm -rf "$tmpdir"
  cd "$dir"
}
installNerdFonts 'DroidSansMono' 'FiraCode' 'Hack' 'Inconsolata'

# Performance test tools
brew install nghttp2

# Remove outdated versions from the cellar.
brew cleanup

# Use GNU tools by defaults
if [ -d /opt/homebrew/opt/coreutils/libexec/gnubin ]; then
  if ! grep -q "/opt/homebrew/opt/coreutils/libexec/gnubin" ~/.path; then
    {
      echo "/opt/homebrew/opt/coreutils/libexec/gnubin"
      echo "/opt/homebrew/opt/findutils/libexec/gnubin"
      echo "/opt/homebrew/opt/gnu-indent/libexec/gnubin"
      echo "/opt/homebrew/opt/gnu-sed/libexec/gnubin"
      echo "/opt/homebrew/opt/gnu-tar/libexec/gnubin"
      echo "/opt/homebrew/opt/gnu-which/libexec/gnubin"
      echo "/opt/homebrew/opt/grep/libexec/gnubin"
    } >>~/.path
  fi
fi
if [ -d /usr/local/opt/coreutils/libexec/gnubin ]; then
  if ! grep -q "/usr/local/opt/coreutils/libexec/gnubin" ~/.path; then
    {
      echo "/usr/local/opt/coreutils/libexec/gnubin"
      echo "/usr/local/opt/findutils/libexec/gnubin"
      echo "/usr/local/opt/gnu-indent/libexec/gnubin"
      echo "/usr/local/opt/gnu-sed/libexec/gnubin"
      echo "/usr/local/opt/gnu-tar/libexec/gnubin"
      echo "/usr/local/opt/gnu-which/libexec/gnubin"
      echo "/usr/local/opt/grep/libexec/gnubin"
    } >>~/.path
  fi
fi

# Copy some scripts to loaded path
mkdir -p "$HOME/Scripts"
cp ./scripts/* "$HOME/Scripts/"

# Copy automator actions
mkdir -pf "$HOME/Library/Services"
cp -r ./automator/* "$HOME/Library/Services/"

# Install xcode
xcode-select --install

# Create ssh key
if [ ! -f ~/.ssh/config ]; then
  echo "Generating initial ssh key"
  eval "$(ssh-agent -s)"
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
  ssh-add ~/.ssh/id_ed25519
  {
    echo "Host *"
    echo "  IgnoreUnknown UseKeychain"
    echo "  AddKeysToAgent yes"
    echo "  UseKeychain yes"
    echo "  IdentityFile ~/.ssh/id_ed25519"
  } >~/.ssh/config

  if command -v pbcopy &>/dev/null; then
    pbcopy <~/.ssh/id_ed25519.pub
    echo "New SSH key is in the clipboard. Register the key on https://github.com/settings/keys"
    echo "Remember to generate GPG key with: gpg-generate-key-for-github"
  fi
fi

echo ""
echo "NEXT STEPS"
echo ""
echo "Git"
echo "- Register SSH key in github:"
echo "  - cat ~/.ssh/id_ed25519.pub | pbcopy"
echo "  - Go to: https://github.com/settings/keys"
echo "- Generate gpg key"
echo "  - gpg-generate-key-for-github"
echo ""
echo "AppStore"
echo "- Login to App Store and install apps"
echo ""
echo "Dropbox"
echo "- Log in"
echo "- Remove Dropbox from context menu:"
echo "  - System Preferences > Extensions > Finder extensions > Disable Dropbox"
echo "- Remove Dropbox from finder top menu:"
echo "  - Finder > Right Click Toolbar > Customize > ..."
echo ""
echo "iTerm2"
echo "- Read settings from file: Preferences > General > Preferences"
echo "    Read from file .dotfiles/_sysinit/macos/iterm2"
echo ""
echo "Other"
echo "- Fix keyboard shortcuts"
echo "  - Preferences > Keyboard > Shortcuts > Mission Control > Disable: Move left/right a space"
echo "- Turn off trackpad dictionary"
echo "  - Preferences > Trackpad > Point & Click > Disable: Look up & data detectors"
echo "- Fix fullscreen open during presentations"
echo "  - Preferences > Mission Control > Check 'Displays have separate spaces'"
echo "- Fix mouse scrolling"
echo "  - Start Linearmouse > Change scrolling mode to 'Lines' and start with system startup"
