#!/bin/bash

function conkyio {
    (df | grep ^/dev | sed "s|^.*% ||g"; echo -e "\n\n\n\n\n" ) | head -n 5 | while read disk; do
        if [ -z "$disk" ]; then
            echo ""
        else
            local name=`echo $disk | sed "s|.\+/||"`
            name=${name:0:10}
            echo "\${offset 205}\${color1}$name\${color2}\${goto 340}\${fs_used $disk}/\${fs_size $disk}\${alignr}\${fs_used_perc $disk}%"
        fi
    done
}

conkyio;
