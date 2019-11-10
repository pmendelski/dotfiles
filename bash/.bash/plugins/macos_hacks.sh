#!/bin/bash

if [[ "$OSTYPE" == "darwin"* ]]; then
  # Sometimes after update macos overrides previous changes
  hacks_use-brew-sh() {
    sudo rm -f /bin/bash_old
    sudo rm -f /bin/zsh_old
    sudo rm -f /bin/sh_old
    sudo mv /bin/bash /bin/bash_old
    sudo mv /bin/zsh /bin/zsh_old
    sudo mv /bin/sh /bin/sh_old
    sudo chmod a-x /bin/bash_old
    sudo chmod a-x /bin/zsh_old
    sudo chmod a-x /bin/sh_old
    sudo ln -s /usr/local/bin/bash /bin/bash
    sudo ln -s /usr/local/bin/bash /bin/sh
    sudo ln -s /usr/local/bin/zsh /bin/zsh
  }

  # Sometimes after pluging new camera it is not visible
  # See: https://medium.com/@jcmrgo/fix-mic-video-without-restarting-your-mac-ab704360f79c
  hacks_fix-cameras() {
    sudo killall VDCAssistant
  }

  hacks_fix-audio() {
    sudo killall coreaudiod
  }
fi
