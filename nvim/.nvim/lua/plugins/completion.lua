-- https://www.lazyvim.org/extras/coding/blink
-- https://cmp.saghen.dev/configuration/keymap.html#super-tab
return {
  "saghen/blink.cmp",
  build = "cargo +nightly build --release",
  opts = {
    keymap = {
      preset = "super-tab",
      ["<CR>"] = { "accept", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<ESC>"] = { "hide", "fallback" },
    },
    completion = {
      ghost_text = { enabled = false },
    },
    sources = {
      -- default = { "lsp", "path", "snippets" },
      providers = {
        lsp = { fallbacks = {}, score_offset = 2 },
        path = { fallbacks = {}, score_offset = 1 },
        snippets = {
          fallbakcs = {},
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
