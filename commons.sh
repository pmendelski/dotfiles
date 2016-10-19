#!/bin/bash

# Constant values
declare -r PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"
declare -r PROJECT_BASENAME="$(basename $PROJECT_ROOT)"
declare -r PARENT_PROJECT_DIR="$(dirname $PROJECT_ROOT)"
declare -r DISTROS_DIR="$PROJECT_ROOT/_distros"
declare -r BACKUP_DIR="$HOME/.dotfiles.bak"

# Source terminal utilities
source "./bash/.bash/util/terminal.sh"

# Default flags
declare -i nocolor=0
declare -i silent=0
declare -i verbose=0
declare -i yes=0
declare -i no=0
declare -i dryrun=0

# Some stats to gather
declare backups=""
declare skipped=""
declare templates=""

# Private functions

function __shorten() {
    echo $1 | sed -e "s|$PROJECT_ROOT|$PROJECT_BASENAME|" -e "s|$HOME|~|"
}

function __link() {
    local -r destDir="$(dirname "$2")"
    if [ $dryrun = 0 ]; then
        [ ! -d "$destDir" ] && \
        mkdir -p "$destDir"
        execute "ln -fs $1 $2" "symlink: $(__shorten $2) → $(__shorten $1)"
    else
        printSuccess "[dryrun] symlink: $(__shorten $2) → $(__shorten $1)"
    fi
}

function __backupAndRemove() {
    local -r file="$1"
    local -r destDir="$(dirname "$file" | sed -e "s|$HOME|$BACKUP_DIR|")"
    local -r backupLocation="$(echo "$file" | sed -e "s|$HOME|$BACKUP_DIR|")"
    if [ $dryrun = 0 ]; then
        if [ ! -d "$BACKUP_DIR" ]; then
            mkdir "$BACKUP_DIR"
            printWarn "Created backup directory: $BACKUP_DIR"
        fi
        [ ! -d "$destDir" ] && \
            mkdir -p "$destDir"
        cp -rfP "$file" "$destDir" && \
            printDebug "Created backup: $file" && \
            rm -rf "$file" && \
            printDebug "Removed: $(__shorten $file)"
        printSuccess "backup: $(__shorten $file) → $(__shorten $backupLocation)"
    else
        printSuccess "[dryrun] backup: $(__shorten $file) → $(__shorten $backupLocation)"
    fi
    backups+="$(__shorten $backupLocation)\n"
}

function __resolveTemplateVariables() {
    local -r templateFile="$1"
    sed -e "s|\$USER|$USER|" \
        -e "s|\$HOSTNAME|${HOSTNAME:=$HOST}|" \
        -e "s|\$HOME|$HOME|" \
        "$templateFile"
}

function __setupTemplate() {
    local -r templateFile="$1"
    local -r targetFile="$(echo "$2" | sed -e "s|\.tpl$||")"
    if [ ! -e "$targetFile" ]; then
        # Expand variables
        if [ $dryrun = 0 ]; then
            __resolveTemplateVariables $templateFile > "$targetFile"
            printSuccess "template: $(__shorten $templateFile) → $(__shorten $targetFile)"
        else
            printSuccess "[dryrun] template: $(__shorten $templateFile) → $(__shorten $targetFile)"
        fi
        templates+="$(__shorten $templateFile) → $(__shorten $targetFile)\n"
    else
        printInfo "Template config skipped. File already exists: $(__shorten $targetFile)"
        skipped+="template: $(__shorten ${templateFile})\n"
    fi
}

function __setupSymlink() {
    local -r linkFrom="$1"
    local -r linkTo="$2"
    if [ ! -e "$linkTo" ] && [ ! -L "$linkTo" ]; then
        __link $linkFrom $linkTo
    elif [ "$(readlink "$linkTo")" == "$linkFrom" ]; then
        printInfo "Symbolic link already created: $(__shorten $linkTo) → $(__shorten $linkFrom)"
    elif [ $no != 0 ]; then
        printInfo "File already exists. Skipping: $(__shorten $linkTo) → $(__shorten $linkFrom)"
    elif [ $yes != 0 ]; then
        __link $linkFrom $linkTo
    else
        if askForConfirmation "'$(__shorten $linkTo)' already exists, do you want to overwrite it?"; then
            __backupAndRemove $linkTo
            __link $linkFrom $linkTo
        else
            printWarn "Omitted: $(__shorten $linkFrom)"
            skipped+="link: $(__shorten $linkFrom)\n"
        fi
    fi
}

function __setupFile() {
    local -r file="$1"
    local -r sourceFile="$PWD/$1"
    local -r targetFile="$HOME/$1"
    [ "$(basename $file)" == "readme.md" ] && return
    [[ "$file" == *.tpl ]] && \
        __setupTemplate "$sourceFile" "$targetFile" || \
        __setupSymlink "$sourceFile" "$targetFile"
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
    for dir in $(find $PROJECT_ROOT -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name '_*'); do
        cd $dir
        setupFiles $(ls -A)
    done
}

function setupSubmodules() {
    printInfo "Installling submodules"
    git submodule update --init
}

function setupDistroCommon() {
    printInfo "Installling distro common configuration files"
    cd "$DISTROS_DIR/common"
    source 'setup.sh'
}

function setupDistro() {
    local distro="$(__distroName)"
    if [ ! -z "$distro" ]; then
        if [ -e "$DISTROS_DIR/$distro" ]; then
            setupDistroCommon
            printInfo "Installling distro $distro"
            cd "$DISTROS_DIR/$distro"
            source 'setup.sh'
        else
            printInfo "No distro specific configuration found. Distro name: $distro"
        fi
    fi
}

function install() {
    setupSubmodules
    setupBasic
    setupDistro
    [ -n "$templates" ] && \
        printWarn "Check template configurations. Templates:\n$templates"
}
