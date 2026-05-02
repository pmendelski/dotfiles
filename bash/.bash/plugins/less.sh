#!/usr/bin/env bash

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Make it colorful
export LESSOPEN="| $HOME/.lessfilter %s"
export LESS=" -R "
export PAGER="less"

# Less colors for man pages
export LESS_TERMCAP_mb=$'\e[1;32m'    # bold green
export LESS_TERMCAP_md=$'\e[1;34m'    # bold blue
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;37;44m' # bold white on blue
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;37m'  # underline bold white
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[4m'
export LESS_TERMCAP_ZV=$'\e[24m'
export LESS_TERMCAP_ZO=$'\e[4m'
export LESS_TERMCAP_ZW=$'\e[24m'
