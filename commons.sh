#!/bin/bash

# Constant values
declare -r PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"
declare -r DISTROS_DIR_NAME="distros"
declare -r BACKUP_DIR="$HOME/.dotfiles.bak"

# Source terminal utilities
source "./bash/.bash/util/terminal.sh"

# Default flags
declare -i nocolor=0
declare -i silent=0
declare -i verbose=0
declare -i yes=0
declare -i dryrun=0

# Private functions

function __pwd() {
    local -r dir="${PWD:${#PROJECT_ROOT}}"
    local -r dirWithoutLeadingSlash="${dir:1}"
    [ -n "$dirWithoutLeadingSlash" ] && echo "$dirWithoutLeadingSlash/"
}

function __link() {
    local -r destDir="$(dirname "$2")"
    if [ $dryrun = 0 ]; then
        [ ! -d "$destDir" ] && \
        mkdir -p "$destDir"
        execute "ln -fs $PWD/$1 $2" "symlink: $2 → $(__pwd)$1"
    else
        printSuccess "[dryrun] symlink: $2 → $(__pwd)$1"
    fi
}

function __backupAndRemove() {
    local -r file="$1"
    if [ $dryrun = 0 ]; then
        if [ ! -d "$BACKUP_DIR" ]; then
            mkdir "$BACKUP_DIR"
            printWarn "Created backup directory: $BACKUP_DIR"
        fi
        local destDir="$(dirname "$file" | sed -e "s|$HOME|$BACKUP_DIR|")"
        [ ! -d "$destDir" ] && \
            mkdir -p "$destDir"
        cp -rfP "$file" "$destDir" && \
            printDebug "Created backup: $file" && \
            rm -rf "$file" && \
            printDebug "Removed: $file"
    else
        printSuccess "[dryrun] backupAndRemove: $file → $destDir"
    fi
}

function __resolveTemplateVariables() {
    local -r templateFile="$1"
    sed -e "s|\$USER|$USER|" \
        -e "s|\$HOSTNAME|${HOSTNAME:=$HOST}|" \
        -e "s|\$HOME|$HOME|" \
        "$templateFile"
}

function __setupTemplate() {
    local -r targetFile="$(echo "$1" | sed -e "s|\.tpl$||")"
    local -r templateFile="$1"
    if [ ! -e "$targetFile" ]; then
        # Expand variables
        if [ $dryrun = 0 ]; then
            __resolveTemplateVariables $templateFile > "$targetFile"
            printSuccess "template: $(__pwd)${templateFile} → $targetFile"
        else
            printSuccess "[dryrun] template: $(__pwd)${templateFile} → $targetFile"
        fi
    else
        printInfo "Template config skipped. File already exists: $targetFile"
    fi
}

function __setupSymlink() {
    local -r linkFrom="$1"
    local -r linkTo="$HOME/$1"
    if [ ! -e "$linkTo" ]; then
        __link $linkFrom $linkTo
    elif [ "$(readlink "$linkTo")" == "$linkFrom" ]; then
        printInfo "Symbolic link already created: $linkFrom"
    elif [ $yes != 0 ]; then
        __link $linkFrom $linkTo
    else
        if askForConfirmation "'$linkTo' already exists, do you want to overwrite it?"; then
            __backupAndRemove $linkTo
            __link $linkFrom $linkTo
        else
            printWarn "Omitted: $linkFrom"
        fi
    fi
}

function __setupFile() {
    local -r file="$1"
    [[ "$file" == *.tpl ]] && \
        __setupTemplate "$file" || \
        __setupSymlink "$file"
}

function __distroName() {
    if [ -x "$(command -v lsb_release)" ]; then
        lsb_release -si | tr '[:upper:]' '[:lower:]'
    else
        (>&2 printWarn "Omitted distro specific configuration: Command 'lsb_release' not found.")
    fi
}

# Public functions

function setupFiles() {
    for file in $@; do
        __setupFile "$file"
    done
}

function setupBasic() {
    printInfo "Installling basic dotfiles"
    for dir in $(find $PROJECT_ROOT -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name $DISTROS_DIR_NAME); do
        cd $dir
        setupFiles $(ls -A)
    done
}

function setupDistroCommon() {
    printInfo "Installling distro common configuration files"
    cd "$PROJECT_ROOT/$DISTROS_DIR_NAME/common"
    source 'setup.sh'
}

function setupDistro() {
    local distro="$(__distroName)"
    if [ ! -z "$distro" ]; then
        if [ -e "$PROJECT_ROOT/$DISTROS_DIR_NAME/$distro" ]; then
            setupDistroCommon
            printInfo "Installling distro $distro"
            cd "$PROJECT_ROOT/$DISTROS_DIR_NAME/$distro"
            source 'setup.sh'
        else
            printInfo "No distro specific configuration found. Distro name: $distro"
        fi
    fi
}

function install() {
    setupBasic
    setupDistro
}
