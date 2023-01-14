#!/usr/bin/env bash

# if [ -r "/etc/profile.d/bash_completion.sh" ]; then
#   source /etc/profile.d/bash_completion.sh
# fi

# Enable git completions
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB:menu-complete'
# Display a list of the matching files
bind "set show-all-if-ambiguous on"
# Perform partial (common) completion on the first Tab press, only start
# cycling full results on the second Tab press (from bash version 5)
bind "set menu-complete-display-prefix on"
