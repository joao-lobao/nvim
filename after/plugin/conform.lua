local conform_status, conform = pcall(require, "conform")
if not conform_status then
	return
end

conform.setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		sh = { "shfmt" },
		lua = { "stylua" },
		python = { "isort", "black" },
	},
})

vim.keymap.set({ "n", "v" }, "<leader>p", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })

-- native lsp format command when Conform can't do it
vim.api.nvim_create_user_command("GenericFormat", function()
	vim.lsp.buf.format()
end, {})
-- native lsp format mapping when Conform can't do it
vim.keymap.set({ "n", "v" }, "<leader>{", ":GenericFormat<CR>", {})
