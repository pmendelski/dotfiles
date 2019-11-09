#!/usr/bin/env bash

net_procs() {
  local -r result="$(lsof -i -P -n)"
  echo "$result" | head -n 1
  echo "$result" | grep LISTEN
}

net_proc() {
  local -r port="${1:?Expected port}"
  lsof -nP -iTCP:$port -sTCP:LISTEN
}

net_proc_pid() {
  local -r port="${1:?Expected port}"
  lsof -nP -iTCP:$port -sTCP:LISTEN -t
}

net_proc_kill() {
  local -r port="${1:?Expected port}"
  local -r pid="$(netproc_pid $port | head -n1)"
  [ -n "$pid" ] && kill -9 "$pid"
}

net_ip_external() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

net_ip() {
  local -r iface="$(net_iface)"
  ip addr show "$iface" | grep "inet " | cut -d '/' -f1 | cut -d ' ' -f6
}

net_mac() {
  local -r iface="$(net_iface)"
  cat /sys/class/net/$iface/address
}

net_iface() {
  ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' '
}

net_dns() {
  local -r iface="$(net_iface)"
  nmcli dev show "$iface" | grep DNS | sed -nE 's|^[^\ ]+\ +(.+)|\1|p'
}
