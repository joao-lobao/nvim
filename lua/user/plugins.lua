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
	{ "tpope/vim-commentary" }, -- plugin commentary feature
	{ "tpope/vim-repeat" }, -- repeat commands from other plugins that are not atomic to vim
	{ "tpope/vim-fugitive" }, -- for git integration
	{ "janko/vim-test" }, -- easily run tests
	{ "github/copilot.vim" }, -- github copilot

	-- NOTE: Now, plugins that require configuration
	-- LSP
	{ "neovim/nvim-lspconfig", dependencies = { "hrsh7th/cmp-nvim-lsp" } }, -- easily configure language servers
	{
		"williamboman/mason.nvim",
		dependencies = {
			"nvimtools/none-ls.nvim", -- configure formatters & linters (the fork of null-ls)
		},
	}, -- in charge of managing lsp servers, linters & formatters

	-- CMP
	{
		"hrsh7th/nvim-cmp", -- completion plugin
		dependencies = {
			"L3MON4D3/LuaSnip", -- snippets engine
			"rafamadriz/friendly-snippets", -- useful snippets
			"saadparwaiz1/cmp_luasnip", -- for snippets autocompletion
		},
	},

	-- OTHERS
	{
		"epwalsh/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = false,
		ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		-- event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
		--   "BufReadPre path/to/my-vault/**.md",
		--   "BufNewFile path/to/my-vault/**.md",
		-- },
		dependencies = {
			-- Required.
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/vaults/personal",
				},
				{
					name = "work",
					path = "~/vaults/work",
				},
			},
		},
	},
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, -- improve syntax highlighting
	{ "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" }, -- to create custom mappings for text objects (ex: `daf` to delete a function)
})
