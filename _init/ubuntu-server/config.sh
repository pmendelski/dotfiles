#!/usr/bin/env bash -ex

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
