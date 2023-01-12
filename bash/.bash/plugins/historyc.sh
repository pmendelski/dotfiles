#!/usr/bin/env bash

# Wrapper function for history command.
historyc() {
  local -r ESC="$(printf '\033')"
  local -r HIST_COLOR_GREEN="${ESC}[0;32m"
  local -r HIST_COLOR_BLUE="${ESC}[0;34m"
  local -r HIST_COLOR_RESET="${ESC}[0m"
  local -r NUMBER_STYLE="${HIST_COLOR_GREEN}"
  local -r TIME_STYLE="${HIST_COLOR_BLUE}"
  \history "$@" | sed \
    -e "s/\(^ *[^ ]\+\)  \([^ ]\+ [^ ]\+\)  \([^ ]\+\)/${NUMBER_STYLE}\1  ${TIME_STYLE}\2  ${HIST_COLOR_RESET}\3/g"
  return ${PIPESTATUS[0]}
}
alias history="historyc"
