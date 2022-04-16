#!/usr/bin/env bash

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
brew install wget
brew install wdiff
brew install gawk
brew install gnu-indent
brew install gnu-sed
brew install gnu-tar
brew install gnu-which
brew install grep
brew install gzip
brew install zlib
brew install less
brew install gnupg
brew install neovim
brew install httpie
brew install openssh
brew install git
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
brew install tmux
brew install zsh
brew install bash
brew install bash-completion2
brew install fasd
brew install fd
brew install ripgrep
brew install bat
brew install git-delta
brew install lazygit
brew install htop
brew install transmission

# Mpeg thumnails
brew install ffmpegthumbnailer

# PDF
brew install poppler

# Rust
brew install rustup-init
rustup-init -y --no-modify-path

# Docker
brew cask install docker
brew install docker-compose
# link zsh completion files
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion /usr/local/share/zsh/site-functions/_docker || echo "Completion file _docker exists"
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.zsh-completion /usr/local/share/zsh/site-functions/_docker-machine || echo "Completion file _docker-machine exists"
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion /usr/local/share/zsh/site-functions/_docker-compose || echo "Completion file _docker-compose exists"

# UI apps
brew install --cask alfred
brew install --cask iterm2
brew install --cask github
brew install --cask visual-studio-code
brew install --cask dropbox
brew install --cask keepassx
brew install --cask spotify
brew install --cask transmission
brew install --cask robo-3t
brew install --cask deluge
brew install --cask opera
brew install --cask intellij-idea
brew install --cask intellij-idea-ce
brew install --cask insomnia
brew install --cask sublime-text

# Fonts
brew tap homebrew/cask-fonts
brew install font-inconsolata
brew install font-fira-code
installNerdFonts() {
  mkdir -p ~/Library/Fonts
  local -r dir="$(pwd)"
  local -r tmpdir="$(mktemp -d -t nerd-fonts)"
  cd "$tmpdir"
  for font in "$@"; do
    wget -O "$font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/$font.zip" \
      && unzip -qq -o "$font.zip" -d ~/Library/Fonts \
      && echo "Installed nerd font: $font"
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
if ! grep -q "/opt/homebrew/opt/coreutils/libexec/gnubin" ~/.path; then
  echo "/opt/homebrew/opt/coreutils/libexec/gnubin" >> ~/.path
  echo "/opt/homebrew/opt/findutils/libexec/gnubin" >> ~/.path
  echo "/opt/homebrew/opt/gnu-indent/libexec/gnubin" >> ~/.path
  echo "/opt/homebrew/opt/gnu-sed/libexec/gnubin" >> ~/.path
  echo "/opt/homebrew/opt/gnu-tar/libexec/gnubin" >> ~/.path
  echo "/opt/homebrew/opt/gnu-which/libexec/gnubin" >> ~/.path
  echo "/opt/homebrew/opt/grep/libexec/gnubin" >> ~/.path
  # echo "/opt/homebrew/opt/binutils/bin" >> ~/.path
  # echo "/opt/homebrew/opt/diffutils/bin" >> ~/.path
fi

# Copy some scripts to loaded path
mkdir -pf $HOME/Scripts
cp ./scripts/* $HOME/Scripts/

# Copy automator actions
mkdir -pf $HOME/Library/Services
cp ./automator/* $HOME/Library/Services/

# Create ssh key
if [ ! -f ~/.ssh/config ]; then
  echo "Generating initial ssh key"
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519
  ssh-add ~/.ssh/id_ed25519
  echo "Host *" > ~/.ssh/config
  echo "  IgnoreUnknown UseKeychain" >> ~/.ssh/config
  echo "  AddKeysToAgent yes" >> ~/.ssh/config
  echo "  UseKeychain yes" >> ~/.ssh/config
  echo "  IdentityFile ~/.ssh/id_ed25519" >> ~/.ssh/config

  if command -v pbcopy &> /dev/null; then
    cat ~/.ssh/id_ed25519 | pbcopy
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
echo "- Import tokyo-night from _init/macos/iterm2"
echo "- Use font: FirCode Nerd Font"
echo "- Transparency: 5"
echo ""
echo "Other"
echo "- Fix keyboard shortcurs"
echo "  - Preferences > Keyboard > Shortcuts > Mission Control > Disable: Move left/right a space"
