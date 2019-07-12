#!/usr/bin/env bash

loop() {
  local n=1000;
  local delay=1;
  local inline=0;
  local condition=""
  if [[ "$1" == -* ]]; then
    while (($#)); do
      case $1 in
        --inline|-i)
          inline=1;
          ;;
        --count|-n)
          n="$2"
          shift
          if [[ ! "$n" =~ ^[0-9]+$ ]]; then
            echo "Invalid params: n=\"$n\""
            echo "Expected a positive integer"
            return 1
          fi
          ;;
        --condition|-c)
          condition="$2"
          shift
          ;;
        --delay|-d)
          delay="$2"
          shift
          if [[ ! "$delay" =~ ^[0-9]+$ ]]; then
            echo "Invalid params: delay=\"$delay\""
            echo "Expected a positive integer"
            return 1
          fi
          ;;
        --help|-h)
          echo "Execute actionin a loop:"
          echo "Sample: loop -i -n 10 -d 1 echo \"Printed inline 10 times with 1 second of delay between\" "
          return
          ;;
        *)
          break
          ;;
      esac
      shift
    done
  fi
  local lastResult=""
  local lastCmdResult=""
  for i in $(seq "$n"); do
    if [ $i -gt 1 ] && [ $inline = 1 ]; then
      for (( l=1; l <= $(echo $lastResult | wc -l); l++ ));do
        tput cuu1 #Move cursor up by one line
        tput el #Clear the line
      done
    fi
    lastResult=""
    lastResult+="# Iteration: ${i}/${n}\n"
    lastCmdResult="$($@)"
    lastResult+="$lastCmdResult\n"
    echo "$lastResult"
    if [ -n "$condition" ] && [ "$lastCmdResult" -eq "$condition" ]; then
      echo "# Exit condition reached:"
      echo "#   \"$lastCmdResult\" == \"$condition\""
      return
    fi
    if [ "$i" != "$n" ]; then
      sleep "$delay"
    fi
  done;
}
