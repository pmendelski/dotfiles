local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
  end,
  buffer_not_plugin = function()
    return vim.bo.filetype ~= "snacks_picker_list"
      and vim.bo.filetype ~= "snacks_picker_input"
      and vim.bo.filetype ~= "Trouble"
  end,
  buffer_wide = function()
    return vim.fn.winwidth(0) > 80
  end,
  check_git_workspace = function()
    local filepath = vim.fn.expand("%:p:h")
    local gitdir = vim.fn.finddir(".git", filepath .. ";")
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end,
}

local fileFormatIcons = {
  unix = "", -- e712
  dos = "", -- e70f
  mac = "", -- e711
}

local encoding = {
  function()
    local encoding = vim.bo.fileencoding
    if encoding == "utf-8" then
      encoding = ""
    end
    local format = vim.bo.fileformat
    if format == "unix" then
      return encoding
    end
    if not vim.g.term_unicodes_enabled then
      return encoding
    end
    local icon = fileFormatIcons[format] or format
    return encoding .. " " .. icon
  end,
  cond = function()
    return conditions.buffer_wide() and conditions.buffer_not_plugin()
  end,
  separator = " ",
  padding = { left = 0, right = 1 },
}

local file_size = {
  function()
    local function format_file_size(file)
      local size = vim.fn.getfsize(file)
      if size <= 0 then
        return ""
      end
      local sufixes = { "b", "k", "m", "g" }
      local i = 1
      while size > 1024 do
        size = size / 1024
        i = i + 1
      end
      return string.format("%.1f%s", size, sufixes[i])
    end

    local file = vim.fn.expand("%:p")
    if string.len(file) == 0 then
      return ""
    end
    return format_file_size(file)
  end,
  cond = function()
    return conditions.buffer_not_empty() and conditions.buffer_wide() and conditions.buffer_not_plugin()
  end,
  separator = " ",
}

local function disable_icons(config)
  local result = {}
  for _, v in ipairs(config) do
    if type(v) == "string" or type(v) == "function" then
      table.insert(result, { v, icons_enabled = false })
    else
      local mapped = vim.tbl_deep_extend("force", v, { icons_enabled = false })
      table.insert(result, mapped)
    end
  end
  return result
end

local function disable_separators(config)
  local result = {}
  for _, v in ipairs(config) do
    if type(v) == "string" or type(v) == "function" then
      table.insert(result, { v, separator = " " })
    else
      local mapped = vim.tbl_deep_extend("force", v, { separator = " " })
      table.insert(result, mapped)
    end
  end
  return result
end

return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    opts = vim.tbl_deep_extend("force", opts, {
      sections = {
        lualine_z = {
          file_size,
          encoding,
        },
      },
    })
    if not vim.g.term_unicodes_enabled then
      opts = vim.tbl_deep_extend("force", opts, {
        options = {
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = disable_separators(opts.sections.lualine_a),
          lualine_b = disable_separators(opts.sections.lualine_b),
          lualine_c = disable_separators(opts.sections.lualine_c),
          lualine_x = disable_separators(opts.sections.lualine_x),
          lualine_y = disable_separators(opts.sections.lualine_y),
          lualine_z = disable_separators(opts.sections.lualine_z),
        },
      })
    end
    if not vim.g.term_nerd_font_enabled then
      opts = vim.tbl_deep_extend("force", opts, {
        options = {
          icons_enabled = false,
        },
        sections = {
          lualine_a = disable_icons(opts.sections.lualine_a),
          lualine_b = disable_icons(opts.sections.lualine_b),
          lualine_c = disable_icons(opts.sections.lualine_c),
          lualine_x = disable_icons(opts.sections.lualine_x),
          lualine_y = disable_icons(opts.sections.lualine_y),
          lualine_z = disable_icons(opts.sections.lualine_z),
        },
      })
    end
    return opts
  end,
}
