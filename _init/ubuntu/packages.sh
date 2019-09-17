# VPN Netowork manager packages
sudo apt-get -y install \
  network-manager-openvpn-gnome \
  network-manager-openvpn \
  network-manager-pptp \
  network-manager-vpnc
sudo systemctl restart NetworkManager

# DB Managers
sudo apt install -y mysql-workbench
sudo snap install squirrelsql

# Docker
sudo apt-get remove -y docker docker-engine docker.io containerd runc
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt -y update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker "${USER}"
su - "${USER}"
# Docker compose https://docs.docker.com/compose
docker-compose-version="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)"
sudo curl -L "https://github.com/docker/compose/releases/download/${docker-compose-version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/${docker-compose-version}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
sudo curl -L https://raw.githubusercontent.com/docker/compose/${docker-compose-version}/contrib/completion/zsh/_docker-compose > ~/.zsh/completion/_docker-compose
