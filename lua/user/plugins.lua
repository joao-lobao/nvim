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
	{ "tpope/vim-surround" }, -- plugin for surrounding feature
	{ "tpope/vim-commentary" }, -- plugin commentary feature
	{ "tpope/vim-repeat" }, -- repeat commands from other plugins that are not atomic to vim
	{ "airblade/vim-rooter" }, -- changes the cwd to the project root when a file or directory is opened

	-- NOTE: Now, plugins that require configuration
	-- LSP
	{ "neovim/nvim-lspconfig", dependencies = { "hrsh7th/cmp-nvim-lsp" } }, -- easily configure language servers
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim", -- bridges gap b/w mason & lspconfig
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
	}, -- in charge of managing lsp servers, linters & formatters

	--LINTING AND FORMATTING
	{
		"stevearc/conform.nvim",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
	},
	{
		"mfussenegger/nvim-lint",
		lazy = true,
		event = { "BufReadPre", "BufNewFile" },
	},

	-- CMP
	{
		"hrsh7th/nvim-cmp", -- completion plugin
		dependencies = {
			"hrsh7th/cmp-buffer", -- source completion for text in buffer
			"hrsh7th/cmp-path", -- source completion for file system paths
			"hrsh7th/cmp-calc", -- source completion for calc
			"onsails/lspkind.nvim", -- vs-code like icons for autocompletion
		},
	}, -- snippet engine

	-- OTHERS
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
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
	},
	{ "github/copilot.vim" }, -- github copilot
  { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true },
	{ "norcalli/nvim-colorizer.lua" }, -- color highlighter
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	}, -- file explorer
	{ "vuki656/package-info.nvim", dependencies = { "MunifTanjim/nui.nvim" } }, -- package.json dependencies manager helpers
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, -- improve syntax highlighting
	{ "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" }, -- to create custom mappings for text objects (ex: `daf` to delete a function)
  { "lewis6991/gitsigns.nvim" }, -- git integration show line modifications on left hand side
	{ "tpope/vim-fugitive" }, -- for git integration
	{ "tpope/vim-projectionist" }, -- alternate files / naviagation cmds / buffer configuration
	{ "janko/vim-test" }, -- easily run tests
})
