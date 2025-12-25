local theme = require("util.theme")

return {
  {
    "folke/snacks.nvim",
    dependencies = { theme.pluginName },
    opts = function(_, opts)
      ---@type Rainbow
      local rainbow = theme.resolve().rainbow
      return vim.tbl_extend("force", opts, {
        indent = {
          enabled = true,
          animate = {
            enabled = false,
          },
          indent = {
            hl = rainbow.dark_groups,
          },
          scope = {
            hl = rainbow.groups,
          },
        },
      })
    end,
  },
}
