#!/bin/bash

function sayhello() {
    if $(command -v dailyepigram >/dev/null); then
        echo "$COLOR_BLUE_BOLD"
        dailyepigram
        echo "$COLOR_GREEN_BOLD"
        echo ""
        echo "User: $USER@${HOSTNAME:-$HOST}"
        echo "Time: `date`"
        echo "$COLOR_RESET"
    fi
}

function dailyhello() {
    local -r datefile="$BASH_TMP_DIR/sayhello"
    local -r today=$(date +"%Y%m%d")
    local lastdate=0;
    [ -s "$datefile" ] && lastdate=`cat $datefile`

    if [ "$today" -gt "$lastdate" ]; then
        echo "$today" > "$datefile"
        sayhello
        # screenfetch
    fi
}
