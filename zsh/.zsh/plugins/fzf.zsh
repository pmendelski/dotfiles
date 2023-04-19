#!/bin/zsh

# Must be loaded after syntax-highlighting
source $ZSH_DIR/plugins/zsh-syntax-highlighting.zsh

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --follow . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --follow . "$1"
}

# Load fzf
if [ -f ~/.fzf.zsh ]; then
  source ~/.fzf.zsh
else
  if [ -f "/usr/share/doc/fzf/examples/completion.zsh" ] && [[ $- == *i* ]]; then
    source "/usr/share/doc/fzf/examples/completion.zsh" 2>/dev/null
  fi
  if [ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]; then
    source "/usr/share/doc/fzf/examples/key-bindings.zsh"
  fi
fi
