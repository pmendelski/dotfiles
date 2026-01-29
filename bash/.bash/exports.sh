#!/usr/bin/env bash

# Directories
export BASH_DIR="$HOME/.bash"
export BASH_TMP_DIR="$BASH_DIR/tmp"

# Internationalization
# Prefer US English and use UTF-8
# ...produces problems on VMs
export LANG="en_US.UTF-8"
# export LC_ALL="en_US.UTF-8"

# Custom Globals
# Make (n)vim the default editor
if command -v nvim &>/dev/null; then
  export EDITOR="nvim"
else
  export EDITOR="vim"
fi

# Terminal capabilities
if [ "$TERM" != "linux" ]; then
  export TERM_NERD_FONT_ENABLED="true"
  export TERM_UNICODE_ENABLED="true"
  # could be checked with `tput colors`
  export TERM_COLORS=256
else
  export TERM_NERD_FONT_ENABLED="false"
  export TERM_UNICODE_ENABLED="false"
  export TERM_COLORS=8
fi

# ShellCheck ignore some errors by default
export SHELLCHECK_OPTS="-e SC2155 -e SC1090 -e SC1091"
