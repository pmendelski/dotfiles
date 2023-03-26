# Tmux

## Tmux basics

- Every tmux process is called a session.
- Session have multiple windows.
- Windows have multiple panes.
- Every pane is like a separate terminal.

## Keybindings

### Base keybindings

| Keybinding    | Action |
|---------------|--------|
| `C-a`         | **prefix** for most other tmux keybindings (original from `C-b`) |
| `C-[`         | **copy Mode** enters copy mode |
| `:`           | **command mode** |
| `C-a z/Z`     | **zen mode** toggle (Z hides status) |
| `C-a a`       | **scratch** popup (custom) |

### Sessions

| Keybinding    | Action |
|---------------|--------|
| `C-a s`       | **list** sessions |
| `C-a S`       | **new** session (custom) |
| `C-a D`       | **kill** session (custom) |
| `C-a d`       | **detach** from session |
| `C-a $`       | **rename** session |
| `C-a )`       | **next** session |
| `C-a (`       | **previous** session |

```
tmux                # Create new session
tmux new -s <name>  # ... with name
tmux attach         # Attach to last session
tmux a -t <name>    # ...with name
tmux ls             # list sessions
tmux kill-session -t myname
```

### Windows

| Keybinding    | Action |
|---------------|--------|
| `C-a w`       | **list** windows |
| `C-a c`       | **create** new window |
| `C-a &`       | **kill** window |
| `C-a ,`       | **rename** window |
| `C-a .`       | **reorder** window |
| `C-a <num>`   | **go to <num>** window |
| `C-a n`       | **next** window |
| `C-a p`       | **previous** window |
| `C-a l`       | **toggle** last active window |

### Panes

| Keybinding    | Action |
|---------------|--------|
| `C-a "`       | **split** vertically |
| `C-a %`       | **split** horizontally |
| `C-a x`       | **kill** pane |
| `A-<Arrow>`   | **go to** pane (custom, `C-a <Arrow>`) |
| `C-a q`       | **go to** pane by index |
| `C-a o`       | **go to** next pane |
| `C-a-<Arrow>` | **resize** current pane |
| `C-S-<Arrow>` | **move** current pane (custom, `C-a }/}{`) |
| `C-a ;`       | **toggle** last active pane |
| `C-a z`       | **maximize/minimize** pane in same window |
| `C-a !`       | **move to a separate window** |
| `C-a _`       | **sync all panes** (custom) |

### Misc

| Keybinding    | Action |
|---------------|--------|
| `C-a t`       | **big clock** |
| `C-a ?`       | **show keybindings** |


## Copy mode

Copy mode opens new vim like features.

| Keybinding    | Action |
|---------------|--------|
| `C-a [`       | **copy mode start** |
| `C-a ]`       | **paste the most recent copied buffer** |
| `C-a =`       | **select buffer** to paste |
| `C-a +`       | **delete recent buffer** |

### Copy and paste

Copy and paste using [vi bindings](https://awhan.wordpress.com/2010/06/20/copy-paste-in-tmux/)

1. `C-a [` enter copy mode, move to selection start
2. `Space` start visual selection (like in vim) move to selection
  - `Shift-v Space` to select whole lines
  - `v Space` to start rectangular selection
3. `y` copy selection to tmux buffer or to system clipboard
4. `C-a ]` paste last buffer or `C-a =` to select specific buffer

Copy and paste using mouse

1. Left click and drag to select desired text (do not release the button)
2. Press `y`to copy selection to tmux buffer or to system clipboard
3. Paste where needed

## Plugins

### Tmux yank

[Tmux Yank](https://github.com/tmux-plugins/tmux-yank) - Enables copying to system clipboard.

| Keybinding    | Action |
|---------------|--------|
| `C-a y`       | **copy text from command line** |
| `C-a Y`       | **copy current working directory** |

Copy mode keybindings

| Keybinding    | Action |
|---------------|--------|
| `y`           | **copy to clipboard** |
| `Y`           | **pasting selection to the command line** |

### Tmux open

[Tmux Open](https://github.com/tmux-plugins/tmux-open) - Opens highlighted selection directly from Tmux copy mode.

Copy mode keybindings

| Keybinding    | Action |
|---------------|--------|
| `o`           | open highlighted selection with the system default program |
| `C-o`         | open a highlighted selection with the `$EDITOR` |

### Tmux copycat

[Tmux copycat](https://github.com/tmux-plugins/tmux-copycat) - Easy search and select.

Copy mode keybindings

| Keybinding    | Action |
|---------------|--------|
| `C-a /`       | regex search |
| `C-a C-f`     | simple file search |
| `C-a C-g`     | search file in `git status` result |
| `C-a A-h`     | search SHA-1 hashes in `git log` result |
| `C-a C-u`     | search URLs |
| `C-a C-d`     | search numbers |
| `C-a A-i`     | search IPs |

**Copycat mode** bindings

| Keybinding    | Action |
|---------------|--------|
| `n`           | jumps to the next match |
| `N`           | jumps to the previous match |

### Tmux logging

[Tmux Logging](https://github.com/tmux-plugins/tmux-logging) - Adds ability to log tmux pane to a file.

All log files are saved in `~/.tmux/tmp/logging` directory.

| Keybinding    | Action |
|---------------|--------|
| `C-a Shift-p` | toggle logging current pane |
| `C-a Alt-p`   | textual screenshot of a current pane |
| `C-a Alt-Shit-p` | saves whole history |
| `C-a Alt-c` | clear pane history |

### Tmux prefix-highlight

[Tmux Prefix Highlight](https://github.com/tmux-plugins/tmux-prefix-highlight) - Add status placeholder for prefix/copy mode.

### Tmux fzf url

[Tmux fzf url](https://github.com/wfxr/tmux-fzf-url) - A tmux plugin for opening urls from browser quickly without mouse.

| Keybinding    | Action |
|---------------|--------|
| `C-a u` | fzf visible urls |

# Credits
- http://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
- http://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily
- https://leanside.com/2014/01/copy-paste-in-tmux/
