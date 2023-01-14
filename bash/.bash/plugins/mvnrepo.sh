#!/usr/bin/env bash

mvnrepo() {
  local -r query="${1:?Expected query}"
  local -r n="${2-0}"
  local -r search="$(curl -s "https://search.maven.org/solrsearch/select?q=$query" |
    jq -r '.response.docs | map(.id + ":" + .latestVersion) | .[]' |
    grep "$query")"
  if [ "$n" -gt "0" ]; then
    # Print versions of first artifact: mvnrepo logback-core 1
    local -r x="$(echo "$search" | head -n 1 | tr ':' '\n')"
    local group="$(echo "$x" | head -n 1)"
    local artifact="$(echo "$x" | head -n 2 | tail -n 1)"
    curl -s "https://search.maven.org/solrsearch/select?q=g:$group%20AND%20a:$artifact&core=gav&rows=$n" |
      jq -r '.response.docs[].id' |
      grep "$query"
  else
    # Print artifacts: mvnrepo logback-core
    echo "$search"
  fi
}
