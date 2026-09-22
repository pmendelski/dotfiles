#!/usr/bin/env bash
# Claude Code status line: dir git (left)  |  usage (right, color-coded)

input=$(cat)

RESET=$'\033[0m'
DIM=$'\033[2m'
BLUE_BOLD=$'\033[1;34m'    # matches PS1 PWD color
MAGENTA_BOLD=$'\033[1;35m' # matches PS1 git color
GREEN=$'\033[32m'
YELLOW=$'\033[33m'
ORANGE=$'\033[38;5;208m'
RED=$'\033[31m'
VIOLET=$'\033[38;5;147m'
GREY=$'\033[38;5;245m'

# Color a percentage: green <60, yellow <85, orange <95, red >=95
color_pct() {
  local pct=$1 r
  r=$(printf '%.0f' "$pct")
  if   [ "$r" -ge 95 ]; then printf '%s%s%%%s' "$RED"    "$r" "$RESET"
  elif [ "$r" -ge 85 ]; then printf '%s%s%%%s' "$ORANGE"  "$r" "$RESET"
  elif [ "$r" -ge 60 ]; then printf '%s%s%%%s' "$YELLOW"  "$r" "$RESET"
  else                       printf '%s%s%%%s' "$GREEN"   "$r" "$RESET"
  fi
}

# Format a Unix epoch as local HH:MM; empty for junk or already-past times.
reset_time() {
  local epoch=$1
  case "$epoch" in '' | *[!0-9]*) return 0 ;; esac
  [ "$epoch" -gt "$(date +%s)" ] || return 0
  # BSD date uses -r for epoch, GNU date uses -d @epoch (and -r for files)
  date -r "$epoch" +%H:%M 2>/dev/null || date -d "@$epoch" +%H:%M 2>/dev/null
}

# ---------------------------------------------------------------------------
# Right side: usage labels + colored percentages
# ---------------------------------------------------------------------------
five_pct=$(printf '%s'   "$input" | jq -r '.rate_limits.five_hour.used_percentage  // empty')
week_pct=$(printf '%s'   "$input" | jq -r '.rate_limits.seven_day.used_percentage  // empty')
five_reset=$(printf '%s' "$input" | jq -r '.rate_limits.five_hour.resets_at        // empty')
week_reset=$(printf '%s' "$input" | jq -r '.rate_limits.seven_day.resets_at        // empty')
ctx_pct=$(printf '%s'    "$input" | jq -r '.context_window.used_percentage         // empty')
model=$(printf '%s'      "$input" | jq -r '.model.id // empty' | sed 's/^claude-//')

# Rate limits aren't reported by Claude Code until the first API response.
# Cache the last known values so the statusline shows usage from the very
# first prompt (marked with "~" while stale).
cache_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/cache"
cache_file="$cache_dir/statusline-rate-limits"
five_stale=""
week_stale=""
if [ -n "$five_pct" ] && [ -n "$week_pct" ]; then
  mkdir -p "$cache_dir" 2>/dev/null
  printf '%s %s %s %s\n' "$five_pct" "$week_pct" \
    "${five_reset:-0}" "${week_reset:-0}" > "$cache_file" 2>/dev/null
elif [ -f "$cache_file" ]; then
  read -r cached_five cached_week cached_five_reset cached_week_reset < "$cache_file"
  [ -z "$five_pct" ] && [ -n "$cached_five" ] && {
    five_pct="$cached_five"; five_stale="~"; five_reset="$cached_five_reset"
  }
  [ -z "$week_pct" ] && [ -n "$cached_week" ] && {
    week_pct="$cached_week"; week_stale="~"; week_reset="$cached_week_reset"
  }
fi

right=""
# append_right <label> <stale-marker> <pct> [reset-epoch]
# The reset time is only worth screen space once the window is over half spent.
append_right() {
  local label=$1 stale=$2 pct=$3 reset=${4:-} at=""
  if [ -n "$reset" ] && [ "$(printf '%.0f' "$pct")" -gt 50 ]; then
    at=$(reset_time "$reset")
    [ -n "$at" ] && at="${GREY}@${at}${RESET}"
  fi
  [ -n "$right" ] && right="${right} "
  right="${right}${GREY}${stale}${label}:${RESET}$(color_pct "$pct")${at}"
}
[ -n "$five_pct" ] && append_right "5h"  "$five_stale" "$five_pct" "$five_reset"
[ -n "$week_pct" ] && append_right "7d"  "$week_stale" "$week_pct" "$week_reset"
[ -n "$ctx_pct"  ] && append_right "ctx" ""             "$ctx_pct"
[ -n "$model"    ] && { [ -n "$right" ] && right="${right} "; right="${right}${GREY}${model}${RESET}"; }

# Config dir indicator — shown only when not the default ~/.claude
claude_cfg="${CLAUDE_CONFIG_DIR:-}"
if [ -n "$claude_cfg" ] && [ "$claude_cfg" != "$HOME/.claude" ]; then
  cfg_suffix="${claude_cfg#"$HOME/.claude"}"
  if [ -n "$cfg_suffix" ]; then
    cfg_label="${VIOLET}[c${cfg_suffix}]${RESET}"
    [ -n "$right" ] && right="${right} ${cfg_label}" || right="$cfg_label"
  fi
fi

# ---------------------------------------------------------------------------
# Left side: directory (bold blue, matching PS1 PWD)
# ---------------------------------------------------------------------------
cwd=$(printf '%s' "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$cwd" ] && cwd="$(pwd)"

home="$HOME"
if   [ "$cwd" = "$home" ]; then pwd_display="~"
elif [ "$cwd" = "/"     ]; then pwd_display="/"
else
  short="$(dirname "$cwd" \
    | sed -e "s|/$||" -e "s|$home|~|" \
          -e "s|/\(.\)[^/]*/|/\1/|g"  \
          -e "s|/\(.\)[^/]*$|/\1|")/$(basename "$cwd")"
  pwd_display="$(printf '%s' "$short" \
    | sed -E 's|((/[^/]+){3,})((/[^/]+){3})$|...\3|')"
fi

left="${BLUE_BOLD}${pwd_display}${RESET}"

# ---------------------------------------------------------------------------
# Left side: git status (bold magenta, matching PS1 git color, no parens)
# ---------------------------------------------------------------------------
_skip_git=0
if [ -n "${REMOTE_FS-}" ]; then
  _rem=":$REMOTE_FS:"
  while [ -n "$_rem" ] && [ "$_rem" != ":" ]; do
    _rem="${_rem#:}"
    _fs="${_rem%%:*}"
    _rem="${_rem#"$_fs"}"
    [ -z "$_fs" ] && continue
    _clean_fs="${_fs%/}"
    if [[ "$cwd" == "$_clean_fs" || "$cwd" == "$_clean_fs/"* ]]; then
      _skip_git=1
      break
    fi
  done
fi

if [ "$_skip_git" = 0 ] && command -v git >/dev/null 2>&1 \
    && git_out=$(git -C "$cwd" rev-parse --is-inside-work-tree --short HEAD 2>/dev/null); then
  inside=$(printf '%s' "$git_out" | awk 'NR==1')
  sha=$(printf '%s'    "$git_out" | awk 'NR==2')
  if [ "$inside" = "true" ]; then
    branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null) || branch="(${sha}...)"

    staged=0; unstaged=0; untracked=0
    while IFS= read -r line; do
      x="${line:0:1}"; y="${line:1:1}"
      if [ "$x" = "?" ] && [ "$y" = "?" ]; then untracked=1
      else
        [ "$x" != " " ]                    && staged=1
        [ "$y" != " " ] && [ "$y" != "?" ] && unstaged=1
      fi
    done < <(git -C "$cwd" status --porcelain=v1 -unormal 2>/dev/null)

    dirty=""
    [ "$staged"    = 1 ] && dirty="${dirty}+"
    [ "$unstaged"  = 1 ] && dirty="${dirty}*"
    [ "$untracked" = 1 ] && dirty="${dirty}%"

    count=$(git -C "$cwd" rev-list --count --left-right "@{upstream}...HEAD" 2>/dev/null || true)
    upstream=""
    case "$count" in
      "0	0") ;;
      "0	"*) upstream=" u+${count#0	}" ;;
      *"	0") upstream=" u-${count%	0}" ;;
      ?*)     upstream=" u+${count#*	}-${count%	*}" ;;
    esac

    stash=""
    sc=$(git -C "$cwd" rev-list --walk-reflogs --count refs/stash 2>/dev/null || true)
    [ -n "$sc" ] && [ "$sc" -gt 0 ] && stash=" s${sc}"

    git_info="${branch}${dirty}${stash}${upstream}"
    left="${left} ${MAGENTA_BOLD}${git_info}${RESET}"
  fi
fi

# ---------------------------------------------------------------------------
# Assemble: dir git  -  usage
# ---------------------------------------------------------------------------
if [ -n "$right" ]; then
  printf '%s' "${left}${DIM} - ${RESET}${right}"
else
  printf '%s' "$left"
fi
