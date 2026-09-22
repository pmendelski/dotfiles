--- Extra keys that scroll the which-key popup, on top of `opts.keys`.
--- which-key compares each key against a single `scroll_down`/`scroll_up`, so
--- these are rewritten into the configured ones before it sees them.
local scroll_aliases = {
  ["<C-Down>"] = "scroll_down",
  ["<C-Up>"] = "scroll_up",
}

return {
  "folke/which-key.nvim",
  opts = function()
    -- HACK: `getchar` is internal, but it is the one place every key read by
    -- the popup passes through. Only while the popup is shown: otherwise the
    -- key is a mapping continuation, and must stay what was pressed.
    local State = require("which-key.state")
    if State.scroll_aliased then
      return -- opts are resolved again on reload
    end
    State.scroll_aliased = true
    local getchar = State.getchar
    State.getchar = function()
      local ok, char = getchar()
      local action = ok and scroll_aliases[vim.fn.keytrans(char)]
      if action and require("which-key.view").valid() then
        char = vim.keycode(require("which-key.config").keys[action])
      end
      return ok, char
    end
  end,
}
