#!/bin/bash

# This script symlinks all the dotfiles to home directory.
# It is safe to run multiple times and will prompt you about anything unclear.
# Go to the end of file for some interesting code

# Make sure we're in the projects root directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"
cd "$DIR"

# Terminal utilities
source ".bash/util/terminal.sh"
# Default flags
declare -i nocolor=0
declare -i silent=0
declare -i verbose=0
declare -i force=0
declare -i dryrun=0

####################################################
# Main logic
####################################################

function main() {
    local -r backupDir="$HOME/.dotfiles.bak"

    function listSymlinks() {
        local -a files=(
            $(find . -maxdepth 1 -type f -name ".*")
            ".vim"
            # personal branch
            $(find .atom -type f)
            $(find .config -type f)
            ".local/share/file-manager/actions"
            ".conky"
            "Scripts"
        )
        files=($(\
            printf "%s\n" "${files[@]}" | sed -e "s|^\./||" | \
            grep -v \.tpl$ | \
            grep -v \.gitignore | \
            grep -v \.editorconfig | \
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
        local destDir="$(dirname "$2")"
        if [ dryrun = 0 ]; then
            [ ! -d "$destDir" ] && \
            mkdir -p "$destDir"
            execute "ln -fs $1 $2" "$1 → $2"
        else
            printSuccess "link: $1 → $2"
        fi
    }

    function backupAndRemove() {
        if [ dryrun = 0 ]; then
            [ ! -d "$backupDir" ] && \
                mkdir "$backupDir"
            local destDir="$(dirname "$targetFile" | sed -e "s|$HOME|$backupDir|")"
            [ ! -d "$destDir" ] && \
                mkdir -p "$destDir"
            cp -rfP "$targetFile" "$destDir" && \
                printDebug "Created backup: $targetFile" && \
                rm -rf "$targetFile" && \
                printDebug "Removed: $targetFile"
        else
            printSuccess "backupAndRemove: $targetFile → $destDir"
        fi
    }

    printInfo "Updating gitsubmodules"
    [ dryrun = 0 ] && \
        git submodule update --init --recursive && \
        printSuccess "Updated git submodules"

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
            if [ dryrun = 0 ]; then
                sed -e "s/\$USER/$USER/" \
                    -e "s/\$HOSTNAME/$HOSTNAME/" "$fullSourceFile" \
                    > "$targetFile"
            fi
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

function update() {
    local banchName="$(git rev-parse --abbrev-ref HEAD)"
    git pull --rebase origin $banchName
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
        --dryrun|-d)
            dryrun=1
            ;;
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
            update
            ;;
        --update-master)
            git checkout personal && \
                git pull --rebase origin personal && \
                git checkout master && \
                git merge personal && \
                git push origin master
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
