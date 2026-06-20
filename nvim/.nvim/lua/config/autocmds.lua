-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- Reload buffers changed externally (e.g. by Claude Code or git)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})

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
