#!/bin/bash

longerExtPatterns() {
    git ls-files |
        sed -E \
            -e 's|^([/]?.*\/)*(.*)$|\2|' \
            -e 's|^[^.]+$|^[^.]+$|' \
            -e 's|^\..+|^\\\\..+$|' \
            -e 's|^[^^][^.]*(\..+)$|\1$|' |
        sort -u
}

shorterExtPatterns() {
    longerExtNames |
        sed -E 's|^\..*?(\..+)\$$|\1$|' |
        sort -u
}

extToPrint() {
    if [ "$1" = '^\..+$' ]; then
        echo "<dotfile>";
    elif [ "$1" = '^[^.]+$' ]; then
        echo "<noext>";
    else
        echo "${1%\$}"
    fi
}

countFilesByFileNamePattern() {
    git ls-files |
        sed -E 's|^([/]?.*\/)*(.*)$|\2|' |
        grep -E "$1" |
        wc -l
}

countLinesInFile() {
    cat $1 |
        sed '/^\\s*$/d' |
        wc -l
}

extractFileLines() {
    cat "$1" 2>/dev/null | sed '/^\\s*$/d'
}

countFileLines() {
    while read filename; do
        extractFileLines $filename
    done | wc -l
}

countFileLinesByFileNamePattern() {
    git grep --cached -Il '' |
        grep -E "$1" |
        countFileLines
}

countAllFiles() {
    git ls-files | wc -l
}

countAllFileLines() {
    git grep --cached -Il '' |
        countFileLines
}

createTableBody() {
    local sortby="$1";
    local totalFiles="$2";
    local totalLines="$3";
    longerExtPatterns |
        while read extpattern; do
            local files=$(countFilesByFileNamePattern $extpattern);
            local filesColumns="$files $(( 100 * $files / $totalFiles ))";
            local lines=$(countFileLinesByFileNamePattern $extpattern);
            local lineColumns="$lines $(( 100 * $lines / $totalLines ))";
            echo "$(extToPrint $extpattern) $filesColumns $lineColumns";
        done |
        ([ "$sortby" = "1" ] && LC_ALL=C sort || sort -gr -k $sortby)
}

fileStats() {
    local sortby="${1:-1}";
    local totalFiles=$(countAllFiles);
    local totalLines=$(countAllFileLines);
    local table="$(createTableBody $sortby $totalFiles $totalLines)";
    local separator="-------------------- ---------- --- ---------- ---";
    local header="$(echo 'Ext Count % Lines %' | sed -rn "s|(( *[a-zA-Z%]+){$sortby})(.*)|\1* \3|p")";
    local footer="Total $totalFiles -  $totalLines -";
    echo "$header\n$separator\n$table\n$separator\n$footer" |
        awk '{ printf "%-20s   %+10s %3s   %+10s %3s   %+10s %3s   %+10s\n", $1, $2, $3, $4, $5, $6, $7, $8 }';
}

fileStats "$@"
