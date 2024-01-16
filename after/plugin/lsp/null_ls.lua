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

function Format_Null_ls()
	--get lsp clients attached to current buffer
	local buffer = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = buffer })
	local is_diff_mode = vim.o.diff

	if #clients > 0 and not is_diff_mode then
		vim.cmd(
			"lua vim.lsp.buf.format({ filter = function(client) return client.name == 'null-ls' end, bufnr = bufnr, })"
		)
		Notification("File formatted", vim.log.levels.INFO)
		return
	end
	Notification("Format not supported on this buffer", vim.log.levels.WARN)
end
function Format_Native()
	vim.cmd("lua vim.lsp.buf.format()")
end

local opts = { noremap = true, silent = true }
vim.keymap.set({ "n", "v" }, "<leader>p", "<cmd>lua Format_Null_ls()<CR>", opts)
-- native lsp format mapping when null_ls can't do it
vim.keymap.set({ "n", "v" }, "<leader>{", "<cmd>lua Format_Native()<CR>", opts)

-- Format On Save
local group_format = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.cmd("lua Format_Null_ls()")
	end,
	group = group_format,
})
