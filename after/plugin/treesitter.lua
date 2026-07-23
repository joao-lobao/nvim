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
		"latex",
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
	query_linter = {
		enable = true,
		use_virtual_text = true,
		lint_events = { "BufWrite", "CursorHold" },
	},
})
