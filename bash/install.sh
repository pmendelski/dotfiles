#!/usr/bin/env bash
source "./bash/.bash/util/terminal.sh"

initFile() {
  local -r file="bash/_$1"
  local -r target="$HOME/.$1"
  local -r host="${HOST:-$HOSTNAME}"
  if [ ! -f "$target" ]; then
    cp "$file" "$target"
    sed -i \
      -e "s|@PROMPT_DEFAULT_USERHOST@|$USER@$host|" "$target" \
      -e "s|@HOME@|$HOME|" "$target"
    printSuccess "Created: ~/.$1"
  else
    printInfo "File already exists. Skipping: ~/.$1"
  fi
}

initFile "bash_exports"
initFile "path"
