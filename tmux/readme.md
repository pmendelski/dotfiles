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
| `C-a`         | **Prefix** for most other tmux keybindings |
| `C-[`         | **Copy Mode** enters so called copy mode |
| `:`           | **Command mode** |

### Sessions

| Keybinding    | Action |
|---------------|--------|
| `C-a K`       | **kill** session |
| `C-a $`       | **rename** session |
| `C-a s`       | **list** sessions |
| `A-}`         | **next** session |
| `A-{`         | **previous** session |
| `A-P`         | **last** session |

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
| `C-a c`       | **create** new window |
| `C-a k`       | **kill** window |
| `C-a ,`       | **rename** window |
| `C-a T`       | **move** window to first the top |
| `C-a w`       | **list** windows |
| `C-a <num>`   | **go to <num>** window |
| `A-]`         | **next** window |
| `A-[`         | **previous** window |
| `A-p`         | **last** window |

### Panes

| Keybinding    | Action |
|---------------|--------|
| `C-a |`       | **split** vertically |
| `C-a -`       | **split** horizontally |
| `C-a x`       | **kill** pane |
| `A-<Arrow>`   | **change** pane |
| `C-a z`       | **maximize/minimize** pane in same window |
| `C-a !`       | **move to a separate window** |
| `C-a A-<Arrow>` | **resize** current pane |
| `C-a P`       | **move to top** current pane |
| `C-a C-o`     | **cycle** location of panes |
| `C-a C-{`     | **swap with previous** |
| `C-a C-}`     | **swap with next** |

### Misc

| Keybinding    | Action |
|---------------|--------|
| `C-a t`       | **big clock** |
| `C-a y`       | **sync all panes** |
| `C-a q`       | **show pane indexes** |
| `C-a ?`       | **show keybindings** |
| `C-a :`       | **prompt** |


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
2. `v Space` start visual selection (like in vim) move to selection
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

[Tmux Open](https://github.com/tmux-plugins/tmux-open) - Easy search and select.

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

# Credits
- http://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
- http://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily
- https://leanside.com/2014/01/copy-paste-in-tmux/
