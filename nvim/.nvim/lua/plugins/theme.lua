---@type ThemeModule
local theme = require("util.theme")

return {
  theme.pluginName,
  config = theme.setup,
}
