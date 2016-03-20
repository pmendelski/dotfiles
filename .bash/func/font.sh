#!/bin/bash -e

function install-font() {
    declare fontdir=$([ "$(whoami)" = "root" ] && \
        echo "/usr/share/fonts/truetype" || \
        echo "${HOME}/.local/share/fonts")
    for fontpath in "$@"; do
        declare fontbasename="$(basename "$fontpath")"
        declare fontname="$(echo "$fontbasename" | sed -n "s|^\([^-]\+\).*\.ttf$|\1|p")"
        if [ -n "$fontname" ]; then
            cp "$fontpath" "${fontdir}"
            chmod 644 "${fontdir}/$fontbasename"
            echo "Intalled $fontpath in $fontdir"
        else
            echo "Cound not installl font $fontpath"
        fi
    done
    fc-cache -fv
    echo "Cleared cache"
}
