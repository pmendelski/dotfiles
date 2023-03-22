#!/usr/bin/env bash

[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

# Set visual tab width to 4
tabs -4

# Import colors definition
source "$BASH_DIR/util/colors.sh"

function lscolors() {
  local color color_val format format_val filter
  filter=${1-"normal"}
  filter=$(echo "$filter" | tr '[:lower:]' '[:upper:]')
  for color in $(echo "${!COLOR_COLORS[@]}" | tr ' ' '\n' | sort); do
    color_val=${COLOR_COLORS[${color}]}
    for format in $(echo "${!COLOR_FORMATS[@]}" | tr ' ' '\n' | sort); do
      format_val=${COLOR_FORMATS[${format}]}
      [ "$filter" != "ALL" ] && [ "$filter" != "$format" ] && continue
      [ "$format" = "NORMAL" ] &&
        format="" ||
        format="_$format"
      value=""
      eval value="\${COLOR_${color}${format}}"
      printf "${value}%-20s   %s $COLOR_RESET\n" "COLOR_${color}${format}" "\\e[${format_val};${color_val}m"
    done
  done
}

function lscolors_codes() {
  for clfg in {30..37} {90..97} 39; do
    for attr in 0 1 2 4 5 7; do
      echo -en "\e[${attr};${clfg}m\\\e[${attr};${clfg}m\e[0m   "
    done
    echo
  done
}
