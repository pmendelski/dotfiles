#!/bin/bash

declare -gr COLOR_ESC="\e"
declare -gr COLOR_RESET="\e[0m"
declare -rgA COLOR_COLORS=(
  ["WHITE"]="97"
  ["BLACK"]="30"
  ["RED"]="31"
  ["GREEN"]="32"
  ["YELLOW"]="33"
  ["BLUE"]="34"
  ["MAGENTA"]="35"
  ["CYAN"]="36"
  ["GRAY"]="37"
  # intensive colors
  ["GRAY_INT"]="90"
  ["RED_INT"]="91"
  ["GREEN_INT"]="92"
  ["YELLOW_INT"]="93"
  ["BLUE_INT"]="94"
  ["MAGENTA_INT"]="95"
  ["CYAN_INT"]="96"
)
declare -rgA COLOR_FORMATS=(
  ["NORMAL"]="0"
  ["BOLD"]="1"
  ["UNDERLINE"]="4"
  ["INVERSE"]="7"
  # Don't work on ubuntu
  # ["BLINK"]="5"
  # ["DIM"]="2"
)

function defineColors() {
  local color color_val format format_val
  for color in "${!COLOR_COLORS[@]}"; do
    color_val=${COLOR_COLORS[${color}]}
    for format in "${!COLOR_FORMATS[@]}"; do
      format_val=${COLOR_FORMATS[${format}]}
      [ "$format" = "NORMAL" ] && \
        format="" || \
        format="_$format"
      eval COLOR_${color}${format}="'\e[${format_val};${color_val}m'";
    done
  done
}

defineColors
unset -f defineColors
