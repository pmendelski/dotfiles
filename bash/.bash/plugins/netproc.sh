#!/bin/bash

netproc() {
  local -r port="${1:?Expected port}"
  case "$(systype)" in
    linux*) netstat -a -n | grep LISTEN | grep "$port";;
    macos*) lsof -nP -iTCP:$port -sTCP:LISTEN;;
    *) echo "Unsupported system"; return 1; ;;
  esac
}

netprocPid() {
  local -r port="${1:?Expected port}"
  case "$(systype)" in
    linux*) netstat -a -n | grep LISTEN | grep "$port";;
    macos*) lsof -nP -iTCP:$port -sTCP:LISTEN -t;;
    *) echo "Unsupported system"; return 1; ;;
  esac
}

netprocKill() {
  local -r port="${1:?Expected port}"
  local -r pid="$(netprocPid $port | head -n1)"
  kill -9 "$pid"
}