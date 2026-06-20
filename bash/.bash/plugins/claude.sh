# Parse "2am" / "11:30pm" in a given timezone to a UTC epoch timestamp.
# Uses sed/grep instead of shell regex captures — works in bash and zsh on Linux and macOS.
_claude_reset_epoch() {
  local time_str="$1" tz="$2"

  local h m ap
  h=$(printf '%s' "$time_str" | sed 's/[^0-9].*//')
  ap=$(printf '%s' "$time_str" | grep -o '[ap]m')
  m=$(printf '%s' "$time_str" | sed -n 's/[0-9]*:\([0-9]*\)[ap]m/\1/p')
  m=${m:-0}

  [[ -z "$h" || -z "$ap" ]] && return 1
  [[ "$ap" == "pm" && "$h" != "12" ]] && h=$((h + 12))
  [[ "$ap" == "am" && "$h" == "12" ]] && h=0
  local hhmm
  hhmm=$(printf '%02d:%02d' "$h" "$m")

  local ts now
  now=$(date +%s)
  # GNU date (Linux / Homebrew macOS)
  ts=$(TZ="$tz" date -d "$hhmm" +%s 2>/dev/null)
  if [[ $? -ne 0 || -z "$ts" ]]; then
    # BSD date (macOS) — explicit :00 seconds to avoid inheriting current seconds
    ts=$(TZ="$tz" date -j -f "%H:%M:%S" "${hhmm}:00" +%s 2>/dev/null) || return 1
  fi
  # If the time already passed today in that timezone, it must mean tomorrow
  [[ "$ts" -le "$now" ]] && ts=$((ts + 86400))
  echo "$ts"
}

# Invoke claude, setting CLAUDE_CONFIG_DIR only for non-default config dirs.
# Explicitly setting it to ~/.claude confuses Claude's own default resolution.
_claude_invoke() {
  local config_dir="$1"
  shift
  if [[ "$config_dir" != "${HOME}/.claude" ]]; then
    CLAUDE_CONFIG_DIR="$config_dir" claude "$@"
  else
    claude "$@"
  fi
}

# Poll until rate limit clears. Prints in-place status to /dev/tty. Returns 0 when done.
#
# All locals are declared ONCE here, up-front. They must NOT be re-declared inside
# the loop: in zsh a bare `local NAME` for an already-set parameter re-displays it
# as `NAME=value` on stdout, which on every iteration after the first leaks the
# poll's variables to the terminal (a caller-side `2>/dev/null` can't catch it —
# it's stdout, not stderr). Declare here, assign in the loop.
_claude_poll() {
  local config_dir="$1"
  local check_interval=300 reset_ts=0
  local output time_part tz_part new_ts now next_check remaining reset_disp status_msg

  while true; do
    output=$(_claude_invoke "$config_dir" -p 'x' 2>&1)
    if [[ $? -eq 0 ]]; then
      printf '\r\033[KTokens available!\n' >/dev/tty
      return 0
    fi

    time_part=$(printf '%s' "$output" | grep -oiE 'resets [0-9:]+[ap]m' | grep -oiE '[0-9:]+[ap]m' | tr '[:upper:]' '[:lower:]' | head -1)
    tz_part=$(printf '%s' "$output" | grep -oiE 'resets [0-9:]+[ap]m \([^)]+\)' | grep -oE '\([^)]+\)' | tr -d '()' | head -1)
    if [[ -n "$time_part" && -n "$tz_part" ]]; then
      new_ts=$(_claude_reset_epoch "$time_part" "$tz_part") && reset_ts=$new_ts
    fi

    now=$(date +%s)
    next_check=$((now + check_interval))

    while true; do
      now=$(date +%s)
      [[ $now -ge $next_check ]] && break
      remaining=$((next_check - now))
      if [[ $reset_ts -gt $now ]]; then
        reset_disp=$(date -r "$reset_ts" +"%H:%M %Z" 2>/dev/null || date -d "@$reset_ts" +"%H:%M %Z" 2>/dev/null)
        status_msg="Rate limited — resets ~${reset_disp}  (retry in ${remaining}s)"
      else
        status_msg="Rate limited — retry in ${remaining}s"
      fi
      printf '\r\033[K%s' "$status_msg" >/dev/tty
      sleep 1
    done
    printf '\r\033[K' >/dev/tty
  done
}

# Resolve session ID for --continue: explicit arg, else the most-recently-active
# session for the *current directory*. Claude stores each session as a .jsonl under
# <config>/projects/<cwd>, where <cwd> is the path with '/' and '.' replaced by '-'.
# The newest .jsonl by mtime is the session that last ran here — far more reliable
# than the global current-session file (stale) or a tmux pane var (goes stale when a
# session is started outside claudex). Empty result => caller falls back to `claude -c`.
_claude_resolve_session() {
  local config_dir="$1" explicit="$2"
  if [[ -n "$explicit" ]]; then
    printf '%s' "$explicit"
    return
  fi
  local proj newest
  proj=$(printf '%s' "$PWD" | sed 's,[/.],-,g')
  # List the dir (no glob — an unmatched glob errors under zsh's nomatch and
  # bypasses 2>/dev/null); -t sorts by mtime, newest first. `command ls` avoids
  # any `ls` alias (e.g. eza, whose -t flag means something else).
  # shellcheck disable=SC2012,SC2010  # ls -t = portable mtime sort; names are UUID.jsonl
  newest=$(command ls -t "$config_dir/projects/$proj" 2>/dev/null | grep '\.jsonl$' | head -1)
  [[ -n "$newest" ]] && printf '%s' "${newest%.jsonl}"
}

# claudex — unified Claude launcher
#
# Usage: claudex [OPTIONS] [ACTION] [-- ARGS...]
#
# Options:
#   -u N, --user N    Config dir ~/.claudeN  (N≥1; default: 1 → ~/.claude)
#   -r,   --remote    Remote-control spawn (sets CLAUDE_REMOTE=1)
#   -e,   --env       Source .env before launching
#   -h,   --help      Print this help
#   --helpx           Pass --help to claude
#
# Actions (all implicitly wait for rate-limit before acting):
#   --wait                           Poll until tokens available, exit 0
#   --continue [SESSION]             Resume SESSION (newest in cwd) in auto permission mode
#   --continue [SESSION] --prompt P  Resume SESSION with prompt P
#   --prompt P                       Start a new session with prompt P
#
#   Without an action, passes remaining ARGS directly to claude.
function claudex() {
  local user_num=1 do_remote=0 do_env=0
  local do_wait=0 do_continue=0 do_prompt=0
  local continue_session="" prompt=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -h | --help)
      cat <<'EOF'
claudex — unified Claude launcher

Usage: claudex [OPTIONS] [ACTION] [-- ARGS...]

Options:
  -u N, --user N    Config dir ~/.claudeN  (N≥1; default: 1 → ~/.claude)
  -r,   --remote    Remote-control spawn (sets CLAUDE_REMOTE=1)
  -e,   --env       Source .env before launching
  -h,   --help      Print this help
  --helpx           Pass --help to claude

Actions (all wait for rate-limit before acting):
  --wait                            Poll until tokens available, exit 0
  --continue [SESSION]              Resume SESSION (newest in cwd) in auto permission mode
  --continue [SESSION] --prompt P   Resume SESSION with prompt P
  --prompt P                        Start a new session with prompt P

  Without an action, passes remaining args directly to claude.

Examples:
  claudex --wait && notify 'Tokens available!'
  claudex --continue
  claudex --continue abc-123
  claudex --continue --prompt 'continue the refactor'
  claudex --continue abc-123 --prompt 'push through to completion'
  claudex --prompt 'explain this codebase'
  claudex -u 2 --prompt 'review this PR'
  claudex --helpx
EOF
      return 0
      ;;
    --helpx)
      claude --help
      return
      ;;
    -u | --user)
      [[ $# -lt 2 ]] && {
        echo "claudex: --user requires an argument" >&2
        return 1
      }
      user_num="$2"
      shift 2
      ;;
    -r | --remote)
      do_remote=1
      shift
      ;;
    -e | --env)
      do_env=1
      shift
      ;;
    --wait)
      do_wait=1
      shift
      ;;
    --continue)
      do_continue=1
      if [[ $# -ge 2 && "$2" != -* ]]; then
        continue_session="$2"
        shift 2
      else
        shift
      fi
      ;;
    --prompt)
      [[ $# -lt 2 ]] && {
        echo "claudex: --prompt requires an argument" >&2
        return 1
      }
      do_prompt=1
      prompt="$2"
      shift 2
      ;;
    --)
      shift
      break
      ;;
    *) break ;;
    esac
  done

  if ! [[ "$user_num" =~ ^[1-9][0-9]*$ ]]; then
    echo "claudex: --user requires a positive integer (got: '$user_num')" >&2
    return 1
  fi

  local config_dir
  [[ "$user_num" -eq 1 ]] &&
    config_dir="${HOME}/.claude" ||
    config_dir="${HOME}/.claude${user_num}"

  [[ "$do_env" -eq 1 && -f .env ]] && source .env

  # --wait alone: poll until tokens clear, exit 0
  if [[ "$do_wait" -eq 1 && "$do_continue" -eq 0 && "$do_prompt" -eq 0 ]]; then
    _claude_poll "$config_dir" 2>/dev/null
    return
  fi

  # --continue and/or --prompt: wait then act
  if [[ "$do_continue" -eq 1 || "$do_prompt" -eq 1 ]]; then
    local session_id
    if [[ "$do_continue" -eq 1 ]]; then
      session_id=$(_claude_resolve_session "$config_dir" "$continue_session")
      if [[ -n "$session_id" ]]; then
        echo "Resuming session: $session_id" >/dev/tty
      else
        echo "Resuming last session (-c)" >/dev/tty
      fi
    fi

    _claude_poll "$config_dir" 2>/dev/null || return 1

    if [[ "$do_continue" -eq 1 ]]; then
      # auto mode: a classifier auto-approves routine actions (edits, tests,
      # lockfile installs, git on the current branch) and only blocks dangerous
      # ones (curl|bash, prod deploys, force-push to main). acceptEdits would
      # still prompt on every non-edit Bash command, defeating unattended resume.
      local msg="${prompt:-continue}"
      if [[ -n "$session_id" ]]; then
        _claude_invoke "$config_dir" --permission-mode auto --resume "$session_id" "$msg"
      else
        _claude_invoke "$config_dir" --permission-mode auto -c "$msg"
      fi
    else
      # --prompt alone: new session
      _claude_invoke "$config_dir" "$prompt" "$@"
    fi
    return
  fi

  # Plain invocation
  if [[ "$do_remote" -eq 1 ]]; then
    CLAUDE_REMOTE=1 _claude_invoke "$config_dir" remote-control --spawn=same-dir "$@"
  else
    _claude_invoke "$config_dir" "$@"
  fi
}

# --- completion helpers (plain sh; usable from both bash and zsh) ----------------

# Available user numbers: 1, plus any existing ~/.claudeN config dirs.
# Lists $HOME (no glob — an unmatched glob errors under zsh's nomatch).
_claudex_complete_users() {
  printf '%s\n' 1
  command ls -1A "$HOME" 2>/dev/null | grep -E '^\.claude[0-9]+$' | sed 's/^\.claude//'
}

# Session IDs (newest first) for the given user number, scoped to the cwd's
# project dir — same encoding as _claude_resolve_session.
_claudex_complete_sessions() {
  local n="${1:-1}" config_dir proj
  [[ "$n" == 1 ]] && config_dir="$HOME/.claude" || config_dir="$HOME/.claude$n"
  proj=$(printf '%s' "$PWD" | sed 's,[/.],-,g')
  # shellcheck disable=SC2012,SC2010  # ls -t = portable mtime sort; names are UUID.jsonl
  command ls -t "$config_dir/projects/$proj" 2>/dev/null | grep '\.jsonl$' | sed 's/\.jsonl$//'
}

# --- completion registration -----------------------------------------------------

if [ -n "${ZSH_VERSION-}" ]; then
  if [[ $- == *i* ]]; then
    _claudex() {
      local curcontext="$curcontext" state line unum=1 i
      typeset -A opt_args
      for ((i = 1; i <= $#words; i++)); do
        if [ "${words[i]}" = "-u" ] || [ "${words[i]}" = "--user" ]; then
          unum=${words[i + 1]:-1}
        fi
      done
      _arguments -C \
        '(-u --user)'{-u,--user}'[config dir ~/.claudeN]:user number:->users' \
        '(-r --remote)'{-r,--remote}'[remote-control spawn]' \
        '(-e --env)'{-e,--env}'[source .env before launching]' \
        '(-h --help)'{-h,--help}'[show claudex help]' \
        '--helpx[pass --help through to claude]' \
        '--wait[poll until tokens available, then exit]' \
        '--continue[resume newest session in cwd]::session:->sessions' \
        '--prompt[start/resume with a prompt]:prompt:' \
        '*::claude args:_default'
      case "$state" in
      users) compadd -- $(_claudex_complete_users) ;;
      sessions) compadd -o nosort -- $(_claudex_complete_sessions "$unum") ;;
      esac
    }
    compdef _claudex claudex
  fi
elif [ -n "${BASH_VERSION-}" ]; then
  if [[ $- == *i* ]]; then
    _claudex() {
      local cur prev unum=1 i
      cur="${COMP_WORDS[COMP_CWORD]}"
      prev="${COMP_WORDS[COMP_CWORD - 1]}"
      for ((i = 1; i < COMP_CWORD; i++)); do
        case "${COMP_WORDS[i]}" in
        -u | --user) unum="${COMP_WORDS[i + 1]:-1}" ;;
        esac
      done
      # shellcheck disable=SC2207  # values are flags/UUIDs (no spaces); bash 3.2 has no mapfile
      case "$prev" in
      -u | --user)
        COMPREPLY=($(compgen -W "$(_claudex_complete_users)" -- "$cur"))
        return
        ;;
      --continue)
        COMPREPLY=($(compgen -W "$(_claudex_complete_sessions "$unum")" -- "$cur"))
        return
        ;;
      --prompt) return ;; # free-form text
      esac
      COMPREPLY=($(compgen -W \
        "-u --user -r --remote -e --env -h --help --helpx --wait --continue --prompt" -- "$cur"))
    }
    complete -F _claudex claudex
  fi
fi
