#!/usr/bin/env bash

# Become a root and preserve environment variables and shell
alias root="sudo su --preserve-environment"

# Easier navigation: .., ..., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias cd..="cd .."
alias ~="cd ~"
alias -- -="cd -"
alias groot='cd $(git root)'

# Better ls
alias ls="ls -aFh --color --group-directories-first"
alias lld='ls -lha --group-directories-first | grep --color="never" "^d"'
alias llf='ls -lha --group-directories-first | grep --color="never" "^[^d]"'
alias ll='LC_COLLATE=C ls -alhF --group-directories-first --color'
alias la='ls -A --group-directories-first --color'
alias l='ls -CF --group-directories-first --color'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'

# Better grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Fast clear
alias clr='clear'

# Lazy git
alias lg='lazygit'

# fd
alias fd="fd --hidden"

# rg
alias rg="rg --hidden --glob '!.git'"

# Portable shebang
alias shebang='echo "#!/usr/bin/env bash"'

# Easy access to hosts file
alias hosts="sudo \$EDITOR /etc/hosts"

# Editor
alias v="vim"
alias editor="\$EDITOR"
alias e="\$EDITOR"

# Nvim
alias nvim-update="nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"

# Tmux
alias ta='tmux attach'
alias tls='tmux ls'
alias tmux-kill='tmux kill-server'
alias tmux-kill-windows='tmux kill-window -a'
alias tmux-kill-sessions='tmux kill-session -a'

# File/Directory Sizes
alias ducks='du -cksh * | sort -hr'
alias ducks15='du -cksh * | sort -hr | head -n 15'

# URL
alias urlencode='node -e "console.log(encodeURIComponent(process.argv[1]))"'
alias urldecode='node -e "console.log(decodeURIComponent(process.argv[1]))"'

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec \${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n} | grep . --color=never'

# Lock the screen (when going AFK)
if [[ "$OSTYPE" == darwin* ]]; then
  alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
fi

# HELP
alias dotfiles="editor ~/.dotfiles"
