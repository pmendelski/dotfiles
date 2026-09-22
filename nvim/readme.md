# NVIM

[Neovim](https://neovim.io/) - hyper-extensible Vim-based text editor

## Basic keybindings

Basic keybindings are unchanged and the same as for vim.
See [vim readme](../vim) to recall the basics.

`<leader>` is `Space`. Keybindings marked **(custom)** are defined in this repo,
the rest come from [LazyVim](https://www.lazyvim.org/).

### Finding code (LSP)

| Keybinding      | Action |
|-----------------|--------|
| `gd`            | **definition** |
| `gr`            | **references** |
| `gI`            | **implementations** |
| `gy`            | **type definition** |
| `gD`            | **declaration** |
| `gai` / `gao`   | **calls** incoming / outgoing |
| `<leader>ss`    | **symbols** in the current file |
| `<leader>sS`    | **symbols** in the workspace |
| `K`             | **hover** documentation |
| `<c-f>` / `<c-b>` | scroll hover, signature or completion docs **down** / **up** |
| `<c-Down>` / `<c-Up>` | the same, on the arrows (custom) |
| `<a-n>` / `<a-p>` | **next/prev reference** in the current file |

With no popup open, `<c-Down>`/`<c-Up>` keep moving between splits. In the
which-key popup (`<leader>?`, or a pending `<leader>`) they scroll it, next to
the built-in `<c-d>`/`<c-u>` (custom).

`gr`, `gI` and the call pickers always open the list, even for a single result
(custom) — one hit is still worth seeing in context. `gd`, `gD` and `gy` keep
jumping straight there, since they name one target anyway.

### Finding files and text

| Keybinding    | Action |
|---------------|--------|
| `<leader>ff`  | **files** (root dir) |
| `<leader>fF`  | **files** (cwd) |
| `<leader>fr`  | **recent** files |
| `<leader>fb`  | **buffers** |
| `<leader>sg`  | **grep** (root dir), same as `<leader>/` |
| `<leader>sG`  | **grep** (cwd) |
| `<leader>sw`  | **grep** word under cursor or selection |

### Inside a picker

| Keybinding    | Action |
|---------------|--------|
| `?`           | **help** — every key for the picker that is open |
| `<a-q>`       | **toggle test files + import lines** (custom) |
| `<a-t>`       | **toggle test files** only (custom) |
| `<a-u>`       | **toggle import lines** only, LSP references (custom) |
| `<c-s>` / `<c-v>` | open in **split** / **vsplit** |
| `<c-q>`       | send results to **quickfix** |
| `<a-p>`       | toggle **preview** |
| `<a-m>`       | **maximize** — fullscreen, list narrowed to ~30% (custom ratio) |
| `<a-h>` / `<a-i>` | toggle **hidden** / **ignored** files |
| `<c-f>` / `<c-b>` | scroll preview **down** / **up**, half a screen |
| `<c-Down>` / `<c-Up>` | the same, on the arrows (custom) |
| `<c-Right>` / `<c-Left>` | scroll preview **right** / **left**, 10 columns (custom) |
| `<c-g>`       | **print path** of the item (result list) |
| `<Esc>`, `<F1>`–`<F4>` | **close** (custom) |

The preview window title shows the project-relative path, shortened in the
middle when it does not fit (custom).

Plain arrows move the result list and the cursor in the query, so ctrl-arrows
move the preview instead. The sideways keys are inert in previews that wrap
their lines (diffs, git log) — there is nothing off-screen to scroll to.
`<a-w>` cycles the focus into the preview itself, where every normal motion
works; `i` goes back.

### Filtering noise out of results

Two filters — test files and import lines — with one key for both and separate
keys for each. **Both are on by default.** The keys live inside a picker, but
they are not scoped to it: a toggle flips the global setting and every picker
opened afterwards uses the new state.

| Keybinding    | Action |
|---------------|--------|
| `<a-q>`       | **toggle both** — quiet pickers (custom) |
| `<a-t>`       | **toggle test files** only (custom) |
| `<a-u>`       | **toggle import lines** only (custom) |

Each filter covers only the sources it makes sense for, so a key can be a no-op
in the picker you press it in — the notification says so when that happens. The
global flag still flips, and the other pickers pick it up.

`<a-q>` reads as "shown" unless *both* filters are already hiding, so a single
press always quiets everything from a mixed state.

The state lives in `vim.g.picker_hide_tests` / `vim.g.picker_hide_imports`;
unset means hiding. Set either to `false` in `.nvim/lua/config/options.lua` to
start a session with the filter off.

The test filter also steps aside on its own when the search is already *about*
tests, decided when the picker opens:

- the current file is a test file — `gr` on a struct used by the test you are
  editing lists the other tests too,
- the search is scoped to a test directory — `<leader>f` or `<leader>g` on
  `tests/` in the explorer, which would otherwise return nothing.

`<a-t>` and `<a-q>` still win: a press always flips what the picker in front of
you shows, and that choice becomes the global one.

**Test files** apply to LSP references/definitions/implementations, grep and
find files — but **not the explorer**, which is a tree you navigate rather than
a list of results; hiding directories there would put tests out of reach.
Matched by name (`*_test.*`, `*_spec.*`, `*.test.*`, `*.spec.*`, `test_*.py`,
`*Test.java`, `*Tests.cs`) and by directory (`test/`, `tests/`, `__tests__/`,
`spec/`, `testdata/`) — see `.nvim/lua/util/tests.lua`.

**Import lines** apply to `gr` only. `gd`, `gI` and `gy` can legitimately land
on an import statement, so they are never filtered. Matched on the text of the
referencing line — `import`, `from … import`, `export … from`, `use`,
`pub(crate) use`, `using`, `#include`, `require(`. Braced multi-line lists are
matched too, by scanning back to the keyword:

```rust
use super::infra::{
    Repository, RepositoryInner, StorageRepository,   // <- also hidden
};
```

See `.nvim/lua/util/imports.lua`.

### Renaming, moving, deleting

| Keybinding    | Action |
|---------------|--------|
| `<leader>cr`  | **rename** symbol under cursor (LSP) |
| `<leader>cR`  | **rename/move** the current file, updating imports (LSP) |
| `<leader>ca`  | **code action** |

File operations live in the explorer — see `a` / `r` / `m` / `c` / `d` below.

### Explorer

| Keybinding    | Action |
|---------------|--------|
| `<F4>`        | **toggle** explorer (custom) |
| `<F3>`        | **toggle focus** between explorer and editor (custom) |
| `<leader>e`   | **open** explorer (root dir), `<leader>E` for cwd |

Inside the tree:

| Keybinding    | Action |
|---------------|--------|
| `l` / `h`     | **open** / **close** directory |
| `<BS>`        | go **up** one directory |
| `Z`           | **collapse all** |
| `.`           | **focus** the tree on the item under cursor |
| `a`           | **add** file or directory (trailing `/` makes a directory) |
| `r`           | **rename** |
| `m`           | **move** |
| `c`           | **copy** |
| `d`           | **delete** |
| `y` / `p`     | **yank** / **paste** |
| `o`           | **open** with the system application |
| `u`           | **refresh** |
| `H` / `I`     | toggle **hidden** / **ignored** files |
| `P`           | toggle **preview** |
| `<c-c>`       | **cd** to the directory under cursor |
| `t`           | **run tests** at the path under cursor (custom) |
| `<leader>f`   | **find files** under the directory (custom) |
| `<leader>g`   | **grep** under the directory (custom) |
| `<leader>s`   | **LSP symbols** under the directory (custom) |

### Navigating diagnostics

| Keybinding    | Action |
|---------------|--------|
| `]d` / `[d`   | next / prev **diagnostic** |
| `]e` / `[e`   | next / prev **error** |
| `]w` / `[w`   | next / prev **warning** |
| `<leader>cd`  | **line diagnostics** |
| `<leader>xx`  | **diagnostics list** (Trouble), `<leader>xX` for the current buffer |

The same `]d` / `[d`, `]e` / `[e` and `]w` / `[w` work inside the explorer,
jumping between files that carry diagnostics.

### Navigating git changes

| Keybinding    | Action |
|---------------|--------|
| `]h` / `[h`   | next / prev **hunk** |
| `]H` / `[H`   | **last** / **first** hunk |
| `]g` / `[g`   | next / prev **changed file** (inside the explorer) |
| `<leader>ghp` | **preview** hunk inline |
| `<leader>ghs` | **stage** hunk, `<leader>ghS` for the buffer |
| `<leader>ghr` | **reset** hunk, `<leader>ghR` for the buffer |
| `<leader>ghu` | **undo stage** hunk |
| `<leader>ghb` | **blame** line, `<leader>ghB` for the buffer |
| `<leader>gg`  | **lazygit** |
| `<leader>gs`  | **status** picker |
| `<leader>gd`  | **diff** (hunks) picker |
| `<leader>gb`  | **blame** line picker |
| `<leader>gf`  | **history** of the current file |
