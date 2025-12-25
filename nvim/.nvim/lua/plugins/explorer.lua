local function focus_filetype(ft)
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == ft then
      vim.api.nvim_set_current_win(win)
      return true
    end
  end
  return false
end

local function focus()
  local explorer = require("snacks").explorer
  local explorer_ft = "snacks_picker_list"
  if vim.bo.filetype == explorer_ft then
    vim.cmd("wincmd p")
  elseif not focus_filetype("snacks_picker_list") then
    explorer.open()
  end
end

local function toggle()
  local explorer = require("snacks").explorer
  explorer.open()
end

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        -- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md#%EF%B8%8F-config
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { ".git" },
          layout = {
            cycle = false,
            auto_hide = { "input" },
          },
          win = {
            input = {
              keys = {
                ["<ESC>"] = false,
              },
            },
            list = {
              keys = {
                ["<ESC>"] = false,
              },
            },
          },
        },
      },
    },
  },
  keys = {
    { "<F3>", focus, mode = { "n", "x", "i" }, desc = "Explorer: Toggle focus" },
    { "<F4>", toggle, mode = { "n", "x", "i" }, desc = "Explorer: Toggle" },
  },
}
