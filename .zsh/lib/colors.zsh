#!/bin/bash

autoload -U colors && colors
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

declare -rg PR_ESC="\e"
declare -rg PR_RESET="\e[0m"
typeset -AHg PR_COLORS PR_FORMAT

PR_COLORS=(
    WHITE       "97"
    BLACK       "30"
    RED         "31"
    GREEN       "32"
    YELLOW      "33"
    BLUE        "34"
    MAGENTA     "35"
    CYAN        "36"
    GRAY        "37"
    GRAY_INT    "90"
    RED_INT     "91"
    GREEN_INT   "92"
    YELLOW_INT  "93"
    BLUE_INT    "94"
    MAGENTA_INT "95"
    CYAN_INT    "96"
)

PR_FORMAT=(
    NORMAL      "0"
    BOLD        "1"
    UNDERLINE   "4"
    INVERSE     "7"
)

function define_colors() {
    local color color_val format format_val
    for color in "${(@k)PR_COLORS}"; do
        color_val=${PR_COLORS[${color}]}
        for format in "${(@k)PR_FORMAT}"; do
            format_val=${PR_FORMAT[${format}]}
            [ "$format" = "NORMAL" ] && \
                format="" || \
                format="_$format"
            eval PR_${color}${format}="'\e[${format_val};${color_val}m'";
        done
    done
}

define_colors
unset -f define_colors

function lscolors() {
    local color color_val format format_val tabs filter;
    filter=${1-"normal"};
    filter=$(echo "$filter" | tr '[:lower:]' '[:upper:]')
    for color in $(echo ${(@k)PR_COLORS} | tr ' ' '\n' | sort); do
        color_val=${PR_COLORS[${color}]}
        for format in $(echo ${(@k)PR_FORMAT} | tr ' ' '\n' | sort); do
            format_val=${PR_FORMAT[${format}]}
            [ $filter != "ALL" ] && [ $filter != $format ] && continue
            [ "$format" = "NORMAL" ] && \
                format="" || \
                format="_$format"
            eval value="\${PR_${color}${format}}"
            printf "${value}%-20s   %s $PR_RESET\n" "PR_${color}${format}" "\\e[${format_val};${color_val}m"
        done
    done
}

function lscolorcodes() {
    for clfg in {30..37} {90..97} 39 ; do
        #Formatting
        for attr in 0 1 2 4 5 7 ; do
            #Print the result
            echo -en "\e[${attr};${clfg}m\\\e[${attr};${clfg}m\e[0m   "
        done
        echo #Newline
    done
}
