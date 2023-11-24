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
	{ "hrsh7th/cmp-buffer" }, -- source completion for text in buffer
	{ "hrsh7th/cmp-path" }, -- source completion for file system paths
	{ "hrsh7th/cmp-calc" }, -- source completion for calc
	{ "hrsh7th/cmp-copilot" }, -- source completion for copilot
	{ "saadparwaiz1/cmp_luasnip" }, -- for snippets autocompletion
	{ "windwp/nvim-ts-autotag" }, -- autoclose tags

	-- NOTE: Now, plugins that require configuration
	-- LSP
	{ "neovim/nvim-lspconfig" }, -- easily configure language servers
	{
		"glepnir/lspsaga.nvim",
		branch = "main",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
	}, -- enhanced lsp uis
	{ "williamboman/mason.nvim" }, -- in charge of managing lsp servers, linters & formatters
	{ "williamboman/mason-lspconfig.nvim" }, -- bridges gap b/w mason & lspconfig
	{ "jose-elias-alvarez/null-ls.nvim" }, -- configure formatters & linters
	{
		"jayp0521/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jose-elias-alvarez/null-ls.nvim",
		},
	}, -- bridges gap b/w mason & null-ls
	{ "hrsh7th/cmp-nvim-lsp" }, -- for autocompletion
	{ "jose-elias-alvarez/typescript.nvim" }, -- additional functionality for typescript server (e.g. rename file & update imports)
	{ "onsails/lspkind.nvim" }, -- vs-code like icons for autocompletion
	-- Others
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {}, -- this is equalent to setup({}) function}, autoclose parens, brackets, quotes, etc...
	},
	{ "github/copilot.vim" }, -- github copilot
	{ "lewis6991/gitsigns.nvim" }, -- git integration show line modifications on left hand side
	{ "ellisonleao/gruvbox.nvim" }, -- colorscheme
	{
		"ray-x/lsp_signature.nvim",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons", opt = true } }, -- plugin for statusline
	{
		"L3MON4D3/LuaSnip",
		dependencies = { "rafamadriz/friendly-snippets" }, -- useful snippets
	}, -- snippet engine
	{ "hrsh7th/nvim-cmp" }, -- completion plugin
	{ "norcalli/nvim-colorizer.lua" }, -- color highlighter
	{
		"petertriho/nvim-scrollbar",
		dependencies = {
			"kevinhwang91/nvim-hlslens", -- optional
			"lewis6991/gitsigns.nvim", -- optional
		},
	}, -- adds a scroll bar
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	}, -- file explorer
	{ "vuki656/package-info.nvim", dependencies = { "MunifTanjim/nui.nvim" } }, -- package.json dependencies manager helpers
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	}, -- refactor/extract tool
	{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" }, -- improve syntax highlighting
	{ "nvim-treesitter/playground" }, -- useful for testing treesitter queries
	{ "nvim-treesitter/nvim-treesitter-textobjects", dependencies = "nvim-treesitter/nvim-treesitter" }, -- to create custom mappings for text objects (ex: `daf` to delete a function)
	{ "tpope/vim-fugitive" }, -- for git integration
	{ "tpope/vim-projectionist" }, -- alternate files / naviagation cmds / buffer configuration
	{ "janko/vim-test" }, -- easily run tests
})
