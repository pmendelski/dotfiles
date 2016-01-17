#!/bin/bash

declare -gr PR_ESC="\e"
declare -gr PR_RESET="\e[0m"
declare -rgA PR_COLORS=(
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
declare -rgA PR_FORMAT=(
    ["NORMAL"]="0"
    ["BOLD"]="1"
    ["UNDERLINE"]="4"
    ["INVERSE"]="7"
    # Don't work on ubuntu
    # ["BLINK"]="5"
    # ["DIM"]="2"
)

function define_colors() {
    local color color_val format format_val
    for color in "${!PR_COLORS[@]}"; do
        color_val=${PR_COLORS[${color}]}
        for format in "${!PR_FORMAT[@]}"; do
            format_val=${PR_FORMAT[${format}]}
            [ "$format" = "NORMAL" ] && \
                format="" || \
                format="_$format"
            eval PR${format}_${color}="'\e[${format_val};${color_val}m'";
        done
    done
}

define_colors
unset -f define_colors
