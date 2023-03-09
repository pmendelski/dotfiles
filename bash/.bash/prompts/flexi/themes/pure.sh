#!/usr/bin/env bash

# Line feed
__FLEXI_PROMPT_NEWLINE=2
__FLEXI_PROMPT_NEWLINE_PRECMD=1

# PWD
__FLEXI_PROMPT_PWD_MODE=0
__FLEXI_PROMPT_PWD_SKIP_HOME=1
__FLEXI_PROMPT_PWD_BEFORE="$(__flexiPromptUnprintable "$COLOR_BLUE_INT")"
__FLEXI_PROMPT_PWD_AFTER="$(__flexiPromptUnprintable "$COLOR_RESET")"

# Shell level
__FLEXI_PROMPT_SHLVL_BEFORE="$(__flexiPromptUnprintable "$COLOR_YELLOW")"
__FLEXI_PROMPT_SHLVL_AFTER="|$(__flexiPromptUnprintable "$COLOR_RESET")"

# GIT
__FLEXI_PROMPT_GIT_BEFORE=" $(__flexiPromptUnprintable "$COLOR_MAGENTA_BOLD")"
__FLEXI_PROMPT_GIT_AFTER="$(__flexiPromptUnprintable "$COLOR_RESET")"

# Timer
__FLEXI_PROMPT_TIMER_BEFORE=" $(__flexiPromptUnprintable "$COLOR_GRAY_INT")"
__FLEXI_PROMPT_TIMER_AFTER="$(__flexiPromptUnprintable "$COLOR_RESET") "

# Timestamp
__FLEXI_PROMPT_TIMESTAMP_BEFORE="$(__flexiPromptUnprintable "$COLOR_GRAY_INT")["
__FLEXI_PROMPT_TIMESTAMP_AFTER="]$(__flexiPromptUnprintable "$COLOR_RESET") "

# CMD sign
__FLEXI_PROMPT_SIGN="❯" # or "λ"
__FLEXI_PROMPT_CMD_ERROR="$(__flexiPromptUnprintable "$COLOR_RED")$__FLEXI_PROMPT_SIGN$(__flexiPromptUnprintable "$COLOR_RESET") "
__FLEXI_PROMPT_CMD_SUCCESS="$(__flexiPromptUnprintable "$COLOR_MAGENTA")$__FLEXI_PROMPT_SIGN$(__flexiPromptUnprintable "$COLOR_RESET") "

# SSH indicator
__FLEXI_PROMPT_SSH_INDICATOR="$(__flexiPromptUnprintable "$COLOR_YELLOW")SSH|$(__flexiPromptUnprintable "$COLOR_RESET")"

# User and host
__FLEXI_PROMPT_USERHOST_BEFORE="$(__flexiPromptUnprintable "$COLOR_GREEN")"
__FLEXI_PROMPT_USERHOST_AFTER=":$(__flexiPromptUnprintable "$COLOR_RESET")"
__FLEXI_PROMPT_USERHOST_ROOT_BEFORE="$(__flexiPromptUnprintable "$COLOR_RED")"
__FLEXI_PROMPT_USERHOST_ROOT_AFTER=":$(__flexiPromptUnprintable "$COLOR_RESET")"

# chroot
__FLEXI_PROMPT_CHROOT_BEFORE="$(__flexiPromptUnprintable "$COLOR_GREEN")("
__FLEXI_PROMPT_CHROOT_AFTER=")$(__flexiPromptUnprintable "$COLOR_RESET")"
