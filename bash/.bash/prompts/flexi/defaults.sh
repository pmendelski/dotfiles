#!/bin/bash -x

################################################################################
# Basic prompts
################################################################################
: ${__FLEXI_PROMPT_BASIC:="${debian_chroot:+($debian_chroot)}$COLOR_GREEN_BOLD\u@\h$COLOR_RESET:$COLOR_BLUE_BOLD\w$COLOR_RESET\$ "}
: ${__FLEXI_PROMPT_BASIC_NO_COLORS:="${debian_chroot:+($debian_chroot)}\u@\h:\w\$ "}
# Use colors
__flexiPromptDefineOpt prompt_colors __FLEXI_PROMPT_COLORS 1
# Fallback to simple prompt
__flexiPromptDefineOpt prompt_simple __FLEXI_PROMPT_SIMPLE 0

################################################################################
# Globals
################################################################################
: ${__FLEXI_PROMPT_PS2:=1}
: ${__FLEXI_PROMPT_PS4:=1}
: ${__FLEXI_PROMPT_UNPRINTABLE_PREFIX:="\x01"}
: ${__FLEXI_PROMPT_UNPRINTABLE_SUFFIX:="\x02"}
: ${__FLEXI_PROMPT_TITLE_PREFIX:="\033]0;"}
: ${__FLEXI_PROMPT_TITLE_SUFFIX:="\007"}

################################################################################
# Line break
################################################################################
# Break command line after prompt
#   0 - no line break, 1 - line break, 2 - line break skip home
__flexiPromptDefineOpt prompt_newline __FLEXI_PROMPT_NEWLINE 0
# Break command line before prompt
#   0 - no line break, 1 - line break
__flexiPromptDefineOpt prompt_newline_precmd __FLEXI_PROMPT_NEWLINE_PRECMD 0

################################################################################
# PWD
################################################################################
: ${__FLEXI_PROMPT_PWD_BEFORE:="$(__flexiPromptUnprintable $COLOR_BLUE_BOLD)"}
: ${__FLEXI_PROMPT_PWD_AFTER:="$(__flexiPromptUnprintable $COLOR_RESET)"}
# Setup pwd mode (0-"~/Desktop/Project", 1-"~/a/b/c/project", 2-".../x/y/z/project")
__flexiPromptDefineOpt prompt_pwd_mode __FLEXI_PROMPT_PWD_MODE 2

################################################################################
# Shell level
################################################################################
: ${__FLEXI_PROMPT_SHLVL_BEFORE:="$(__flexiPromptUnprintable $COLOR_YELLOW_BOLD)"}
: ${__FLEXI_PROMPT_SHLVL_AFTER:="$(__flexiPromptUnprintable $COLOR_RESET)\\"}
# Show subshell count from SHLVL (-1=all, 0=never, x>0=mesure those above x sublevels)
__flexiPromptDefineOpt prompt_shlvl __FLEXI_PROMPT_SHLVL 1

################################################################################
# GIT
################################################################################
: ${__FLEXI_PROMPT_GIT_BEFORE:="$(__flexiPromptUnprintable $COLOR_MAGENTA_BOLD)("}
: ${__FLEXI_PROMPT_GIT_AFTER:=")$(__flexiPromptUnprintable $COLOR_RESET)"}
: ${__FLEXI_PROMPT_GIT_STAGED_CHANGES:="+"}
: ${__FLEXI_PROMPT_GIT_UNSTAGED_CHANGES:="*"}
: ${__FLEXI_PROMPT_GIT_UNTRACKED_FILES:="%"}
# Show GIT status
__flexiPromptDefineOpt prompt_git __FLEXI_PROMPT_GIT $(hash git 2>/dev/null && echo 1)

################################################################################
# Timer
################################################################################
: ${__FLEXI_PROMPT_TIMER_BEFORE:="$(__flexiPromptUnprintable $COLOR_GRAY)["}
: ${__FLEXI_PROMPT_TIMER_AFTER:="]$(__flexiPromptUnprintable $COLOR_RESET)"}
# Long running cmd notification (-1=all, 0=never, x>0=mesure those above x ms)
__flexiPromptDefineOpt prompt_notify __FLEXI_PROMPT_NOTIFY 5000
# Time cmd execution (-1=all, 0=never, x>0=mesure those above x ms)
__flexiPromptDefineOpt prompt_timer __FLEXI_PROMPT_TIMER 5000

################################################################################
# Timestamp
################################################################################
: ${__FLEXI_PROMPT_TIMESTAMP_BEFORE:="$(__flexiPromptUnprintable $COLOR_GRAY)["}
: ${__FLEXI_PROMPT_TIMESTAMP_AFTER:="]$(__flexiPromptUnprintable $COLOR_RESET)"}
# Add timestamp to prompt (date format)
__flexiPromptDefineOpt prompt_timestamp __FLEXI_PROMPT_TIMESTAMP 0

################################################################################
# CMD sign
################################################################################
: ${__FLEXI_PROMPT_CMD_ERROR:="$(__flexiPromptUnprintable $COLOR_RED_BOLD)\$$(__flexiPromptUnprintable $COLOR_RESET) "}
: ${__FLEXI_PROMPT_CMD_SUCCESS:="$(__flexiPromptUnprintable $COLOR_MAGENTA)\$$(__flexiPromptUnprintable $COLOR_RESET) "}

################################################################################
# User and host
################################################################################
: ${__FLEXI_PROMPT_USERHOST_BEFORE:="$(__flexiPromptUnprintable $COLOR_GREEN_BOLD)"}
: ${__FLEXI_PROMPT_USERHOST_AFTER:=":$(__flexiPromptUnprintable $COLOR_RESET)"}
: ${__FLEXI_PROMPT_USERHOST_ROOT_BEFORE:="$(__flexiPromptUnprintable $COLOR_RED_BOLD)"}
: ${__FLEXI_PROMPT_USERHOST_ROOT_AFTER:=":$(__flexiPromptUnprintable $COLOR_RESET)"}
# Add it to ~/.bash_exports (sample: PROMPT_DEFAULT_USERHOST="mendlik@dell")
__flexiPromptDefineOpt prompt_default_userhost PROMPT_DEFAULT_USERHOST ""

################################################################################
# chroot
################################################################################
: ${__FLEXI_PROMPT_CHROOT_BEFORE:="$(__flexiPromptUnprintable $COLOR_GREEN_BOLD)("}
: ${__FLEXI_PROMPT_CHROOT_AFTER:=")$(__flexiPromptUnprintable $COLOR_RESET)"}
