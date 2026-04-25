return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        go = {}, -- Disable golangci-lint
      },
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", os.getenv("HOME") .. "/.markdownlint.yaml", "--" },
        },
      },
    },
  },
}
