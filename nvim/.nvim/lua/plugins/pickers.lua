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
        return with_path_title(filters.apply(opts))
      end,
      actions = {
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
