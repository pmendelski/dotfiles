# TMUX

TMUX basics:

- Session have multiple windows.
- Windows have multiple panes.
- A pane is like a separate terminal.

# Keybindings

## Sessions

| Keybinding    | Action |
|---------------|--------
| `C-a K`       | **kill** session |
| `C-a $`       | **rename** session |
| `C-a s`       | **list** sessions |

## Windows

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

## Panes

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

## Misc

| Keybinding    | Action |
|---------------|--------
| `C-a t`       | **big clock** |
| `C-a ?`       | **show keybindings** |
| `C-a :`       | **prompt** |

## Copy and paste

Copy and paste using [vi bindings](https://awhan.wordpress.com/2010/06/20/copy-paste-in-tmux/)

1. `C-a [` enter copy mode, move to selection start
2. `Space` start selecting, move to selection set-option
3. `Enter or y` copy selection to tmux buffer or to system clipboard
4. `C-a ]` paste

| Keybinding    | Action |
|---------------|--------
| `C-a [`       | **copy** |
| `C-a ]`       | **paste** |
| `C-a =`       | **select buffer** to paste |

# Credentials
- http://www.hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/
- http://lukaszwrobel.pl/blog/tmux-tutorial-split-terminal-windows-easily
