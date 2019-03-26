# Setup flexi ZSH prompt
export ZSH_PROMPT=flexi

# Force tmux
export TMUX_FORCE="$([ -x "$(command -v tmux)" ] && echo '1' || echo '0')"

# Do not print the default use@host in prompt
export PROMPT_DEFAULT_USERHOST="$USER@$HOSTNAME"