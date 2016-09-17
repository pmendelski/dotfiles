# tmux

## TMUX basics:

- Every tmux process is called a session.
- Session have multiple windows.
- Windows have multiple panes.
- Every pane is like a separate terminal.

## Keybindings

### Base keybindings

| Keybinding    | Action |
|---------------|--------
| `C-a`         | **Prefix** for most other tmux keybindings |
| `C-[`         | **Copy Mode** enters so called copy mode |
| `:`           | **Command mode** |

### Sessions

| Keybinding    | Action |
|---------------|--------
| `C-a K`       | **kill** session |
| `C-a $`       | **rename** session |
| `C-a s`       | **list** sessions |

### Windows

| Keybinding    | Action |
|---------------|--------|
| `C-a c`       | **create** new window |
| `C-a k`       | **kill** window |
| `C-a ,`       | **rename** window |
| `C-a T`       | **move** window to first the top |
| `C-a w`       | **list** windows |
| `C-a <num>`   | **go to <num>** window |
| `C-a l`       | **go to last** active window |
| `C-a n`       | **go to next** window |
| `C-a p`       | **go to previous** window |

### Panes

| Keybinding    | Action |
|---------------|--------|
| `C-a |`       | **split** vertically |
| `C-a -`       | **split** horizontally |
| `C-d`         | **kill** pane |
| `A-<Arrow>`   | **change** pane |
| `C-a z`       | **maximize/minimize** pane in same window |
| `C-a !`       | **move to a separate window** |
| `C-a A-<Arrow>` | **resize** current pane |
| `C-a C-o`     | **cycle** location of panes |
| `C-a C-{`     | **swap with previous** |
| `C-a C-}`     | **swap with next** |

### Misc

| Keybinding    | Action |
|---------------|--------
| `C-a t`       | **big clock** |
| `C-a ?`       | **show keybindings** |
| `C-a y`       | **sync all panes** |
| `C-a :`       | **prompt** |


## Copy mode

Copy mode opens new vim like features.

| Keybinding    | Action |
|---------------|--------
| `C-a [`       | **copy mode start** |
| `C-a ]`       | **copy  mode exit** |
| `C-a =`       | **select buffer** to paste |

| Copy mode keybinding    | Action |
|-------------------------|--------|
| `C-b`                   | **Scroll Up** by whole page  |
| `C-f`                   | **Scroll Down** by whole page  |
| `/`                     | **Search** phrase. Hit `n` to jump to next place  |

### Copy and paste

Copy and paste using [vi bindings](https://awhan.wordpress.com/2010/06/20/copy-paste-in-tmux/)

1. `C-a [` enter copy mode, move to selection start
2. `v` start visual selection (like in vim), move to selection
3. `y` copy selection to tmux buffer or to system clipboard
4. `C-S-v` paste last buffer or `C-a =` to select specific buffer

# Credits
- http://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
- http://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily
