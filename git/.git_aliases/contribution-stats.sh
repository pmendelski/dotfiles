#!/usr/bin/env bash
set -euf -o pipefail

replaceDiacritics() {
  sed \
    -e 's|ą|a|g' \
    -e 's|Ą|A|g' \
    -e 's|ć|c|g' \
    -e 's|Ć|C|g' \
    -e 's|ę|e|g' \
    -e 's|Ę|E|g' \
    -e 's|ł|l|g' \
    -e 's|Ł|L|g' \
    -e 's|ń|n|g' \
    -e 's|Ń|N|g' \
    -e 's|ó|o|g' \
    -e 's|Ó|O|g' \
    -e 's|ś|s|g' \
    -e 's|Ś|S|g' \
    -e 's|ź|z|g' \
    -e 's|Ź|Z|g' \
    -e 's|ż|z|g' \
    -e 's|Ż|Z|g'
}

max() {
  [ "$1" -gt "$2" ] &&
    echo "$1" ||
    echo "$2"
}

sumAuthorCommits() {
  local name="$1"
  local total="$(max "$2" 1)"
  local commits="$(git rev-list --count --author="${name:-^ <}" --no-merges HEAD)"
  echo "$commits $((100 * "$commits" / "$total"))"
}

sumAuthorChanges() {
  local name="$1"
  local total="$2"
  git log --author="${name:-^ <}" --pretty=tformat: --numstat |
    awk -v total="$(max "$total" 1)" \
      'function min(a,b) { return a < b ? a : b } \
    { locmin=min($1,$2); modified+=locmin; added+=$1-locmin; removed+=$2-locmin; } END \
    { \
      printf "%s %s %s %s %.0f", \
        added, removed, modified, \
        added + removed + modified, \
        100 * (added + removed + modified) / total \
    }'
}

printAuthorName() {
  echo "${1:-[empty]}" | sed \
    -e 's|ą|a|g' \
    -e 's|Ą|A|g' \
    -e 's|ć|c|g' \
    -e 's|Ć|C|g' \
    -e 's|ę|e|g' \
    -e 's|Ę|E|g' \
    -e 's|ł|l|g' \
    -e 's|Ł|L|g' \
    -e 's|ń|n|g' \
    -e 's|Ń|N|g' \
    -e 's|ó|o|g' \
    -e 's|Ó|O|g' \
    -e 's|ś|s|g' \
    -e 's|Ś|S|g' \
    -e 's|ź|z|g' \
    -e 's|Ź|Z|g' \
    -e 's|ż|z|g' \
    -e 's|Ż|Z|g' \
    -e 's|\ \+|_|g' \
    -e 's|^\(.\{20\}\).*|\1|'
}

createTableBody() {
  local -r contrubutors="$(
    (cat "$(git rev-parse --show-toplevel)/.contributors" "$HOME/.contributors" 2>/dev/null || echo "") |
      sed -e 's|\([^=[[:space:]]]*\)[[:space:]]*=[[:space:]]*\(.*\)|\1=\2|'
  )"
  git log --format='%aN' |
    sort -u |
    while read -r name; do
      local changes="$(sumAuthorChanges "$name" "$1")"
      local commits="$(sumAuthorCommits "$name" "$2")"
      local name="$(printAuthorName "$name")"
      local mapped="$(echo "$contrubutors" | grep "${name}=" | cut -d '=' -f2)"
      if [ -n "$mapped" ]; then
        name="$mapped"
      fi
      echo "$name $changes $commits"
    done
}

sumCommits() {
  git rev-list --count --no-merges HEAD
}

sumAddedAndRemoved() {
  git log --pretty=tformat: --numstat |
    awk \
      'function min(a,b) { return a < b ? a : b } \
    { locmin=min($1,$2); modified+=locmin; added+=$1-locmin; removed+=$2-locmin; } END \
    { printf "%s\n%s\n%s", added, removed, modified }'
}

contributionStats() {
  local sortby="${1:-1}"
  local totals="$(sumAddedAndRemoved)"
  local totalAdded="$(echo "$totals" | sed '1q;d')"
  local totalRemoved="$(echo "$totals" | sed '2q;d')"
  local totalModified="$(echo "$totals" | sed '3q;d')"
  local totalChanges="$(("$totalAdded" + "$totalRemoved" + "$totalModified"))"
  local totalCommits="$(sumCommits)"
  local table="$(
    createTableBody "$totalChanges" "$totalCommits" |
      awk '{ added[$1] += $2; removed[$1] += $3; modified[$1] += $4; changes[$1] += $5; changes_proc[$1] += $6; commits[$1] += $7; commits_proc[$1] += $8 } END { for (i in added) print i, added[i], removed[i], modified[i], changes[i], changes_proc[i], commits[i], commits_proc[i] }'
  )"
  if [ "$sortby" = "1" ]; then
    table="$(echo "$table" | LC_ALL=C sort)"
  else
    table="$(echo "$table" | sort -hr -k "$sortby")"
  fi
  local columnSep="---------- ---"
  local separator="-------------------- ---------- ---------- ---------- $columnSep $columnSep"
  local header="$(echo "Name Added Removed Modified Changes % Commits %" | sed -rn "s|(( *[a-zA-Z%]+){$sortby})(.*)|\1* \3|p")"
  local footer="Total $totalAdded $totalRemoved $totalModified $totalChanges - $totalCommits -"
  printf "%s\n%s\n%s\n%s\n%s" "$header" "$separator" "$table" "$separator" "$footer" |
    awk '{ printf "%-20s   %+10s %+10s %+10s %+10s %3s   %+10s %3s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9 }'
}

contributionStats "$@"
