#!/bin/bash

contributionStats() {
    local sortby="${1:-1}";
    local totals="$(
        git log --pretty=tformat: --numstat |
        awk '{ add += $1; rem += $2; dif += $1 - $2; sum += $1 + $2;} END { printf "%s\n%s\n%s\n%s", add, rem, dif, sum }'
    )";
    local total_added="$(echo "$totals" | sed '1q;d')";
    local total_removed="$(echo "$totals" | sed '2q;d')";
    local total_diff="$(echo "$totals" | sed '3q;d')";
    local total_sum="$(echo "$totals" | sed '4q;d')";
    local table="$(
        git log --format='%aN' |
        sort -u |
        while read name; do
            git log --author="$name" --pretty=tformat: --numstat |
            awk -v name="$(echo ${name:-'<empty>'} | sed -e 's|\ \+|_|g' -e 's|^\(.\{20\}\).*|\1|')" \
                -v ta="$total_added" \
                -v tr="$total_added" \
                -v td="$total_diff" \
                -v ts="$total_sum" \
                '{ add += $1; rem += $2; dif += $1 - $2; sum += $1 + $2; } END { printf "'%s' %s %.0f %s %.0f %s %.0f %s\\n", name, add, 100 * add / ta, rem, 100 * rem / tr, sum, 100 * sum / ts, dif }';
        done |
        ([ "$sortby" = "1" ] && sort || sort -gr -k $sortby)
    )";
    local separator="-------------------- ---------- --- ---------- --- ---------- --- ----------";
    local header="$(echo 'Name Added % Removed % Sum % Diff' | sed -rn "s|(( *[a-zA-Z%]+){$sortby})(.*)|\1* \3|p")";
    local footer="Total $total_added -  $total_removed - $total_sum - $total_diff";
    echo "$header\n$separator\n$table\n$separator\n$footer" |
        awk '{ printf "%-20s   %+10s %3s   %+10s %3s   %+10s %3s   %+10s\n", $1, $2, $3, $4, $5, $6, $7, $8 }';
}

contributionStats "$@"
