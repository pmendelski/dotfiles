#!/bin/bash

specialFilePatterns() {
    echo '<noext> ^(.*/)?[^./]+$';
    echo '<dotfile> ^(.*/)?\.[^./]+$';
}

longerExtPatterns() {
    specialFilePatterns
    git ls-files |
        sed -nE 's|^(.*/)?[^./]+\.([^/]+)$|.\2 ^(.*/)?[^./]+\\.\2$|p' |
        sort -u
}

shorterExtPatterns() {
    specialFilePatterns
    git ls-files |
        sed -nE 's|^(.*/)?[^./][^/]+\.([^/]+)$|.\2 ^(.*/)?[^./][^/]+\\.\2$|p' |
        sort -u
}

countFilesByFileNamePattern() {
    git ls-files |
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

countFileBytes() {
    while read filename; do
        wc -c $filename 2>/dev/null
    done | awk '{s+=$1} END {print s}'
}

countFileLinesByFileNamePattern() {
    git grep --cached -Il '' |
        grep -E "$1" |
        countFileLines
}

countFileBytesByFileNamePattern() {
    git ls-files |
        grep -E "$1" |
        countFileBytes
}

countAllFiles() {
    git ls-files |
        wc -l
}

countAllFileBytes() {
    git ls-files |
        countFileBytes
}

countAllFileLines() {
    git grep --cached -Il '' |
        countFileLines
}

bytesToHuman() {
    numfmt --to=iec --suffix=B $1
}

createTableBody() {
    local sortby="$1";
    local totalFiles="$2";
    local totalLines="$3";
    local totalBytes="$4";
    while read -r extline; do
        local extname="$(echo $extline | cut -d ' ' -f 1)"
        local extpattern="$(echo $extline | cut -d ' ' -f 2)"
        local files=$(countFilesByFileNamePattern $extpattern);
        local filesColumns="$files $(( 100 * $files / $totalFiles ))";
        local lines=$(countFileLinesByFileNamePattern $extpattern);
        local lineColumns="$lines $(( 100 * $lines / $totalLines ))";
        local bytes=$(countFileBytesByFileNamePattern $extpattern);
        local byteColumns="$(bytesToHuman $bytes) $(( 100 * $bytes / $totalBytes ))";
        echo "$extname $filesColumns $lineColumns $byteColumns";
    done |
    ([ "$sortby" = "1" ] && LC_ALL=C sort || sort -hr -k $sortby)
}

fileStats() {
    local sortby="${1:-1}";
    local extopt="${2:-short}";
    local totalFiles=$(countAllFiles);
    local totalLines=$(countAllFileLines);
    local totalBytes=$(countAllFileBytes);
    local table="$(
        ([ "$extopt" = "short" ] && shorterExtPatterns || longerExtPatterns) |
        createTableBody $sortby $totalFiles $totalLines $totalBytes
    )";
    local separator="-------------------- ---------- --- ---------- --- ---------- ---";
    local header="$(echo "Ext Count % Lines % Size %" | sed -rn "s|(( *[a-zA-Z%]+){$sortby})(.*)|\1* \3|p")";
    local footer="Total $totalFiles -  $totalLines - $(bytesToHuman $totalBytes) -";
    echo "$header\n$separator\n$table\n$separator\n$footer" |
        awk '{ printf "%-20s   %+10s %3s   %+10s %3s   %+10s %3s\n", $1, $2, $3, $4, $5, $6, $7 }';
}

fileStats "$@"
