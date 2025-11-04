-- need to install treesitter cli
-- npm i -g tree-sitter-cli

-- import nvim-treesitter plugin safely
local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

-- configure treesitter
treesitter.setup({
	-- auto install above language parsers
	auto_install = true,
	ensure_installed = {
		"bash",
		"comment",
		"css",
		"diff",
		"dockerfile",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"haskell",
		"html",
		"javascript",
		"json",
		"jsonc",
		"lua",
		"markdown",
		"markdown_inline",
		"python",
		"prisma",
		"sql",
		"rust",
		"scss",
		"typescript",
		"vim",
		"yaml",
	}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
	highlight = {
		enable = true, -- false will disable the whole extension
	},
	indent = {
		enable = true,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<c-n>", -- set to `false` to disable one of the mappings
			node_incremental = "<c-n>",
			scope_incremental = "<c-i>",
		},
	},
	textobjects = {
		select = {
			enable = true,
			-- Automatically jump forward to textobj, similar to targets.vim
			lookahead = true,
			keymaps = {
				-- You can use the capture groups defined in textobjects.scm
				["aa"] = "@parameter.outer",
				["ia"] = "@parameter.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["m0"] = "@function.outer",
				["c0"] = "@class.inner",
			},
			goto_next_end = {
				["m$"] = "@function.outer",
				["c$"] = "@class.inner",
			},
			goto_previous_start = {
				["M0"] = "@function.outer",
				-- ["C0"] = "@class.inner",
			},
			goto_previous_end = {
				["M$"] = "@function.outer",
				-- ["C$"] = "@class.inner",
			},
		},
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
})
local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

-- Creates Super Repeatable Move functionality. Repeat movement with ; and ,
-- ensure ; goes forward and , goes backward regardless of the last direction
vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
-- make builtin f, F, t, T also repeatable with ; and ,
vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
-- also many more functionalities are available, see https://github.com/nvim-treesitter/nvim-treesitter-textobjects
