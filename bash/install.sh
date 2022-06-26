#!/usr/bin/env bash
source "./bash/.bash/util/terminal.sh"

initFile() {
  local -r file="bash/_$1"
  local -r target="$HOME/.$1"
  local -r host="${HOST:-$HOSTNAME}"
  if [ ! -f "$target" ]; then
    local -r content="S(cat "$file" | sed \
      -e "s|@PROMPT_DEFAULT_USERHOST@|$USER@$host|" \
      -e "s|@HOME@|$HOME|")"
    echo "$content" >> "$target"
    printSuccess "Created: ~/.$1"
  else
    printInfo "File already exists. Skipping: ~/.$1"
  fi
}

appendFile() {
  local -r file="bash/_$1"
  local -r target="$HOME/.$1"
  local -r host="${HOST:-$HOSTNAME}"
  local -r content="$(cat "$file" | sed \
      -e "s|@PROMPT_DEFAULT_USERHOST@|$USER@$host|" \
      -e "s|@HOME@|$HOME|")"
  echo "$content" >> "$target"
  if [ ! -f "$target" ]; then
    printSuccess "Created: ~/.$1"
  elif ! grep -q "$(echo "$content" | head -n 1)" "$target"; then
    printSuccess "Appended: ~/.$1"
  else
    printInfo "File already exists and contains the entries. Skipping: ~/.$1"
  fi
}

initFile "bash_exports"
initFile "path"
