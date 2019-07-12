#!/usr/bin/env bash

systype() {
  case "$OSTYPE" in
    linux*)   echo "linux" ;;
    bsd*)     echo "linux" ;;
    darwin*)  echo "macos" ;;
    solaris*) echo "solaris" ;;
    cygwin*)  echo "windows" ;;
    msys*)    echo "windows" ;;
    *)        echo "unknown" ;;
  esac
}
