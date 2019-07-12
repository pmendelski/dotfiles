#!/bin/bash -e
source "./bash/.bash/util/terminal.sh"

initFile() {
  local -r file="bash/_$1"
  local -r target="$HOME/.$1"
  if [ ! -f "$file" ]; then
    cp "$file" "$target"
    sed \
      -e "s|@PROMPT_DEFAULT_USERHOST@|$USER@$HOST|" "$target" \
      -e "s|@HOME@|$HOME|" "$target"
    printSuccess "Created: ~/.$1"
  else
    printInfo "File already exists. Skipping: ~/.$1"
  fi
}

initFile "bash_exports"
initFile "path"
