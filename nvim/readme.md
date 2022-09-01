# NVIM

[Neovim](https://neovim.io/) - hyperextensible Vim-based text editor

## Keybindings
Most keybindings come from [vim.rtorr.com](https://vim.rtorr.com/).

### Movement

| Keybinding         | Action  |
|--------------------|--------|---------|
| `h`/`j`/`k`/`l`    | **move** left/down/up/right |
| `<C-o>`/`<C-l>`    | **jump** to next/previous visited position |
| `H`/`M`/`L`        | **jump** to top/middle/bottom of the screen |
| `]]`/`[[`          | **jump** to the next/previous `{` |
| `gg`/`G`           | **jump** to the end of the document |
| `{num}G`           | **jump** to a line |
| `0`/`$`            | **jump** to the beginning/end of the line |
| `^`/`g_`           | **jump** to the first/last non blank character in the line |
| `w`/`W`            | **jump** to the start of a word (with punctuation treated as a part of a word) |
| `b`/`B`            | **jump** backwards to the start of a word (with punctuation treated as a part of a word) |
| `e`/`E`            | **jump** to the end of a word (with punctuation treated as a part of a word) |
| `%`                | **jump** to matching character `()`, `[]`, `{}` |
| `{`/`}`            | **jump** to the next/previous paragraph |
| `f{char}`/`F`      | **jump** to next (previous) character `{char}` in line |
| `t{char}`/`T`      | **jump** to before next (previous) character `{char}` in line |
| `;`/`,`            | **repeat** last jump done with `f`, `F`, `t`, `T` (backwards) |

### Search and replace

| Keybinding         | Action  |
|--------------------|---------|
| `/<pattern>`       | **search forward** for a pattern |
| `?<pattern>`       | **search backward** for a pattern |
| `n`                | **jump to next** occurrence |
| `N`                | **jump to previous** occurrence |
| `*`                | **search and jump to next** occurrence of word under cursor |
| `#`                | **search and jump to previous** occurrence of word under cursor |
| `<Esc>`            | **turn off** search highlight |

### Editing

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `r`/`x`            | N | **replace or cut** a single character |
| `xp`               | N | **replace** two characters |
| `cc`/`c{motion}`   | N | **change** entire line or by motion |
| `dd`/`d{motion}`   | N | **delete** entire line or by motion |
| `J`                | N | **join** two lines with a single space |
| `gu`/`gU`/`g~`     | N | **change** to lowercase/uppercase/switch up to motion |
| `<Alt>-j`          | * | **move** down (custom) |
| `<Alt>-k`          | * | **move** up (custom) |
| `<Ctrl>-d`         | * | **duplicate** line |
| `<leader>-'`       | N | **add** add new line in N mode (custom) |
| `<leader>-"`       | N | **remove** add new line in N mode (custom) |

## Changing modes

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `F12`              | N | enter `ZEN` mode (`<ctrl-a z>` hides tmux status bar) |
| `i`                | N | enter `INSERT` mode |
| `a`                | N | enter `INSERT` mode but put cursor after selected placement |
| `o`                | N | enter `INSERT` mode and put add a new line before |
| `O`                | N | enter `INSERT` mode and put add a new line after |
| `A`                | N | enter `INSERT` mode but put cursor at the end of line |
| `v`                | N | enter `VISUAL` mode |
| `<Shift>-v`        | N | enter `VISUAL-LINE` mode |
| `<Alt>-v`          | N | enter `VISUAL-BLOCK` mode (custom, by default it's ctrl-v) |
| `<Insert>` or `R`  | * | enter `REPLACE` mode from any mode, then toggle with `INSERT` (custom) |

### Visual

| Keybinding         | Action  |
|--------------------|---------|
| `v`                | **expand** selection ([vim-expand-region](https://github.com/terryma/vim-expand-region)) |
| `<Ctrl>-v`         | **shrink** selection ([vim-expand-region](https://github.com/terryma/vim-expand-region)) |
| `~`                | **switch case** |
| `d`                | **delete** |
| `c`                | **change** |
| `y`                | **yank** |
| `>` (or `<Tab>`)   | **indent** |
| `<` (or `<S-Tab>`) | **unindent** |

### Motion

| Keybinding         | Action  |
|--------------------|---------|
| `gg`/`G`           | to the end of the document |
| `0`/`$`            | to beginning/end of the line |
| `^`/`g_`           | to first/last non blank character in the line |
| `w`/`W`            | to the start of a word (with punctuation treated as a part of a word) |
| `b`/`B`            | backwards to the start of a word (with punctuation treated as a part of a word) |
| `e`/`E`            | to the end of a word (with punctuation treated as a part of a word) |
| `aw`               | a word (with white space) |
| `iw`	             | inner word |
| `aW`               | a WORD (with white space) |
| `iW`	             | inner WORD |
| `as`	             | a sentence (with white space) |
| `is`               | inner sentence |
| `ap`               | a paragraph (with white space) |
| `ip`               | inner paragraph |
| `ab`               | a () block (with parentheses) |
| `ib`               | inner () block |
| `aB`               | a {} block (with braces) |
| `iB`               | inner {} block |
| `at`               | a `<tag> </tag>` block (with tags) |
| `it`               | inner `<tag> </tag>` block |
| `a<`               | a `<>` block (with `<>`) |
| `i<`               | inner `<>` block |
| `a[`               | a [] block (with []) |
| `i[`               | inner [] block |
| `a"`               | a double quoted string (with quotes) |
| `i"`               | inner double quoted string |
| `a'`               | a single quoted string (with quotes) |
| `i'`               | inner simple quoted string |
| ``a` ``             | a string in backticks (with backticks) |
| ``i` ``             | inner string in backticks |

### Copy-Paste

Enabled `Ctrl-[cvx]` keybindings and made vim use system clipboard.

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Ctrl>-c`         | V | **copy** selection |
| `<Ctrl>-v`         | I | **paste** |
| `<Ctrl>-x`         | V | **cut** selection |

### Undo-Redo

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Ctrl>-u`         | * | **undo** |
| `<Ctrl>-r`         | * | **redo** |
| `<Ctrl>-z`         | I | **undo** |
| `<Ctrl>-y`         | I | **redo** |

### Spellchecking

| Keybinding         | Action  |
|--------------------|---------|
| `z=`    | **fix** using dictionary |
| `zg`    | **add** to dictionary |
| `[s`    | **go to next** error |
| `]s`    | **go to previous** error |
| `<F9>` | **toggle** spellcheck |

### Git

Uses: [vim-fugitive](https://github.com/tpope/vim-fugitive), [vim-gitgutter](https://github.com/airblade/vim-gitgutter)

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `h-[`              | N | **jump** to next hunk |
| `h-]`              | N | **jump** to previous hank |
| `<Leader>-hp`      | N | **preview** hunk |
| `:Git`             | C | **show** changed files |
| `:Gdiffsplit`      | C | **diff** current file changes |

### Configuration file

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Leader> vr`      | N | **reload** config file |
| `<Leader> ve`      | N | **edit** config file |

## Panes

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Leader> |`       | N | **split** vertically |
| `<Leader> /`       | N | **split** horizontally |
| `<Leader> q`       | N | **kill** pane |
| `<Ctrl>-[hjkl]`    | N | **change** pane |
| `(`, `)`, `+`, `-` | N | **resize** panes |
| `<Leader> o`       | N | **kill** all other panes |
| `<Leader> !`       | N | **move to a separate tab** |
| `<leader> e`       | N | **toggle** explorer pane |
| `<Alt>-e`          | N | **focus** explorer pane |
| `<leader> t`       | N | **toggle** terminal pane |
| `<Alt>-t`          | N | **focus** terminal pane |

# Hopping

| Keybinding         | Action  |
|--------------------|---------|
| `h<char>`       | **hop forward in current line** to given character |
| `H<char>`       | **hop backward in current line** to given character |
| `<leader>hw`       | **hop to word** in whole file |
| `<leader>hl`       | **hop to line** in whole file |
| `<leader>h/`       | **hop to pattern** in whole file |

# Code

| Keybinding         | Action  |
|--------------------|---------|
| `]]`/`[[`          | **jump** to the next/previous `{` |
| `<Ctrl>-/`         | **(un)comment** line or selection (in V mode) |
| `<Ctrl>-s`         | **save and format** file |
| `gd`               | **go to** definition |
| `gD`               | **go to** declaration |
| `gi`               | **go to** implementation |
| `gf`               | **go to** file in the import |
| `gg`               | **find** references |
| `gh`               | **display** documentation |
| `gr`               | **rename** |
| `gc`               | **code action** |
| `gp`               | **display** diagnostic problem |
| `gP`               | **display** line diagnostic problem |
| `g>`, `g<`, `gs`   | **swap** coma separated values like arguments ([vim-swap](https://github.com/machakann/vim-swap)) |
| `[d`/`gx`          | **go to** next diagnostic problem |
| `]d`               | **go to** previous diagnostic problem |

### Buffers

| Keybinding         | Action  |
|--------------------|---------|
| `<Leader> ;`       | **show** buffer list |
| `<Leader> d`       | **close** buffer |
| `<Leader>-[1-9]`   | **open** buffer by tab number |
| `b[`/`b]`          | **open** previous/next tab buffer |
| `<Ctrl>-Left`/`<Ctrl>-Right` | **open** open previous/next tab buffer |
| `B[`/`B]`          | **move** tab buffer back/forward |
| `<Ctrl>-x` or `bc` | **close** active tab buffer |
| `ba`/`bo`          | **close** all/other tab buffers |

### Tree

| Keybinding         | Action  |
|--------------------|---------|
| `<F2>`              | **open** tree pane |
| `<F3>`              | **open** current file in tree pane |
| `+` / `-` / `=`     | **resize** tree pane |
| `<Enter>`           | **open** file/directory |
| `<Backspace>`       | **close** directory |
| `R`                 | **refresh** the tree |
| `a`                 | **add** a file/directory - adding directory requires leaving a leading / at the end of the path. |
| `r`                 | **rename** a file/directory |
| `<Ctrl>-r`          | **rename** a file and omit the filename on input |
| `x`                 | **cut** file/directory to clipboard |
| `c`                 | **copy** file/directory to clipboard |
| `p`                 | **paste** from clipboard |
| `d`                 | **delete** a file |
| `y`                 | **copy name** to system clipboard |
| `Y`                 | **copy relative path** to clipboard |
| `gy`                | **copy absolute path** to system clipboard |
| `<Ctrl-]>`          | **cd** into the directory under the cursor |
| `<Ctrl-[>`          | **cd** into the parent directory |
| `o`                 | **open a file** with default system application |
| `s`                 | **open in a horizontal split** |
| `v`                 | **open in a vertical split** |
| `t`                 | **open in a new tab** |
| `<Tab>`             | **open as a preview** (keeps the cursor in the tree) |
| `I`                 | **toggle visibility of folders** hidden via `g:nvim_tree_ignore` |
| `H`                 | **toggle visibility of dotfiles** |

### F Keys

| Keybinding         | Action  |
|--------------------|---------|
| `F1`               | **Terminal** |
| `F2`               | **Toggle file tree** |
| `F3`               | **Locate file in file tree** |
| `F12`              | **Zen Mode** |

### Others

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `gx`               | N | **open** link under cursor |
| `za`               | N | **toggle** fold |
| `<Leader> w`       | N | **toggle** word wrap |
| `<C-q> <tab>`      | I | **insert tab** character |
