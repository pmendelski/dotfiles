#!/usr/bin/env bash

notify() {
  local title=""
  local subtitle=""
  local message=""
  local error=0
  if [[ "$1" == -* ]]; then
    while (($#)); do
      case $1 in
      --title | -t)
        title="$2"
        shift
        ;;
      --subtitle | -s)
        subtitle="$2"
        shift
        ;;
      --help | -h)
        echo "Notify user"
        echo "Sample: notify --title 'Lorem' --subtitle 'ipsum' \"Loferm Ipsum\" "
        return
        ;;
      --error | -e)
        error=1
        ;;
      *)
        message="$*"
        break
        ;;
      esac
      shift
    done
  else
    message="$*"
  fi
  if [ -x "$(command -v notify-send)" ]; then
    if [ -z "$title" ]; then
      title="$subtitle"
      subtitle=""
    fi
    if [ -z "$title" ]; then
      title="$message"
      message=""
    fi
    if [ -n "$subtitle" ] && [ -n "$message" ]; then
      message="$subtitle | $message"
    elif [ -n "$subtitle" ]; then
      message="$subtitle"
    fi
    notify-send --urgency=low -i "$([ $error = 1 ] && echo error || echo terminal)" "$title" "$message"
  elif [ -x "$(command -v osascript)" ]; then
    local type="$([ $error = 1 ] && echo 'Error: ' || echo '')"
    osascript -e "display notification \"${message//\"/\\\"}\" with title \"$type${title//\"/\\\"}\" subtitle \"${subtitle//\"/\\\"}\""
  fi
}

notifyLastCmd() {
  local -r lastStatus="$?"
  local -r lastCmd="$(
    \history |
      tail -n 1 |
      sed -e 's/^\s*[0-9]*\s*[0-9-]*\s[0-9:]*\s*//'
  )"
  while read -r cmd; do
    if [[ "$lastCmd" == "$cmd" ]] || [[ "$lastCmd" == ^$cmd\ .* ]]; then
      return
    fi
  done < <(echo "${NOTIFY_LAST_CMD_BLACKLIST:-nvim vim gitk}" | tr ' ' '\n')
  if [ $lastStatus = 0 ]; then
    notify -t "$lastCmd" -s "Status: Success" "$@"
  else
    notify -e -t "$lastCmd" -s "Status: Failure" "$@"
  fi
}

notifyWhenHttp200() {
  local -r url="${1:?Expected url}"
  while true; do
    local result="$(curl -s -o /dev/null -w "%{http_code}" "$url")"
    if [ "$result" = "200" ]; then
      figlet "200"
      echo "URL: $url"
      break
    fi
    sleep 1
    echo -ne "[$(date '+%Y-%m-%d %H:%M:%S')] HTTP Status: $result"\\r
  done
}
