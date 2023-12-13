-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

-- for conciseness
local formatting = null_ls.builtins.formatting -- to setup formatters
local diagnostics = null_ls.builtins.diagnostics -- to setup linters

local function json_has_eslint_config(pattern, utils)
	local has_package_json = utils.root_has_file("package.json")
	local has_eslint_config = false
	local lines = ""
	if has_package_json then
		lines = vim.fn.readfile(vim.fn.expand(vim.fn.getcwd() .. "/" .. "package.json"))
		for _, line in ipairs(lines) do
			if line:match(pattern) then
				has_eslint_config = true
				break
			end
		end
	end
	return has_eslint_config
end

local utils = require("null-ls.utils").make_conditional_utils()
local get_eslint_rules = function()
	-- enable eslint from the project eslint own rules
	if utils.root_has_file_matches("eslintrc") or json_has_eslint_config("eslintConfig", utils) then
		return nil
	end
	-- else enable general airbnb eslint rules
	-- requires eslint-config-airbnb to be installed globally 'npx install-peerdeps -g eslint-config-airbnb'
	local node_root = vim.fn.system("npm root -g")
	local trimmed_node_root = string.gsub(node_root, "%s+", "")
	return {
		"-c",
		trimmed_node_root .. "/eslint-config-airbnb/index.js",
	}
end

-- configure null_ls
null_ls.setup({
	-- setup formatters & linters
	sources = {
		--  to disable file types use
		--  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
		formatting.prettier, -- js/ts formatter
		formatting.stylua, -- lua formatter
		formatting.shfmt, -- bash formatter
		formatting.isort, -- python formatter
		formatting.black, -- python formatter
		diagnostics.pylint, -- python linter
		diagnostics.markdownlint, -- markdown linter
		diagnostics.eslint_d.with({
			extra_args = get_eslint_rules(),
		}),
	},
})

local opts = { noremap = true, silent = true }
vim.keymap.set(
	{ "n", "v" },
	"<leader>p",
	"<cmd>lua vim.lsp.buf.format({ filter = function(client) return client.name == 'null-ls' end, bufnr = bufnr, })<CR>",
	opts
)
-- native lsp format mapping when null_ls can't do it
vim.keymap.set({ "n", "v" }, "<leader>{", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
