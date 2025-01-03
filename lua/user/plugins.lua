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
	{ "windwp/nvim-ts-autotag" }, -- auto close tag
	{
		"folke/drop.nvim",
		opts = {
			theme = "auto", -- when auto, it will choose a theme based on the date
			themes = {
				{ theme = "new_year", month = 1, day = 1 },
				{ theme = "valentines_day", month = 2, day = 14 },
				{ theme = "st_patricks_day", month = 3, day = 17 },
				{ theme = "easter", holiday = "easter" },
				{ theme = "april_fools", month = 4, day = 1 },
				{ theme = "us_independence_day", month = 7, day = 4 },
				{ theme = "halloween", month = 10, day = 31 },
				{ theme = "us_thanksgiving", holiday = "us_thanksgiving" },
				{ theme = "xmas", from = { month = 11, day = 19 }, to = { month = 12, day = 25 } },
				{ theme = "leaves", from = { month = 9, day = 22 }, to = { month = 11, day = 19 } },
				{ theme = "snow", from = { month = 12, day = 21 }, to = { month = 3, day = 19 } },
				{ theme = "spring", from = { month = 3, day = 20 }, to = { month = 6, day = 20 } },
				{ theme = "summer", from = { month = 6, day = 21 }, to = { month = 9, day = 21 } },
			},
			max = 75, -- maximum number of drops on the screen
			interval = 100, -- every 150ms we update the drops
			screensaver = 1000 * 60 * 5, -- show after 5 minutes. Set to false, to disable
			filetypes = { "dashboard", "alpha", "ministarter" }, -- will enable/disable automatically for the following filetypes
			winblend = 100, -- winblend for the drop window
		},
	}, -- animation/screensaver
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
	-- LSP
	{ "neovim/nvim-lspconfig", dependencies = { "hrsh7th/cmp-nvim-lsp" } }, -- easily configure language servers
	{
		"williamboman/mason.nvim",
		dependencies = {
			"nvimtools/none-ls.nvim", -- configure formatters & linters (the fork of null-ls)
			"nvimtools/none-ls-extras.nvim",
		},
	}, -- in charge of managing lsp servers, linters & formatters

	-- CMP
	{
		"hrsh7th/nvim-cmp", -- completion plugin
		dependencies = {
			"L3MON4D3/LuaSnip", -- snippets engine
			"rafamadriz/friendly-snippets", -- useful snippets
			"saadparwaiz1/cmp_luasnip", -- for snippets autocompletion
			"hrsh7th/cmp-path", -- for path autocompletion
			"hrsh7th/cmp-buffer", -- for buffer autocompletion
			"hrsh7th/cmp-calc", -- for math operations autocompletion
		},
	},
	{
		"tzachar/cmp-tabnine",
		build = "./install.sh",
		dependencies = "hrsh7th/nvim-cmp",
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
					name = "0_Inbox",
					path = "~/vaults/0_Inbox",
				},
				{
					name = "1_Projects",
					path = "~/vaults/1_Projects",
				},
				{
					name = "2_Areas",
					path = "~/vaults/2_Areas",
				},
				{
					name = "3_Resources",
					path = "~/vaults/3_Resources",
				},
				{
					name = "4_Archive",
					path = "~/vaults/4_Archive",
				},
			},
			note_id_func = function(title)
				-- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
				-- In this case a note with the title 'My new note' will be given an ID that looks
				-- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
				local suffix = ""
				if title ~= nil then
					-- If title is given, transform it into valid file name.
					suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
				else
					-- If title is nil, just add 4 random uppercase letters to the suffix.
					for _ = 1, 4 do
						suffix = suffix .. string.char(math.random(65, 90))
					end
				end
				-- return tostring(os.time()) .. "-" .. suffix
				return suffix
			end,

			-- Optional, customize how note file names are generated given the ID, target directory, and title.
			note_path_func = function(spec)
				-- This is equivalent to the default behavior.
				local path = spec.dir / tostring(spec.id)
				return path:with_suffix(".md")
			end,
		},
	},
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{ "norcalli/nvim-colorizer.lua" }, -- color highlighter
	{ "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
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
