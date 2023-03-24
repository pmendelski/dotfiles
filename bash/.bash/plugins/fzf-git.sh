#!/usr/bin/env bash

# Mostly copied from:
# https://github.com/junegunn/fzf-git.sh/blob/main/fzf-git.sh
# - changed cmd names to "fgit-*"
# - added more bindings
# - extracted subcommands to bash/scripts/fzf-git

__fzf_git="$HOME/.bash/scripts/fzf-git"

if [[ -z "$_fzf_git_cat" ]]; then
  # Sometimes bat is installed as batcat
  export _fzf_git_cat="cat"
  _fzf_git_bat_options="--style='${BAT_STYLE:-full}' --color=always --pager=never"
  if command -v batcat >/dev/null; then
    _fzf_git_cat="batcat $_fzf_git_bat_options"
  elif command -v bat >/dev/null; then
    _fzf_git_cat="bat $_fzf_git_bat_options"
  fi
fi

# Redefine this function to change the options
_fzf_git_fzf() {
  fzf \
    --layout=reverse --multi --height=50% --min-height=20 --border \
    --color='header:italic:underline' \
    --preview-window='right,50%,border-left' \
    --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

_fzf_git_check() {
  git rev-parse HEAD >/dev/null 2>&1 && return
  [[ -n $TMUX ]] && tmux display-message "Not in a git repository"
  return 1
}

fgit-files() {
  cmd="files=(); for f in {+}; do f=\"\$(echo \"\$f\" | cut -c4- | sed 's/.* -> //')\"; files+=(\$f); done; ${EDITOR:-vim} \${files[@]}"
  _fzf_git_check || return
  (
    git -c color.status=always status --short
    git ls-files | grep -vxFf <(
      git status -s | grep '^[^?]' | cut -c4-
      echo :
    ) | sed 's/^/   /'
  ) |
    _fzf_git_fzf -m --ansi --nth 2..,.. \
      --prompt 'Files > ' \
      --multi \
      --header $'C-o (open in browser) / C-e,enter (edit)\n\n' \
      --bind "ctrl-e:execute:$cmd" \
      --bind "ctrl-o:execute-silent:bash $__fzf_git file {-1}" \
      --bind "enter:become($cmd)" \
      --preview "git diff --no-ext-diff --color=always -- {-1} | sed 1,4d; $_fzf_git_cat {-1}" "$@"
}

fgit-branches() {
  _fzf_git_check || return
  bash "$__fzf_git" branches |
    _fzf_git_fzf --ansi \
      --prompt 'Branches > ' \
      --header-lines 2 \
      --tiebreak begin \
      --preview-window down,border-top,40% \
      --color hl:underline,hl+:underline \
      --no-hscroll \
      --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
      --bind "ctrl-o:execute-silent:bash $__fzf_git branch {}" \
      --bind "ctrl-l:change-prompt(All branches > )+reload:bash \"$__fzf_git\" all-branches" \
      --bind "enter:become(git checkout {1})" \
      --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' "$@"
}

fgit-tags() {
  _fzf_git_check || return
  git tag --sort -version:refname |
    _fzf_git_fzf --preview-window right,70% \
      --prompt 'Tags > ' \
      --header $'C-o (open in browser)\n\n' \
      --bind "ctrl-o:execute-silent:bash $__fzf_git tag {}" \
      --bind "enter:become(git checkout {1})" \
      --preview 'git show --color=always {}' "$@"
}

fgit-hashes() {
  _fzf_git_check || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
    _fzf_git_fzf --ansi --no-sort --bind 'ctrl-s:toggle-sort' \
      --prompt 'Hashes > ' \
      --header $'C-o (open in browser) / C-d (diff) / C-s (toggle sort)\n\n' \
      --bind "ctrl-o:execute-silent:bash $__fzf_git commit {}" \
      --bind 'ctrl-d:execute:grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git diff > /dev/tty' \
      --bind 'enter:become(grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git checkout)' \
      --color hl:underline,hl+:underline \
      --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | head -n 1 | xargs git show --color=always' "$@" |
    awk 'match($0, /[a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9][a-f0-9]*/) { print substr($0, RSTART, RLENGTH) }'
}

fgit-remotes() {
  _fzf_git_check || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
    _fzf_git_fzf --tac \
      --prompt 'Remotes > ' \
      --bind 'ctrl-y:execute-silent(echo -n {1} | pbcopy)' \
      --header $'C-o (open in browser)\n\n' \
      --bind "ctrl-o:execute-silent:bash $__fzf_git remote {1}" \
      --bind "enter:execute-silent:bash $__fzf_git remote {1}" \
      --preview-window right,70% \
      --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {1}/"$(git rev-parse --abbrev-ref HEAD)"' "$@" |
    cut -d$'\t' -f1
}

fgit-stashes() {
  _fzf_git_check || return
  git stash list | _fzf_git_fzf \
    --prompt 'Stashes > ' \
    --header $'C-x (drop stash) / enter (pop)\n\n' \
    --bind 'ctrl-x:execute-silent(git stash drop {1})+reload(git stash list)' \
    --bind 'ctrl-y:execute-silent(echo -n {1} | pbcopy)' \
    --bind 'enter:become(git stash pop {1})' \
    -d: \
    --preview 'git show --color=always {1}' "$@" |
    cut -d: -f1
}

fgit-refs() {
  _fzf_git_check || return
  bash "$__fzf_git" refs | _fzf_git_fzf --ansi \
    --nth 2,2.. \
    --tiebreak begin \
    --prompt 'Refs > ' \
    --header-lines 2 \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --bind 'ctrl-y:execute-silent(echo -n {2} | pbcopy)' \
    --bind "ctrl-o:execute-silent:bash $__fzf_git {1} {2}" \
    --bind "ctrl-e:execute:${EDITOR:-vim} <(git show {2}) > /dev/tty" \
    --bind "ctrl-l:change-prompt(All refs > )+reload:bash \"$__fzf_git\" all-refs" \
    --bind "enter:become(git checkout {2})" \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {2}' "$@"
}
