# Git Aliases

## Git pearls

Most interesting and frequently used git magic spells.

```
git start               - Start your next git project the right way.
git pr-prepare          - Prepare a branch to be a non problematic pull request.
git pr-close            - Checkout master and cleanup.
git push-force          - The most secure version of push with force
git push-fix            - Quickly push fixes
git push-conflict-fix   - Resolve conflict with master and push
git sync-all            - Rebase all branches with freshly fetched remotes.
git drop-uncommited     - Drop all uncommited changes.
git stash-all           - Stash all, even untracked.
git log-blame           - Correct way for displaying file annotations.
git cleanup             - Cleanup your repo from garbage
```

## Feature flow

Example of an everyday usage:

```sh
# Start a new feature
git create-branch feature/PROJ-001-new-feature
echo 'important' > abc
git commit-all -m 'Important commit'
echo 'fixup' >> abc
git commit-fixup
echo 'squash' >> abc
git commit-squash HEAD^ -m 'Squash'
git pr-prepare
git push
# Apply some code review fixes
echo 'quick-fix' >> abc
git push-fix
# Feature branch merged!
git pr-close
```

...instead of

```sh
# Start a new feature
git checkout -b feature/PROJ-001-new-feature
git push -u origin feature/PROJ-001-new-feature
echo 'important' > abc
git add -A
git commit -am 'Important commit'
echo 'fixup' >> abc
git commit -a --fixup=HEAD
echo 'squash' >> abc
git commit -a --squash=HEAD^ -m 'Squash'
git fetch
# Make sure there are no conflicts
git rebase origin/feature/PROJ-001-new-feature
git rebase origin/master
# Check whitespaces
git diff-tree --check $(git hash-object -t tree /dev/null) HEAD
# Squash commits
git rebase -i
git push
# Apply some code review fixes
echo 'quick-fix' >> abc
git commit -a --amend --no-edit
git push -f --atomic --force-with-lease
# Feature branch merged!
git fetch
git checkout master
git pull
git remote prune origin
git gc
```

## Shorter versions of common commands

Just a two letter abbreviations of common git commands.

```
ad = add
br = branch
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

## Grouped aliases

### Finding aliases

Aliases for finding other aliases.

- **`git aliases [PHRASE]`** - `(al)` List aliases.
    - `PHRASE` - phrase that will be use to search for an alias. If no phrase is specified command will list all aliases.
- **`git aliases-doc`** - `(ald)` Open browser on this readme page.

### Log aliases

Aliases for [inspecting a repository](https://www.atlassian.com/git/tutorials/inspecting-a-repository)
with [`git log`](https://git-scm.com/docs/git-log).

- **`git lg`** - Shorter version of `git log`.
- **`git log-pretty`** - `(lgp)` Pretty log.
- **`git log-graph`** - `(lgg)` Pretty log + graph.
- **`git log-files`** - `(lgf)` Pretty log + file changes.
- **`git log-merges`** - `(lgm)` Pretty log merge commits only.
- **`git log-no-merges`** - `(lgnm)` Pretty log non-merge commits only.
- **`git log-diff [N]`** - `(lgd)` Pretty log + diff.
    - `N` - a negative number of commits to be presented in diff.
    - Example: `git log-diff` - will present a log with diff of all commits.
    - Example: `git log-diff -1` - will present a log with diff of the last commit.
- **`git log-blame FILE`** - `(lgb)` Pretty log + diff. [Better replacement](http://blog.andrewray.me/a-better-git-blame/) for `git blame`.
    - `FILE` - a file path to diff.
- **`git log-issues`** - `(lgi)` Log jira issues.

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
- **`git fetch-branch [BRANCH] [REMOTE]`** - `(feb)` Fetch remote branch.
    - `BRANCH` - Name of the branch to be fetched. Default value is the name of the current branch.
    - `REMOTE` - Name of the remote repository to be fetched from. Default value is `origin`.
- **`git fetch-master [REMOTE]`** - `(fem)` Fetch remote `master`.

### Checkout aliases

Aliases for [navigating between branches](https://www.atlassian.com/git/tutorials/using-branches/git-checkout)
with [`git checkout`](https://git-scm.com/docs/git-checkout).

- **`git co`** - Shorter version of `git checkout`.
- **`git checkout-master`** - `(com)` Checkout master branch

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

- **`git amend`** - Amend staged changes to last commit.
- **`git amend-all`** - Stage all and amend all changes.
- **`git amend-message MSG`** - Amend new commit message.
    - `MSG` - New commit message. This parameter is required.
- **`git amend-author [NAME] [EMAIL]`** - Amend new commit author.
    - `NAME` - New author's name. Default value is `git config --get user.name`.
    - `EMAIL` - New author's email. Default value is `git config --get user.email`. Brackets (`<`, `>`) will be automatically added.
    - Executing `git amend-author` will replace last commit author with you.

### Sync aliases

Sync alias consist of [`git fetch`](https://git-scm.com/docs/git-fetch) and [`git rebase`](https://git-scm.com/docs/git-rebase). It is like a rebase with always updated remote branch.

- **`git sync [BRANCH]`** - `(sy)` Fetch and rebase with remote branch.
    - `BRANCH` - the name of the remote branch to be rebased with. Default value is `master`.
- **`git sync-master`** - `(sym)` Rebase remote `master` branch.
- **`git sync-force`** - Fetch remote branch and reset all local changes.

### Squash aliases

Aliases for [rewriting commit history](https://www.atlassian.com/git/tutorials/rewriting-history/)
with interactive version of [`git rebase -i`](https://git-scm.com/docs/git-rebase).

Be aware that every command at the end will open an interactive rebase editor.

- **`git squash [X]`** - `(sq)` Squash commits.
    - `X` - may be a revision. Squash 5 last commits `git squash HEAD~4`.
    - `X` - may be a branch name. All commits made after branching from branch X will be squashed.
    - `X` - default value is `master`. Executing `git squash` will squash all your feature branch commits that are ahead of `master`.
- **`git squash-ahead`** - `(sqa)` Squash all commits that are ahead of the upstream.
- **`git squash-total`** - `(sqt)` Squash all commits available on the branch. All commits even those created before branch will be squashed.

### Stash aliases

Aliases for [saving locally changes](https://www.atlassian.com/git/tutorials/git-stash/) with [`git stash`](https://git-scm.com/docs/git-stash).

- **`git stash-all`** - Stash all - tracked and untracked files.

### Tag aliases

Aliases related with [`git tag`](https://git-scm.com/docs/git-tag).

- **`git tg`** - Shorter version of `git tag`.
- **`git tags`** - Show all tags.
- **`git tags-branch [BRANCH]`** - `(tgb)` List tags available on the branch.
    - `BRANCH` - name of the branch. Default value is the current branch name.
- **`git create-tag TAG_NAME [TAG_MSG]`** - Tag with a name and an optional message.
    - `TAG_NAME` - name of a new tag.
    - `TAG_MSG` - message for a new tag. If message is specified an annotated tag is created.
- **`git create-tag-with-date [PREFIX]`** - Tag with current date and optional prefix.
- **`git last-tag`**  - Show current/last tag.
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
    - `REMOTE` - name of the remote. Default value is `origin`.
- **`git delete-tag-globally [TAG] [REMOTE]`**  - Delete tag locally and remotely.

### History traversal aliases

Aliases for traveling through commit history.

- **`git prev-commit BRANCH`** - Go to the previous commit.
    - `BRANCH` - Branch name. When a commit have multiple children commits or multiple parent commits branch name must be specified to pick one of them.
- **`git next-commit BRANCH`** - Go to the next commit. If there is no child commit it will attempt to checkout the branch.
- **`git prev-tag BRANCH`**  - Go to the previous tag.
- **`git next-tag BRANCH`**  - Go to the next tag. Works like `git next-commit`.

### Push aliases

Aliases related with [sending your changes to remote repostiry](https://www.atlassian.com/git/tutorials/syncing/)
with [git push](https://git-scm.com/docs/git-push).

- **`git push-force`** - Like `git push --force-with-lease`. The most secure version of git push.
    - [`force-with-lease`](https://developer.atlassian.com/blog/2015/04/force-with-lease/?utm_source=medium&utm_medium=blog&utm_campaign=lesser-git) force push only if there were no changes on remote
    - [`atomic`](https://github.com/blog/1994-git-2-4-atomic-pushes-push-to-deploy-and-more) - total success or a total fail. Transactional version of a push. This command does not include `--atomic` because some repositories are not ready for it.
- **`push-fix`** - Amend and push all changes to the remote. Perfect for quick code review fixes.
- **`push-conflict-fix`** - Rebase with remote master and push to the remote. Perfect when there is a conflict in your PR with the master.

### Diff aliases

Aliases related with [comparing changes](http://stackoverflow.com/a/1587952/2284884))
with [`git diff`](https://git-scm.com/docs/git-diff).

Be aware that untracked files are not visible for `git diff` command.

- **`git df`** - Shorter version of `git diff`. Shows the changes between the working directory and the index. This shows what has been changed, but is not staged for a commit.
- **`git diff-index-work`** - Like `git diff` but uses compares word by work not line by line. No pluses and minuses. Easier to read.
- **`git diff-head-index`** - Shows the changes between the index and the HEAD.
- **`git diff-head-work`** - Shows all the changes between the working directory and HEAD.
- **`git diff-patch`** - Like `git diff-head-work` but includes also binaries. Could be used as a patch file and applied with `git apply <filename>`.
- **`git diff-apply`** - Alias for `git apply <filename>`.

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

- **`git drop-ignored`** - Drop all ignored files.
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

- **`git find-file PHRASE`** - `(fnf)` Look for specified patterns in the tracked files in the work tree with options: case insensitive, no matching on binary files, show line numbers.
- **`git find-branch-by-hash HASH_PART`** - `(fnbh)` Show branches that contain the commit hash part.
- **`git find-tag-by-hash HASH_PART`** - `(fnth)` Show tags that contain the commit hash part.
- **`git find-commit-by-hash HASH_PART`** - `(fnch)` Show commits that contain the hash part.
- **`git find-commit-by-msg MSG`** - `(fncm)` Show commits that contain the message.
- **`git find-commit-by-content PHRASE`** - `(fncc)` Show commits that contain the phrase in their content.

### Branch aliases

Aliases for [using branches](https://www.atlassian.com/git/tutorials/using-branches/)
with [`git branch`](https://git-scm.com/docs/git-branch).

- **`git br`** - Shorter version of `git branch`.
- **`git curr-branch`** - Show current branch name.
- **`git branches-local`** - List local branches.
- **`git branches-all`** - List all branches.
- **`git create-branch BRANCH`** - Create a new branch.
    - `BRANCH` - the name of the branch to be created.
- **`git push-branch [REMOTE]`** - Push current branch.
    - `REMOTE` - name of the remote. Default value is `origin`.
- **`git push-branches [REMOTE]`** - Push all branches to remote.
- **`git delete-branch [BRANCH]`**  - Delete branch locally. Added sanity check to not remove master branch.
    - `BRANCH` - name of the branch to be deleted. Default value is the last branch.
- **`git delete-branch-remotely [BRANCH] [REMOTE]`**  - Delete branch remotely. Added sanity check to not remove master branch.
    - `REMOTE` - name of the remote. Default value is `origin`.
- **`git delete-branch-globally [BRANCH] [REMOTE]`**  - Delete branch locally and remotely. Added sanity check to not remove master branch.
- **`git merge-branch`** - Alias for `git merge --no-ff --no-edit`. Merge and create a [commit to leave merge information in history](https://hackernoon.com/lesser-known-git-commands-151a1918a60#823c). Perfect for feature branch workflow.

### Origin aliases

Aliases for presenting information about the origin.

- **`git origin`** - `(or)` Show basic information about the origin. Includes: URL, branches
- **`git origin-commits`** - `(orc)` Show all origins branches with commit information. Good to quickly figure out what is going on all origin branches.

### Pull request aliases

Aliases to ease pull request flow.

- **`git pr-prepare`** - `(prp)` Prepare a branch to be a non problematic pull request.
- **`git pr-close`** - `(prc)` Execute after merging pr. Checkout master and update repository.

### Ignore aliases

Aliases for ignoring local changes
with [`.gitignore` file](https://www.atlassian.com/git/tutorials/gitignore/)
and [`git update-index`](http://stackoverflow.com/a/11366713/2284884).

- **`git ignore FILE`** - Ignore changes in a tracked file.
- **`git unignore FILE`** - Unignore changes in a tracked file.
- **`git ignored`** - List ignored files with `git ignore` command.
- **`git gitignore`** - Show local `.gitignore` file.
- **`git gitignore-edit`** - Edit local `.gitignore` file with vim.
- **`git gitignore-fix`** - [Fix `.gitignore`](http://stackoverflow.com/a/1139797/2284884).

### Contribution aliases

Aliases for presenting statistics on about contribution.

- **`git contributors`** - List contributors.
- **`git contribution-stats`** - Show contribution statistics grouped by commit authors.
    - Columns: added, removed, sum (added + removed), commits
- **`git file-stats`** - Show file statistics grouped by file extension.
    - Columns: count, lines, size

### Other aliases

List of other ungrouped aliases.

- **`git root`** - Prints repository root directory.
- **`git start`** - Alias for `git init && git add . && git commit --allow-empty -am "Initial commit"`. The first commit of a repository can not be rebased like regular commits, so it’s [good practice](https://hackernoon.com/lesser-known-git-commands-151a1918a60#9d13) to create an empty commit as your repository root.
- **`git check-whitespaces`** - Check if any file in repo has [whitespace errors](http://peter.eisentraut.org/blog/2014/11/04/checking-whitespace-with-git/).
- **`git cleanup`** - Cleans up your local repository.
    - Removes local [branches merged to master](http://railsware.com/blog/2014/08/11/git-housekeeping-tutorial-clean-up-outdated-branches-in-local-and-remote-repositories/)
    - [Prunes remotes](http://railsware.com/blog/2014/08/11/git-housekeeping-tutorial-clean-up-outdated-branches-in-local-and-remote-repositories/)
    - Starts [repository cleanup](https://git-scm.com/docs/git-gc)

## In case of emergency

When something goes wrong.
To undo most git commands use the [reflog](https://www.atlassian.com/git/tutorials/rewriting-history/git-reflog):

- Find a state in the reflog that is not compromised
- Reset back to it using `git reset --soft HEAD@{<THE_STATE_NUMBER>}`
