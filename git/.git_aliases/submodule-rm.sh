#!/bin/bash

modulePath() {
  git config --file .gitmodules --get-regexp path | grep "submodule.$1.path" | cut -d ' ' -f2
};

submoduleRm() {
  local name="$1";
  [ -z "$name" ] && {
    echo "Please specify submodule name."
    exit 1;
  };
  local path="$(modulePath $1)";
  [ -z "$path" ] && {
    echo "Could not resolve path for module: $name."
    exit 1;
  };
  echo "Removing submodule"
  echo "  Name: $name"
  echo "  Path: $path"
  rm -rf "$path" &&
    git submodule deinit "$path" &&
    git rm -f "$path" &&
    rm -rf ".git/modules/$name" &&
    echo "Submodule removed"
};

submoduleRm "$@"
