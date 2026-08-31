-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- Keep buffers (and thus attached LSP clients) in sync with files changed
-- externally, e.g. by Claude Code editing/renaming/deleting files on disk
-- while nvim isn't focused. Two layers:
--   1. `checktime` on a wide set of events, for whichever buffer you're
--      looking at when you refocus/idle.
--   2. A per-file libuv watcher, so buffers reload (or close, if deleted)
--      the instant Claude writes to disk -- no focus change required.
vim.o.autoread = true

-- `was_read_from_disk` distinguishes "file that used to exist and vanished"
-- from a fresh `:e newfile.rs` you haven't saved yet, so the latter is never
-- auto-closed below.
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    vim.b[args.buf].was_read_from_disk = true
  end,
})

-- Grace period before treating a missing file as genuinely deleted (see
-- below). Covers editors/formatters/git that save via "write temp file,
-- then swap it into place" (or delete-then-recreate), which produce a real
-- but brief window where the path doesn't exist -- same class of race as
-- the RaspberryPi I/O comment further down in this file.
local DELETE_GRACE_MS = 400

-- Reload `buf` from disk, or close it if its file was deleted/renamed away.
-- `checktime` alone can't handle deletion: it just warns and leaves a stale
-- buffer that LSP servers keep serving from their open-document overlay
-- (e.g. rust-analyzer will happily search for references inside a buffer
-- whose file no longer exists in the crate graph).
local function sync_buffer(buf)
  if
    not vim.api.nvim_buf_is_valid(buf)
    or not vim.api.nvim_buf_is_loaded(buf)
    or vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= ""
  then
    return
  end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then
    return
  end

  if vim.fn.filereadable(name) == 1 then
    vim.cmd("checktime " .. buf)
    return
  end

  if not vim.b[buf].was_read_from_disk or vim.api.nvim_get_option_value("modified", { buf = buf }) then
    return
  end

  -- Don't act on a single negative read -- re-check after a grace period so
  -- an in-progress atomic save doesn't get mistaken for a deletion.
  vim.defer_fn(function()
    if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_buf_is_loaded(buf) then
      return
    end
    if vim.fn.filereadable(name) == 1 then
      vim.cmd("checktime " .. buf)
      return
    end
    if vim.api.nvim_get_option_value("modified", { buf = buf }) then
      return
    end

    -- Detach LSP clients regardless: this fixes the actual bug (a server
    -- serving stale results for a document that no longer exists on disk)
    -- without touching the buffer itself.
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
      vim.lsp.buf_detach_client(buf, client.id)
    end

    -- Only wipe the buffer if it isn't on screen anywhere. Force-deleting a
    -- buffer that's displayed in a window/split closes that window (Neovim
    -- has no "show something else here" fallback for a window whose only
    -- buffer just got deleted from under it), which cascades into visible
    -- glitches (line numbers/signcolumn/gitsigns not showing correctly in
    -- whatever ends up filling that space). A buffer nobody is looking at
    -- can be safely removed from the buffer list.
    if #vim.fn.win_findbuf(buf) == 0 then
      pcall(vim.api.nvim_buf_delete, buf, { force = false })
      vim.notify("Closed buffer for externally deleted file: " .. name, vim.log.levels.INFO)
    else
      vim.notify("File deleted externally, LSP detached: " .. name, vim.log.levels.WARN)
    end
  end, DELETE_GRACE_MS)
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "WinEnter", "TermLeave", "CursorHold", "CursorHoldI" }, {
  callback = function(args)
    sync_buffer(args.buf)
  end,
})

-- Per-file fs watcher: reloads/closes buffers the moment they change on
-- disk, independent of focus. Deliberately watches individual open files
-- rather than the project tree -- libuv's `recursive` watch option only
-- works on macOS/Windows, so a directory-tree watcher would behave
-- differently on Linux. One watch per open file avoids that split entirely
-- and is cheap since it's bounded by how many buffers you actually have
-- open, not repo size.
local file_watchers = {} ---@type table<integer, uv_fs_event_t>

local function stop_file_watcher(buf)
  local handle = file_watchers[buf]
  if handle then
    if not handle:is_closing() then
      handle:stop()
      handle:close()
    end
    file_watchers[buf] = nil
  end
end

local function start_file_watcher(buf)
  if
    not vim.api.nvim_buf_is_loaded(buf)
    or vim.api.nvim_get_option_value("buftype", { buf = buf }) ~= ""
  then
    return
  end
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" or vim.fn.filereadable(path) == 0 then
    return
  end
  stop_file_watcher(buf)

  local handle = assert(vim.uv.new_fs_event())
  file_watchers[buf] = handle
  handle:start(path, {}, function(err)
    if err then
      return
    end
    vim.schedule(function()
      sync_buffer(buf)
    end)
  end)
end

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(args)
    start_file_watcher(args.buf)
  end,
})
vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
  callback = function(args)
    stop_file_watcher(args.buf)
  end,
})
-- Watch buffers already open when this config loads (e.g. `nvim file.rs`).
vim.schedule(function()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    start_file_watcher(buf)
  end
end)

-- Disable autoformat for some file types
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "html", "markdown" },
  callback = function()
    vim.b.autoformat = false
  end,
})

-- Sometimes on RaspberryPi there is a race condition caused by slow I/O
-- that breaks file type detection.
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    if vim.bo.filetype == "" or vim.bo.filetype == nil then
      vim.api.nvim_command("filetype detect")
    end
  end,
})

-- Cleanup usused imports in rust files
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    -- 1. Check if autoformat is disabled (globally or for this buffer)
    -- This works with most common 'autoformat' toggle plugins/configs
    if vim.g.autoformat == false or vim.b.autoformat == false then
      return
    end

    local diags = vim.diagnostic.get(0)
    local items_to_delete = {}

    -- 2. Identify unused import squiggles
    for _, d in ipairs(diags) do
      if d.code == "unused_imports" or (d.message and d.message:find("unused import")) then
        table.insert(items_to_delete, {
          lnum = d.lnum,
          s_col = d.col,
          e_col = d.end_col,
        })
      end
    end

    if #items_to_delete == 0 then
      return
    end

    -- 3. Sort backwards to prevent coordinate shifting
    table.sort(items_to_delete, function(a, b)
      if a.lnum ~= b.lnum then
        return a.lnum > b.lnum
      end
      return a.s_col > b.s_col
    end)

    for _, item in ipairs(items_to_delete) do
      vim.api.nvim_buf_set_text(0, item.lnum, item.s_col, item.lnum, item.e_col, {})

      local line = vim.api.nvim_buf_get_lines(0, item.lnum, item.lnum + 1, false)[1]
      if line then
        -- Aggressive cleanup: remove empty braces, double commas, and 'empty' use paths
        local cleaned = line
          :gsub(",%s*,", ",") -- Remove double commas
          :gsub("{%s*,", "{") -- Remove leading comma in brace
          :gsub(",%s*}", "}") -- Remove trailing comma in brace
          :gsub("{%s*}", "") -- Remove empty braces
          :gsub("::%s*;", ";") -- Clean up trailing colons: std::; -> std;
          :gsub("use%s*[%w_:]*%s*;", "") -- Remove use lines that have no import target

        -- Final check: if the line is now just whitespace, delete it
        if cleaned:match("^%s*$") then
          vim.api.nvim_buf_set_lines(0, item.lnum, item.lnum + 1, false, {})
        else
          vim.api.nvim_buf_set_lines(0, item.lnum, item.lnum + 1, false, { cleaned })
        end
      end
    end
  end,
})
