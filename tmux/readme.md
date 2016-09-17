# Dotfiles / TMUX

TMUX basics:

- Every tmux process is called a session.
- Session have multiple windows.
- Windows have multiple panes.
- Every pane is like a separate terminal.

# Keybindings

## Base bindings

| Keybinding    | Action |
|---------------|--------
| `C-a`         | **Prefix** for most other tmux keybindings |
| `C-[`         | **Copy Mode** enters so called copy mode |
| `:`           | **Command mode** |

## Sessions

| Keybinding    | Action |
|---------------|--------
| `'P K`       | **kill** session |
| `'P $`       | **rename** session |
| `'P s`       | **list** sessions |

## Windows

| Keybinding    | Action |
|---------------|--------|
| `'P c`       | **create** new window |
| `'P k`       | **kill** window |
| `'P ,`       | **rename** window |
| `'P T`       | **move** window to first the top |
| `'P w`       | **list** windows |
| `'P <num>`   | **go to <num>** window |
| `'P l`       | **go to last** active window |
| `'P n`       | **go to next** window |
| `'P p`       | **go to previous** window |

## Panes

| Keybinding    | Action |
|---------------|--------|
| `'P |`       | **split** vertically |
| `'P -`       | **split** horizontally |
| `C-d`         | **kill** pane |
| `A-<Arrow>`   | **change** pane |
| `'P z`       | **maximize/minimize** pane in same window |
| `'P !`       | **move to a separate window** |
| `'P A-<Arrow>` | **resize** current pane |
| `'P C-o`     | **cycle** location of panes |
| `'P C-{`     | **swap with previous** |
| `'P C-}`     | **swap with next** |

## Misc

| Keybinding    | Action |
|---------------|--------
| `'P t`       | **big clock** |
| `'P ?`       | **show keybindings** |
| `'P y`       | **sync all panes** |
| `'P :`       | **prompt** |


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

| Keybinding    | Action |
|---------------|--------
| `C-a [`       | **copy mode start** |
| `C-a ]`       | **copy  mode exit** |
| `C-a =`       | **select buffer** to paste |

# Credits
- http://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
- http://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily
