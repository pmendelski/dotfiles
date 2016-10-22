#!/bin/bash

max() {
    [ "$1" -gt "$2" ] && \
        echo "$1" ||
        echo "$2"
}

sumAuthorCommits() {
    local name="$1";
    local total="$(max $2 1)"
    local commits="$(git rev-list --count HEAD --author="${name:-^ <}")"
    echo "$commits $(( 100 * $commits / $total ))"
}

sumAuthorChanges() {
    local name="$1";
    local totalAdded="$2";
    local totalRemoved="$3";
    local totalSum="$4";
    git log --author="${name:-^ <}" --pretty=tformat: --numstat |
    awk -v ta="$(max $totalAdded 1)" \
        -v tr="$(max $totalRemoved 1)" \
        -v ts="$(max $totalSum 1)" \
        '{ \
            added += $1; \
            removed += $2; \
        } END { \
            printf "%s %.0f %s %.0f %s %.0f", \
                added, 100 * added / ta, \
                removed, 100 * removed / tr, \
                added + removed, 100 * (added + removed) / ts \
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
        local changes="$(sumAuthorChanges "$name" "$1" "$2" "$3")";
        local commits="$(sumAuthorCommits "$name" "$4")";
        echo "$(printAuthorName "$name") $changes $commits"
    done
}

sumCommits() {
    git rev-list --count HEAD
}

sumAddedAndRemoved() {
    git log --pretty=tformat: --numstat |
        awk '{added+=$1; removed+=$2} END {printf "%s\n%s", added, removed}'
}

contributionStats() {
    local sortby="${1:-1}";
    local totals="$(sumAddedAndRemoved)";
    local totalAdded="$(echo "$totals" | sed '1q;d')";
    local totalRemoved="$(echo "$totals" | sed '2q;d')";
    local totalSum="$(( $totalAdded + $totalRemoved ))";
    local totalCommits="$(sumCommits)";
    local table="$(
        createTableBody $totalAdded $totalRemoved $totalSum $totalCommits |
        ([ "$sortby" = "1" ] && LC_ALL=C sort || sort -hr -k $sortby)
    )";
    local columnSep="---------- ---";
    local separator="-------------------- $columnSep $columnSep $columnSep $columnSep";
    local header="$(echo "Name Added % Removed % Sum % Commits %" | sed -rn "s|(( *[a-zA-Z%]+){$sortby})(.*)|\1* \3|p")";
    local footer="Total $totalAdded - $totalRemoved - $totalSum - $totalCommits -";
    echo "$header\n$separator\n$table\n$separator\n$footer" |
        awk '{ printf "%-20s   %+10s %3s   %+10s %3s   %+10s %3s   %+10s %3s\n", $1, $2, $3, $4, $5, $6, $7, $8, $9 }';
}

contributionStats "$@"
