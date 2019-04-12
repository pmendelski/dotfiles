# Tmux
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

# History
alias hist='history | grep --color '

# Base code editor
if type "code" > /dev/null; then
  alias code='code .'
fi
