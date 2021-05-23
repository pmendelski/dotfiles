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
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
