return {
  "nvim-treesitter/nvim-treesitter",
  -- "VeryLazy" is too lazy and sometimes syntax is not loaded
  event = { "BufReadPost", "BufNewFile" },
}
