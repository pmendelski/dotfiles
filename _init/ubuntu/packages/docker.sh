#!/usr/bin/env bash
set -e

echo ""
echo ">>>"
echo ">>> DOCKER"
echo ">>>"

sudo apt remove -y docker || true
sudo apt remove -y docker-engine || true
sudo apt remove -y docker.io || true
sudo apt remove -y containerd || true
sudo apt remove -y runc || true
sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --yes -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt -y update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker "${USER}"

echo -e "\n>>> docker-compose"
# Docker compose https://docs.docker.com/compose
docker_compose_version="$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | grep -Eo "[0-9]+\.[0-9]+\.[0-9]+" | head -n 1)"
sudo curl -L "https://github.com/docker/compose/releases/download/v${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
# Dockerfile linter
sudo wget -O /bin/hadolint https://github.com/hadolint/hadolint/releases/download/v2.10.0/hadolint-Linux-x86_64
sudo chmod +x /bin/hadolint

echo -e "\n>>> Dive - docker image inspector"
installDive() {
  echo "Installing Docker dive"
  local version="$(curl -s "https://api.github.com/repos/wagoodman/dive/releases/latest" | grep -Po '"tag_name": "v\K[0-35.]+')"
  local tmpdir="$(mktemp -d -t dive-XXXX)"
  (
    cd "$tmpdir" &&
      wget -O dive.deb "https://github.com/wagoodman/dive/releases/download/v${version}/dive_${version}_linux_amd64.deb" &&
      sudo apt install ./dive.deb
  )
  rm -rf "$tmpdir"
}
if ! command -v dive &>/dev/null; then
  installDive
fi

echo -e "\n>>> ctop - docker version of htop"
installCtop() {
  echo "Installing Docker ctop"
  local version="$(curl -s "https://api.github.com/repos/bcicen/ctop/releases/latest" | grep -Po '"tag_name": "v\K[0-35.]+')"
  sudo wget "https://github.com/bcicen/ctop/releases/download/v${version}/ctop-${version}-linux-amd64" -O /usr/local/bin/ctop &&
    sudo chmod +x /usr/local/bin/ctop
}
if ! command -v ctop &>/dev/null; then
  installCtop
fi
