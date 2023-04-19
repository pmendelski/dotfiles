#!/usr/bin/env bash

if [ -n "${BASH_VERSION}" ] && [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
else
  if [ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ]; then
    source "/usr/share/doc/fzf/examples/key-bindings.bash"
  fi
fi

# FZF finders
export FZF_FIND_ANY='fd --hidden --exclude .git --strip-cwd-prefix'
export FZF_FIND_FILE="$FZF_FIND_ANY --type f"
export FZF_FIND_DIR="$FZF_FIND_ANY --type d"
# FZF previews
export FZF_PREVIEW_FILE='bat -n --color=always --line-range=:500 {}'
export FZF_PREVIEW_DIR='tree -C {} | head -200'
export FZF_PREVIEW_ANY="if [ -d {} ]; then $FZF_PREVIEW_DIR; else $FZF_PREVIEW_FILE; fi"
# FZF defaults
export FZF_DEFAULT_COMMAND="$FZF_FIND_FILE"
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --info=inline --color header:italic'

# CTRL-T - print location
export FZF_CTRL_T_COMMAND="$FZF_FIND_ANY"
export FZF_CTRL_T_OPTS="
  --multi
  --bind='ctrl-g:reload($FZF_FIND_ANY)'
  --bind='ctrl-g:+change-prompt()'
  --bind='ctrl-g:+change-preview($FZF_PREVIEW_ANY)'
  --bind='ctrl-g:+refresh-preview'
  --bind='ctrl-f:reload($FZF_FIND_FILE)'
  --bind='ctrl-f:+change-prompt(Files: )'
  --bind='ctrl-f:+change-preview($FZF_PREVIEW_FILE)'
  --bind='ctrl-f:+refresh-preview'
  --bind='ctrl-d:reload($FZF_FIND_DIR)'
  --bind='ctrl-d:+change-prompt(Dirs: )'
  --bind='ctrl-d:+change-preview($FZF_PREVIEW_DIR)'
  --bind='ctrl-d:+refresh-preview'
  --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --bind='ctrl-a:select-all'
  --bind='ctrl-n:deselect-all'
  --bind='ctrl-e:become(nvim {+})'
  --bind='ctrl-/:change-preview-window(down|hidden|right)'
  --preview='$FZF_PREVIEW_ANY'
  --height='50%'
  --layout='reverse'
"

# ALT-C - cd to directory
export FZF_ALT_C_COMMAND="$FZF_FIND_DIR"
export FZF_ALT_C_OPTS_ARR=(
  "--preview=$FZF_PREVIEW_DIR"
  "--bind=ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort"
  "--bind=ctrl-e:become(nvim {+})"
  "--bind=ctrl-/:change-preview-window(down|hidden|)"
)
export FZF_ALT_C_OPTS="${FZF_ALT_C_OPTS_ARR[*]}"

# CTRL-R - Search history
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'C-y copy, C-/ preview'"

# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-between-ripgrep-mode-and-fzf-mode
export FZF_RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
export FZF_RG_OPTS="
  --ansi
  --color='hl:-1:underline,hl+:-1:underline:reverse'
  --bind='change:reload:sleep 0.1; $FZF_RG_PREFIX {q} || true'
  --bind='ctrl-f:unbind(change,ctrl-f)+change-prompt(fzf > )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)'
  --bind='ctrl-r:unbind(ctrl-r)+change-prompt(rg > )+disable-search+reload($FZF_RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)'
  --bind='start:unbind(ctrl-r)'
  --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --bind='ctrl-e:become(nvim {+})'
  --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --bind='ctrl-a:select-all'
  --bind='ctrl-n:deselect-all'
  --bind='ctrl-e:become(nvim {1} +{2})'
  --prompt='rg > '
  --delimiter=':'
  --header='C-r (ripgrep mode) ╱ C-f (fzf mode) ╱'
  --preview='bat --color=always {1} --highlight-line {2}'
  --preview-window='up,60%,border-bottom,+{2}+3/3,~3'
"

# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates after **<tab>
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  $FZF_FIND_ANY "$1"
}

# Use fd to generate the list for directory completion after **<tab>
_fzf_compgen_dir() {
  $FZF_FIND_DIR "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
  cd) fzf --preview "$FZF_PREVIEW_DIR" "$@" ;;
  export | unset) fzf --preview "eval 'echo \$'{}" "$@" ;;
  ssh) fzf --preview 'dig {}' "$@" ;;
  *) fzf --preview "$FZF_PREVIEW_FILE" "$@" ;;
  esac
}

fvim() {
  FZF_DEFAULT_COMMAND="$FZF_CTRL_T_COMMAND" \
    FZF_DEFAULT_OPTS="$FZF_CTRL_T_OPTS" \
    fzf --bind 'enter:become(nvim {+})'
}

fvimrg() {
  INITIAL_QUERY="${*:-}"
  FZF_DEFAULT_COMMAND="$FZF_RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
  FZF_DEFAULT_OPTS="$FZF_RG_OPTS" \
    fzf \
    --disabled --query "$INITIAL_QUERY" \
    --bind 'enter:become(nvim {1} +{2})'
}

fcd() {
  FZF_DEFAULT_COMMAND="$FZF_ALT_C_COMMAND" \
    FZF_DEFAULT_OPTS="$FZF_ALT_C_OPTS" \
    fzf --bind 'enter:become(z {})'
}

fcde() {
  selection="$(
    FZF_DEFAULT_COMMAND="echo .. && $FZF_FIND_ANY --exact-depth 1" \
      FZF_DEFAULT_OPTS="$FZF_CTRL_T_OPTS" \
      fzf \
      --bind='ctrl-o:become(echo ..)' \
      --bind='ctrl-i:become(echo {1})'
  )"
  if [ -z "$selection" ]; then
    return 0
  fi
  n="$(echo "$selection" | wc -l)"
  if [ "$n" = 0 ]; then
    return 0
  fi
  if [ "$n" = 1 ] && [ -d "$selection" ]; then
    cd "$selection" && fcde
  else
    nvim "$selection"
  fi
}

frg() {
  INITIAL_QUERY="${*:-}"
  FZF_DEFAULT_COMMAND="$FZF_RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
  FZF_DEFAULT_OPTS="$FZF_RG_OPTS" \
    fzf --disabled --query "$INITIAL_QUERY"
}

fgrepp() {
  local -r name="${1:?Expected file name}"
  INITIAL_QUERY=""
  FZF_DEFAULT_COMMAND="$FZF_RG_PREFIX --no-column $(printf %q "$INITIAL_QUERY") \"$name\"" \
  FZF_DEFAULT_OPTS="
    --ansi
    --prompt='rg > '
    --delimiter=':'
    --layout=reverse
    --bind='change:reload:$FZF_RG_PREFIX --no-column {q} \"$name\" || true'
    --bind='ctrl-e:execute:nvim \"$name\" +{1}'
    --bind='enter:become(nvim \"$name\" +{1})'
    --preview='bat --color=always \"$name\" --highlight-line {1}'
    " \
    fzf --disabled --query "$INITIAL_QUERY"
}

fproc() {
  procs="ps -ef"
  killcmd="for d in {+}; do echo \"\$d\" | awk '{ print \$2 }' | xargs kill -9; done"
  (
    date
    eval $procs
  ) |
    fzf \
      --multi \
      --bind="ctrl-r:reload(date; $procs)" \
      --bind="enter:become($killcmd)" \
      --bind="ctrl-x:execute-silent($killcmd)+reload(date; $procs)" \
      --header=$'C-r reload / C-x kill\n' \
      --header-lines=2 \
      --preview='echo {}' \
      --preview-window=down,5,wrap \
      --layout=reverse --height=80%
}

fnproc() {
  procs="lsof -i -P -n | head -n 1 && lsof -i -P -n | grep IPv4 | grep LISTEN"
  killcmd="for d in {+}; do echo \"\$d\" | awk '{ print \$2 }' | xargs kill -9; done"
  (
    date
    eval $procs
  ) |
    fzf \
      --multi \
      --bind="ctrl-r:reload(date; $procs)" \
      --bind="enter:become($killcmd)" \
      --bind="ctrl-x:execute-silent($killcmd)+reload(date; $procs)" \
      --header=$'C-r reload / C-x kill\n' \
      --header-lines=2 \
      --preview='echo {}' \
      --preview-window=down,5,wrap \
      --layout=reverse --height=80%
}
