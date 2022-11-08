-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

-- enable mason
mason.setup()

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = {
		"tsserver",
		"html",
		"cssls",
		"sumneko_lua",
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})

mason_null_ls.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"eslint_d", -- ts/js linter
		"markdownlint",
	},
	-- auto-install configured formatters & linters (with null-ls)
	automatic_installation = true,
})

-- LSP
-- "yaml-language-server",
-- "vim-language-server",
-- "python-lsp-server",
-- "json-lsp",
-- "emmet-ls",
-- "eslint-lsp",
-- "diagnostic-languageserver",
-- "dockerfile-language-server",
-- "cssmodules-language-server",
-- "bash-language-server",
-- "angular-language-server",
-- "css-lsp",
-- "html-lsp",
-- "lua-language-server",
-- "tailwindcss-language-server",
-- "typescript-language-server",
-- "haskell-language-server",
-- LINTERS
-- "yamllint"
-- "jsonlint"
-- "markdownlint"
-- "eslint_d"
