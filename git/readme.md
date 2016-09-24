# Git

## Aliases

### Shorter versions of common commands

```
ad = add
cl = clone
cm = commit
co = checkout
cp = cherry-pick
df = diff
fe = fetch
lg = log --pretty
rb = rebase
rl = reflog --pretty
st = status
```

### Finding aliases

Some commands for finding aliases.

- `git alias ALIAS` - Find an alias.
- `git aliases` - List all aliases.

Example:
```
$ git alias log
logpretty           => !git log --pretty=custom
loggraph            => !git log --graph --pretty=custom
logfiles            => !git log --pretty=custom --numstat --decorate --name-status
logdiff             => !git log -M --follow --stat --pretty=custom -p --color-words
reflogpretty        => !git reflog --pretty=customreflog
```

### Log aliases

Aliases related with `git log`.

- `git logpretty` - (`lg`) Pretty log.
- `git loggraph` - (`lgg`) Pretty log + graph.
- `git logfiles` - (`lgf`) Pretty log + file changes.
- `git logdiff FILE` - (`lgd`) Pretty log + diff. Better replacement for `git blame`.

### Status aliases

Aliases related with `git status`.

- `git st` - Shorter version of `git status`
- `git sts` - Shorter version of `git status -s`. Shows minimal status.
- `git sta` - Shorter version of `git status -v`. Shows diff.

```
$ git sts
 M git/.gitconfig_aliases
 M git/readme.md
```

### Commit aliases

Aliases related with `git commit`.

- `git cm` - Shorter version `git commit`.
- `git commitall` - (`cma`) Stage all and commit all.
- `git uncommit` - Revert the act of commiting. Shorter version of `git reset --soft HEAD^`.
- `git amend` - (`an`) Amend all changes.
- `git amendall` - (`ana`) Stage all and amend all changes.
- `git amendmessage $MSG` - Amend new commit message.
- `git amendauthor [$NAME] [$EMAIL]` - Amend new commit author. By default name and email are taken from git config.

### Commit traversal aliases

Aliases that enables traversing through commit history.

- `git prevcommit` - Go to previous commit.
- `git nextcommit` - Go to next commit. If there is no child commit it will attempt to checkout related branch.

### Add aliases

Aliases related with `git add`.

- `git ad` - Shorter version of `git add`.
- `git ada` - Shorter version of `git add -A`.

### Undo aliases

[Undoing things](http://stackoverflow.com/a/2846154/2284884). Makes no changes to your files.

- `git uncommit` - Undo commit. Alias for `git reset --soft HEAD^`.
- `git unadd [FILE]` - Undo staging. Alias for `git reset HEAD --`.
- `git undo` - Undo commit and staging. Alias for `git reset HEAD^`.

### Drop aliases

[Dropping things](https://www.atlassian.com/git/tutorials/undoing-changes/git-reset). Be aware that dropping things will make changes to your files.

- `git dropcommit` - Drop last commit.
- `git dropunadded` - Drop all untracked files.
- `git dropadded` - Drop all indexed changes.
- `git drop` - Drop all local and indexed changes.

### Fetch aliases

Aliases related with `git fetch`.

- `git fe` - Shorter version of `git fetch`.
- `git fetchmaster` - (`fem`) Fetch remote master.
- `git fetchbranch [$BRANCH]` - (`feb`) Fetch remote branch. If no $BRANCH is specified the current branch will be fetched.

### Checkout aliases

Aliases related with `git checkout`.

- `git co` - Shorter version of `git checkout`.
- `git checkoutmaster` - (`com`) Checkout master.
- `git checkoutsynced` - (`cos`) Checkout branch and pull changes. If no branch is specified `master` branch is used.

### Diff aliases

Aliases related with `git diff` ([how does diff work](http://stackoverflow.com/a/1587952/2284884)). Remember that untracked files are not visible for `git diff` command.

- `git df` - Shorter version of `git diff`.
- `git diffwords` - (`dfw`) Diff words only. No pluses and minuses. Easier to read.
- `git diffall` - (`dfa`) Diff all (tracked and untracked) with HEAD.
- `git difftracked` - (`dft`) Diff tracked files with HEAD
- `git diffpatch` - (`dfp`) Diff that includes all changes including binaries. Could be used as a patch file and applied with `git apply <filename>`.

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
