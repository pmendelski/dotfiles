#!/usr/bin/env bash
set -euf -o pipefail

echo "Turnoff sleep mode on lid close"
if ! grep -q '^HandleLidSwitch=ignore' /etc/systemd/logind.conf; then
  # https://askubuntu.com/a/594417
  echo 'HandleLidSwitch=ignore' | sudo tee --append /etc/systemd/logind.conf
  echo 'HandleLidSwitchDocked=ignore' | sudo tee --append /etc/systemd/logind.conf
  sudo service systemd-logind restart
fi

echo "Turnoff display on lid close"
sudo apt-get install acpi-support vbetool
echo 'event=button/lid.*' | sudo tee -a /etc/acpi/events/lid-button
echo 'action=/etc/acpi/lid.sh' | sudo tee -a /etc/acpi/events/lid-button
sudo touch /etc/acpi/lid.sh
sudo chmod +x /etc/acpi/lid.sh
sudo tee /etc/acpi/lid.sh << END
#!/usr/bin/env bash
grep -q close /proc/acpi/button/lid/*/state
if [ \$? = 0 ]; then
  sleep 0.2 && vbetool dpms off
fi
grep -q open /proc/acpi/button/lid/*/state
if [ \$? = 0 ]; then
  vbetool dpms on
fi
END

# Change shell to zsh
chsh -s "$(which zsh)"

# Open basic ports
# See: https://www.liquidweb.com/kb/set-firewall-using-iptables-ubuntu-16-04/
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
sudo iptables -A INPUT -p udp --dport 1194 -j ACCEPT
