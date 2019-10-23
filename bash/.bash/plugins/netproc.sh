#!/usr/bin/env bash

netproc() {
  local -r port="${1:?Expected port}"
  case "$(systype)" in
    linux*) sudo netstat -tulpn | grep LISTEN | grep "$port";;
    macos*) lsof -nP -iTCP:$port -sTCP:LISTEN;;
    *) echo "Unsupported system"; return 1; ;;
  esac
}

netproc_pid() {
  local -r port="${1:?Expected port}"
  case "$(systype)" in
    linux*) sudo netstat -tulpn | grep LISTEN | grep ":$port" | sed -E "s|.*LISTEN +([0-9]+)/.*|\1|g";;
    macos*) lsof -nP -iTCP:$port -sTCP:LISTEN -t;;
    *) echo "Unsupported system"; return 1; ;;
  esac
}

netproc_kill() {
  local -r port="${1:?Expected port}"
  local -r pid="$(netproc_pid $port | head -n1)"
  [ -n "$pid" ] && kill -9 "$pid"
}
