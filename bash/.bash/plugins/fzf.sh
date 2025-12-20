#!/usr/bin/env bash

if [ -n "${BASH_VERSION}" ]; then
  if [ -f ~/.fzf.bash ]; then
    source ~/.fzf.bash
  else
    if [ -f "/usr/share/doc/fzf/examples/key-bindings.bash" ]; then
      source "/usr/share/doc/fzf/examples/key-bindings.bash"
    fi
  fi
fi

# FZF finders
export FZF_FIND_ANY="fd --exclude .git --strip-cwd-prefix ${FZF_PATHS-}"
if [ -f "$HOME/.fzf-paths" ] && [ -x "$HOME/.fzf-paths" ]; then
  # To limit paths define ~/.fzf-paths
  export FZF_FIND_ANY="fd --exclude .git . \$($HOME/.fzf-paths)"
elif [ -f "$HOME/.dotfiles-ext/bash/.fzf-paths" ] && [ -x "$HOME/.dotfiles-ext/bash/.fzf-paths" ]; then
  # To limit paths define ~/.fzf-paths
  export FZF_FIND_ANY="fd --exclude .git . \$($HOME/.dotfiles-ext/bash/.fzf-paths)"
fi

export FZF_FIND_FILE="$FZF_FIND_ANY --type f"
export FZF_FIND_DIR="$FZF_FIND_ANY --type d"
# FZF previews
export FZF_PREVIEW_FILE='bat -n --color=always --line-range=:500 {}'
if command -v eza &>/dev/null; then
  export FZF_PREVIEW_DIR='eza --tree --color=always {} | head -200'
else
  export FZF_PREVIEW_DIR='tree -C {} | head -200'
fi
export FZF_PREVIEW_ANY="if [ -d {} ]; then $FZF_PREVIEW_DIR; else $FZF_PREVIEW_FILE; fi"
# FZF defaults
export FZF_DEFAULT_COMMAND="$FZF_FIND_FILE"
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --info=inline --color header:italic'

# CTRL-T - print location
export FZF_CTRL_T_COMMAND="$FZF_FIND_ANY"
export FZF_CTRL_T_OPTS="
  --multi
  --color header:italic
  --header='C-f find file / C-d find dir ╱ C-g find any ╱ C-y copy ╱ C-e vim ╱ C-/ preview'
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
export FZF_ALT_C_OPTS_ARR="
  --preview='$FZF_PREVIEW_DIR'
  --color header:italic
  --header='C-e vim ╱ C-y copy ╱ C-/ preview'
  --bind='ctrl-y:execute-silent(echo -n {1..} | pbcopy)+abort'
  --bind='ctrl-e:become(nvim {+})'
  --bind='ctrl-/:change-preview-window(down|hidden|)'
"
export FZF_ALT_C_OPTS="${FZF_ALT_C_OPTS_ARR[*]}"
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS"

# CTRL-R - Search history
# CTRL-/ to toggle small preview window to see the full command
# CTRL-Y to copy the command into clipboard using pbcopy
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'C-y copy ╱ C-/ preview'"

# https://github.com/junegunn/fzf/blob/master/ADVANCED.md#switching-between-ripgrep-mode-and-fzf-mode
export FZF_RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
export FZF_RG_OPTS="
  --ansi
  --color='hl:-1:underline,hl+:-1:underline:reverse'
  --bind='change:reload:sleep 0.1; $FZF_RG_PREFIX {q} || true'
  --bind='ctrl-f:unbind(change,ctrl-f)+change-prompt(fzf > )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)'
  --bind='ctrl-r:unbind(ctrl-r)+change-prompt(rg > )+disable-search+reload($FZF_RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)'
  --bind='start:unbind(ctrl-r)'
  --bind='ctrl-e:become(nvim {+})'
  --bind='ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --bind='ctrl-a:select-all'
  --bind='ctrl-n:deselect-all'
  --bind='ctrl-e:become(nvim {1} +{2})'
  --prompt='rg > '
  --delimiter=':'
  --header='C-r ripgrep ╱ C-f fzf mode'
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

fzvim() {
  local -r dir="$(
    INITIAL_QUERY="${1}"
    FZF_DEFAULT_COMMAND="zoxide query $(printf %q "$INITIAL_QUERY") -l | grep -v \"^\$(pwd)/$\" | sed \"s|\$(pwd)/|./|\" " \
    FZF_DEFAULT_OPTS="
    --multi
    --color header:italic
    --header='C-y copy ╱ C-/ preview'
    --bind='ctrl-y:execute-silent(echo -n {1..} | pbcopy)+abort'
    --bind='ctrl-a:select-all'
    --bind='ctrl-n:deselect-all'
    --bind='ctrl-/:change-preview-window(down|hidden|right)'
    --preview='$FZF_PREVIEW_ANY'
    --height='50%'
    --layout='reverse'
    --bind='change:reload:sleep 0.1; zoxide query {q} -l | grep -v \"^\$(pwd)$\" | sed \"s|\$(pwd)/|./|\" || true'
    " \
      fzf \
      --disabled --query "$INITIAL_QUERY"
  )"
  if [ -n "$dir" ]; then
    nvim "$dir"
  fi
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
  local -r dir="$(
    FZF_DEFAULT_COMMAND="$FZF_ALT_C_COMMAND" \
      FZF_DEFAULT_OPTS="$FZF_ALT_C_OPTS" \
      fzf
  )"
  if [ -n "$dir" ]; then
    z "$dir"
  fi
}

fz() {
  local -r dir="$(
    INITIAL_QUERY="${1}"
    FZF_DEFAULT_COMMAND="zoxide query $(printf %q "$INITIAL_QUERY") -l | grep -v \"^\$(pwd)/$\" | sed \"s|\$(pwd)/|./|\" " \
    FZF_DEFAULT_OPTS="
    --multi
    --color header:italic
    --header='C-y copy ╱ C-e vim ╱ C-/ preview'
    --bind='ctrl-y:execute-silent(echo -n {1..} | pbcopy)+abort'
    --bind='ctrl-a:select-all'
    --bind='ctrl-n:deselect-all'
    --bind='ctrl-e:become(echo @nvim@{1})'
    --bind='ctrl-/:change-preview-window(down|hidden|right)'
    --preview='$FZF_PREVIEW_ANY'
    --height='50%'
    --layout='reverse'
    --bind='change:reload:sleep 0.1; zoxide query {q} -l | grep -v \"^\$(pwd)$\" | sed \"s|\$(pwd)/|./|\" || true'
    " \
      fzf \
      --disabled --query "$INITIAL_QUERY"
  )"
  if [ "${dir:0:6}" = "@nvim@" ]; then
    nvim "${dir:6}"
  elif [ -n "$dir" ]; then
    z "$dir"
  fi
}

# Fzf file traversal with preview
fcde() {
  selection="$(
    FZF_DEFAULT_COMMAND="$FZF_FIND_ANY --exact-depth 1" \
      FZF_DEFAULT_OPTS="$FZF_CTRL_T_OPTS" \
      fzf \
      --color header:italic \
      --header=$'C-c cd ╱ C-o out ╱ C-i in ╱ C-e vim\n' \
      --bind='ctrl-c:become(echo @cd@{1})' \
      --bind='ctrl-c:become(echo @nvim@{1})' \
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
  elif [ "${selection:0:6}" = "@nvim@" ]; then
    nvim "${selection:6}"
  elif [ "$n" = 1 ] && [ "${selection:0:4}" = "@cd@" ]; then
    cd "${selection:4}"
  else
    nvim "$selection"
  fi
}

# Fzf file
frg() {
  INITIAL_QUERY="${*:-}"
  FZF_DEFAULT_COMMAND="$FZF_RG_PREFIX $(printf %q "$INITIAL_QUERY")" \
  FZF_DEFAULT_OPTS="$FZF_RG_OPTS" \
    fzf --disabled --query "$INITIAL_QUERY"
}

# Fzf file content
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

# Fzf all processes
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
      --color header:italic \
      --header=$'C-r reload / C-x kill\n' \
      --header-lines=2 \
      --preview='echo {}' \
      --preview-window=down,5,wrap \
      --layout=reverse --height=80%
}

# Fzf network processes
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
      --color header:italic \
      --header=$'C-r reload / C-x kill\n' \
      --header-lines=2 \
      --preview='echo {}' \
      --preview-window=down,5,wrap \
      --layout=reverse --height=80%
}
