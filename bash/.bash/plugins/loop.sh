#!/usr/bin/env bash

loop() {
  local n=-1
  local delay=1
  local stopOnError=0
  local stopOnSuccess=0
  local condition=""
  if [[ "$1" == -* ]]; then
    while (($#)); do
      case $1 in
      --count | -n)
        n="$2"
        shift
        if [[ ! "$n" =~ ^[0-9]+$ ]]; then
          echo "Invalid params: n=\"$n\""
          echo "Expected a positive integer"
          return 1
        fi
        ;;
      --stopOnError | -e)
        stopOnError=1
        ;;
      --stopOnSuccess | -s)
        stopOnSuccess=1
        ;;
      --condition | -c)
        condition="$2"
        shift
        ;;
      --delay | -d)
        delay="$2"
        shift
        if [[ ! "$delay" =~ ^[0-9]+$ ]]; then
          echo "Invalid params: delay=\"$delay\""
          echo "Expected a positive integer"
          return 1
        fi
        ;;
      --help | -h)
        echo "Execute action in a loop:"
        echo "  loop -n 10 -d 1 echo \"Printed inline 10 times with 1 second of delay between\" "
        echo "  other params:"
        echo "    --count/-n N   - finish after N iterations"
        echo "    --stopOnError"
        echo "    --stopOnSuccess"
        return
        ;;
      *)
        break
        ;;
      esac
      shift
    done
  fi
  local lastCmdResult=""
  local lastCmdStatus=""
  tput sc
  for ((i = 1; n < 0 || i <= n; i++)); do
    echo -e "\n# Iteration: ${i}/${n}"
    lastCmdResult="$("$@" | tee /dev/tty)"
    lastCmdStatus="$?"

    if [ -n "$condition" ] && [ "$lastCmdResult" -eq "$condition" ]; then
      echo
      echo "# Exit condition reached:"
      echo "#   \"$lastCmdResult\" == \"$condition\""
      return
    fi

    if [ $stopOnError -eq 1 ] && [ ! "$lastCmdStatus" -eq 0 ]; then
      echo
      echo "# Exit condition reached:"
      echo "#   Last command status is error: $lastCmdStatus"
      return
    fi

    if [ $stopOnSuccess -eq 1 ] && [ "$lastCmdStatus" -eq 0 ]; then
      echo
      echo "# Exit condition reached:"
      echo "#   Last command status is success: $lastCmdStatus"
      return
    fi

    if [ "$i" != "$n" ]; then
      sleep "$delay"
    fi
  done
}
