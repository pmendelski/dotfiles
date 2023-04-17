local cmd = vim.cmd

cmd("packadd packer.nvim")
cmd(":command Update :PackerSync")

local present, packer = pcall(require, "packer")
if not present then
	local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"

	print("Cloning packer..")
	-- remove the dir before cloning
	vim.fn.delete(packer_path, "rf")
	vim.fn.system({
		"git",
		"clone",
		"https://github.com/wbthomason/packer.nvim",
		"--depth",
		"20",
		packer_path,
	})

	cmd("packadd packer.nvim")
	present, packer = pcall(require, "packer")

	if present then
		print("Packer cloned successfully.")
	else
		error("Couldn't clone packer !\nPacker path: " .. packer_path .. "\n" .. packer)
	end
end

local snapshots = require("snapshots")
local config = {
	snapshot_path = snapshots.path(),
	autoremove = true,
	display = {
		open_fn = require("packer.util").float,
	},
}

packer.startup({
	function(use)
		-- Packer manager
		use({
			"wbthomason/packer.nvim",
			opt = true,
		})
		-- Common lua functions
		use("nvim-lua/plenary.nvim")
		-- Icons
		use("kyazdani42/nvim-web-devicons")
		-- Profiling
		-- use({
		-- 	"dstein64/vim-startuptime",
		-- 	cmd = "StartupTime",
		-- })
		-- Show indents
		use({
			"lukas-reineke/indent-blankline.nvim",
			config = [[require("plugin/indent")]],
		})
		-- Text matching
		use({
			"andymass/vim-matchup",
			opt = true,
		})
		-- Theme
		use({
			"folke/tokyonight.nvim",
			config = [[require("plugin/tokyonight")]],
		})
		-- Status Bar
		use({
			"nvim-lualine/lualine.nvim",
			requires = { "arkav/lualine-lsp-progress" },
			config = [[require("plugin/lualine")]],
		})
		-- Terminal
		use({
			"numtostr/FTerm.nvim",
			config = [[require("plugin/terminal").config()]],
		})
		-- Tree
		use({
			"kyazdani42/nvim-tree.lua",
			after = "tokyonight.nvim",
			config = [[require("plugin/tree/config").config()]],
		})
		-- Tabs for buffers
		use({
			"akinsho/nvim-bufferline.lua",
			after = "nvim-tree.lua",
			config = [[require("plugin/bufferline").config()]],
		})
		-- Telescope select
		use({ "nvim-telescope/telescope-ui-select.nvim" })
		-- Telescope
		use({
			"nvim-telescope/telescope.nvim",
			requires = {
				"nvim-lua/popup.nvim",
				"nvim-telescope/telescope-live-grep-args.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
				"nvim-telescope/telescope-project.nvim",
				"nvim-telescope/telescope-media-files.nvim",
				"crispgm/telescope-heading.nvim",
				"nvim-telescope/telescope-symbols.nvim",
			},
			-- event = "BufWinEnter",
			setup = [[require("plugin/telescope").keymap()]],
			config = [[require("plugin/telescope").config()]],
		})
		-- Zen editing
		use({
			"Pocco81/TrueZen.nvim",
			cmd = { "Zen" },
			setup = [[require("plugin/truezen").keymap()]],
			config = [[require("plugin/truezen").config()]],
		})
		-- Programming spellcheck dictionary
		use({
			"psliwka/vim-dirtytalk",
			run = ":DirtytalkUpdate",
		})
		-- Debugging
		use({
			"mfussenegger/nvim-dap",
			config = [[require("plugin/dap/config")]],
		})
		use({
			"rcarriga/nvim-dap-ui",
			requires = { "mfussenegger/nvim-dap" },
			config = [[require("plugin/dap/ui")]],
		})
		-- Syntax hightligting
		use({
			"nvim-treesitter/nvim-treesitter",
			run = ":TSUpdate",
			config = [[require("plugin/treesitter")]],
		})
		use({
			"nvim-treesitter/nvim-treesitter-textobjects",
			after = "nvim-treesitter",
		})
		use({
			"nvim-treesitter/nvim-treesitter-refactor",
			after = "nvim-treesitter",
		})
		use({
			"windwp/nvim-ts-autotag",
			after = "nvim-treesitter",
		})
		-- Comments
		use({
			"b3nj5m1n/kommentary",
			event = "BufWinEnter",
			config = [[require("plugin/comments")]],
		})
		-- Argument swapping
		use({
			"machakann/vim-swap",
			event = "BufWinEnter",
		})
		-- LSP
		use({
			"neovim/nvim-lspconfig",
			config = [[require("plugin/lsp/config")]],
		})
		use({
			"folke/trouble.nvim",
			config = [[require("plugin/trouble")]],
		})
		-- External formatters with diagnostics
		use({
			"jose-elias-alvarez/null-ls.nvim",
			config = [[require("plugin/null-ls").config()]],
			requires = { "nvim-lua/plenary.nvim" },
		})
		-- Formatter
		use({
			"mhartington/formatter.nvim",
			cmd = { "Format", "FormatWrite" },
			setup = [[require("plugin/formatter").keymap()]],
			config = [[require("plugin/formatter").config()]],
		})
		-- Snippets
		use({ "rafamadriz/friendly-snippets" })
		use({
			"L3MON4D3/LuaSnip",
			config = [[require("plugin/luasnip")]],
		})
		-- Autocomplete
		use({
			"hrsh7th/nvim-cmp",
			requires = {
				{ "onsails/lspkind-nvim", after = "nvim-cmp" },
				{ "hrsh7th/cmp-buffer", after = "nvim-cmp" },
				{ "hrsh7th/cmp-cmdline", after = "nvim-cmp" },
				{ "hrsh7th/cmp-git", after = "nvim-cmp" },
				{ "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" },
				{ "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
				{ "hrsh7th/cmp-path", after = "nvim-cmp" },
				{ "hrsh7th/cmp-calc", after = "nvim-cmp" },
				{ "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" },
			},
			event = "InsertEnter",
			config = [[require("plugin/nvim-cmp")]],
		})
		-- Editorconfig
		use({ "gpanders/editorconfig.nvim" })
		-- Surround text with quotes/tags/brackets
		use({
			"kylechui/nvim-surround",
			tag = "*",
			config = [[require("plugin/surround")]],
		})
		-- Auto pair parenthesis
		use({
			"windwp/nvim-autopairs",
			after = "nvim-cmp",
			config = [[require("plugin/autopairs")]],
		})
		-- Git
		use({
			"lewis6991/gitsigns.nvim",
			event = "BufEnter",
			config = [[require("plugin/gitsigns")]],
		})
		-- Go
		use({
			"leoluz/nvim-dap-go",
			ft = "go",
			config = [[require("plugin/dap/lang/go")]],
		})
		-- Rust
		use({
			"simrat39/rust-tools.nvim",
			ft = "rust",
			config = [[require("plugin/rust-tools")]],
		})
		use({
			"saecki/crates.nvim",
			ft = "toml",
			requires = { "nvim-lua/plenary.nvim" },
		})
		-- Toml
		use({
			"cespare/vim-toml",
			ft = "toml",
		})
		-- CSS
		use({
			"norcalli/nvim-colorizer.lua",
			ft = { "css", "html", "javascript", "lua", "typescript" },
			config = [[require("colorizer").setup()]],
		})
	end,
	config = config,
})

if require("os").getenv("NVIM_AUTOUPDATE") == "1" then
	vim.defer_fn(function()
		-- Check if there is only packer installed so we can decide if we should
		-- use PackerInstall or PackerSync, useful for generating the
		-- `plugin/packer_compiled.lua` on first doom launch
		local installed = vim.tbl_count(vim.fn.globpath(vim.fn.stdpath("data") .. "/site/pack/packer/opt", "*", 0, 1))
		if installed > 0 and snapshots.is_locked() == false and snapshots.has_snapshot() == false then
			snapshots.create_snapshot()
			packer.sync()
		elseif installed == 0 then
			packer.clean()
			packer.install()
			vim.cmd(':exe "normal \\<c-w>w"')
			-- vim.cmd(':exe "normal \\<c-w>w"')
			-- vim.cmd(':exe "normal \\<c-w>w"')
		end
	end, 200)
end
