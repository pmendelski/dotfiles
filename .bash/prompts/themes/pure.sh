#!/bin/bash -x

# Line feed
__PROMPT_NEWLINE=1
__PROMPT_NEWLINE_PRECMD=1

# PWD
__PROMPT_PWD_MODE=0
__PROMPT_PWD_BEFORE="$(__promptUnprintable $COLOR_BLUE)"
__PROMPT_PWD_AFTER="$(__promptUnprintable $COLOR_RESET)"

# Shell level
__PROMPT_SHLVL_BEFORE="$(__promptUnprintable $COLOR_YELLOW)"
__PROMPT_SHLVL_AFTER="|$(__promptUnprintable $COLOR_RESET)"

# GIT
__PROMPT_GIT_BEFORE=" $(__promptUnprintable $COLOR_MAGENTA_BOLD)"
__PROMPT_GIT_AFTER="$(__promptUnprintable $COLOR_RESET)"

# Timer
__PROMPT_TIMER_BEFORE=" $(__promptUnprintable $COLOR_GRAY)"
__PROMPT_TIMER_AFTER="$(__promptUnprintable $COLOR_RESET)"

# Timestamp
__PROMPT_TIMESTAMP_BEFORE=" $(__promptUnprintable $COLOR_GRAY)["
__PROMPT_TIMESTAMP_AFTER="]$(__promptUnprintable $COLOR_RESET)"

# CMD sign
__PROMPT_CMD_ERROR="$(__promptUnprintable $COLOR_RED)\$$(__promptUnprintable $COLOR_RESET) "
__PROMPT_CMD_SUCCESS="$(__promptUnprintable $COLOR_MAGENTA)\$$(__promptUnprintable $COLOR_RESET) "

# User and host
__PROMPT_USERHOST_BEFORE="$(__promptUnprintable $COLOR_GREEN)"
__PROMPT_USERHOST_AFTER=":$(__promptUnprintable $COLOR_RESET)"
__PROMPT_USERHOST_ROOT_BEFORE="$(__promptUnprintable $COLOR_RED)"
__PROMPT_USERHOST_ROOT_AFTER=":$(__promptUnprintable $COLOR_RESET)"

# chroot
__PROMPT_CHROOT_BEFORE="$(__promptUnprintable $COLOR_GREEN)("
__PROMPT_CHROOT_AFTER=")$(__promptUnprintable $COLOR_RESET)"
