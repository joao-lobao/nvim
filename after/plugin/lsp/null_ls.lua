-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

local code_actions = require("user.utils.null_ls").code_actions(null_ls)

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

-- configure null_ls
null_ls.setup({
	-- setup formatters & linters
	sources = {
		--  to disable file types use
		--  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
		formatting.prettier, -- js/ts formatter
		formatting.stylua, -- lua formatter
		formatting.shfmt, -- bash formatter
		diagnostics.markdownlint, -- markdown linter
		diagnostics.eslint_d,
	},
})

null_ls.register(code_actions.no_undef)

local opts = { noremap = true, silent = true }
vim.keymap.set(
	{ "n", "v" },
	"<leader>p",
	"<cmd>lua vim.lsp.buf.format({ filter = function(client) return client.name == 'null-ls' end, bufnr = bufnr, })<CR>",
	opts
)
-- native lsp format mapping when null_ls can't do it
vim.keymap.set({ "n", "v" }, "<leader>{", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
