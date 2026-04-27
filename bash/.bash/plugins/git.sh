#!/usr/bin/env bash

git_branch_status() {
  local repo_info rev_parse_exit_code
  repo_info="$(git rev-parse --git-dir --is-inside-git-dir \
    --is-bare-repository --is-inside-work-tree \
    --short HEAD 2>/dev/null)"
  rev_parse_exit_code="$?"

  if [ -z "$repo_info" ]; then
    # not in git repository
    return
  fi

  local short_sha
  if [ "$rev_parse_exit_code" = "0" ]; then
    short_sha="${repo_info##*$'\n'}"
    repo_info="${repo_info%$'\n'*}"
  fi

  # parse flags from rev-parse
  local inside_worktree="${repo_info##*$'\n'}"
  repo_info="${repo_info%$'\n'*}"
  local bare_repo="${repo_info##*$'\n'}"
  repo_info="${repo_info%$'\n'*}"
  local inside_gitdir="${repo_info##*$'\n'}"
  local g="${repo_info%$'\n'*}"

  if [ "true" = "$inside_worktree" ] &&
    [ -n "${GIT_PS1_HIDE_IF_PWD_IGNORED-}" ] &&
    git check-ignore -q .; then
    # inside ignored directory
    return
  fi

  # in case of rebasing
  local rebaseStatus=""
  local rebaseBranch=""
  local rebaseStep=""
  local rebaseTotal=""
  if [ -d "$g/rebase-merge" ]; then
    __git_eread "$g/rebase-merge/head-name" rebaseBranch
    __git_eread "$g/rebase-merge/msgnum" rebaseStep
    __git_eread "$g/rebase-merge/end" rebaseTotal
    if [ -f "$g/rebase-merge/interactive" ]; then
      rebaseStatus="|REBASE-i"
    else
      rebaseStatus="|REBASE-m"
    fi
  else
    if [ -d "$g/rebase-apply" ]; then
      __git_eread "$g/rebase-apply/next" rebaseStep
      __git_eread "$g/rebase-apply/last" rebaseTotal
      if [ -f "$g/rebase-apply/rebasing" ]; then
        __git_eread "$g/rebase-apply/head-name" rebaseBranch
        rebaseStatus="|REBASE"
      elif [ -f "$g/rebase-apply/applying" ]; then
        rebaseStatus="|AM"
      else
        rebaseStatus="|AM/REBASE"
      fi
    elif [ -f "$g/MERGE_HEAD" ]; then
      rebaseStatus="|MERGING"
    elif [ -f "$g/CHERRY_PICK_HEAD" ]; then
      rebaseStatus="|CHERRY-PICKING"
    elif [ -f "$g/REVERT_HEAD" ]; then
      rebaseStatus="|REVERTING"
    elif [ -f "$g/BISECT_LOG" ]; then
      rebaseStatus="|BISECTING"
    fi

    if [ -n "$rebaseBranch" ]; then
      :
    elif [ -h "$g/HEAD" ]; then
      # symlink symbolic ref
      rebaseBranch="$(git symbolic-ref HEAD 2>/dev/null)"
    else
      local head=""
      if ! __git_eread "$g/HEAD" head; then
        return
      fi
      # is it a symbolic ref?
      rebaseBranch="${head#ref: }"
      if [ "$head" = "$rebaseBranch" ]; then
        # detached=yes
        rebaseBranch="$(
          case "${GIT_PROMPT_DESCRIBE_STYLE-}" in
          contains)
            git describe --contains HEAD
            ;;
          branch)
            git describe --contains --all HEAD
            ;;
          describe)
            git describe HEAD
            ;;
          default | *)
            git describe --tags --exact-match HEAD
            ;;
          esac 2>/dev/null
        )" ||
          rebaseBranch="$short_sha..."
        rebaseBranch="($rebaseBranch)"
      fi
    fi
  fi
  rebaseBranch=${rebaseBranch##refs/heads/}

  if [ -n "$rebaseStep" ] && [ -n "$rebaseTotal" ]; then
    rebaseStatus="$rebaseStatus $rebaseStep/$rebaseTotal"
  fi

  if [ "true" = "$inside_gitdir" ]; then
    if [ "true" = "$bare_repo" ]; then
      rebaseBranch="BARE:$rebaseBranch"
    else
      rebaseBranch="GIT_DIR!"
    fi
  fi
  echo "$rebaseBranch$rebaseStatus"
}

git_upstream_status() {
  # Find how many commits we are ahead/behind our upstream
  local count="$(git rev-list --count --left-right "@{upstream}...HEAD" 2>/dev/null)"
  local result

  # calculate the result
  case "$count" in
  "") # no upstream
    result="" ;;
  "0	0") # equal to upstream
    result="=" ;;
  "0	"*) # ahead of upstream
    result="+${count#0	}" ;;
  *"	0") # behind upstream
    result="-${count%	0}" ;;
  *) # diverged from upstream
    result="+${count#*	}-${count%	*}" ;;
  esac
  echo "$result"
}

git_upstream_name() {
  git rev-parse --abbrev-ref "@{upstream}" 2>/dev/null
}

git_status_flags() {
  # Returns "staged unstaged untracked" as 0/1 values via a single git call
  local staged=0 unstaged=0 untracked=0 x y
  while IFS= read -r line; do
    x="${line:0:1}" y="${line:1:1}"
    if [[ "$x" == '?' && "$y" == '?' ]]; then
      untracked=1
    else
      [[ "$x" != ' ' ]] && staged=1
      [[ "$y" != ' ' && "$y" != '?' ]] && unstaged=1
    fi
  done < <(git status --porcelain=v1 -unormal 2>/dev/null)
  echo "$staged $unstaged $untracked"
}

git_has_unstaged_changes() {
  ! git diff --no-ext-diff --quiet
  return $?
}

git_has_staged_changes() {
  ! git diff --no-ext-diff --cached --quiet
  return $?
}

git_has_untracked_files() {
  git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' >/dev/null 2>/dev/null
  return $?
}

git_has_stashed_changes() {
  git rev-parse --verify --quiet refs/stash >/dev/null
  return $?
}

git_stash_size() {
  git rev-list --walk-reflogs --count refs/stash 2>/dev/null
}

git_prompt() {
  local branchStatus="$(git_branch_status)"
  [ -z "$branchStatus" ] && return

  local staged unstaged untracked
  read -r staged unstaged untracked <<< "$(git_status_flags)"

  local dirtyStatus=""
  [ "$staged" = 1 ]   && dirtyStatus="$dirtyStatus+"
  [ "$unstaged" = 1 ] && dirtyStatus="$dirtyStatus*"
  if [ "$untracked" = 1 ]; then
    [ -n "${ZSH_VERSION-}" ] && dirtyStatus="$dirtyStatus%%" || dirtyStatus="$dirtyStatus%"
  fi

  local stashStatus="$(git_stash_size)"
  [ -z "$stashStatus" ] || [ ! "$stashStatus" -gt 0 ] && stashStatus=""

  local upstreamStatus="$(git_upstream_status)"
  [ "$upstreamStatus" = "=" ] && upstreamStatus=""

  local result="$branchStatus"
  [ "${dirtyStatus}" != "" ] && result="${result}${dirtyStatus}"
  [ "${stashStatus}" != "" ] && result="${result} S${stashStatus}"
  [ "${upstreamStatus}" != "" ] && result="${result} U${upstreamStatus}"
  echo "$result"
}

__git_eread() {
  local f="$1"
  shift
  test -r "$f" && read -r "$@" <"$f"
}
