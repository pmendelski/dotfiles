# NVIM

## Keybindings
Most keybindings come from [vim.rtorr.com](https://vim.rtorr.com/).

### Movement

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `h`/`j`/`k`/`l`    | N | **jump** left/down/up/right |
| `<C-o>`/`<C-l>`    | N | **jump** to next/previous visited position |
| `H`/`M`/`L`        | N | **jump** to top/middle/bottom of the screen |
| `gg`/`G`           | N | **jump** to the end of the document |
| `{num}G`           | N | **jump** to a line |
| `0`/`$`            | N | **jump** to beginning/end of the line |
| `^`/`g_`           | N | **jump** to first/last non blank character in the line |
| `w`/`W`            | N | **jump** to the start of a word (with puntuation treateded as a part of a word) |
| `b`/`B`            | N | **jump** backwords to the start of a word (with puntuation treateded as a part of a word) |
| `e`/`E`            | N | **jump** to the end of a word (with puncruation treated as a part of a word) |
| `%`                | N | **jump** to matching character `()`, `[]`, `{}` |
| `{`/`}`            | N | **jump** to the next/previous paragraiph |
| `f{char}`/`F`      | N | **jump** to next (previous) character `{char}` in line |
| `t{char}`/`T`      | N | **jump** to before next (previous) character `{char}` in line |
| `;`/`,`            | N | **repeat** last jump done with `f`, `F`, `t`, `T` (backwards) |

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
| `<leader>-'`       | N | **add** add new line in N mode (custom) |
| `<leader>-"`       | N | **remove** add new line in N mode (custom) |

## Changing modes

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `i`                | N | enter `INSERT` mode |
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
| `w`/`W`            | to the start of a word (with puntuation treateded as a part of a word) |
| `b`/`B`            | backwords to the start of a word (with puntuation treateded as a part of a word) |
| `e`/`E`            | to the end of a word (with puncruation treated as a part of a word) |
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

### Git

Ues: [vim-fugitive](https://github.com/tpope/vim-fugitive), [vim-gitgutter](https://github.com/airblade/vim-gitgutter)

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `h-[`              | N | **jump** to next hunk |
| `h-]`              | N | **jump** to previous hank |
| `<Leader>-hp`      | N | **preview** hunk |
| `:Git`             | C | **show** changed files |
| `:Gdiffsplit`      | C | **diff** current file changes |

### Undo-Redo

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Ctrl>-u`         | * | **undo** |
| `<Ctrl>-r`         | * | **redo** |
| `<Ctrl>-z`         | I | **undo** |
| `<Ctrl>-y`         | I | **redo** |

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

## Buffers

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Leader> ;`       | N | **show** buffer list |
| `<Leader> d`       | N | **close** buffer |

# Code

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `<Ctrl>-/`         | N,I | **(un)comment** line or selection (in V mode) |
| `<Ctrl>-s`         | * | **save and format** file |
| `g>`, `g<`, `gs`   | N | **swap** coma separated values like arguments ([vim-swap](https://github.com/machakann/vim-swap)) |
| `<Leader> fmd`     | N | **change syntax** to markdown |
| `<Leader> fj`      | N | **change syntax** to java |
| `<Leader> frs`     | N | **change syntax** to rust |
| `<Leader> fsh`     | N | **change syntax** to shell |
| `<Leader> fjson`   | N | **change syntax** to json |
| `<Leader> fyml`    | N | **change syntax** to yaml |
| `<Leader> ftml`    | N | **change syntax** to toml |
| `<Leader> fkt`     | N | **change syntax** to kotlin |
| `<Leader> fgr`     | N | **change syntax** to groovy |
| `<Leader> fjs`     | N | **change syntax** to js |
| `<Leader> fts`     | N | **change syntax** to ts |

### Others

| Keybinding         | Mode   | Action  |
|--------------------|--------|---------|
| `gx`               | N | **open** link under cursor |
| `za`               | N | **toggle** fold |
| `<Leader> w`       | N | **toggle** word wrap |
| `<Esc>`            | N | **turn off** search highlight |

