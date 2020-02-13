#!/usr/bin/env bash

function gradle-wrapper-update() {
  local -r version="$(curl -s "https://services.gradle.org/distributions/" | \
    grep -oE "/distributions/gradle-[0-9.]+-bin.zip" | \
    grep -oE "[0-9][0-9.]*" | \
    sort -V | \
    tail -n 1)"
  if [ "$1" = "--force" ]; then
    echo "Removing previous gradle wrapper files"
    rm -rf gradle/wrapper .gradle gradlew gradlew.bat
  fi
  echo "Updating gradle wrapper to version: $version"
  gradle wrapper --gradle-version "$version" --distribution-type all
}
