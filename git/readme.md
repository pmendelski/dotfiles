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
re = rebase
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
- `git uncommit` - Revert the act of committing. Shorter version of `git reset --soft HEAD^`.
- `git amend` - (`an`) Amend all changes.
- `git amendall` - (`ana`) Stage all and amend all changes.
- `git amendmessage MSG` - Amend new commit message.
    - **MSG** - New commit message. This parameter is required.
- `git amendauthor [NAME] [EMAIL]` - Amend new commit author. By default name and email are taken from `git config`.
    - **NAME** - Author's name. Default value is `git config --get user.name`.
    - **EMAIL** - Author's email. Default value is `git config --get user.email`. Brackets (`<`, `>`) will be automatically added.

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

- `git unadd [FILE]` - Undo staging. Alias for `git reset HEAD --`. What was in staging area will untouched on working tree.
    - **FILE** - You can unadd specific files. By default all files will unadded.
- `git uncommit` - Undo commit. Alias for `git reset --soft HEAD^`. What was committed will be in staging area.
- `git undo` - Undo commit and staging. Alias for `git reset HEAD^`. What was committed and in staging area now will be on your working tree.
- `git undobranchcommits` - Undo all branch commits. Undo all

### Drop aliases

[Dropping things](https://www.atlassian.com/git/tutorials/undoing-changes/git-reset). Be aware that **these aliases will make changes to your files**.

- `git dropunadded` - Drop all unstaged changes.
- `git dropuncommitted` - Drop all uncommitted changes. Everything what was not staged nor committed will be dropped.
- `git dropcommit` - Drop all committed and uncommitted changes. It's like an 'undo' to previous commit.
- `git dropbranchchanges` - Drop all committed and uncommitted changes made on the branch. Be aware that it is a **dangerous** alias.

### Fetch aliases

Aliases related with `git fetch`.

- `git fe` - Shorter version of `git fetch`.
- `git fetchbranch [BRANCH]` - (`feb`) Fetch remote branch.
    - **BRANCH** - Name of the branch to be fetched. Default value is the name of the current branch.
- `git fetchmaster` - (`fem`) Fetch remote master.

### Checkout aliases

Aliases related with `git checkout`.

- `git co` - Shorter version of `git checkout`.
- `git checkoutsynced [BRANCH]` - (`cos`) Checkout branch and pull changes.
    - **BRANCH** - the name of a branch to be checked out. Default value is `master`. It means that executing `git checkoutsynced` will checkout master with pulled all changes from the remote.

### Diff aliases

Aliases related with `git diff` ([how does diff work](http://stackoverflow.com/a/1587952/2284884)). Remember that untracked files are not visible for `git diff` command.

- `git df` - Shorter version of `git diff`.
- `git diffwords` - (`dfw`) Diff words only. No pluses and minuses. Easier to read.
- `git diffall` - (`dfa`) Diff all (tracked and untracked) with HEAD.
- `git difftracked` - (`dft`) Diff tracked files with HEAD.
- `git diffpatch` - (`dfp`) Diff that includes all changes including binaries. Could be used as a patch file and applied with `git apply <filename>`.

### Reflog aliases

Aliases related with `git reflog`.

- `git rl` - Shorter version of `git reflog`.
- `git reflogpretty` - (`rlp`) Pretty printed reflog.

### Rebase aliases

Aliases related with `git rebase`.

- `git re` - Shorter version of `git rebase`
- `git rebaseremote [BRANCH]` - (`rer`) Rebase remote branch. By default current branch is used.
    - **BRANCH** - the name of the remote branch to be rebased with. Default value is **master**.  
- `git rebaseremotemaster` - (`rerm`) Very descriptive alias. Rebase remote master branch.

### Squash aliases

Aliases related with squashing commits with `git rebase -i`. Every command at the end will open an editor for an interactive rebase.

**In case of emergency**: To undo a rebase see the reflog and find HEAD state before rebasing. Than just execute `git reset --soft HEAD@{<THE_STATE_NUMBER>}`.

- **`git squash [X]`** - (`sq`) Squash commits.
    - *X* - may be a number of commits to be squashed.
    - *X* - may be a branch name. All commits made after branching from branch X will be squashed.
    - *X* - default value is **master**. Executing `git squash` will squash all your feature branch commits that are ahead of master.
- **`git squashup`** - (`squ`) Squash all commits that are ahead of the upstream.
- **`git squashall`** - (`sqa`) Squash all commits available on the branch. All commits even those created before branch will be squashed.

### Tag aliases


- `git taglast`  - (`tgl`) Show last tag
- `git tagretag` - (`tgr`) Drop last tag and retag latest commit


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
