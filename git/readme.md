# Git

### Shorter versions of common commands

```
lg = log --pretty
st = status -s
cl = clone
co = checkout
cm = commit -av
cp = cherry-pick
fe = fetch
df = diff
rb = rebase
```


## Alias prefixes

All aliases with similar functionality are prefixed for easier usage. List of alias prefixes:

| Aliases                               | Prefix    | Abbrev    |
| ---                                   | ---       | ---       |
| [Log aliases](#log-aliases)           | `log`     | `lg`      |
| [Log aliases](#status-aliases)        | `status`  | `st`      |
| [Log aliases](#commit-aliases)        | `commit`  | `cm`      |
| [Add aliases](#add-aliases)           | `add`     | `ad`      |
| [Fetch aliases](#tetch-aliases)       | `fetch`   | `fe`      |
| [Checkout aliases](#checkout-aliases) | `checkout`| `co`      |
| [Diff aliases](#diff-aliases)         | `diff`    | `df`      |
| [Undo aliases](#undo-aliases)         | `undo`    | `un`      |
| [Rebase aliases](#rebase-aliases)     | `rebase`  | `rb`      |
| [Squash aliases](#squash-aliases)     | `squash`  | `sq`      |
| [Tag aliases](#tag-aliases)           | `tag`     | `tg`      |
| [Find aliases](#find-aliases)         | `find`    | `fn`      |


## Alias implementation

To find out what an alias does just execute `git aliases | grep "^<alias>"`.

Example:
```
git aliases | grep "^log"
logpretty           => log --pretty=custom
loggraph            => log --graph --pretty=custom
logfiles            => log --pretty=custom --numstat --decorate --name-status
logdiff             => log --pretty=custom  --numstat
```

## Aliases

### Log aliases

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
git squash [$COMMITS] [$MSG] - (`sq`) Squash last $COMMITS commits with $MSG. Defaults: COMMITS=1, MSG=last commit msg.
git squashi [$COMMITS]       - (`sqi`) Interactively squash last $COMMITS commits. Defaults: COMMITS=1.
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
