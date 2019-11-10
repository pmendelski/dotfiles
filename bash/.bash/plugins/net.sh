#!/usr/bin/env bash

net_procs() {
  local -r result="$(lsof -i -P -n)"
  echo "$result" | head -n 1
  echo "$result" | grep IPv4 | grep LISTEN
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

net_ip_public() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

if [[ "$OSTYPE" == darwin* ]]; then
  net_mac() {
    local -r iface="$(net_iface)"
    ifconfig "$iface" | grep ether | sed 's|\tether ||'
  }

  net_iface() {
    route get 0.0.0.0 2>/dev/null | grep 'interface' | sed 's| *interface: ||'
  }

  net_ip() {
    local -r iface="$(net_iface)"
    ifconfig $iface | grep 'inet ' | sed -nE 's|^.*inet ([^ ]+) .*$|\1|p'
  }

  net_ip6() {
    local -r iface="$(net_iface)"
    ifconfig $iface | grep inet6 | sed -nE 's|^.*inet6 ([^ %]+).*$|\1|p'
  }

  net_dns() {
    dig google.com | grep SERVER | sed -nE 's|^.*\(([^(]+)\)$|\1|p'
  }
else
  net_ip() {
    local -r iface="$(net_iface)"
    ip addr show "$iface" | grep "inet " | cut -d '/' -f1 | cut -d ' ' -f6
  }

  net_ip6() {
    local -r iface="$(net_iface)"
    ip addr show "$iface" | grep "inet6 " | cut -d '/' -f1 | cut -d ' ' -f6
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
    if hash nmcli 2>/dev/null; then
      nmcli dev show "$iface" | grep DNS | sed -nE 's|^[^\ ]+\ +(.+)|\1|p'
    else
      systemd-resolve eno1 --status | grep 'DNS Servers: ' | sed -nE 's|^.+\: (.+)$|\1|p'
    fi
  }
fi

net_info() {
  if net_ip_public &>/dev/null; then
    echo "    Hostname: $(hostname)"
    echo "   Public IP: $(net_ip_public)"
    echo "    Local IP: $(net_ip)"
    echo "   Local IP6: $(net_ip6)"
    echo "   Interface: $(net_iface)"
    echo "         MAC: $(net_mac)"
    echo "         DNS: $(net_dns)"
    if [ "$1" = "-a" ]; then
      echo ""
      echo ">> Resolve.conf (cat /etc/resolv.conf):"
      cat /etc/resolv.conf | grep -v '^#' | grep -v '^$'
      echo ""
      echo ">> Open Ports:"
      net_procs
      if hash systemd-resolve 2>/dev/null; then
        echo ""
        echo ">> DNS from systemd-resolve:"
        systemd-resolve $(net_iface) --status | grep -A 3 'DNS Servers: '
      fi
    fi
  else
    (>&2 echo "No Internet")
    return 1
  fi
}
