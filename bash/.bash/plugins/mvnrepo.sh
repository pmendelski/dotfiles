#!/usr/bin/env bash -x

mvnrepo() {
  local -r query="${1:?Expected query}"
  local -r size="${2:-20}"
  curl -s "https://search.maven.org/solrsearch/select?q=$query&start=0&rows=$size" \
    | jq -r '.response.docs | map(.id + ":" + .latestVersion) | .[]' \
    | grep "$query"
}

mvnrepo-meta() {
  local -r query="${1:?Expected query}"
  local -r size="${2:-20}"
  local -r response="$(curl -s "https://search.maven.org/solrsearch/select?q=$query&start=0&rows=$size" | jq '.response')"
  local -r total="$(echo "$response" | jq '.numFound')"
  local -r entries="$(echo "$response" | jq -r '.docs | map(.id + ":" + .latestVersion) | .[]')"
  echo "$entries" | grep "$query"
  >&2 echo -e "\nTotal: $total"
  >&2 echo "URL: https://search.maven.org/search?q=$query"
}
