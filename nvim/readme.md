
# Modes

## Visual
Standard bindings: https://vim.rtorr.com/

## Changing modes Modes

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `i`                | N | enter `INSERT` mode |
| `v`                | N | enter `VISUAL` mode |
| `<Ctrl>-v`         | N | enter `VISUAL` mode and select block |
| `<Shift>-v`        | N | enter `VISUAL` mode and select line |
| `<Insert>` or `R`  | * | enter `REPLACE` mode from any mode, then toggle with `INSERT` |
| `<Leader> <Leader>` | N | enter `VISUAL` from any mode |

### Selection

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `v`                | V | **expand** selection |
| `<Ctrl>-v`         | V | **shrink** selection |
| `<Leader> l`       | V,N | **select** current line |
| `<Leader> b`       | V,N | **select** current block |
| `<Leader> a`       | V,N | **select** all |

### Copy-Paste

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Ctrl>-c`         | V | **copy** selection |
| `<Ctrl>-v`         | I | **paste** |
| `<Ctrl>-x`         | V | **cut** selection |
| `<Leader> cl`      | V,N | **copy** line |
| `<Leader> xl`      | V,N | **cut** line |
| `<Leader> cb`      | V,N | **copy** block |
| `<Leader> xb`      | V,N | **cut** block |
| `<Leader> ca`      | V,N | **copy** all |
| `<Leader> xa`      | V,N | **cut** all |

### Undo-Redo

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Ctrl>-u`         | * | **undo** |
| `<Ctrl>-r`         | * | **redo** |
| `<Ctrl>-z`         | I | **undo** |
| `<Ctrl>-y`         | I | **redo** |

### Move line up/down

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Alt>-j`          | * | **move** down |
| `<Alt>-k`          | * | **move** up |

### Configuration file

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Leader> vr`      | N | **reload** config file |
| `<Leader> ve`      | N | **edit** config file |

### Change syntax

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Leader> fmd`     | N | change to markdown |
| `<Leader> fj`      | N | change to markdown |
| `<Leader> frs`     | N | change to markdown |
| `<Leader> fsh`     | N | change to markdown |
| `<Leader> fjson`   | N | change to markdown |
| `<Leader> fyml`    | N | change to markdown |
| `<Leader> ftml`    | N | change to markdown |
| `<Leader> fkt`     | N | change to markdown |
| `<Leader> fgr`     | N | change to markdown |
| `<Leader> fjs`     | N | change to markdown |
| `<Leader> fts`     | N | change to markdown |

### Others

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `za`               | N | **toggle** fold |
| `<Ctrl>-s`         | * | **save and format** file |
| `<Ctrl>-z`         | N,V | **toggle** between terminal and vim |
| `<Ctrl>-h`         | N,V | **toggle** between search highlight |

## Panes

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Leader> |`       | N | **split** vertically |
| `<Leader> -`       | N | **split** horizontally |
| `<Leader> x`       | N | **kill** pane |
| `<Ctrl>-[hjkl]`    | N,V,I | **change** pane |
| `<Shift>-[hjkl]`   | N | **resize** panes |
| `<Leader> o`       | N | **kill** all other panes |
| `<Leader> !`       | N | **move to a separate tab** |
| `<Leader> z`       | N | **maximize** pane and minimize others |
| `<Leader> =`       | N | **make equal** panes |

# Terminal

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Leader> t`       | N | **open** terminal |

# Code

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Ctrl>-/`         | N,I | **(un)comment** line |
| `<Ctrl>-/`         | V | **(un)comment** selection |
