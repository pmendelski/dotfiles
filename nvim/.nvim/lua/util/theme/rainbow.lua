-- rainbow delimiters
local default_rainbow_colors = {
  "#F6ED56",
  "#A6C955",
  "#4BA690",
  "#4191C9",
  "#2258A0",
  "#654997",
  "#994D95",
  "#D45196",
  "#DB3A35",
  "#E5783A",
  "#EC943F",
  "#F7C247",
}

local default_bg_color = "#16161e"

local function strip_hash(s)
  if s:find("^#") ~= nil then
    return s:sub(2)
  end
  return s
end

local function hex_to_table(h)
  local r = tonumber(h:sub(1, 2), 16)
  local g = tonumber(h:sub(3, 4), 16)
  local b = tonumber(h:sub(5), 16)
  return { r, g, b }
end

local function mix_color(a, b, pa)
  local num = math.floor(a * pa) + math.floor(b * (1 - pa))
  local adjusted = math.min(math.max(num, 0), 255)
  local res = string.format("%x", adjusted)
  return res
end

--- Mixes two RGB color strings with an optional ratio.
---@param a string The first color.
---@param b string The second color.
---@param pa number The mixture ratio for a, should be a number between 0 and 1. The mixture
---of b is automatically (1 - a).
---@return string
local function mix_colors(a, b, pa)
  local color_a = hex_to_table(strip_hash(a))
  local color_b = hex_to_table(strip_hash(b))
  pa = pa or 0.5 -- default to even mix
  local res = "#"
  for i, _ in ipairs(color_a) do
    res = res .. mix_color(color_a[i], color_b[i], pa)
  end
  return res
end

local function setup_rainbow(prefix, bg, colors, bright)
  for i, color in ipairs(colors) do
    local darker = mix_colors(color, bg, bright)
    vim.api.nvim_set_hl(0, prefix .. i, { fg = darker })
  end
end

local prefixes = {
  delim = "RainbowDelim",
  dimDelim = "RainbowDimDelim",
  darkDelim = "RainbowDarkDelim",
}

local function groups(prefix, n)
  local out = {}
  for i = 1, n do
    table.insert(out, prefix .. i)
  end
  return out
end

---@module rainbow
local M = {}

---@class Rainbow
---@field groups string[]
---@field dim_groups string[]
---@field dark_groups string[]

---@param bg_color? string
---@param colors? string[]
---@return Rainbow
function M.setup(bg_color, colors)
  local c = colors or default_rainbow_colors
  local bg = bg_color or default_bg_color
  local count = 0
  setup_rainbow(prefixes.delim, bg, c, 1)
  setup_rainbow(prefixes.dimDelim, bg, c, 0.85)
  setup_rainbow(prefixes.darkDelim, bg, c, 0.2)
  for _ in pairs(c) do
    count = count + 1
  end
  return {
    groups = groups(prefixes.delim, count),
    dim_groups = groups(prefixes.dimDelim, count),
    dark_groups = groups(prefixes.darkDelim, count),
  }
end

return M
