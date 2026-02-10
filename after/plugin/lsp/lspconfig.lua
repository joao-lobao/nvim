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
		-- disable formatting since it's handled by prettier
		if client.resolved_capabilities ~= nil then
			client.resolved_capabilities.document_formatting = false
		end
	end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰠠 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
		},
	},
})

local servers = {
	html = {
		cmd = { "vscode-html-language-server", "--stdio" },
		filetypes = { "html" },
		root_markers = { ".git" },
		on_attach = on_attach,
		capabilities = capabilities,
	},

	lua_ls = {
		cmd = { "lua-language-server" },
		filetypes = { "lua" },
		root_markers = { ".luarc.json", ".git" },
		on_attach = on_attach,
		capabilities = capabilities,
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
			},
		},
	},

	cssls = {
		cmd = { "vscode-css-language-server", "--stdio" },
		filetypes = { "css", "scss", "less" },
		root_markers = { ".git" },
		on_attach = on_attach,
		capabilities = capabilities,
	},

	jsonls = {
		cmd = { "vscode-json-language-server", "--stdio" },
		filetypes = { "json", "jsonc" },
		root_markers = { ".git" },
		on_attach = on_attach,
		capabilities = capabilities,
	},

	ts_ls = {
		-- this replaces tsserver / ts_ls from lspconfig
		cmd = { "typescript-language-server", "--stdio" },
		filetypes = {
			"typescript",
			"typescriptreact",
			"typescript.tsx",
			"javascript",
			"javascriptreact",
		},
		root_markers = { "package.json", "tsconfig.json", ".git" },
		on_attach = on_attach,
		capabilities = capabilities,
	},

	pyright = {
		cmd = { "pyright-langserver", "--stdio" },
		filetypes = { "python" },
		root_markers = { "pyproject.toml", "setup.py", ".git" },
		on_attach = on_attach,
		capabilities = capabilities,
	},

	bashls = {
		cmd = { "bash-language-server", "start" },
		filetypes = { "sh", "bash" },
		root_markers = { ".git" },
		on_attach = on_attach,
		capabilities = capabilities,
	},

	vimls = {
		cmd = { "vim-language-server", "--stdio" },
		filetypes = { "vim" },
		root_markers = { ".git" },
		on_attach = on_attach,
		capabilities = capabilities,
	},

	marksman = {
		cmd = { "marksman", "server" },
		filetypes = { "markdown" },
		root_markers = { ".git", ".marksman.toml" },
		on_attach = on_attach,
		capabilities = capabilities,
	},
}

for name, config in pairs(servers) do
	vim.lsp.config[name] = config
	vim.lsp.enable(name)
end
