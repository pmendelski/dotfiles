#!/bin/bash

declare -r FORMAT_BOLD=`tput bold`
declare -r FORMAT_UNDERLINE=`tput smul`
declare -r FORMAT_DIM=`tput dim`
declare -r FORMAT_RESET=`tput sgr0`

declare -r COLOR_BLACK=`tput setaf 0`
declare -r COLOR_RED=`tput setaf 1`
declare -r COLOR_GREEN=`tput setaf 2`
declare -r COLOR_YELLOW=`tput setaf 3`
declare -r COLOR_BLUE=`tput setaf 4`
declare -r COLOR_MAGENTA=`tput setaf 5`
declare -r COLOR_CYAN=`tput setaf 6`
declare -r COLOR_WHITE=`tput setaf 7`

declare -r COLOR_BG_BLACK=`tput setab 0`
declare -r COLOR_BG_RED=`tput setab 1`
declare -r COLOR_BG_GREEN=`tput setab 2`
declare -r COLOR_BG_YELLOW=`tput setab 3`
declare -r COLOR_BG_BLUE=`tput setab 4`
declare -r COLOR_BG_MAGENTA=`tput setab 5`
declare -r COLOR_BG_CYAN=`tput setab 6`
declare -r COLOR_BG_WHITE=`tput setab 7`
