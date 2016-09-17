#!/bin/bash -x

# Just unset all prompt setting variables.
# They will restored using default ones.

unset __FLEXI_PROMPT_XXX
################################################################################
# Globals
################################################################################
unset __FLEXI_PROMPT_PS2
unset __FLEXI_PROMPT_PS4
unset __FLEXI_PROMPT_UNPRINTABLE_PREFIX
unset __FLEXI_PROMPT_UNPRINTABLE_SUFFIX
unset __FLEXI_PROMPT_TITLE_PREFIX
unset __FLEXI_PROMPT_TITLE_SUFFIX

################################################################################
# Line break
################################################################################
__FLEXI_PROMPT_NEWLINE=0
__FLEXI_PROMPT_NEWLINE_PRECMD=0

################################################################################
# PWD
################################################################################
unset __FLEXI_PROMPT_PWD_MODE
unset __FLEXI_PROMPT_PWD_BEFORE
unset __FLEXI_PROMPT_PWD_AFTER
unset __FLEXI_PROMPT_PWD_SKIP_HOME

################################################################################
# Shell level
################################################################################
unset __FLEXI_PROMPT_SHLVL_BEFORE
unset __FLEXI_PROMPT_SHLVL_AFTER

################################################################################
# GIT
################################################################################
unset __FLEXI_PROMPT_GIT_BEFORE
unset __FLEXI_PROMPT_GIT_AFTER
unset __FLEXI_PROMPT_GIT_STAGED_CHANGES
unset __FLEXI_PROMPT_GIT_UNSTAGED_CHANGES
unset __FLEXI_PROMPT_GIT_UNTRACKED_FILES

################################################################################
# Timer
################################################################################
unset __FLEXI_PROMPT_TIMER_BEFORE
unset __FLEXI_PROMPT_TIMER_AFTER

################################################################################
# Timestamp
################################################################################
unset __FLEXI_PROMPT_TIMESTAMP_BEFORE
unset __FLEXI_PROMPT_TIMESTAMP_AFTER
unset __FLEXI_PROMPT_TIMESTAMP

################################################################################
# CMD sign
################################################################################
unset __FLEXI_PROMPT_CMD_ERROR
unset __FLEXI_PROMPT_CMD_SUCCESS

################################################################################
# User and host
################################################################################
unset __FLEXI_PROMPT_USERHOST_BEFORE
unset __FLEXI_PROMPT_USERHOST_AFTER
unset __FLEXI_PROMPT_USERHOST_ROOT_BEFORE
unset __FLEXI_PROMPT_USERHOST_ROOT_AFTER

################################################################################
# chroot
################################################################################
unset __FLEXI_PROMPT_CHROOT_BEFORE
unset __FLEXI_PROMPT_CHROOT_AFTER
