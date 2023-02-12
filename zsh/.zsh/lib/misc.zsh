#!/bin/zsh

## Load smart urls if available
# bracketed-paste-magic is known buggy in zsh 5.1.1 (only), so skip it there; see #4434
autoload -Uz is-at-least
if [ "${ZSH_VERSION-}" != "5.1.1" ]; then
  for d in $fpath; do
    if [[ -e "$d/url-quote-magic" ]]; then
      if is-at-least 5.1; then
        autoload -Uz bracketed-paste-magic
        zle -N bracketed-paste bracketed-paste-magic
      fi
      autoload -Uz url-quote-magic
      zle -N self-insert url-quote-magic
      break
    fi
  done
fi

## jobs
setopt long_list_jobs

# recognize comments
setopt interactivecomments

autoload -U colors && colors
autoload -Uz is-at-least
autoload zsh/terminfo

# directories
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

setopt long_list_jobs
setopt interactivecomments
setopt no_beep
setopt multios
setopt cdablevars
setopt prompt_subst
