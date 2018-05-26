#!/bin/bash

aliases() {
  git config --list |
  grep 'alias\.' |
  sed 's|alias\.\([^=]*\)=\(.*\)|\1 => \2|' |
  sed 's|[[:space:]]\+\ *| |g' |
  awk 'BEGIN { FS = "=>" } { printf("%-20s=>%s\n", $1, $2)}';
}

aliases
