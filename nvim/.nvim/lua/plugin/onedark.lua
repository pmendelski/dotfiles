local onedarkpro = require('onedarkpro')
onedarkpro.setup({
  theme = "onedark", -- The theme to be used (opts: 'onedark' or 'onelight')
  -- colors = {}, -- Override default colors
  -- hlgroups = {}, -- Override default highlight groups
  -- styles = {
  --     strings = "NONE", -- Style that is applied to strings
  --     comments = "NONE", -- Style that is applied to comments
  --     keywords = "NONE", -- Style that is applied to keywords
  --     functions = "NONE", -- Style that is applied to functions
  --     variables = "NONE", -- Style that is applied to variables
  -- },
  options = {
      bold = true, -- Use the themes opinionated bold styles?
      italic = false, -- Use the themes opinionated italic styles?
      underline = true, -- Use the themes opinionated underline styles?
      undercurl = true, -- Use the themes opinionated undercurl styles?
      transparent = false, -- Use a transparent background?
      highlight_cursorline = true, -- Use cursorline highlighting?
  }
})
onedarkpro.load()
