#!/bin/bash

max() {
  [ "$1" -gt "$2" ] && \
    echo "$1" ||
    echo "$2"
}

sumAuthorCommits() {
  local name="$1";
  local total="$(max $2 1)"
  local commits="$(git rev-list --count --author="${name:-^ <}" --no-merges HEAD)"
  echo "$commits $(( 100 * $commits / $total ))"
}

sumAuthorChanges() {
  local name="$1";
  local total="$2";
  git log --author="${name:-^ <}" --pretty=tformat: --numstat |
  awk -v total="$(max $total 1)" \
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
  echo ${1:-'<empty>'} |
    sed -e 's|\ \+|_|g' -e 's|^\(.\{20\}\).*|\1|'
}

createTableBody() {
  git log --format='%aN' |
  sort -u |
  while read name; do
    local changes="$(sumAuthorChanges "$name" "$1")";
    local commits="$(sumAuthorCommits "$name" "$2")";
    echo "$(printAuthorName "$name") $changes $commits"
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
  local sortby="${1:-1}";
  local totals="$(sumAddedAndRemoved)";
  local totalAdded="$(echo "$totals" | sed '1q;d')";
  local totalRemoved="$(echo "$totals" | sed '2q;d')";
  local totalModified="$(echo "$totals" | sed '3q;d')";
  local totalChanges="$(( $totalAdded + $totalRemoved + $totalModified ))";
  local totalCommits="$(sumCommits)";
  local table="$(
    createTableBody $totalChanges $totalCommits |
    ([ "$sortby" = "1" ] && LC_ALL=C sort || sort -hr -k $sortby)
  )";
  local columnSep="---------- ---";
  local separator="-------------------- ---------- ---------- ---------- $columnSep $columnSep";
  local header="$(echo "Name Added Removed Modified Changes % Commits %" | sed -rn "s|(( *[a-zA-Z%]+){$sortby})(.*)|\1* \3|p")";
  local footer="Total $totalAdded $totalRemoved $totalModified $totalChanges - $totalCommits -";
  echo "$header\n$separator\n$table\n$separator\n$footer" |
    awk '{ printf "%-20s   %+10s %+10s %+10s %+10s %3s   %+10s %3s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9 }';
}

contributionStats "$@"
