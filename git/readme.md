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

Aliases for finding other aliases.

- **`git aliases`** - List all aliases.
- **`git alias [PHRASE]`** - `(al)` Find an alias.
    - `PHRASE` - phrase that will be use to search for an alias. If no phrase is specified command will list all aliases.
- **`git aliases-doc`** - `(ald)` Open browser on this readme page.

### Log aliases

Aliases for [inspecting a repository](https://www.atlassian.com/git/tutorials/inspecting-a-repository)
with [`git log`](https://git-scm.com/docs/git-log).

- **`git lg`** - Shorter version of `git log`.
- **`git log-pretty`** - `(lgp)` Pretty log.
- **`git log-graph`** - `(lgg)` Pretty log + graph.
- **`git log-files`** - `(lgf)` Pretty log + file changes.
- **`git log-diff [N]`** - `(lgd)` Pretty log + diff.
    - `N` - a negative number of commits to be presented in diff.
    - Example: `git log-diff` - will present a log with diff of all commits.
    - Example: `git log-diff -1` - will present a log with diff of the last commit.
- **`git log-blame FILE`** - `(lgb)` Pretty log + diff. [Better replacement](http://blog.andrewray.me/a-better-git-blame/) for `git blame`.
    - `FILE` - a file path to diff.

### Status aliases

Aliases for [inspecting a repository](https://www.atlassian.com/git/tutorials/inspecting-a-repository)
with [`git status`](https://git-scm.com/docs/git-status).

- **`git st`** - Shorter version of `git status`
- **`git status-short`** - `(sts)` Show minimal status.
- **`git status-verbose`** - `(stv)` Show verbose status with a diff of changes.

### Fetch aliases

Aliases for [syncing with remote repository](https://www.atlassian.com/git/tutorials/syncing)
with [`git fetch`](https://git-scm.com/docs/git-fetch).

- **`git fe`** - Shorter version of `git fetch`.
- **`git fetch-branch [BRANCH]`** - `(feb)` Fetch remote branch.
    - `BRANCH` - Name of the branch to be fetched. Default value is the name of the current branch.
- **`git fetch-master`** - `(fem)` Fetch remote `master`.

### Checkout aliases

Aliases for [navigating between branches](https://www.atlassian.com/git/tutorials/using-branches/git-checkout)
with [`git checkout`](https://git-scm.com/docs/git-checkout).

- **`git co`** - Shorter version of `git checkout`.
- **`git checkout-synced [BRANCH]`** - `(cos)` Checkout branch and pull changes.
    - `BRANCH` - the name of a branch to be checked out. Default value is `master`. It means that executing `git checkout-synced` will checkout `master` and pull all changes from the remote.

### Add aliases

Aliases for [saving changes](https://www.atlassian.com/git/tutorials/saving-changes/)
with [`git add`](https://git-scm.com/docs/git-add).

- **`git ad`** - Shorter version of `git add`.
- **`git add-all`** - `(ada)` Add all.

Related aliases: [undo](#undo-aliases).

### Commit aliases

Aliases for [saving changes](https://www.atlassian.com/git/tutorials/saving-changes/)
with [`git commit`](https://git-scm.com/docs/git-commit).

- **`git cm`** - Shorter version of `git commit`.
- **`git commit-all`** - `(cma)` Stage all and commit all changes.
- **`git commit-fixup`** - `(cmf)` Stage all and commit all changes as a [fixup](https://robots.thoughtbot.com/autosquashing-git-commits).
- **`git commit-squash`** - `(cms)` Stage all and commit all changes as a [squash](https://robots.thoughtbot.com/autosquashing-git-commits).

Related aliases: [amend](#amend-aliases), [undo](#undo-aliases), [history traversal](#history-traversal-aliases).

### Amend aliases

Aliases related with [rewriting commit history](https://www.atlassian.com/git/tutorials/rewriting-history/)
with [`git commit --amend`](https://git-scm.com/docs/git-commit).

- **`git amend`** - `(an)` Amend staged changes to last commit.
- **`git amend-all`** - `(ana)` Stage all and amend all changes.
- **`git amend-message MSG`** - `(anm)` Amend new commit message.
    - `MSG` - New commit message. This parameter is required.
- **`git amend-author [NAME] [EMAIL]`** - `(anu)` Amend new commit author.
    - `NAME` - New author's name. Default value is `git config --get user.name`.
    - `EMAIL` - New author's email. Default value is `git config --get user.email`. Brackets (`<`, `>`) will be automatically added.
    - Executing `git amend-author` will replace last commit author with you.

### Rebase aliases

Aliases for [rewriting commit history](https://www.atlassian.com/git/tutorials/rewriting-history/)
with [`git rebase`](https://git-scm.com/docs/git-rebase).

- **`git re`** - Shorter version of `git rebase`.
- **`git rebase-remote [BRANCH]`** - `(rer)` Rebase remote branch. By default current branch is used.
    - `BRANCH` - the name of the remote branch to be rebased with. Default value is `master`.  
- **`git rebase-remote-master`** - `(rerm)` Rebase remote `master` branch.

### Squash aliases

Aliases for [rewriting commit history](https://www.atlassian.com/git/tutorials/rewriting-history/)
with interactive version of [`git rebase -i`](https://git-scm.com/docs/git-rebase).

Be aware that every command at the end will open an interactive rebase editor.

- **`git squash [X]`** - `(sq)` Squash commits.
    - `X` - may be a number of commits to be squashed.
    - `X` - may be a branch name. All commits made after branching from branch X will be squashed.
    - `X` - default value is `master`. Executing `git squash` will squash all your feature branch commits that are ahead of `master`.
- **`git squash-ahead`** - `(sqa)` Squash all commits that are ahead of the upstream.
- **`git squash-total`** - `(sqt)` Squash all commits available on the branch. All commits even those created before branch will be squashed.

### Tag aliases

Aliases related with [`git tag`](https://git-scm.com/docs/git-tag).

- **`git tg`** - Shorter version of `git tag`.
- **`git tags`** - `(tga)` Show all tags.
- **`git tags-branch [BRANCH]`** - `(tgb)` List tags available on the branch.
    - `BRANCH` - name of the branch. Default value is the current branch name.
- **`git create-tag TAG_NAME [TAG_MSG]`** - Tag with a name and an optional message.
    - `TAG_NAME` - name of a new tag.
    - `TAG_MSG` - message for a new tag. If message is specified an annotated tag is created.
- **`git create-tag-date [PREFIX]`** - Tag with current date and optional prefix.
- **`git lasttag`**  - Show last tag.
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

### History traversal aliases

Aliases for traveling through commit history.

- **`git prev-commit`** - Go to the previous commit.
- **`git next-commit [BRANCH]`** - Go to the next commit. If there is no child commit it will attempt to checkout a related branch.
    - `BRANCH` - Branch name. When a commit have multiple child commits branch name must be specified to pick one of them.
- **`git prev-tag`**  - Go to the previous tag.
- **`git next-tag [BRANCH]`**  - Go to the next tag. Works like `git next-commit`.

### Diff aliases

Aliases related with [comparing changes](http://stackoverflow.com/a/1587952/2284884))
with [`git diff`](https://git-scm.com/docs/git-diff).

Be aware that untracked files are not visible for `git diff` command.

- **`git df`** - Shorter version of `git diff`. Shows the changes between the working directory and the index. This shows what has been changed, but is not staged for a commit.
- **`git diff-index-work`** - `(dfiw)` Like `git diff` but uses compares word by work not line by line. No pluses and minuses. Easier to read.
- **`git diff-head-index`** - `(dfhi)` Shows the changes between the index and the HEAD.
- **`git diff-head-work`** - `(dfhw)` Shows all the changes between the working directory and HEAD.
- **`git diff-patch`** - `(dfp)` Like `git diff-head-work` but includes also binaries. Could be used as a patch file and applied with `git apply <filename>`.

### Undo actions aliases

Aliases related with [undoing things](http://stackoverflow.com/a/2846154/2284884)
with [`git reset`](https://git-scm.com/docs/git-reset).

Be aware that these aliases will make no changes to your local files.

- **`git unadd [FILE]`** - Undo staging. Alias for `git reset HEAD --`. What was in staging area will untouched on working tree.
    - `FILE` - You can unadd specific files. By default all files will be unstaged.
- **`git uncommit`** - Undo commit. Alias for `git reset --soft HEAD^`. What was committed will be in staging area.
- **`git undo-prev-commit`** - Undo to previous commit. This will undo a commit and staging. Alias for `git reset HEAD^`. What was committed and in staging area now will be on your working tree.
- **`git undo-branch-local-commits`** - Undo all branch local commits. Reset to upstream branch.
- **`git undo-branch-commit-range [SRC_BRANCH]`** - Undo all branch commits that are ahead of source branch.
    - `SRC_BRANCH` - Source branch name. Default value is `master`.

### Drop changes aliases

[Dropping things](https://www.atlassian.com/git/tutorials/undoing-changes/git-reset).

Be aware that **these aliases will change your local files** (see [in case of emergency](#in-case-of-emergency)).

- **`git drop-unadded`** - Drop all unstaged changes.
- **`git drop-uncommitted`** - Drop all uncommitted changes. Everything what was not staged nor committed will be dropped.
- **`git drop-prev-commit`** - Drop to previous commit. Drop all committed and uncommitted changes. It will restore state to previous commit.
- **`git drop-branch-local-changes`** - Drop all committed and uncommitted changes made on the branch. Hard reset to upstream branch.
- **`git drop-branch-change-range [SRC_BRANCH]`** - Drop all changes that are ahead of a source branch.
    - `SRC_BRANCH` - Source branch name. Default value is `master`.

### Reflog aliases

Aliases related with [`git reflog`](https://git-scm.com/docs/git-reflog).

- **`git rl`** - Shorter version of `git reflog`.
- **`git reflog-pretty`** - `(rlp)` Pretty printed reflog.

### Find aliases

Aliases for finding things in the repository.

- **`git find-file PHRASE`** - Look for specified patterns in the tracked files in the work tree with options: case insensitive, no matching on binary files, show line numbers.
- **`git find-branch-by-hash HASH_PART`** - Show branches that contain the commit hash part.
- **`git find-tag-by-hash HASH_PART`** - Show tags that contain the commit hash part.
- **`git find-commit-by-hash HASH_PART`** - Show commits that contain the hash part.
- **`git find-commit-by-msg MSG`** - Show commits that contain the message.
- **`git find-commit-by-content PHRASE`** - Show commits that contain the phrase in their content.

## In case of emergency

When something goes wrong.
To undo most git commands use the [reflog](https://www.atlassian.com/git/tutorials/rewriting-history/git-reflog):

- Find a state in the reflog that is not compromised
- Reset back to it using `git reset --soft HEAD@{<THE_STATE_NUMBER>}`
