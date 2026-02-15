return {
  {
    "psliwka/vim-dirtytalk",
    build = ":DirtytalkUpdate",
    config = function()
      -- This adds "programming" to the existing spelllang list
      vim.opt.spelllang:append("programming")
      -- Ensure spell checking is actually on
      -- vim.opt.spell = true
    end,
  },
}
