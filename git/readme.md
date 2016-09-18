# Git

## Alases for `git log`

- `git logpretty` (`lg`) - Pretty log
- `git loggraph` (`lgg`) - Pretty log + graph
- `git logfiles` (`lgf`) - Pretty log + files
- `git logdiff` (`lgd`) - Pretty log + diff

```
git logpretty   ==  git lg      ==  git log --pretty=custom
git loggraph    ==  git lgg     ==  git log --pretty=custom --graph
git logfiles    ==  git lgf     ==  git log --pretty=custom --numstat --decorate
git logdiff     ==  git lgd     ==  git log --pretty=custom -u
```

```
git logpretty   (lg)    Pretty log            git log --pretty=custom
git loggraph    (lgg)   Pretty log + graph    git log --pretty=custom --graph
git logfiles    (lgf)   Pretty log + files    git log --pretty=custom --numstat --decorate
git logdiff     (lgd)   Pretty log + diff     git log --pretty=custom -u
```

| Alias                 | Description           | Original |
| -----------           | ----------            | ---------- |
| `logpretty` (`lg`)    | Pretty log            | `git log --pretty=custom` |
| `loggraph` (`lgg`)    | Pretty log + graph    | `git log --pretty=custom --graph` |
| `logfiles` (`lgf`)    | Pretty log + files    | `git log --pretty=custom --numstat --decorate` |
| `logdiff` (`lgd`)     | Pretty log + diff     | `git log --pretty=custom -u` |


## Alases for `git status`

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `st`                  | Shorter version       | `git status` |
| `statusshort` (`sts`) | Short format          | `git status -s` |


## Alases for `git commit`

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `cm`                  | Shorter version       | `git commit` |
| `commitall` (`cma`)   | Commit all            | `git add -A && git commit -av` |
| `amend` (`an`)        | Amend                 | `git commit --amend --no-edit` |
| `amend all` (`ana`)   | Amend all             | `git add -A && git commit --amend --no-edit` |
| `change author $NAME $EMAIL` | Change last commit author (default author is taken from config) | `git commit --amend --author \"$1 <$2>\" -C HEAD;` |

## Alases for `git add`

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `addall` (`ada`)      | Add all               | `git add -A` |


## Alases for `git fetch`

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `fe`                  | Shorter version       | `git fetch` |
| `fetchmaster` (`fem`) | Fetch remote master   | `git fetch $REMOTE master` |
| `fetchcurrent` (`fec`)| Fetch remote branch   | `git fetch $REMOTE $CURRENT_BRANCH` |


## Alases for `git checkout`

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| (`co`)                | Shorter version       | `git checkout` |
| `checkoutmaster` (`com`)| Fetch origin/master | `git checkout master` |


## Alases for `git diff`

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `diffwords` (`df`)    | Diff words only. No pluses and minuses. Easier to read. | `git diff --color-words` |
| `diffall` (`dfa`)     | Diff all with head    | `git diff HEAD --color-words` |
| `difftracked` (`dft`) | Diff tracked files with head | `git diff --cached --color-words` |
| `diffpatch` (`dfp`)   | Diff all including binaries. Could be used as patch and `git apply sth.diff` | `git diff HEAD --binary` |


## Alases for [undoing changes](https://www.atlassian.com/git/tutorials/undoing-changes/git-clean)

| Alias                 | Description               | Original |
| -----------           | --------              | ---------- |
| `undo` (`un`)         | Undo all              | `git reset --hard && git clean -f` |
| `undotracked` (`unt`) | Undo tracked changes  | `git reset --hard` |
| `undountracked` (`unu`)| Undo untracked changes | `git clean -xf` |


## Alases for `git rebase`

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `rb`                  | Rebase                | `git rebase` |
| `rebaseremote` (`rbr` ) | Rebase remote $BRANCH | `git rebase $REMOTE` |
| `rebasemaster` (`rbrm`) | Rebase remote master  | `git rebase $REMOTE master` |
| `squash $COMMITS [$MSG]` (`sq`) | Squash last $COMMITS commits (with message) | `git fetch $REMOTE master` |
| `squashi $COMMITS` (`sqi`) | Interactively squash last $COMMITS commits  | `git fetch $REMOTE $CURRENT_BRANCH` |


## Alases for `git tag`

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `taglast`             | Show last tag         | `git describe --tags --abbrev=0` |
| `tagretag`            | Drop last tag and tag latest commit | |


## Alases for finding things

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `findfile` (`ff`)     | Find file by content. | `grep -Iin $@` |
| `findbranch` (`fb`)   | Find branches by commit |  |
| `findtags` (`ft`)     | Find tags by commit |  |
| `findcommitbycontent` (`fct`) | Find tags by commit by content |  |
| `findcommitbymsg` (`fcm`)     | Find tags by commit by message |  |


## Alases for listings

| Alias                 | Description           | Original |
| -----------           | --------              | ---------- |
| `tags`                | List tags             | `git tag -l` |
| `branches`            | List branches         | `git branch -a` |
| `remotes`             | List remotes          | `git remote -v` |
| `aliases`             | List aliases          |  |
