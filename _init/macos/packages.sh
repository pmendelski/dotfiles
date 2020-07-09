#!/usr/bin/env bash

# Install brew
if [[ $(command -v brew) == "" ]]; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew update
brew upgrade

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
brew install vim
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
brew cask install java

# Docker
brew cask install docker
brew install docker-compose
# link zsh completion files
ln -s /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion /usr/local/share/zsh/site-functions/_docker || echo "Completion file _docker exists"
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.zsh-completion /usr/local/share/zsh/site-functions/_docker-machine || echo "Completion file _docker-machine exists"
ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion /usr/local/share/zsh/site-functions/_docker-compose || echo "Completion file _docker-compose exists"

# UI apps
brew cask install iterm2
brew cask install alfred
brew cask install fliqlo
brew cask install github
brew cask install transmission
brew cask install yujitach-menumeters
brew cask install visual-studio-code
brew cask install dropbox
brew cask install keepassx
brew cask install spotify
brew cask install robo-3t
brew cask install skype
brew cask install deluge
brew cask install opera
brew cask install intellij-idea
brew cask install intellij-idea-ce
brew cask install insomnia

# Remove outdated versions from the cellar.
brew cleanup

# Use GNU tools by defaults
echo "/usr/local/opt/coreutils/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/findutils/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/binutils/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/diffutils/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/gnu-indent/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/gnu-sed/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/gnu-tar/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/gnu-tar/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/gnu-which/libexec/gnubin" >> ~/.path
echo "/usr/local/opt/grep/libexec/gnubin" >> ~/.path

# Switch to using brew-installed shells as default
sudo mv /bin/bash /bin/bash_old
sudo mv /bin/zsh /bin/zsh_old
sudo mv /bin/sh /bin/sh_old
sudo chmod a-x /bin/bash_old
sudo chmod a-x /bin/zsh_old
sudo chmod a-x /bin/sh_old
sudo ln -s /usr/local/bin/bash /bin/bash
sudo ln -s /usr/local/bin/bash /bin/sh
sudo ln -s /usr/local/bin/zsh /bin/zsh

# Install headers for python/ruby compilation
if [ -f /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg ]; then
  installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /
fi

# Copy some scripts to loaded path
mkdir -pf $HOME/Scripts
cp ./scripts/* ./Scripts/

echo "Recommended apps to install manually:"
echo "  - Magnet (https://itunes.apple.com/pl/app/magnet/id441258766)"
echo "  - RedQuits (http://www.carsten-mielke.com/redquits.html)"
echo "  - Vanilla (https://matthewpalmer.net/vanilla/)"
echo "  - Mini Calendar (https://matthewpalmer.net/vanilla/)"
