#!/bin/bash

function sayhello() {
    last $USER | grep "$(date +"%a %b %_d")" | grep -v ":0 \+:0" | grep -qv "$(tty | sed "s:/dev/::").* still logged in"
    if [ $? -ne 0 ]; then
        echo "$PR_BLUE_BOLD"
        dailyepigram
        echo "$PR_GREEN_BOLD"
        echo ""
        echo "User: $USER@${HOSTNAME:-$HOST}"
        echo "Time: `date`"
        echo "$PR_RESET"
    fi
}
