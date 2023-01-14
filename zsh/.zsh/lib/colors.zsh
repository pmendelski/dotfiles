autoload -U colors && colors

[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
  if [ -r ~/.dircolors ]; then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

declare -rg COLOR_ESC="\e"
declare -rg COLOR_RESET="\e[0m"
typeset -AHg COLOR_COLORS COLOR_FORMATS

COLOR_COLORS=(
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

COLOR_FORMATS=(
  NORMAL    "0"
  BOLD      "1"
  UNDERLINE "4"
  INVERSE   "7"
)

function define_colors() {
  local color color_val format format_val
  for color in "${(@k)COLOR_COLORS}"; do
    color_val=${COLOR_COLORS[${color}]}
    for format in "${(@k)COLOR_FORMATS}"; do
      format_val=${COLOR_FORMATS[${format}]}
      [ "$format" = "NORMAL" ] && \
        format="" || \
        format="_$format"
      eval COLOR_${color}${format}="'\e[${format_val};${color_val}m'";
    done
  done
}

define_colors
unset -f define_colors

function lscolors() {
  local color color_val format format_val tabs filter;
  filter=${1-"normal"};
  filter=$(echo "$filter" | tr '[:lower:]' '[:upper:]')
  for color in $(echo ${(@k)COLOR_COLORS} | tr ' ' '\n' | sort); do
    color_val=${COLOR_COLORS[${color}]}
    for format in $(echo ${(@k)COLOR_FORMATS} | tr ' ' '\n' | sort); do
      format_val=${COLOR_FORMATS[${format}]}
      [ $filter != "ALL" ] && [ $filter != $format ] && continue
      [ "$format" = "NORMAL" ] && \
        format="" || \
        format="_$format"
      eval value="\${COLOR_${color}${format}}"
      printf "${value}%-20s   %s $COLOR_RESET\n" "COLOR_${color}${format}" "\\e[${format_val};${color_val}m"
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
