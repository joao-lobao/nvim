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
	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
	},

	-- OTHERS
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- use latest release, remove to use latest commit
		ui = { enable = false }, -- disabled to prevent render-markdown plugin incompatibility
		opts = {
			legacy_commands = false, -- this will be removed in the next major release
			workspaces = {
				{
					name = "inbox",
					path = "~/vaults/0_Inbox",
				},
				{
					name = "projects",
					path = "~/vaults/1_Projects",
				},
				{
					name = "areas",
					path = "~/vaults/2_Areas",
				},
				{
					name = "resources",
					path = "~/vaults/3_Resources",
				},
				{
					name = "archive",
					path = "~/vaults/4_Archive",
				},
			},
		},
	},
	{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
	{ "norcalli/nvim-colorizer.lua" }, -- color highlighter
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			-- Disable entire built-in ftplugin mappings to avoid conflicts.
			-- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
			vim.g.no_plugin_maps = true

			-- Or, disable per filetype (add as you like)
			-- vim.g.no_python_maps = true
			-- vim.g.no_ruby_maps = true
			-- vim.g.no_rust_maps = true
			-- vim.g.no_go_maps = true
		end,
		config = function()
			-- configuration
			require("nvim-treesitter-textobjects").setup({
				select = {
					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						["@parameter.outer"] = "v", -- charwise
						["@function.outer"] = "V", -- linewise
						-- ['@class.outer'] = '<c-v>', -- blockwise
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = false,
				},
				move = {
					-- whether to set jumps in the jumplist
					set_jumps = true,
				},
			})
			-- keymaps
			-- You can use the capture groups defined in `textobjects.scm`
			vim.keymap.set({ "x", "o" }, "am", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "im", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ac", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
			end)
			vim.keymap.set({ "x", "o" }, "ic", function()
				require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "m0", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "c0", function()
				require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "m$", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "c$", function()
				require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "M0", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "C0", function()
				require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
			end)

			vim.keymap.set({ "n", "x", "o" }, "M$", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
			end)
			vim.keymap.set({ "n", "x", "o" }, "C$", function()
				require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
			end)

			local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")

			-- Repeat movement with ; and ,
			-- ensure ; goes forward and , goes backward regardless of the last direction
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

			-- vim way: ; goes to the direction you were moving.
			-- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			-- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

			-- Optionally, make builtin f, F, t, T also repeatable with ; and ,
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
	{
		"joao-lobao/simplesession.nvim",
		config = function()
			require("simplesession").setup({
				session_dir = vim.fn.stdpath("config") .. "/session/",
				keymaps = {
					load = "sl",
					create = "sc",
					delete = "sd",
				},
			})
		end,
	},
	{
		"joao-lobao/extracttool.nvim",
		config = function()
			require("extracttool").setup()
		end,
	},
	{
		"joao-lobao/githunks.nvim",
		config = function()
			require("githunks").setup({
				keymaps = {
					goto_hunk_next = "gn",
					goto_hunk_prev = "gp",
				},
			})
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
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },        -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
})
