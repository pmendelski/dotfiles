local config = {}

if vim.g.nvim_basic_formatting_enabled then
  config = {
    {
      "stevearc/conform.nvim",
      opts = {
        formatters_by_ft = {
          go = { "gofmt" },
        },
      },
    },
  }
end

return config
