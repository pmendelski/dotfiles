#!/bin/bash

function sayhello() {
    last $USER | grep "$(date +"%a %b %_d")" | grep -v ":0 \+:0" | grep -qv "$(tty | sed "s:/dev/::").* still logged in"
    if [ $? -ne 0 ] && [ -x "$(command -v dailyepigram)" ]; then
        echo "$COLOR_BLUE_BOLD"
        dailyepigram
        echo "$COLOR_GREEN_BOLD"
        echo ""
        echo "User: $USER@${HOSTNAME:-$HOST}"
        echo "Time: `date`"
        echo "$COLOR_RESET"
    fi
}
