local cmd = vim.cmd

cmd "packadd packer.nvim"
cmd ":command Update :PackerSync"

local present, packer = pcall(require, "packer")
if not present then
  local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

  print "Cloning packer.."
  -- remove the dir before cloning
  vim.fn.delete(packer_path, "rf")
  vim.fn.system {
    "git",
    "clone",
    "https://github.com/wbthomason/packer.nvim",
    "--depth",
    "20",
    packer_path,
  }

  cmd "packadd packer.nvim"
  present, packer = pcall(require, "packer")

  if present then
    print "Packer cloned successfully."
  else
    error("Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer)
  end
end

local config = {
  display = {
    open_fn = require('packer.util').float,
  }
}

-- To test with nvim v7
-- https://github.com/mrjones2014/legendary.nvim

packer.startup({
  function()
    -- Packer manager
    use {
      "wbthomason/packer.nvim",
      opt = true,
    }
    -- Common lua functions
    use "nvim-lua/plenary.nvim"
    -- Icons
    use "kyazdani42/nvim-web-devicons"
    -- Profiling
    use {
      'dstein64/vim-startuptime',
      cmd = 'StartupTime'
    }
    -- Show indents
    use {
      "lukas-reineke/indent-blankline.nvim",
      config = [[require("plugin/indent")]],
    }
    -- Text matching
    use {
      "andymass/vim-matchup",
      opt = true
    }
    -- Theme
    use {
      'folke/tokyonight.nvim',
      config = [[require("plugin/tokyonight")]],
    }
    -- Status Bar
    use {
      "hoob3rt/lualine.nvim",
      requires = { "arkav/lualine-lsp-progress" },
      config = [[require("plugin/lualine")]],
    }
    -- Terminal
    use {
      "numtostr/FTerm.nvim",
      config = [[require("plugin/terminal").config()]],
    }
    -- cd to project root
    use "ygm2/rooter.nvim"
    -- Tree
    use {
      "kyazdani42/nvim-tree.lua",
      after = "tokyonight.nvim",
      config = [[require("plugin/nvim-tree/config").config()]],
    }
    -- Tabs for buffers
    use {
      "akinsho/nvim-bufferline.lua",
      after = "nvim-tree.lua",
      config = [[require("plugin/bufferline").config()]],
    }
    -- Telescope select
    use {'nvim-telescope/telescope-ui-select.nvim' }
    -- Telescope
    use {
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/popup.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        "nvim-telescope/telescope-project.nvim",
        "nvim-telescope/telescope-media-files.nvim",
        "crispgm/telescope-heading.nvim",
        "nvim-telescope/telescope-symbols.nvim",
      },
      -- event = "BufWinEnter",
      setup = [[require("plugin/telescope").keymap()]],
      config = [[require("plugin/telescope").config()]],
    }
    -- Zen editing
    use {
      "Pocco81/TrueZen.nvim",
      cmd = {"TZAtaraxis", "TZFocus", "TZMinimalist"},
      setup = [[require("plugin/truezen").keymap()]],
      config = [[require("plugin/truezen").config()]],
    }
    -- Faster movement
    use {
      'phaazon/hop.nvim',
      event = "BufWinEnter",
      config = [[require("plugin/hop")]],
    }
    -- Editorconfig
    use "editorconfig/editorconfig-vim"
    -- Debugging
    use {
      "mfussenegger/nvim-dap",
      config = [[require("plugin/dap")]],
    }
    use {
      "rcarriga/nvim-dap-ui",
      requires = {"mfussenegger/nvim-dap"},
      config = [[require("plugin/dapui")]],
    }
    -- Expand visual selection
    use {
      "terryma/vim-expand-region",
      config = [[require("plugin/expand")]],
    }
    use {
      "kana/vim-textobj-line",
      requires = { "kana/vim-textobj-user" },
    }
    -- Syntax hightligting
    use {
      "nvim-treesitter/nvim-treesitter",
      event = "BufRead",
      run = ":TSUpdate",
      config = [[require("plugin/treesitter")]],
    }
    use {
      "nvim-treesitter/nvim-treesitter-textobjects",
      after = "nvim-treesitter",
    }
    use {
      "nvim-treesitter/nvim-treesitter-refactor",
      after = "nvim-treesitter",
    }
    use {
      "windwp/nvim-ts-autotag",
      after = "nvim-treesitter",
    }
    -- Required for theme debug only
    -- use {
    --   'nvim-treesitter/playground',
    --   cmd = { 'TSPlaygroundToggle' },
    --   after = "nvim-treesitter",
    -- }
    -- Comments
    use {
      'b3nj5m1n/kommentary',
      event = "BufWinEnter",
      config = [[require("plugin/comments")]],
    }
    -- Argument swapping
    use {
      'machakann/vim-swap',
      event = "BufWinEnter",
    }
    -- LSP
    use {
      "neovim/nvim-lspconfig",
      config = [[require("plugin/lspconfig/config")]],
    }
    use {
      "folke/trouble.nvim",
      config = [[require("plugin/trouble")]],
    }
    -- Formatter
    use {
      "mhartington/formatter.nvim",
      cmd = { "Format", "FormatWrite" },
      setup = [[require("plugin/formatter").keymap()]],
      config = [[require("plugin/formatter").config()]],
    }
    -- Autocomplete
    use {
      "hrsh7th/nvim-cmp",
      requires = {
        { 'onsails/lspkind-nvim', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
        { 'hrsh7th/cmp-calc', after = 'nvim-cmp' },
        { 'saadparwaiz1/cmp_luasnip', after = 'nvim-cmp' },
        { 'L3MON4D3/LuaSnip', after = 'nvim-cmp' },
      },
      event = 'InsertEnter',
      config = [[require("plugin/nvim-cmp")]],
    }
    -- Auto pair parenthesis
    use {
      "windwp/nvim-autopairs",
      after = 'nvim-cmp',
      config = [[require("plugin/autopairs")]],
    }
    -- Git
    use {
      "lewis6991/gitsigns.nvim",
      event = 'BufEnter',
      config = [[require("gitsigns").setup({})]],
    }
    use {
      'TimUntersberger/neogit',
      cmd = {
        'Neogit',
        'Neogit commit',
      },
      requires = { 'sindrets/diffview.nvim' },
      config = [[require("plugin/neogit")]],
    }
    -- Spellchecker
    use {
      "lewis6991/spellsitter.nvim",
      event = 'BufEnter',
      config = [[require("plugin/spellsitter")]],
    }
    -- Rust
    use {
      "simrat39/rust-tools.nvim",
      ft = "rust",
      config = [[require("plugin/rust-tools")]],
    }
    use {
      "saecki/crates.nvim",
      ft = "toml",
      requires = { "nvim-lua/plenary.nvim"}
    }
    -- Toml
    use {
      "cespare/vim-toml",
      ft = "toml",
    }
    -- CSS
    use {
      "norcalli/nvim-colorizer.lua",
      ft = {"css", "html", "javascript", "lua", "typescript"},
      config = [[require("colorizer").setup()]],
    }
  end,
  config = config
})

vim.defer_fn(function()
  -- Check if there is only packer installed so we can decide if we should
  -- use PackerInstall or PackerSync, useful for generating the
  -- `plugin/packer_compiled.lua` on first doom launch
  local installed = vim.tbl_count(vim.fn.globpath(vim.fn.stdpath("data") .. "/site/pack/packer/opt", "*", 0, 1))
  if installed == 1 then
    vim.cmd("PackerSync")
  else
    vim.cmd("PackerClean")
    vim.cmd("PackerInstall")
  end
end, 200)
