#!/bin/bash

function shhello() {
    last $USER | grep "$(date +"%a %b ")17" | grep -qv "$(tty | sed "s:/dev/::").* still logged in"
    if [ $? -eq 0 ]; then
        dailyepigram
        echo ""
        echo "User: $USER@${HOSTNAME:$HOST}"
        echo "Time: `date`"
    fi
}
