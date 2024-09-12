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
			init_selection = "<c-space>", -- set to `false` to disable one of the mappings
			node_incremental = "<c-space>",
			scope_incremental = "<c-i>",
			node_decremental = "<c-space>",
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
			-- goto_next_start = {
			-- ["tnms"] = "@function.outer",
			-- ["tncs"] = "@class.inner",
			-- },
			goto_next_end = {
				["<leader>me"] = "@function.outer",
				["<leader>ce"] = "@class.inner",
			},
			goto_previous_start = {
				["<leader>ms"] = "@function.outer",
				["<leader>cs"] = "@class.inner",
			},
			-- goto_previous_end = {
			-- ["tpme"] = "@function.outer",
			-- ["tpce"] = "@class.inner",
			-- },
		},
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
})
