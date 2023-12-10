-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end
local registry = require("mason-registry")

-- enable mason
mason.setup()

local language_servers = {
	"css-lsp",
	"json-lsp",
	"typescript-language-server",
	"html-lsp",
	"marksman",
	"lua-language-server",
	"vim-language-server",
	"pyright",
	"bash-language-server",
	"emmet-ls",
}

local tools = {
	"prettier", -- ts/js formatter
	"eslint_d", -- ts/js linter
	"markdownlint", -- markdown linter
	"stylua", -- lua formatter
	"shfmt", -- bash formatter
	"isort", -- python formatter
	"black", -- python formatter
	"pylint", -- python linter
}

MasonInstallAll = function()
  -- install all language servers
	for _, server in ipairs(language_servers) do
		if not registry.is_installed(server) then
			vim.cmd("MasonInstall " .. server)
		end
	end

  -- install all tools
	for _, tool in ipairs(tools) do
		if not registry.is_installed(tool) then
			vim.cmd("MasonInstall " .. tool)
		end
	end
end
vim.api.nvim_create_user_command("MasonInstallAll", MasonInstallAll, {})
