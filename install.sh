#!/bin/bash -e

# This script symlinks all the dotfiles to home directory.
# It is safe to run it multiple times.
# It will prompt when overriding files.

# Constant values
declare -r PROJECT_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"
declare -r BACKUP_DIR="$HOME/.dotfiles.bak"

# Make sure we're in the project root directory
cd "$PROJECT_ROOT"

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

# Private functions __*
function __shorten() {
  local -r projectBasename="$(basename $PROJECT_ROOT)"
  echo $1 | sed -e "s|$PROJECT_ROOT|$projectBasename|" -e "s|$HOME|~|"
}

function __link() {
  local -r destDir="$(dirname "$2")"
  if [ $dryrun = 0 ]; then
    [ ! -d "$destDir" ] && \
    mkdir -p "$destDir"
    ln -fs "$1" "$2" && printSuccess "Symlink: $(__shorten "$2") → $(__shorten "$1")"
  else
    printSuccess "[dryrun] Symlink: $(__shorten "$2") → $(__shorten "$1")"
  fi
}

function __backupAndRemove() {
  local -r file="$1"
  local -r destDir="$(dirname "$file" | sed -e "s|$HOME|$BACKUP_DIR|")"
  local -r backupLocation="$(echo "$file" | sed -e "s|$HOME|$BACKUP_DIR|")"
  if [ $dryrun = 0 ]; then
    if [ ! -d "$BACKUP_DIR" ]; then
      mkdir -p "$BACKUP_DIR"
      printWarn "Created a backup directory: $BACKUP_DIR"
    fi
    [ ! -d "$destDir" ] && \
      mkdir -p "$destDir"
    cp -rfP "$file" "$destDir" && \
      printDebug "Created a backup: $file" && \
      rm -rf "$file" && \
      printDebug "Removed: $(__shorten "$file")"
    printSuccess "Backed up: $(__shorten "$file") → $(__shorten "$backupLocation")"
  else
    printSuccess "[dryrun] Backed up: $(__shorten "$file") → $(__shorten "$backupLocation")"
  fi
  backups+="$(__shorten "$backupLocation")\n"
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
      printSuccess "Template: $(__shorten "$templateFile") → $(__shorten "$targetFile")"
    else
      printSuccess "[dryrun] Template: $(__shorten "$templateFile") → $(__shorten "$targetFile")"
      printDebug "Template content: $(__shorten "$targetFile")\n$(__resolveTemplateVariables "$templateFile")"
    fi
    templates+="$(__shorten "$templateFile") → $(__shorten "$targetFile")\n"
  else
    printInfo "Template config skipped. File already exists: $(__shorten "$targetFile")"
    skipped+="template: $(__shorten "$templateFile")\n"
  fi
}

function __setupSymlink() {
  local -r linkFrom="$1"
  local -r linkTo="$2"
  if [ ! -e "$linkTo" ] && [ ! -L "$linkTo" ]; then
    __link "$linkFrom" "$linkTo"
  elif [ "$(readlink "$linkTo")" == "$linkFrom" ]; then
    printInfo "Symbolic link already exists. Skipping: $(__shorten $linkTo) → $(__shorten "$linkFrom")"
  elif [ $no != 0 ]; then
    printInfo "File already exists. Skipping: $(__shorten "$linkTo") → $(__shorten "$linkFrom")"
  elif [ $yes != 0 ]; then
    __link "$linkFrom" "$linkTo"
  else
    if askForConfirmation "'$(__shorten "$linkTo")' already exists, do you want to overwrite it?"; then
      __backupAndRemove "$linkTo"
      __link $linkFrom "$linkTo"
    else
      printWarn "Omitted: $(__shorten "$linkFrom")"
      skipped+="link: $(__shorten "$linkFrom")\n"
    fi
  fi
}

function __setupFile() {
  local -r sourceFile="$1"
  local -r basename="$(basename $1)"
  local -r targetFile="$HOME/$basename"
  [ "$basename" == "readme.md" ] && return
  [[ "$basename" == *.tpl ]] && \
    __setupTemplate "$sourceFile" "$targetFile" || \
    __setupSymlink "$sourceFile" "$targetFile"
}

function setupFiles() {
  for file in $@; do
    __setupFile "$file"
  done
}

function setupDotfiles() {
  printInfo "Installing dotfiles"
  local -r dotfileDirs="$(find $PROJECT_ROOT -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name '_*' | sort)"
  for dir in $dotfileDirs; do
    setupFiles $(find $dir -maxdepth 1 -mindepth 1)
  done
}

function setupGitSubmodules() {
  printInfo "Installing submodules"
  git submodule update --init
}

function install() {
  setupGitSubmodules
  setupDotfiles
  [ -n "$templates" ] && \
    printWarn "Check template configurations:\n$templates"
}

function updateDotfiles() {
  local banchName="$(git rev-parse --abbrev-ref HEAD)"
  git pull --rebase origin $banchName
  git submodule update --init
}

function printHelp() {
  echo "Ubuntu dotfiles."
  echo "Source: https://github.com/pmendelski/dotfiles"
  echo ""
  echo "NAME"
  echo "  install.sh - installs all dotfiles"
  echo ""
  echo "SYNOPSIS"
  echo "  ./install.sh [OPTION]..."
  echo ""
  echo "OPTIONS"
  echo "  -h, --help     Print help."
  echo "  -y, --yes      Assume 'yes'. Override all files with new ones."
  echo "  -n, --no       Assume 'no'. Do not override any file with new one."
  echo "  -u, --update   Update dotfiles from the repository."
  echo "  -v, --verbose  Print additional logs."
  echo "  -s, --silent   Disable logs. Except confirmations."
  echo "  -d, --dryrun   Run installation without making any changes."
  echo "  -c, --nocolor  Disable colors."
  echo ""
}

while (("$#")); do
  case $1 in
    --yes|-y)
      yes=1
      ;;
    --no|-n)
      no=1
      ;;
    --silent|-s)
      silent=1
      ;;
    --dryrun|-d)
      dryrun=1
      ;;
    --nocolor|-c)
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
      updateDotfiles
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
