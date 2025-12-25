local style = "night"
local fullName = "tokyonight-" .. style
local theme = nil

---@class Theme
---@field name string
---@field fullName string
---@field variant string
---@field colors ColorScheme
---@field rainbow Rainbow

---@class ThemeModule
---@field name string
---@field fullName string
---@field variant string
---@field setup fun()
---@field resolve fun(): Theme?
local M = {
  name = "tokyonight",
  pluginName = "folke/tokyonight.nvim",
  fullName = fullName,
  variant = style,
}

---@return Theme
function M.resolve()
  local t = theme
  if not t then
    error("Theme plugin was not setup yet")
  end
  return t
end

function M.setup()
  ---@type tokyonight.Config
  local defaultConfig = require("tokyonight/config").defaults
  ---@type tokyonight.Config
  local config = vim.tbl_deep_extend("force", defaultConfig, {
    style = style,
  })
  require("tokyonight").setup(config)
  local colors = require("tokyonight/colors").setup(config)
  local rainbow = require("util/theme/rainbow").setup(colors.bg_dark)
  theme = {
    name = "tokyonight",
    fullName = fullName,
    variant = style,
    colors = colors,
    rainbow = rainbow,
  }
end

return M
