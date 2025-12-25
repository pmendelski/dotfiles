return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        notifications = {
          win = {
            preview = {
              wo = {
                wrap = true,
              },
            },
          },
          confirm = function(picker, item)
            picker:close()
            Snacks.win({
              text = item.text,
              width = 0.8,
              height = 0.9,
              wo = {
                spell = false,
                wrap = true,
              },
            })
          end,
        },
      },
    },
  },
}
