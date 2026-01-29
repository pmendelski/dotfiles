return {
  "saghen/blink.cmp",
  build = "cargo +nightly build --release",
  opts = {
    keymap = {
      -- Turn off default mappings
      preset = "none",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },
      ["<CR>"] = { "accept", "fallback" },
      -- Only Tab and S-Tab are used to navigate the menu
      -- SMART TAB:
      ["<Tab>"] = {
        function(cmp)
          -- 1. Jeśli menu jest otwarte, wybierz następny element
          if cmp.is_visible() then
            return cmp.select_next()
          -- 2. Jeśli menu jest zamknięte, ale jesteśmy w snippecie, skocz dalej
          elseif cmp.snippet_active() then
            return cmp.snippet_forward()
          end
        end,
        "fallback", -- Jeśli żadne z powyższych, wstaw zwykły Tab
      },
      -- SMART S-TAB:
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.is_visible() then
            return cmp.select_prev()
          elseif cmp.snippet_active() then
            return cmp.snippet_backward()
          end
        end,
        "fallback",
      },
      -- Other
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
      ["<C-n>"] = { "select_next", "fallback_to_mappings" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },
    completion = {
      ghost_text = { enabled = false },
      list = { selection = { preselect = false }, cycle = { from_top = false } },
    },
    sources = {
      -- default = { "lsp", "path", "snippets" },
      providers = {
        lsp = { fallbacks = {}, score_offset = 2 },
        path = { fallbacks = {}, score_offset = 1 },
        snippets = {
          override = {
            get_trigger_characters = function()
              return { "#", "!" }
            end,
          },
        },
        buffer = { fallbacks = {}, enabled = false },
      },
    },
  },
}
