#!/usr/bin/env bash -x

mvnrepo() {
  local -r query="${1:?Expected query}"
  local -r i="${2}"
  local -r search="$(curl -s "https://search.maven.org/solrsearch/select?q=$query&start=0&rows=20" \
      | jq -r '.response.docs | map(.id + ":" + .latestVersion) | .[]' \
      | grep "$query")"
  if [ "$i" -gt "0" ]; then
    # Print versions of first artifact: mvnrepo logback-core 1
    local -r x="$(echo "$search" | head -n "$i" | tail -n 1 | tr ':' '\n')"
    local group="$(echo $x | head -n 1)"
    local artifact="$(echo $x | head -n 2 | tail -n 1)"
    curl -s "https://search.maven.org/solrsearch/select?q=g:$group%20AND%20a:$artifact&core=gav&rows=20" \
      | jq -r '.response.docs[].id' \
      | grep "$query"
  else
    # Print artifacts: mvnrepo logback-core
    echo "$search"
  fi
}
