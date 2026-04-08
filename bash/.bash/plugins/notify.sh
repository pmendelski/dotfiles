#!/usr/bin/env bash

# notify [message] [flags...]
# notify <title> <message> [flags...]
# notify <title> <subtitle> <message> [flags...]
#
# Positional args (leading non-flag args):
#   1 arg  → message
#   2 args → title, message
#   3 args → title, subtitle, message
#   0 args → message defaults to "Notification"
#
# Custom flags (not passed to terminal-notifier):
#   --mobile       send to Telegram chat as well (requires TELEGRAM_BOT_TOKEN, TELEGRAM_CHAT_ID)
#   --mobile-only  skip terminal-notifier, send to Telegram only
#   --level <lvl>  prepend emoji: success=✅  info=ℹ️  warn=⚠️  error=❌
#
# All other flags are forwarded verbatim to terminal-notifier (single-dash form).
# Flags -title/-subtitle/-message (and their -- variants) are intercepted to populate
# the corresponding variables instead of being double-passed.

notify() {
  local title="" subtitle="" message=""
  local mobile=0 mobile_only=0 level="" sound=""
  local -a tn_extra=()
  local pos_count=0

  # Collect leading positional args (anything not starting with -)
  # Use title/subtitle/message as temporary slots to avoid array index differences
  # between bash (0-indexed) and zsh (1-indexed).
  while [[ "${1:-}" != -* && -n "${1:-}" ]]; do
    ((pos_count++)) || true
    case $pos_count in
    1) title="$1" ;;
    2) subtitle="$1" ;;
    3) message="$1" ;;
    esac
    shift
  done

  # Re-map slots: 1 arg = message, 2 args = title+message, 3+ = title+subtitle+message
  case $pos_count in
  1)
    message="$title"
    title=""
    ;;
  2)
    message="$subtitle"
    subtitle=""
    ;;
  esac

  while (($#)); do
    case $1 in
    --mobile) mobile=1 ;;
    --mobile-only) mobile_only=1 ;;
    --sound | -sound)
      if [[ -n "${2:-}" && "${2:-}" != -* ]]; then
        sound="$2"
        shift
      else
        sound="Hero.aiff"
      fi
      ;;
    --level | -level)
      level="$2"
      shift
      ;;
    # Intercept title/subtitle/message so they don't get double-passed
    -title | --title)
      title="$2"
      shift
      ;;
    -subtitle | --subtitle)
      subtitle="$2"
      shift
      ;;
    -message | --message)
      message="$2"
      shift
      ;;
    # Everything else goes straight to terminal-notifier
    *) tn_extra+=("$1") ;;
    esac
    shift
  done

  local emoji=""
  case "$level" in
  success) emoji="✅ " ;;
  info) emoji="ℹ️ " ;;
  warn) emoji="⚠️ " ;;
  error) emoji="❌ " ;;
  esac

  local full_message="${emoji}${message:-Notification}"

  # --- sound ---
  if [[ -n "$sound" ]] && command -v afplay &>/dev/null; then
    (afplay "/System/Library/Sounds/${sound}" 2>/dev/null &)
  fi

  # --- terminal-notifier (macOS) ---
  if [[ $mobile_only -eq 0 ]]; then
    if command -v terminal-notifier &>/dev/null; then
      local -a cmd=(terminal-notifier)
      [[ -n "$title" ]] && cmd+=(-title "$title")
      [[ -n "$subtitle" ]] && cmd+=(-subtitle "$subtitle")
      [[ -n "$full_message" ]] && cmd+=(-message "$full_message")
      cmd+=("${tn_extra[@]}")
      "${cmd[@]}" 2>/dev/null
    elif command -v notify-send &>/dev/null; then
      # Linux fallback: collapse subtitle into message
      local ns_title="${title:-${subtitle}}"
      local ns_msg
      if [[ -n "$subtitle" && -n "$title" && -n "$full_message" ]]; then
        ns_msg="$subtitle | $full_message"
      elif [[ -n "$subtitle" && -n "$title" ]]; then
        ns_msg="$subtitle"
      else
        ns_msg="$full_message"
      fi
      local icon
      icon="$([ "$level" = error ] && echo error || echo terminal)"
      notify-send --urgency=low -i "$icon" "$ns_title" "$ns_msg"
    fi
  fi

  # --- Telegram ---
  if [[ $mobile -eq 1 || $mobile_only -eq 1 ]]; then
    if [[ -n "$TELEGRAM_BOT_TOKEN" && -n "$TELEGRAM_CHAT_ID" ]]; then
      local tg="" nl=$'\n'
      [[ -n "$title" ]] && tg="*${title}*"
      [[ -n "$subtitle" ]] && tg+="${tg:+${nl}}_${subtitle}_"
      [[ -n "$full_message" ]] && tg+="${tg:+${nl}}${full_message}"
      curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d parse_mode="Markdown" \
        --data-urlencode "text=${tg}" &>/dev/null || true
    fi
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
    notify "$lastCmd" "Status: Success" "$@"
  else
    notify "$lastCmd" "Status: Failure" --level error "$@"
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
