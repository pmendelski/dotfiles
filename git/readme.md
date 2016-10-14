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
lg = log
re = rebase
rl = reflog
st = status
tg = tag
```

### Finding aliases

Some aliases for finding other aliases.

- **`git aliases`** - List all aliases.
- **`git aliases-doc`** - `(ald)` Open browser on this readme page.
- **`git alias ALIAS`** - `(al)` Find an alias.
    - `ALIAS` - a part of an aliasname.

### Log aliases

Aliases related with [`git log`](https://www.atlassian.com/git/tutorials/git-log).

- **`git lg`** - `(lg)` Shorter version of `git log`.
- **`git log-pretty`** - `(lgp)` Pretty log.
- **`git log-graph`** - `(lgg)` Pretty log + graph.
- **`git log-files`** - `(lgf)` Pretty log + file changes.
- **`git log-diff FILE`** - `(lgd)` Pretty log + diff. [Better replacement](http://blog.andrewray.me/a-better-git-blame/) for `git blame`.
    - `FILE` - a name of a file to diff.

### Status aliases

Aliases related with `git status`.

- **`git st`** - Shorter version of `git status`
- **`git status-short`** - `(sts)` Show minimal status.
- **`git status-verbose`** - `(stv)` Show verbose status with diff of changes.

### Fetch aliases

Aliases related with `git fetch`.

- **`git fe`** - Shorter version of `git fetch`.
- **`git fetch-branch [BRANCH]`** - `(feb)` Fetch remote branch.
    - `BRANCH` - Name of the branch to be fetched. Default value is the name of the current branch.
- **`git fetch-master`** - `(fem)` Fetch remote `master`.

### Checkout aliases

Aliases related with `git checkout`.

- **`git co`** - Shorter version of `git checkout`.
- **`git checkout-synced [BRANCH]`** - `(cos)` Checkout branch and pull changes.
    - `BRANCH` - the name of a branch to be checked out. Default value is `master`. It means that executing `git checkoutsynced` will checkout `master` with pulled all changes from the remote.

### Add aliases

Aliases related with `git add`.

- **`git ad`** - Shorter version of `git add`.
- **`git add-all`** - `(ada)` Add all.
- **`git unadd`**  - Undo staging (see [undo aliases](#undo-aliases)).

### Commit aliases

Aliases related with `git commit`.

- **`git cm`** - Shorter version of `git commit`.
- **`git commit-all`** - `(cma)` Stage all and commit all changes.
- **`git uncommit`** - Revert the act of committing (see [undo aliases](#undo-aliases)).

### Amend aliases

Aliases related with `git commit --amend`.

- **`git amend`** - `(an)` Amend staged changes. No changes in commit message.
- **`git amend-all`** - `(ana)` Stage all and amend all changes.
- **`git amend-message MSG`** - `(anm)` Amend new commit message.
    - `MSG` - New commit message. This parameter is required.
- **`git amend-author [NAME] [EMAIL]`** - `(anu)` Amend new commit author.
    - `NAME` - New author's name. Default value is `git config --get user.name`.
    - `EMAIL` - New author's email. Default value is `git config --get user.email`. Brackets (`<`, `>`) will be automatically added.
    - Executing `git amend-author` will replace last commit author with you.

### Commit traversal aliases

Aliases that enables traversing through commit history.

- **`git prev-commit`** - Go to the previous commit.
- **`git next-commit [BRANCH]`** - Go to the next commit. If there is no child commit it will attempt to checkout a related branch.
    - `BRANCH` - Branch name. When a commit have multiple child commits branch name must be specified to pick one of them.

### Rebase aliases

Aliases related with `git rebase`.

- **`git re`** - Shorter version of `git rebase`.
- **`git rebase-remote [BRANCH]`** - `(rer)` Rebase remote branch. By default current branch is used.
    - `BRANCH` - the name of the remote branch to be rebased with. Default value is `master`.  
- **`git rebase-remote-master`** - `(rerm)` Rebase remote `master` branch.

### Squash aliases

Aliases related with squashing commits with `git rebase -i`. Every command at the end will open an editor for an interactive rebase.

**In case of emergency**: To undo a rebase see the reflog and find HEAD state before rebasing. Than just execute `git reset --soft HEAD@{<THE_STATE_NUMBER>}`.

- **`git squash [X]`** - `(sq)` Squash commits.
    - `X` - may be a number of commits to be squashed.
    - `X` - may be a branch name. All commits made after branching from branch X will be squashed.
    - `X` - default value is `master`. Executing `git squash` will squash all your feature branch commits that are ahead of `master`.
- **`git squash-ahead`** - `(sqa)` Squash all commits that are ahead of the upstream.
- **`git squash-total`** - `(sqt)` Squash all commits available on the branch. All commits even those created before branch will be squashed.

### Tag aliases

Aliases related with `git tag` command.



- **`git tg`** - Shorter version of `git tag`.
- **`git tags`** - `(tga)` Show all tags.
- **`git tags-branch [BRANCH]`** - `(tgb)` List tags available on branch.
    - `BRANCH` - name of a branch. Default value is current branch name.
- **`git create-tag TAG_NAME [TAG_MSG]`** - Tag with a name and an optional message.
    - `TAG_NAME` - name of a new tag.
    - `TAG_MSG` - message for a new tag. If message is specified an annotated tag is created.
- **`git create-tag-date [PREFIX]`** - Tag with current date and optional prefix.
- **`git lasttag`**  - Show last tag.
- **`git prev-tag`**  - Checkout previous tag.
- **`git next-tag`**  - Checkout next tag.
- **`git retag [NEW_TAG] [OLD_TAG]`** - Drop last tag and retag latest commit
    - `NEW_TAG` - name of a new tag. Default value is equal to `OLD_TAG`.
    - `OLD_TAG` - name of the tag to be replaced. Default value is the last tag.
    - Example: `git retag v01 v001` will delete a tag `v001` and create new tag `v01` pointing to the current commit.
    - Example: `git retag v01` will delete last tag and create new tag `v01` pointing to the current commit.
    - Example: `git retag` will delete last tag and create new tag with the same name pointing to the current commit.
- **`git retag-globally [NEW_TAG] [OLD_TAG]`** - Drop last tag and retag latest commit and sync changes to remote.
- **`git push-tags`**  - Push all tags.
- **`git push-tag [TAG]`**  - Push a tag.
    - `TAG` - name of the tag to be pushed. Default value is the last tag.
- **`git delete-tag [TAG]`**  - Delete tag locally.
    - `TAG` - name of the tag to be deleted. Default value is the last tag.
- **`git delete-tag-remotely [TAG] [REMOTE]`**  - Delete tag remotely.
    - `REMOTE` - name of the remote. Default value is the upstream.
- **`git delete-tag-globally [TAG] [REMOTE]`**  - Delete tag locally and remotely.

### Diff aliases

Aliases related with `git diff` ([how does diff work](http://stackoverflow.com/a/1587952/2284884)).

**Remember that:** untracked files are not visible for `git diff` command.

- **`git df`** - Shorter version of `git diff`.
- **`git diff-words`** - `(dfw)` Diff words only. No pluses and minuses. Easier to read.
- **`git diff-all`** - `(dfa)` Diff all (tracked and untracked) with HEAD.
- **`git diff-tracked`** - `(dft)` Diff tracked files with HEAD.
- **`git diff-patch`** - `(dfp)` Diff that includes all changes including binaries. Could be used as a patch file and applied with `git apply <filename>`.

### Undo actions aliases

[Undoing things](http://stackoverflow.com/a/2846154/2284884). No worries these aliases will make no changes to your local files.

**In case of emergency** To revert an undo [use the reflog](http://stackoverflow.com/a/2531803/2284884). Execute `git reset HEAD@{1}`.

- **`git unadd [FILE]`** - Undo staging. Alias for `git reset HEAD --`. What was in staging area will untouched on working tree.
    - `FILE` - You can unadd specific files. By default all files will be unstaged.
- **`git uncommit`** - Undo commit. Alias for `git reset --soft HEAD^`. What was committed will be in staging area.
- **`git undo`** - Undo commit and staging. Alias for `git reset HEAD^`. What was committed and in staging area now will be on your working tree.
- **`git undolocalbranchcommits`** - Undo all branch local commits. Reset to upstream branch.
- **`git undobranchcommits [SRC_BRANCH]`** - Undo all branch commits that are ahead of source branch.
    - `SRC_BRANCH` - Source branch name. Default value is `master`.

### Drop changes aliases

[Dropping things](https://www.atlassian.com/git/tutorials/undoing-changes/git-reset). Be aware that **these aliases will change your local files**.

**In case of emergency** To revert a drop [use the reflog](http://stackoverflow.com/a/2531803/2284884). Execute `git reset HEAD@{1}`.

- **`git drop-unadded`** - Drop all unstaged changes.
- **`git drop-uncommitted`** - Drop all uncommitted changes. Everything what was not staged nor committed will be dropped.
- **`git drop-topreviouscommit`** - Drop all committed and uncommitted changes. It will restore state to previous commit.
- **`git drop-branch-changes-ahead`** - Drop all committed and uncommitted changes made on the branch. Hard reset to upstream branch.
- **`git undo-branch-changes-ahead [SRC_BRANCH]`** - Drop all changes that are ahead of source branch.
    - `SRC_BRANCH` - Source branch name. Default value is `master`.

### Reflog aliases

Aliases related with `git reflog`.

- **`git rl`** - Shorter version of `git reflog`.
- **`git reflog-pretty`** - `(rlp)` Pretty printed reflog.

### Find aliases

```
git find-file $PHRASE     - `(fnf)` Find files by content
git find-branch $COMMIT   - `(fnb)` Find branches by commit
git find-tags $COMMIT     - `(fnt)` Find tags by commit
git find-commit $PHRASE   - `(fnc)` Find commits by phrase
git find-commit-bymsg $MSG - `(fncm)` Find commits by message
```

## In case of emergency

When something goes wrong.
To undo most git commands use the [reflog](https://www.atlassian.com/git/tutorials/rewriting-history/git-reflog):

- Find a state in the reflog that is not compromised
- Reset back to it using `git reset --soft HEAD@{<THE_STATE_NUMBER>}`
