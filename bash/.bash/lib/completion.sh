#!/bin/bash

# Enable programmable completion features
# It's needed to autocomplete git commands
# http://www.gnu.org/software/bash/manual/bash.html#Programmable-Completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# List options alomst like in zsh
# http://superuser.com/questions/288714/bash-autocomplete-like-zsh
bind 'set show-all-if-ambiguous on'
# Select first option automatically
# bind 'TAB:menu-complete'

# Fixed git checkout autocompletion
# Remove remote branches from completion
# http://stackoverflow.com/a/39059740
_git_checkout ()
{
  __git_has_doubledash && return

  case "$cur" in
  --conflict=*)
    __gitcomp "diff3 merge" "" "${cur##--conflict=}"
    ;;
  --*)
    __gitcomp "
    --quiet --ours --theirs --track --no-track --merge
    --conflict= --orphan --patch
    "
    ;;
  *)
    # check if --track, --no-track, or --no-guess was specified
    # if so, disable DWIM mode
    local flags="--track --no-track --no-guess" track=1
    if [ -n "$(__git_find_on_cmdline "$flags")" ]; then
    track=''
    fi
    # only search local branches instead of remote branches if origin isn't
    # specified
    if [[ $cur == "origin/"* ]]; then
    __gitcomp_nl "$(__git_refs '' $track)"
    else
    __gitcomp_nl "$(__git_heads '' $track)"
    fi
    ;;
  esac
}
