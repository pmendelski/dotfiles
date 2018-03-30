#!/bin/bash -x

################################################################################
# Basic prompts
################################################################################
: ${__FLEXI_PROMPT_BASIC:="${debian_chroot:+($debian_chroot)}$COLOR_GREEN_BOLD\u@\h$COLOR_RESET:$COLOR_BLUE_BOLD\w$COLOR_RESET\$ "}
: ${__FLEXI_PROMPT_BASIC_NO_COLORS:="${debian_chroot:+($debian_chroot)}\u@\h:\w\$ "}

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
# PWD
################################################################################
: ${__FLEXI_PROMPT_PWD_BEFORE:="$(__flexiPromptUnprintable $COLOR_BLUE_BOLD)"}
: ${__FLEXI_PROMPT_PWD_AFTER:="$(__flexiPromptUnprintable $COLOR_RESET)"}

################################################################################
# Shell level
################################################################################
: ${__FLEXI_PROMPT_SHLVL_BEFORE:="$(__flexiPromptUnprintable $COLOR_YELLOW_BOLD)"}
: ${__FLEXI_PROMPT_SHLVL_AFTER:="$(__flexiPromptUnprintable $COLOR_RESET)\\"}

################################################################################
# GIT
################################################################################
: ${__FLEXI_PROMPT_GIT:=1}
: ${__FLEXI_PROMPT_GIT_BEFORE:="$(__flexiPromptUnprintable $COLOR_MAGENTA_BOLD)("}
: ${__FLEXI_PROMPT_GIT_AFTER:=")$(__flexiPromptUnprintable $COLOR_RESET)"}
: ${__FLEXI_PROMPT_GIT_STAGED_CHANGES:="+"}
: ${__FLEXI_PROMPT_GIT_UNSTAGED_CHANGES:="*"}
: ${__FLEXI_PROMPT_GIT_UNTRACKED_FILES:="%"}

################################################################################
# Timer
################################################################################
: ${__FLEXI_PROMPT_TIMER_BEFORE:="$(__flexiPromptUnprintable $COLOR_GRAY)["}
: ${__FLEXI_PROMPT_TIMER_AFTER:="]$(__flexiPromptUnprintable $COLOR_RESET)"}

################################################################################
# Timestamp
################################################################################
: ${__FLEXI_PROMPT_TIMESTAMP_BEFORE:="$(__flexiPromptUnprintable $COLOR_GRAY)["}
: ${__FLEXI_PROMPT_TIMESTAMP_AFTER:="]$(__flexiPromptUnprintable $COLOR_RESET)"}

################################################################################
# CMD sign
################################################################################
: ${__FLEXI_PROMPT_SIGN:="λ"}
: ${__FLEXI_PROMPT_CMD_ERROR:="$(__flexiPromptUnprintable $COLOR_RED_BOLD)$__FLEXI_PROMPT_SIGN$(__flexiPromptUnprintable $COLOR_RESET) "}
: ${__FLEXI_PROMPT_CMD_SUCCESS:="$(__flexiPromptUnprintable $COLOR_MAGENTA)$__FLEXI_PROMPT_SIGN$(__flexiPromptUnprintable $COLOR_RESET) "}

################################################################################
# User and host
################################################################################
: ${__FLEXI_PROMPT_USERHOST_BEFORE:="$(__flexiPromptUnprintable $COLOR_GREEN_BOLD)"}
: ${__FLEXI_PROMPT_USERHOST_AFTER:=":$(__flexiPromptUnprintable $COLOR_RESET)"}
: ${__FLEXI_PROMPT_USERHOST_ROOT_BEFORE:="$(__flexiPromptUnprintable $COLOR_RED_BOLD)"}
: ${__FLEXI_PROMPT_USERHOST_ROOT_AFTER:=":$(__flexiPromptUnprintable $COLOR_RESET)"}

################################################################################
# chroot
################################################################################
: ${__FLEXI_PROMPT_CHROOT_BEFORE:="$(__flexiPromptUnprintable $COLOR_GREEN_BOLD)("}
: ${__FLEXI_PROMPT_CHROOT_AFTER:=")$(__flexiPromptUnprintable $COLOR_RESET)"}
