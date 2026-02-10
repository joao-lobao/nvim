vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require("lazy").setup({
	-- NOTE: First, some plugins that don't require any configuration
	{ "airblade/vim-rooter" }, -- changes the cwd to the project root when a file or directory is opened
	{ "nvim-lua/plenary.nvim" },
	{ "tpope/vim-surround" }, -- plugin for surrounding feature
	{ "tpope/vim-repeat" }, -- repeat commands from other plugins that are not atomic to vim
	{ "tpope/vim-fugitive" }, -- for git integration
	{ "janko/vim-test" }, -- easily run tests
	{ "github/copilot.vim" }, -- github copilot
	{ "windwp/nvim-ts-autotag" }, -- auto close tag
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			-- See Configuration section for options
		},
		-- See Commands section for default commands if you want to lazy load on them
	},

	-- NOTE: Now, plugins that require configuration
	{
		"williamboman/mason.nvim",
		dependencies = {
			"nvimtools/none-ls.nvim", -- configure formatters & linters (the fork of null-ls)
			"nvimtools/none-ls-extras.nvim",
		},
	}, -- in charge of managing lsp servers, linters & formatters
	{
		"ray-x/lsp_signature.nvim",
		event = "InsertEnter",
		opts = {
			bind = true,
			handler_opts = {
				border = "rounded",
			},
		},
		-- or use config
		-- config = function(_, opts) require'lsp_signature'.setup({you options}) end
	},

	-- CMP
	{
		"hrsh7th/nvim-cmp", -- completion plugin
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip", -- snippets engine
			"rafamadriz/friendly-snippets", -- useful snippets
			"saadparwaiz1/cmp_luasnip", -- for snippets autocompletion
			"hrsh7th/cmp-path", -- for path autocompletion
			"hrsh7th/cmp-buffer", -- for buffer autocompletion
			"hrsh7th/cmp-calc", -- for math operations autocompletion
		},
	},

	-- OTHERS
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{ "norcalli/nvim-colorizer.lua" }, -- color highlighter
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, -- improve syntax highlighting
	{ "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" }, -- to create custom mappings for text objects (ex: `daf` to delete a function)
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
	{
		"joao-lobao/simple-session.nvim",
		config = function()
			require("simple-session").setup({
				keymaps = {
					load = "sl",
					create = "sc",
					delete = "sd",
				},
			})
		end,
	},
	{
		"joao-lobao/extract-tool.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			require("extract-tool").setup()
		end,
	},
	{
		"coffebar/transfer.nvim",
		lazy = true,
		cmd = {
			"TransferInit",
			"DiffRemote",
			"TransferUpload",
			"TransferDownload",
			"TransferDirDiff",
			"TransferRepeat",
		},
		opts = {},
	},
})
