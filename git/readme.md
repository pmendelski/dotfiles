# Git

To find out what an alias does just execute `git aliases | grep "^<alias>"`.

Example:
```
git aliases | grep "^log"
logpretty           => log --pretty=custom
loggraph            => log --graph --pretty=custom
logfiles            => log --pretty=custom --numstat --decorate --name-status
logdiff             => log --pretty=custom  --numstat
```

## Shorter versions of common commands



## Alases for `git log`

- **`git logpretty`** (`lg`) - Pretty log
- **`git loggraph`** (`lgg`) - Pretty log + graph
- **`git logfiles`** (`lgf`) - Pretty log + files
- **`git logdiff`** (`lgd`) - Pretty log + diff


## Alases for `git status`

- **`git st`** (`st`) - Shorter version of `git status`
- **`git statusshort`** (`sts`) - Shorter version of `git status -s`


## Alases for `git commit`

- **`git cm`** - Shorter version `git commit`
- **`git commitall`** (`cma`) - Stage all and commit all
- **`git amend [$MSG]`** (`an`) - Amend changes. If no message is specified message from last commit is used.
- **`git amendall [$MSG]`** (`ana`) - Stage all and amend changes. If no message is specified message from last commit is used.
- **`git changeauthor [$NAME $EMAIL]`** - Change last commit author (if not specified name and email is taken from git config)


## Alases for `git add`

- **`git addall`** (`ada`) - Add all


## Alases for `git fetch`

- **`git fe`** - Shorter version of `git fetch`
- **`git fetchmaster`** (`fem`) - Fetch remote master
- **`git fetchbranch [$BRANCH]`** (`feb`) - Fetch remote branch. If no $BRANCH is specified the current branch will be fetched.


## Alases for `git checkout`

- **`git co`** - Shorter version of `git checkout`
- **`git checkoutmaster`** (`com`) - Checkout master

## Alases for `git diff`

- **`git diffwords`** (`df`) - Diff words only. No pluses and minuses. Easier to read.
- **`git diffall`** (`dfa`) - Diff all with head
- **`git difftracked`** (`dft`) - Diff tracked files with head
- **`git diffpatch`** (`dfp`) - Diff all including binaries. Could be used as patch file and applied with `git apply <filename>`


## Alases for [undoing changes](https://www.atlassian.com/git/tutorials/undoing-changes/git-clean)

- **`git undo`** (`un`) - Undo all
- **`git undotracked`** (`unt`) - Undo tracked changes
- **`git undountracked`** (`unu`) - Undo untracked changes


## Alases for `git rebase`

- **`git rb`** - Shorter version for `git rebase`
- **`git rebaseremote [$BRANCH]`** (`rbr`) - Rebase remote $BRANCH
- **`git rebaseremotemaster`** (`rbrm`) - Rebase remote master
- **`git squash [$COMMITS] [$MSG]`** (`sq`) - Squash last $COMMITS commits with $MSG. Defaults: COMMITS=1, MSG=last commit msg.
- **`git squashi [$COMMITS]`** (`sqi`) - Interactively squash last $COMMITS commits. Defaults: COMMITS=1.


## Alases for `git tag`

- **`git taglast`** - Show last tag
- **`git tagretag`** - Drop last tag and retag latest commit


## Alases for finding things

- **`git findfile $PHRASE`** (`ff`) - Find files by content
- **`git findbranch $COMMIT`** (`fb`) - Find branches by commit
- **`git findtags $COMMIT`** (`ft`) - Find tags by commit
- **`git findcommit $PHRASE`** (`fc`) - Find commits by phrase
- **`git findcommitbymsg $MSG`** (`fcm`) - Find commits by message


## Alases for listings

- **`git tags`** - List tags
- **`git branches`** - List branches
- **`git remotes`** - List remotes
- **`git aliases`** - List aliases
