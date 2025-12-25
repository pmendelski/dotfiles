local lazyvim = require("lazyvim.util")

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          hidden = true,
          ignored = false,
          -- exclude = { "node_modules", "dist", ".git" },
        },
        grep = {
          hidden = true,
        },
        -- lines = {
        --   finder = "lines",
        --   format = "lines",
        --   layout = {
        --     preset = "default",
        --     preview = "preview",
        --   },
        -- },
      },
      win = {
        -- input window
        input = {
          keys = {
            -- Easy exit
            ["<Esc>"] = { "close", mode = { "n", "i" } },
            ["<F1>"] = { "close", mode = { "i", "n" } },
            ["<F2>"] = { "close", mode = { "i", "n" } },
            ["<F3>"] = { "close", mode = { "i", "n" } },
            ["<F4>"] = { "close", mode = { "i", "n" } },
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
