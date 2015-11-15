#!/bin/bash

# This script symlinks all the dotfiles to home directory.
# It is safe to run multiple times and will prompt you about anything unclear.

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR"

# Go to the end of file for some interesting code

# Default flags
declare -i nocolor=0
declare -i silent=0
declare -i verbose=0
declare -i force=0

####################################################
# Terminal utlities
####################################################

# Colors: http://misc.flogisoft.com/bash/tip_colors_and_formatting
declare -r COLOR_RESET="0"
declare -r COLOR_RED="0;31"
declare -r COLOR_GREEN="0;32"
declare -r COLOR_YELLOW="0;33"
declare -r COLOR_BLUE="0;34"
declare -r COLOR_MAGENTA="0;35"
declare -r COLOR_CYAN="0;36"

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

    [ "$3" == "true" ] && [ $1 -ne 0 ] \
        && exit
}

print() {
    [ $silent == 0 ] && printf "$1"
}

println() {
    print "$1\n"
}

printColor() {
    if [ $nocolor = 0 ]; then
        print "\e[$1m$2\e[0m"
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

####################################################
# Main logic
####################################################

function main() {
    local -r backupDir="$HOME/.dotfiles.bak"

    function listSymlinks() {
        local -a files=(
            $(find . -maxdepth 1 -type f -name ".*")
            ".vim"
        )
        files=($(\
            printf "%s\n" "${files[@]}" | sed -e "s|^\./||" | \
            grep -v \.tpl$ | \
            grep -v \.gitignore | \
            sort \
        ))
        echo "${files[@]}"
    }

    function listTemplates() {
        local -a files=(
            $(find . -maxdepth 1 -type f -name ".*\.tpl")
        )
        files=($(\
            printf "%s\n" "${files[@]}" | sed -e "s|^\./||" | \
            sort \
        ))
        echo "${files[@]}"
    }

    function link() {
        execute "ln -fs $1 $2" "$1 → $2"
    }

    function backupAndRemove() {
        [ ! -d "$backupDir" ] && \
            mkdir "$backupDir" && \
            cp -rfP $targetFile "$backupDir/" && \
            printDebug "Created backup: $targetFile" && \
            rm -rf "$targetFile" && \
            printDebug "Removed: $targetFile"
    }

    local -a sourceFiles="$(listSymlinks)"
    local sourceFile=''
    local targetFile=''

    for sourceFile in ${sourceFiles[@]}; do
        targetFile="$HOME/$sourceFile"
        fullSourceFile="$DIR/$sourceFile"
        if [ ! -e "$targetFile" ]; then
            link $fullSourceFile $targetFile
        elif [ "$(readlink "$targetFile")" == "$fullSourceFile" ]; then
            printInfo "Symbolic link already created: $sourceFile"
        elif [ $force != 0 ]; then
            link $fullSourceFile $targetFile
        else
            if askForConfirmation "'$targetFile' already exists, do you want to overwrite it?"; then
                backupAndRemove $targetFile
                link $fullSourceFile $targetFile
            else
                printWarn "Omitted: $sourceFile"
            fi
        fi
    done

    sourceFiles="$(listTemplates)"
    for sourceFile in ${sourceFiles[@]}; do
        targetFile="$(echo "$HOME/$sourceFile" | sed -e "s|\.tpl$||")"
        fullSourceFile="$DIR/$sourceFile"
        if [ ! -e "$targetFile" ]; then
            # Expand variables
            sed -e "s/\$USER/$USER/" \
                -e "s/\$HOSTNAME/$HOSTNAME/" "$fullSourceFile" \
                > "$targetFile"
            printSuccess "Change options in template config file: $targetFile"
        else
            printInfo "Template config already created: $(basename "$targetFile")"
        fi
    done

    if [ -d "$backupDir" ]; then
        printWarn "Created backup folder: $backupDir"
    fi

    return 0
}

function printHelp() {
    echo "NAME"
    echo "  dotfiles - Ubuntu dotfiles. Source: https://github.com/mendlik/dotfiles"
    echo ""
    echo "SYNOPSIS"
    echo "  ./install.sh [OPTION]..."
    echo ""
    echo "OPTIONS"
    echo "  -u, --update   Update dotfiles from its source"
    echo "  -v, --verbose  Print additional logs"
    echo "  -s, --silent   Disable logs. Except confirmations."
    echo "  -n, --nocolor  Disable colors"
    echo "  -h, --help     Print help"
    echo ""
}

while (("$#")); do
    case $1 in
        --force|-f)
            force=1
            ;;
        --silent|-s)
            silent=1
            ;;
        --nocolor|-n)
            nocolor=1
            ;;
        --verbose|-v)
            verbose=$((verbose + 1)) # Each -v argument adds 1 to verbosity.
            ;;
        --help|-h)
            printHelp
            exit 0;
            ;;
        --update|-u)
            git pull --rebase origin master
            ;;
        --) # End of all options.
            shift
            break
            ;;
        -?*) # Unidentified option.
            println "Unknown option: $1"
            println "Try --help option"
            exit 1;
            ;;
    esac
    shift
done
main
