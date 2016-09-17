#!/bin/bash

# This script symlinks all the dotfiles to home directory.
# It is safe to run multiple times and will prompt you about anything unclear.
# Go to the end of file for some interesting code.

# Make sure we're in the projects root directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"
cd "$DIR"
source "commons.sh"

function update() {
    local banchName="$(git rev-parse --abbrev-ref HEAD)"
    git pull --rebase origin $banchName
    git submodule update ---init
}

function printHelp() {
    echo "NAME"
    echo "  dotfiles - Ubuntu dotfiles."
    echo "  Source: https://github.com/mendlik/dotfiles"
    echo ""
    echo "SYNOPSIS"
    echo "  ./install.sh [OPTION]..."
    echo ""
    echo "OPTIONS"
    echo "  -h, --help     Print help."
    echo "  -y, --yes      Assume 'yes' answer to all confirmations."
    echo "  -u, --update   Update dotfiles from the repository."
    echo "  -v, --verbose  Print additional logs."
    echo "  -s, --silent   Disable logs. Except confirmations."
    echo "  -n, --nocolor  Disable colors."
    echo "  -d, --dryrun   Run installation without making any changes."
    echo ""
}

while (("$#")); do
    case $1 in
        --yes|-y)
            yes=1
            ;;
        --silent|-s)
            silent=1
            ;;
        --dryrun|-d)
            dryrun=1
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
            update
            exit 0;
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
install
