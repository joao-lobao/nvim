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
		"comment",
		"javascript",
		"scss",
		"css",
		"html",
		"markdown",
		"markdown_inline",
		"json",
		"jsonc",
		"yaml",
		"vim",
		"lua",
		"python",
		"typescript",
		"rust",
		"haskell",
		"bash",
		"dockerfile",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
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
			goto_next_start = {
				["ffn"] = "@function.outer",
			},
			goto_previous_start = {
				["ffc"] = "@class.outer",
				["ffm"] = "@function.outer",
			},
		},
	},
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
})
