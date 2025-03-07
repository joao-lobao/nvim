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

local opts = { noremap = true, silent = false }

local on_attach = function(client)
	-- set keybinds
	keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- show definition, references
	keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts) -- go to definition
	keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts) -- go to references
	keymap.set("n", "<leader>f", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- see available code actions
	keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>lua vim.diagnostic.open_float()<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "dp", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "dn", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts) -- show documentation for what is under cursor
	if client.name == "ts_ls" and Has_eslint_rules() then
		-- disable diagnostics since it's handled by eslint
		client.handlers["textDocument/publishDiagnostics"] = function() end
		-- disable formatting since it's handled by prettier
		if client.resolved_capabilities ~= nil then
			client.resolved_capabilities.document_formatting = false
		end
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure multiple language servers
local servers = { "html", "marksman", "ts_ls", "jsonls", "cssls", "vimls", "bashls", "pyright" }

for _, lsp in pairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
		on_attach = on_attach,
	})
end

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
