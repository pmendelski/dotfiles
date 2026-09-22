local lazyvim = require("lazyvim.util")
local filters = require("util.picker_filter")

--- Flip what the open picker shows, then remember it: the new state becomes the
--- global one, and overrides the context detection for this picker.
--- One press makes the whole group agree: hide unless everything is hidden.
---@param picker snacks.Picker
---@param keys ("hide_tests"|"hide_imports")[]
---@param label string
local function toggle(picker, keys, label)
  local hide, inert = false, true
  for _, key in ipairs(keys) do
    hide = hide or not picker.opts[key]
  end
  local override = picker.opts.filter_override or {}
  for _, key in ipairs(keys) do
    filters.set(key, hide)
    override[key] = hide
    inert = inert and not filters.applies(key, picker.opts.source)
  end
  picker.opts.filter_override = override
  filters.apply(picker.opts)

  local filter = picker.input.filter
  filter.opts = picker.opts.filter
  filter.all = not (filter.opts.cwd or filter.opts.buf or filter.opts.paths or filter.opts.filter)

  picker:find({ refresh = true })
  -- the flags are global, so allow the toggle anywhere, but say where it is a no-op
  Snacks.notify.info((hide and "Hiding " or "Showing ") .. label .. (inert and " (not in this picker)" or ""), {
    id = "picker_filter",
    title = "Picker",
  })
end

--- Truncate a path in the middle, cutting only on separators: keep the leading
--- directory and as many trailing ones as fit. `Snacks.picker.util.truncate`
--- cuts mid-segment, which leaves fragments like `…m/lua/mason-core/...`.
---@param path string
---@param width number
local function fit_path(path, width)
  local strwidth = vim.api.nvim_strwidth
  if strwidth(path) <= width then
    return path
  end
  local parts = vim.split(path, "/")
  local head = parts[1]
  for i = 2, #parts do
    local tail = table.concat(parts, "/", i)
    if strwidth(head) + strwidth(tail) + 3 <= width then -- 3 = "/…/"
      return head .. "/…/" .. tail
    end
  end
  -- not even `head/…/name` fits, so drop the head
  local name = parts[#parts]
  if strwidth(name) + 2 <= width then
    return "…/" .. name
  end
  -- the filename alone is wider than the window
  return Snacks.picker.util.truncate(name, width, true)
end

--- Show the project-relative path in the preview border title.
--- `snacks.picker.preview.file` otherwise falls back to the bare filename.
---@param opts snacks.picker.Config
local function with_path_title(opts)
  local preview = Snacks.picker.config.preview(opts)
  opts.preview = function(ctx)
    local path = ctx.item and Snacks.picker.util.path(ctx.item)
    if path and not ctx.item.preview_title and not ctx.item.title then
      local width = vim.api.nvim_win_is_valid(ctx.win) and vim.api.nvim_win_get_width(ctx.win) or 80
      -- `math.huge` makes truncpath relativize (cwd / git root / ~) without truncating
      local rel = Snacks.picker.util.truncpath(path, math.huge, { cwd = ctx.picker:cwd() })
      ctx.item.preview_title = fit_path(rel, math.max(width - 4, 20))
    end
    return preview(ctx)
  end
  return opts
end

--- Columns per press when scrolling the preview sideways. The built-in
--- `preview_scroll_left`/`preview_scroll_right` move a single column, which is
--- nothing next to the half-page `<c-f>`/`<c-b>` they sit beside.
local preview_hscroll_columns = 10

--- Scroll the preview sideways. Inert in previews that wrap their lines
--- (diffs, git log), the same as `zh`/`zl` anywhere else.
---@param picker snacks.Picker
---@param left boolean
local function preview_hscroll(picker, left)
  local win = picker.preview.win
  if win:valid() then
    vim.api.nvim_win_call(win.win, function()
      vim.cmd(("normal! %d%s"):format(preview_hscroll_columns, left and "zh" or "zl"))
    end)
  end
end

--- How much of a maximized picker the preview gets. The list only needs room
--- for paths, so `<a-m>` is worth more as a reading pane than as a bigger copy
--- of the same 50/50 split.
local maximized_preview_width = 0.7

--- Call `cb` on every preview that sits in a horizontal box. Vertical layouts
--- (`vertical`, `sidebar`, `dropdown`) split on height, so their preview width
--- is not the ratio to touch.
---@param box snacks.layout.Box
---@param cb fun(win: snacks.layout.Win)
local function each_side_preview(box, cb)
  for _, child in ipairs(box) do
    if child.box then
      each_side_preview(child, cb)
    elseif child.win == "preview" and box.box == "horizontal" then
      cb(child)
    end
  end
end

--- The preset ratios, kept the first time a layout is widened so the split can
--- be put back. Keyed by the win spec in the layout config, weakly: a closed
--- picker's layout should not be held alive by this.
---@type table<snacks.layout.Win, number>
local preset_widths = setmetatable({}, { __mode = "k" })

--- Give the preview `maximized_preview_width`, or hand the preset ratio back.
--- Reports whether the layout had a side preview to resize at all.
---@param layout snacks.picker.layout.Config
---@param maximized boolean
---@return boolean
local function set_preview_width(layout, maximized)
  local found = false
  each_side_preview(layout.layout, function(win)
    found = true
    if maximized then
      -- `or win.width` so a second pass over an already-wide layout keeps the
      -- preset rather than recording 0.7 as the thing to restore
      preset_widths[win] = preset_widths[win] or win.width
      win.width = maximized_preview_width
    else
      win.width = preset_widths[win] or win.width
    end
  end)
  return found
end

--- Fullscreen, but with a narrower result list. `layout:maximize()` only flips
--- the fullscreen flag and keeps the preset ratio, so set the widths first:
--- `layout:update()` re-reads them from `opts.layout` on every call.
---@param picker snacks.Picker
local function toggle_maximize(picker)
  local layout = picker.layout
  set_preview_width(layout.opts, not layout.opts.fullscreen)
  layout:maximize()
end

--- Open in the shape `<a-m>` produces, so the preview is a reading pane from
--- the start and `<a-m>` becomes "shrink back to the preset".
--- Only for floats with a preview beside the list: `select` (`vim.ui.select`)
--- and the explorer sidebar have nothing to gain from fullscreen, and splits
--- are not floats to begin with.
--- Decided once per picker -- `config` runs again on every refresh, and forcing
--- the flag there would undo `<a-m>` on the next keystroke.
---@param opts snacks.picker.Config
---@return snacks.picker.Config
local function maximize_by_default(opts)
  if opts.maximized_default then
    return opts
  end
  opts.maximized_default = true
  -- resolve the preset into a concrete layout, so there are widths to set
  local layout = Snacks.picker.config.layout(opts)
  if (layout.layout.position or "float") == "float" and set_preview_width(layout, true) then
    layout.fullscreen = true
    opts.layout = layout
  end
  return opts
end

--- How long a picker waits for results before showing itself empty. The 5s
--- default exists so a picker that may auto-confirm a lone result can close
--- again without ever flashing on screen. Everywhere else it just means an
--- unchanged screen while a cold LSP server gets around to answering `gr`.
--- Still long enough that a quick finder finishes first and keeps its
--- "No results" notification, since a shown picker no longer emits one.
local show_delay = 200

--- LSP sources that may still jump straight to a lone result. `gd`/`gD`/`gy`
--- name a single target, so a picker for one item is only in the way.
--- References, implementations and calls are lists: those always show.
local auto_confirm_sources = {
  lsp_definitions = true,
  lsp_declarations = true,
  lsp_type_definitions = true,
}

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      -- Runs for every picker, after defaults/source/call opts are merged.
      config = function(opts)
        -- Every LSP location source sets `auto_confirm = true` and jumps
        -- straight to a lone result. Keep that only where a single result is
        -- the point; `gr` and `gI` should show their list either way.
        -- Set here rather than per source: the source layer merges *over* the
        -- user config, so `sources = { lsp_references = ... }` alone would lose.
        opts.auto_confirm = auto_confirm_sources[opts.source] == true
        -- Only for pickers that are going to be shown anyway: a picker that is
        -- already on screen never auto-confirms, so shortening the wait for
        -- `gd` would turn every jump into a one-item list to confirm by hand.
        if not opts.auto_confirm then
          opts.show_delay = show_delay
        end
        return maximize_by_default(with_path_title(filters.apply(opts)))
      end,
      actions = {
        -- override built-in actions, so the keys mapped to them pick these up
        toggle_maximize = toggle_maximize,
        preview_scroll_left = function(picker)
          preview_hscroll(picker, true)
        end,
        preview_scroll_right = function(picker)
          preview_hscroll(picker, false)
        end,
        toggle_tests = function(picker)
          toggle(picker, { "hide_tests" }, "test files")
        end,
        toggle_imports = function(picker)
          toggle(picker, { "hide_imports" }, "imports")
        end,
        -- both at once; each half is simply inert where it does not apply
        toggle_noise = function(picker)
          toggle(picker, { "hide_tests", "hide_imports" }, "test files and imports")
        end,
      },
      sources = {
        files = {
          hidden = true,
          ignored = false,
          -- exclude = { "node_modules", "dist", ".git" },
        },
        grep = {
          hidden = true,
        },
        lines = {
          finder = "lines",
          format = "lines",
          layout = {
            preset = "default",
            preview = "preview",
          },
        },
      },
      win = {
        -- input window
        input = {
          keys = {
            -- Hide/show test files and import lines, globally and for good
            ["<a-q>"] = { "toggle_noise", mode = { "i", "n" } },
            ["<a-t>"] = { "toggle_tests", mode = { "i", "n" } },
            ["<a-u>"] = { "toggle_imports", mode = { "i", "n" } },
            -- Move around the preview without leaving the input. Plain arrows
            -- move the list and the cursor in the query, so ctrl moves the
            -- preview; `<c-f>`/`<c-b>` keep scrolling it up and down as well.
            ["<c-Left>"] = { "preview_scroll_left", mode = { "i", "n" } },
            ["<c-Down>"] = { "preview_scroll_down", mode = { "i", "n" } },
            ["<c-Up>"] = { "preview_scroll_up", mode = { "i", "n" } },
            ["<c-Right>"] = { "preview_scroll_right", mode = { "i", "n" } },
            -- Easy exit
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<F1>"] = { "close", mode = { "i", "n" } },
            ["<F2>"] = { "close", mode = { "i", "n" } },
            ["<F3>"] = { "close", mode = { "i", "n" } },
            ["<F4>"] = { "close", mode = { "i", "n" } },
          },
        },
        -- result list window
        list = {
          keys = {
            ["<a-q>"] = "toggle_noise",
            ["<a-t>"] = "toggle_tests",
            ["<a-u>"] = "toggle_imports",
            ["<c-Left>"] = "preview_scroll_left",
            ["<c-Down>"] = "preview_scroll_down",
            ["<c-Up>"] = "preview_scroll_up",
            ["<c-Right>"] = "preview_scroll_right",
          },
        },
      },
    },
  },
  -- https://www.lazyvim.org/extras/editor/snacks_picker#snacksnvim
  keys = {
    -- Fix for cwd vs root
    { "<leader>/", LazyVim.pick("grep", { root = false }), desc = "Grep (Root Dir)" },
    { "<leader>ff", lazyvim.pick("files", { root = false }), desc = "Find Files (Root Dir)" },
    { "<leader>fF", lazyvim.pick("files", { root = true }), desc = "Find Files (cwd)" },
    { "<leader>sg", LazyVim.pick("live_grep", { root = false }), desc = "Grep (Root Dir)" },
    { "<leader>sG", LazyVim.pick("live_grep", { root = true }), desc = "Grep (cwd)" },
    {
      "<leader>sw",
      LazyVim.pick("grep_word", { root = false }),
      desc = "Visual selection or word (Root Dir)",
      mode = { "n", "x" },
    },
    {
      "<leader>sW",
      LazyVim.pick("grep_word", { root = true }),
      desc = "Visual selection or word (cwd)",
      mode = { "n", "x" },
    },
  },
}
