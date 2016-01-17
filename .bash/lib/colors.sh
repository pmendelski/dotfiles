#!/bin/bash

[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Import colors definition
source "$BASH_DIR/util/colors.sh"

function ls_colors() {
    local color color_val format format_val filter;
    filter=${1-"normal"};
    filter=$(echo "$filter" | tr '[:lower:]' '[:upper:]')
    for color in $(echo ${!PR_COLORS[@]} | tr ' ' '\n' | sort); do
        color_val=${PR_COLORS[${color}]}
        for format in $(echo ${!PR_FORMAT[@]} | tr ' ' '\n' | sort); do
            format_val=${PR_FORMAT[${format}]}
            [ $filter != "ALL" ] && [ $filter != $format ] && continue
            [ "$format" = "NORMAL" ] && \
                format="" || \
                format="_$format"
            eval value="\${PR${format}_${color}}"
            printf "${value}%-20s   %s $PR_RESET\n" "PR${format}_${color}" "\\e[${format_val};${color_val}m"
        done
    done
}

function ls_color_codes() {
    for clfg in {30..37} {90..97} 39 ; do
        #Formatting
        for attr in 0 1 2 4 5 7 ; do
            #Print the result
            echo -en "\e[${attr};${clfg}m\\\e[${attr};${clfg}m\e[0m   "
        done
        echo #Newline
    done
}
