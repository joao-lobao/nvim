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

-- import mason-tool-installer plugin safely
local mason_tool_installer_status, mason_tool = pcall(require, "mason-tool-installer")
if not mason_tool_installer_status then
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
		"lua_ls",
		"emmet_ls",
		"jsonls",
		"vimls",
		"bashls",
		"marksman",
		"tailwindcss",
		"svelte",
		"graphql",
		"prismals",
		"pyright",
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})

mason_tool.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"isort", -- python formatter
		"black", -- python formatter
		"eslint_d", -- ts/js linter
		"markdownlint", -- markdown linter
		"pylint", -- python linter
	},
	-- auto-install configured formatters & linters
	automatic_installation = true,
})
