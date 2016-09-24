# Git

## Shorter versions of common commands

```
lg = log --pretty
st = status -s
ad = add
cl = clone
co = checkout
cm = commit -av
cp = cherry-pick
fe = fetch
df = diff
rb = rebase
rl = reflog --pretty
```

## Aliases

Some commands for finding aliases.

- `git alias ALIAS` - find alias
- `git aliases` - list all aliases

Example:
```
$ git alias log
logpretty           => !git log --pretty=custom
loggraph            => !git log --graph --pretty=custom
logfiles            => !git log --pretty=custom --numstat --decorate --name-status
logdiff             => !git log -M --follow --stat --pretty=custom -p --color-words
reflogpretty        => !git reflog --pretty=customreflog
```

## Aliases

### Log aliases

- `git logpretty [LOG_OPTS] [FILE]` - (`lg`) Pretty log
- `git loggraph [LOG_OPTS] [FILE]` - (`lgg`) Pretty log + graph
- `git logfiles [LOG_OPTS] [FILE]` - (`lgf`) Pretty log + file changes
- `git logdiff [LOG_OPTS] FILE` - (`lgd`) Pretty log + diff. Better replacement for `git blame`.

```
git logpretty   - (`lg`) Pretty log
git loggraph    - (`lgg`) Pretty log + graph
git logfiles    - (`lgf`) Pretty log + files
git logdiff     - (`lgd`) Pretty log + diff. Better than `git blame`!
```

### Status aliases

```
git st          - (`st`) Shorter version of `git status`
git statusshort - (`sts`) Shorter version of `git status -s`
```

### Commit aliases

```
git cm              - Shorter version `git commit -av`
git commitall       - (`cma`) Stage all and commit all
git amend [$MSG]    - (`an`) Amend changes. If no message is specified message from last commit is used.
git amendall [$MSG] - (`ana`) Stage all and amend changes. If no message is specified message from last commit is used.
git amendauthor [$NAME $EMAIL] - (`anu`) Change last commit author (if not specified name and email is taken from git config)
```

### Add aliases

```
git addall - (`ada`) Add all
```

### Fetch aliases

```
git fe          - Shorter version of `git fetch`
git fetchmaster - (`fem`) Fetch remote master
git fetchbranch [$BRANCH] - (`feb`) Fetch remote branch. If no $BRANCH is specified the current branch will be fetched.
```

### Checkout aliases

```
git co              - Shorter version of `git checkout`
git checkoutmaster  - (`com`) Checkout master
git checkoutsynced  - (`cos`) Checkout and pull changes. If no branch is specified `master` branch is used.
```

### Diff aliases

```
git diffwords   - (`df`) Diff words only. No pluses and minuses. Easier to read.
git diffall     - (`dfa`) Diff all with head
git difftracked - (`dft`) Diff tracked files with head
git diffpatch   - (`dfp`) Diff all including binaries. Could be used as patch file and applied with `git apply <filename>`
```

### [Undo](https://www.atlassian.com/git/tutorials/undoing-changes/git-clean) aliases

```
git undo            - (`un`) Undo all
git undotracked     - (`unt`) Undo tracked changes
git undountracked   - (`unu`) Undo untracked changes
```

### Rebase aliases

```
git rb                      - Shorter version for `git rebase`
git rebaseremote [$BRANCH]  - (`rbr`) Rebase remote $BRANCH
git rebaseremotemaster      - (`rbrm`) Rebase remote master
```

### Squash aliases

```
git squash [$COMMITS] [$MSG] - (`sq`) Squash last $COMMITS commits with $MSG. Defaults: COMMITS=all commit between branch and upstream, MSG=last commit msg.
git squashi [$COMMITS]       - (`sqi`) Interactively squash last $COMMITS commits. Defaults: COMMITS=all commit between branch and upstream.
git squashall [$MSG]         -  Squash all commits available on the branch
git squashiall [$MSG]        -  Interactively squash all commits available on the branch
```

### Tag aliases

```
git taglast  - (`tgl`) Show last tag
git tagretag - (`tgr`) Drop last tag and retag latest commit
```

### Find aliases

```
git findfile $PHRASE     - (`fnf`) Find files by content
git findbranch $COMMIT   - (`fnb`) Find branches by commit
git findtags $COMMIT     - (`fnt`) Find tags by commit
git findcommit $PHRASE   - (`fnc`) Find commits by phrase
git findcommitbymsg $MSG - (`fncm`) Find commits by message
```

### Listing aliases

```
git tags         - List tags
git branches     - List branches
git remotes      - List remotes
git aliases      - List aliases
git contributors - List contributors
```
