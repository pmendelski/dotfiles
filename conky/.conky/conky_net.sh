#!/bin/bash

# Make sure we're in the projects root directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && echo $PWD )"
cd "$DIR"

mkdir -p "$DIR/tmp"
touch "$DIR/tmp/conky_net_val.sh"

function reset() {
  __CONKY_NET_IFACE=""
  __CONKY_NET_EPOCH=0
  __CONKY_NET_DOWNBYTES=0
  __CONKY_NET_UPBYTES=0
  __CONKY_NET_DOWNSPEED=0
  __CONKY_NET_UPSPEED=0
}

function formatbytes() {
  local bytes=${1:-0}
  local format=${2:-"B"}
  local value=$bytes
  [ $format = "b" ] && value=$(( $bytes * 8 ))
  local kilo=`echo $(echo "scale=2; $value / 1024" | bc | sed 's/^\./0./')`
  local mega=`echo $(echo "scale=2; $value / 1024 / 1024" | bc | sed 's/^\./0./')`
  [[ "$mega" == 0.?* ]] || [[ "$mega" == "0" ]] && \
    echo "${kilo}k${format}" || \
    echo "${mega}M${format}"
}

function conkynet {
  local iface=`ifconfig -s | tail -n +2 | tr -s ' ' | cut -d' ' -f1,4 | sort -n -k2 | tail -n 1 | cut -d' ' -f1`
  local currepoch=`date +%s%3N`
  local currbytes=`cat /proc/net/dev | tail -n +3 | grep $iface | tr -s ' ' | sed 's| *||' | cut -d' ' -f2,10`
  local downbytes=`echo $currbytes | cut -d' ' -f1`
  local upbytes=`echo $currbytes | cut -d' ' -f2`
  local downspeed=0
  local upspeed=0
  source "$DIR/tmp/conky_net_val.sh"
  local epochdelta=$(($currepoch - $__CONKY_NET_EPOCH))
  if [ "$iface" != "$__CONKY_NET_IFACE" ]; then
    reset
  elif [[ $__CONKY_NET_EPOCH -gt 0 ]] && [[ $epochdelta -gt 300 ]]; then
    downspeed=$(( ($downbytes - $__CONKY_NET_DOWNBYTES) / $epochdelta * 1000 ))
    upspeed=$(( ($upbytes - $__CONKY_NET_UPBYTES) / $epochdelta * 1000 ))
    [[ $downspeed -gt $__CONKY_NET_DOWNSPEED ]] && __CONKY_NET_DOWNSPEED=$downspeed
    [[ $upspeed -gt $__CONKY_NET_UPSPEED ]] && __CONKY_NET_UPSPEED=$upspeed
  fi
  echo -e "\
__CONKY_NET_IFACE=$iface
__CONKY_NET_EPOCH=$currepoch
__CONKY_NET_DOWNBYTES=$downbytes
__CONKY_NET_UPBYTES=$upbytes
__CONKY_NET_DOWNSPEED=$__CONKY_NET_DOWNSPEED
__CONKY_NET_UPSPEED=$__CONKY_NET_UPSPEED
" > "$DIR/tmp/conky_net_val.sh"
  local formatted_upbytes=$(formatbytes ${__CONKY_NET_UPBYTES} "B")
  local formatted_upspeed=$(formatbytes ${upspeed} "b")
  local formatted_maxupspeed=$(formatbytes ${__CONKY_NET_UPSPEED} "b")
  local formatted_downbytes=$(formatbytes ${__CONKY_NET_DOWNBYTES} "B")
  local formatted_downspeed=$(formatbytes ${downspeed} "b")
  local formatted_maxdownspeed=$(formatbytes ${__CONKY_NET_DOWNSPEED} "b")
  echo -e "\
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}$iface: \${font Ubuntu:size=9:style=normal}\$color2\${alignr}\${addr $iface}
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Signal: \${font}\$color2\${alignr}\${wireless_link_qual_perc $iface}%

\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Uploaded: \${alignr}\${font}\$color2 ${formatted_upbytes}
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Up: \${font}\${goto 300}\$color2 ${formatted_upspeed}/s\${alignr} ${formatted_maxupspeed}/s
\${offset 205}\${upspeedgraph $iface 40,240 4B1B0C FF5C2B -l}
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Downloaded: \${alignr}\${font}\$color2 ${formatted_downbytes}
\${offset 205}\${color1}\${font Ubuntu:size=9:style=bold}Down: \${font}\${goto 300}\$color2 ${formatted_downspeed}/s\${alignr} ${formatted_maxdownspeed}/s
\${offset 205}\${downspeedgraph $iface 40,240 324D23 77B753 -l}\
"
}

reset
conkynet
