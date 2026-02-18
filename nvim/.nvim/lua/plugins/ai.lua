local config = {}

if vim.g.nvim_ai_enabled then
  config = {
    {
      "ravitemer/mcphub.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      build = "npm install -g mcp-hub@latest",
      config = function()
        require("mcphub").setup({
          config = vim.fn.expand("~/.config/nvim/mcp_servers.json"),
        })
      end,
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      build = "make",
      opts = {
        provider = "gemini",
        -- No more 'dummy' commands. Use the actual environment variable.
        providers = {
          gemini = {
            model = "gemini-2.5-flash-lite", -- Higher RPM on free tier
            -- model = "gemini-2.0-flash",
            api_key_name = "GEMINI_API_KEY",
            -- REDUCE THESE to stay under the 250k TPM limit
            max_tokens = 4096, -- Default is often 20,000+
            temperature = 0, -- Keeps code refactoring predictable
          },
        },
        behaviour = {
          -- IMPORTANT: Set this to false to stop background context indexing
          auto_suggestions = false,
          -- Disables automatic "planning" which sends multiple API calls per prompt
          enable_cursor_planning_mode = false,
        },
        custom_tools = function()
          return { require("mcphub.extensions.avante").mcp_tool() }
        end,
        hints = { enabled = false }, -- This disables the generic hints
        selection = {
          hint_display = "none", -- Specifically hides the <leader>aa popup in visual mode
        },
      },
    },
  }
end

return config
