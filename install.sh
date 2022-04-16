#!/usr/bin/env bash
set -euf -o pipefail

if [ "$(bash --version | grep -o -E '[0-9]+' | head -n 1)" -lt 4 ]; then
  echo "Script requires Bash at least v4. Got bash version: $(bash --version)"
  exit 1
fi

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

function shorten() {
  local -r projectBasename="$(basename $PROJECT_ROOT)"
  echo "$1" | sed -e "s|$PROJECT_ROOT|$projectBasename|" -e "s|$HOME|~|"
}

function link() {
  local -r destDir="$(dirname "$2")"
  if [ $dryrun = 0 ]; then
    [ ! -d "$destDir" ] && \
    mkdir -p "$destDir"
    ln -fs "$1" "$2" && printSuccess "Symlink: $(shorten "$2") → $(shorten "$1")"
  else
    printSuccess "[dryrun] Symlink: $(shorten "$2") → $(shorten "$1")"
  fi
}

function backupAndRemove() {
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
      printDebug "Removed: $(shorten "$file")"
    printSuccess "Backed up: $(shorten "$file") → $(shorten "$backupLocation")"
  else
    printSuccess "[dryrun] Backed up: $(shorten "$file") → $(shorten "$backupLocation")"
  fi
  backups+="$(shorten "$backupLocation")\n"
}

function setupSymlink() {
  local -r linkFrom="$1"
  local -r linkTo="$(echo "$2" | sed 's|_\+$||')"
  if [ ! -e "$linkTo" ] && [ ! -L "$linkTo" ]; then
    link "$linkFrom" "$linkTo"
  elif [ "$(readlink "$linkTo")" == "$linkFrom" ]; then
    printInfo "Symbolic link already exists. Skipping: $(shorten $linkTo) → $(shorten "$linkFrom")"
  elif [ $no != 0 ]; then
    printInfo "File already exists. Skipping: $(shorten "$linkTo") → $(shorten "$linkFrom")"
  elif [ $yes != 0 ]; then
    link "$linkFrom" "$linkTo"
  else
    if askForConfirmation "'$(shorten "$linkTo")' already exists, do you want to overwrite it?"; then
      backupAndRemove "$linkTo"
      link $linkFrom "$linkTo"
    else
      printWarn "Omitted: $(shorten "$linkFrom")"
      skipped+="link: $(shorten "$linkFrom")\n"
    fi
  fi
}

function runInstallScript() {
  local -r script="$1"
  if [ $dryrun = 0 ]; then
    $script \
      || printError "Install script failure: $(shorten "$script")"
  else
    printSuccess "[dryrun] Install script: $(shorten "$script")"
  fi
}

function installModules() {
  printInfo "Installing modules"
  local -r dotfileDirs="$(find $PROJECT_ROOT -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name '_*' | sort)"
  for dir in $dotfileDirs; do
    if [ -f "$dir/install.sh" ]; then
      runInstallScript "$dir/install.sh"
    fi
    for file in $(find $dir -maxdepth 1 -mindepth 1 -name '.*'); do
      setupSymlink "$file" "$HOME/$(basename $file)"
    done
  done
}

function setupDotfiles() {
  printInfo "Installing dotfiles symlinks"
  local -r dotfileDirs="$(find $PROJECT_ROOT -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name '_*' | sort)"
  for dir in $dotfileDirs; do
    for file in $(find $dir -maxdepth 1 -mindepth 1 -name '.*'); do
      setupSymlink "$file" "$HOME/$(basename $file)"
    done
  done
}

function install() {
  setupDotfiles
  installModules
}

function update() {
  local banchName="$(git rev-parse --abbrev-ref HEAD)"
  git pull --rebase origin $banchName
  printInfo "Updating dotfiles"
  local -r dotfileDirs="$(find $PROJECT_ROOT -mindepth 1 -maxdepth 1 -type d ! -name '.*' ! -name '_*' | sort)"
  for dir in $dotfileDirs; do
    if [ -f "$dir/update.sh" ]; then
      runInstallScript "$dir/update.sh"
    fi
  done
}

function printHelp() {
  echo "pmendelski dotfiles."
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

while (($#)); do
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
