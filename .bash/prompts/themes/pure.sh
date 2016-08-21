#!/bin/bash -x

# Line feed
__PROMPT_NEWLINE=1
__PROMPT_NEWLINE_PRECMD=1

# PWD
__PROMPT_PWD_MODE=0
__PROMPT_PWD_BEFORE="$(unprintable $COLOR_BLUE)"
__PROMPT_PWD_AFTER="$(unprintable $COLOR_RESET)"

# Shell level
__PROMPT_SHLVL_BEFORE="$(unprintable $COLOR_YELLOW)"
__PROMPT_SHLVL_AFTER="|$(unprintable $COLOR_RESET)"

# GIT
__PROMPT_GIT_BEFORE=" $(unprintable $COLOR_MAGENTA_BOLD)"
__PROMPT_GIT_AFTER="$(unprintable $COLOR_RESET)"

# Timer
__PROMPT_TIMER_BEFORE=" $(unprintable $COLOR_GRAY)"
__PROMPT_TIMER_AFTER="$(unprintable $COLOR_RESET)"

# Timestamp
__PROMPT_TIMESTAMP_BEFORE=" $(unprintable $COLOR_GRAY)["
__PROMPT_TIMESTAMP_AFTER="]$(unprintable $COLOR_RESET)"

# CMD sign
__PROMPT_CMD_ERROR="$(unprintable $COLOR_RED)\$$(unprintable $COLOR_RESET) "
__PROMPT_CMD_SUCCESS="$(unprintable $COLOR_MAGENTA)\$$(unprintable $COLOR_RESET) "

# User and host
__PROMPT_USERHOST_BEFORE="$(unprintable $COLOR_GREEN)"
__PROMPT_USERHOST_AFTER=":$(unprintable $COLOR_RESET)"
__PROMPT_USERHOST_ROOT_BEFORE="$(unprintable $COLOR_RED)"
__PROMPT_USERHOST_ROOT_AFTER=":$(unprintable $COLOR_RESET)"

# chroot
__PROMPT_CHROOT_BEFORE="$(unprintable $COLOR_GREEN)("
__PROMPT_CHROOT_AFTER=")$(unprintable $COLOR_RESET)"
