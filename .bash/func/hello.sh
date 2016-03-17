#!/bin/bash

function shhello() {
    last $USER | grep "$(date +"%a %b %d")" | grep -qv "$(tty | sed "s:/dev/::").* still logged in"
    if [ $? -ne 0 ]; then
        dailyepigram
        echo ""
        echo "User: $USER@${HOSTNAME:$HOST}"
        echo "Time: `date`"
    fi
}
