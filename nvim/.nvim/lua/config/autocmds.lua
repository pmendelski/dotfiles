-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

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
