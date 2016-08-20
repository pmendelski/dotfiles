#!/bin/bash

function conkynet {
    local iface=`ifconfig -s | tail -n +2 | tr -s ' ' | cut -d' ' -f1,4 | sort -n -k2 | tail -n 1 | cut -d' ' -f1`
    echo -e "\
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}$iface: \${font Ubuntu:size=9:style=normal}\$color2\${alignr}\${addr $iface}
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Signal: \${font}\$color2\${alignr}\${wireless_link_qual_perc $iface}%

\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Uploaded: \${alignr}\${font}\$color2\${totalup $iface}
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Up: \${alignr}\${font}\$color2\${upspeedf $iface} kB/s
\${offset 205}\${upspeedgraph $iface 40,240 4B1B0C FF5C2B -l}
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Downloaded: \${alignr}\${font}\$color2\${totaldown $iface}
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Down: \${alignr}\${font}\$color2\${downspeedf $iface} kB/s
\${offset 205}\${downspeedgraph $iface 40,240 324D23 77B753 -l}\
"
}

conkynet;
