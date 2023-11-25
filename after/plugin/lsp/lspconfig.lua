-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap -- for conciseness

local opts = { noremap = true, silent = true }

local on_attach = function()
	-- set keybinds
	keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- show definition, references
	keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- go to definition
	keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- go to references
	keymap.set("n", "<leader>f", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- see available code actions
	keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- smart rename
	keymap.set("n", "<leader>d", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "<leader>dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) -- show documentation for what is under cursor
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure bash server
lspconfig["bashls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure markdown server
lspconfig["marksman"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tsserver
lspconfig["tsserver"].setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure jsonls server
lspconfig["jsonls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure vim server
lspconfig["vimls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure prisma orm server
lspconfig["prismals"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure graphql language server
lspconfig["graphql"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure python server
lspconfig["pyright"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
