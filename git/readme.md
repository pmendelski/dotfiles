# Git

## Alases for `git log`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | ----------            | ---------- |
| `git logpretty`       | `git lg`      | Pretty log            | `git log --pretty=custom` |
| `git loggraph`        | `git lgg`     | Pretty log + graph    | `git log --pretty=custom --graph` |
| `git logfiles`        | `git lgf`     | Pretty log + files    | `git log --pretty=custom --numstat --decorate` |
| `git logdiff`         | `git lgd`     | Pretty log + diff     | `git log --pretty=custom -u` |


## Alases for `git status`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
|                       | `git st`      | Shorter version       | `git status` |
| `git statusshort`     | `git sts`     | Short format          | `git status -s` |


## Alases for `git commit`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
|                       | `git cm`      | Shorter version       | `git commit` |
| `git commitall`       | `git cma`     | Commit all            | `git add -A && git commit -av` |
| `git amend`           | `git an`      | Amend                 | `git commit --amend --no-edit` |
| `git amend all`       | `git ana`     | Amend all             | `git add -A && git commit --amend --no-edit` |
| `git change author $NAME $EMAIL` |    | Change last commit author (default author is taken from config) | `git commit --amend --author \"$1 <$2>\" -C HEAD;` |

## Alases for `git add`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
| `git addall`          | `git ada`     | Add all               | `git add -A` |


## Alases for `git fetch`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
|                       | `git fe`      | Shorter version       | `git fetch` |
| `git fetchmaster`     | `git fem`     | Fetch remote master   | `git fetch $REMOTE master` |
| `git fetchcurrent`    | `git fec`     | Fetch remote branch  | `git fetch $REMOTE $CURRENT_BRANCH` |


## Alases for `git checkout`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
|                       | `git co`      | Shorter version       | `git checkout` |
| `git checkoutmaster`  | `git com`     | Fetch origin/master   | `git checkout master` |


## Alases for `git diff`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
| `git diffwords`       | `git df`      | Diff words only. No pluses and minuses. Easier to read. | `git diff --color-words` |
| `git diffall`         | `git dfa`     | Diff all with head    | `git diff HEAD --color-words` |
| `git difftracked`     | `git dft`     | Diff tracked files with head | `git diff --cached --color-words` |
| `git diffpatch`       | `git dfp`     | Diff all including binaries. Could be used as patch and `git apply sth.diff` | `git diff HEAD --binary` |


## Alases for [undoing changes](https://www.atlassian.com/git/tutorials/undoing-changes/git-clean)

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
| `git undo`            | `git un`      | Undo all              | `git reset --hard && git clean -f` |
| `git undotracked`     | `git unt`     | Undo tracked changes  | `git reset --hard` |
| `git undountracked`   | `git unu`     | Undo untracked changes | `git clean -xf` |


## Alases for `git rebase`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
|                       | `git rb`      | Rebase                | `git rebase` |
| `git rebaseremote`    | `git rbr`     | Rebase remote $BRANCH | `git rebase $REMOTE` |
| `git rebasemaster`    | `git rbrm`    | Rebase remote master  | `git rebase $REMOTE master` |
| `git squash $COMMITS [$MSG]` | `git sq` | Squash last $COMMITS commits (with message) | `git fetch $REMOTE master` |
| `git squashi $COMMITS`| `git sqi`     | Interactively squash last $COMMITS commits  | `git fetch $REMOTE $CURRENT_BRANCH` |


## Alases for `git tag`

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
| `git taglast`         |               | Show last tag         | `git describe --tags --abbrev=0` |
| `git tagretag`        |               | Drop last tag and tag latest commit | |


## Alases for finding things

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
| `git findfile`        | `git ff`      | Find file by content. | `grep -Iin $@` |
| `git findbranch`      | `git fb`      | Find branches by commit           |  |
| `git findtags`        | `git ft`      | Find tags by commit               |  |
| `git findcommitbycontent` | `git fct` | Find tags by commit by content    |  |
| `git findcommitbymsg` | `git fcm`     | Find tags by commit by message    |  |


## Alases for listings

| Keybinding            | Shorter       | Description           | Original |
| -----------           | --------      | --------              | ---------- |
| `git tags`            |               | List tags             | `git tag -l` |
| `git branches`        |               | List branches         | `git branch -a` |
| `git remotes`         |               | List remotes          | `git remote -v` |
| `git aliases`         |               | List aliases          |  |
