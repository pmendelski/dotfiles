return {
  "folke/snacks.nvim",
  opts = {
    styles = {
      -- Wrap text in notifications
      notifications = {
        wo = {
          wrap = true,
        },
      },
    },
    picker = {
      sources = {
        -- Show notifications picker with a preview and option to show full message on enter
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
