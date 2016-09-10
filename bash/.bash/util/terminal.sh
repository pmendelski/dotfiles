#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/colors.sh"

# Default flags
declare -i nocolor=0
declare -i silent=0
declare -i verbose=0
declare -i force=0

askForConfirmation() {
    [ $force != 0 ] && return 0;
    printQuestion "$1 [Y/n] "
    read -r response
    case $response in
        [yY][eE][sS]|[Y]) # deliberately no 'y'
            return 0;
            ;;
        [nN][oO]|[nN])
            return 1;
            ;;
        *)
            askForConfirmation "$1"
            return $?
            ;;
    esac
}

execute() {
    $1 &> /dev/null
    printResult $? "${2:-$1}"
}

printResult() {
    [ $1 -eq 0 ] \
        && printSuccess "$2" \
        || printError "$2"

    [ "$3" = "true" ] && [ $1 -ne 0 ] \
        && exit
}

print() {
    [ $silent = 0 ] && printf "$1"
}

println() {
    print "$1\n"
}

printColor() {
    if [ $nocolor = 0 ]; then
        print "$1$2${COLOR_RESET}"
    else
        print "$2"
    fi
}

printlnColor() {
    printColor "$1" "$2\n"
}

printQuestion() {
    printColor $COLOR_YELLOW "  [?] $1"
}

printSuccess() {
    printlnColor $COLOR_GREEN "  [ok] $1"
}

printError() {
    printlnColor $COLOR_RED "  [error] $1"
}

printWarn() {
    printlnColor $COLOR_MAGENTA "  [warn] $1"
}

printInfo() {
    printlnColor $COLOR_CYAN "  $1"
}

printDebug() {
    [ $verbose = 1 ] && println "  $1"
}
