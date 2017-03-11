#!/bin/bash -e

# Simple script that will wake you up ;)
#
# Puts the computer on standby and automatically wakes it up at specified time and plays some music.
#
# Takes a 24hour time HH:MM as its argument
# Example:
# wakemeup 9:30
# wakemeup 18:45
# wakemeup 18:45 2016-02-05
# wakemeup 14:23 && echo "Finished"

# ------------------------------------------------------

function wakemeup_youtube() {
    exec $BASH_DIR/plugins/wakemeup_youtube.sh $@
}

function wakemeup_audacious() {
    exec $BASH_DIR/plugins/wakemeup_audacious.sh $@
}

function wakemeup() {
    wakemeup_audacious $@
}
