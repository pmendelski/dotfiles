return {
  "folke/snacks.nvim",
  keys = {
    {
      "<F1>",
      mode = { "n", "x", "i", "t" },
      function()
        require("snacks").terminal.toggle("$SHELL", {
          win = { style = "float" },
        })
      end,
      desc = "Term: Toggle floating terminal",
    },
    {
      "<F2>",
      mode = { "n", "x", "i", "t" },
      function()
        require("snacks").terminal.toggle(nil, { win = { style = "split" } })
      end,
      desc = "Term: Toggle bottom terminal",
    },
  },
}
