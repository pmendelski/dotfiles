#!/bin/bash -x

################################################################################
# Basic prompts
################################################################################
: ${__PROMPT_BASIC:="${debian_chroot:+($debian_chroot)}$COLOR_GREEN_BOLD\u@\h$COLOR_RESET:$COLOR_BLUE_BOLD\w$COLOR_RESET\$ "}
: ${__PROMPT_BASIC_NO_COLORS:="${debian_chroot:+($debian_chroot)}\u@\h:\w\$ "}
# Use colors
__prompt_define_opt prompt_colors __PROMPT_COLORS 1
# Fallback to simple prompt
__prompt_define_opt prompt_simple __PROMPT_SIMPLE 0

################################################################################
# Globals
################################################################################
: ${__PROMPT_PS2:=1}
: ${__PROMPT_PS4:=1}
: ${__PROMPT_UNPRINTABLE_PREFIX:="\x01"}
: ${__PROMPT_UNPRINTABLE_SUFFIX:="\x02"}
: ${__PROMPT_TITLE_PREFIX:="\033]0;"}
: ${__PROMPT_TITLE_SUFFIX:="\007"}

################################################################################
# Line break
################################################################################
# Break command line after prompt
#   0 - no line break, 1 - line break, 2 - line break skip home
__prompt_define_opt prompt_newline __PROMPT_NEWLINE 0
# Break command line before prompt
#   0 - no line break, 1 - line break
__prompt_define_opt prompt_newline_precmd __PROMPT_NEWLINE_PRECMD 0

################################################################################
# PWD
################################################################################
: ${__PROMPT_PWD_BEFORE:="$(__promptUnprintable $COLOR_BLUE_BOLD)"}
: ${__PROMPT_PWD_AFTER:="$(__promptUnprintable $COLOR_RESET)"}
# Setup pwd mode (0-"~/Desktop/Project", 1-"~/a/b/c/project", 2-".../x/y/z/project")
__prompt_define_opt prompt_pwd_mode __PROMPT_PWD_MODE 2

################################################################################
# Shell level
################################################################################
: ${__PROMPT_SHLVL_BEFORE:="$(__promptUnprintable $COLOR_YELLOW_BOLD)"}
: ${__PROMPT_SHLVL_AFTER:="$(__promptUnprintable $COLOR_RESET)\\"}
# Show subshell count from SHLVL (-1=all, 0=never, x>0=mesure those above x sublevels)
__prompt_define_opt prompt_shlvl __PROMPT_SHLVL 1

################################################################################
# GIT
################################################################################
: ${__PROMPT_GIT_BEFORE:="$(__promptUnprintable $COLOR_MAGENTA_BOLD)("}
: ${__PROMPT_GIT_AFTER:=")$(__promptUnprintable $COLOR_RESET)"}
: ${__PROMPT_GIT_STAGED_CHANGES:="+"}
: ${__PROMPT_GIT_UNSTAGED_CHANGES:="*"}
: ${__PROMPT_GIT_UNTRACKED_FILES:="%"}
# Show GIT status
__prompt_define_opt prompt_git __PROMPT_GIT $(hash git 2>/dev/null && echo 1)

################################################################################
# Timer
################################################################################
: ${__PROMPT_TIMER_BEFORE:="$(__promptUnprintable $COLOR_GRAY)["}
: ${__PROMPT_TIMER_AFTER:="]$(__promptUnprintable $COLOR_RESET)"}
# Long running cmd notification (-1=all, 0=never, x>0=mesure those above x ms)
__prompt_define_opt prompt_notify __PROMPT_NOTIFY 5000
# Time cmd execution (-1=all, 0=never, x>0=mesure those above x ms)
__prompt_define_opt prompt_timer __PROMPT_TIMER 5000

################################################################################
# Timestamp
################################################################################
: ${__PROMPT_TIMESTAMP_BEFORE:="$(__promptUnprintable $COLOR_GRAY)["}
: ${__PROMPT_TIMESTAMP_AFTER:="]$(__promptUnprintable $COLOR_RESET)"}
# Add timestamp to prompt (date format)
__prompt_define_opt prompt_timestamp __PROMPT_TIMESTAMP 0

################################################################################
# CMD sign
################################################################################
: ${__PROMPT_CMD_ERROR:="$(__promptUnprintable $COLOR_RED_BOLD)\$$(__promptUnprintable $COLOR_RESET) "}
: ${__PROMPT_CMD_SUCCESS:="$(__promptUnprintable $COLOR_MAGENTA)\$$(__promptUnprintable $COLOR_RESET) "}

################################################################################
# User and host
################################################################################
: ${__PROMPT_USERHOST_BEFORE:="$(__promptUnprintable $COLOR_GREEN_BOLD)"}
: ${__PROMPT_USERHOST_AFTER:=":$(__promptUnprintable $COLOR_RESET)"}
: ${__PROMPT_USERHOST_ROOT_BEFORE:="$(__promptUnprintable $COLOR_RED_BOLD)"}
: ${__PROMPT_USERHOST_ROOT_AFTER:=":$(__promptUnprintable $COLOR_RESET)"}
# Add it to ~/.bash_exports (sample: PROMPT_DEFAULT_USERHOST="mendlik@dell")
__prompt_define_opt prompt_default_userhost PROMPT_DEFAULT_USERHOST ""

################################################################################
# chroot
################################################################################
: ${__PROMPT_CHROOT_BEFORE:="$(__promptUnprintable $COLOR_GREEN_BOLD)("}
: ${__PROMPT_CHROOT_AFTER:=")$(__promptUnprintable $COLOR_RESET)"}
