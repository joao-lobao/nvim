-- import null-ls plugin safely
local setup, null_ls = pcall(require, "null-ls")
if not setup then
	return
end

local code_actions = require("user.utils.null_ls").code_actions(null_ls)

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
Has_eslint_rules = function()
	-- enable eslint from the project eslint own rules
	return utils.root_has_file_matches("eslint") or json_has_eslint_config("eslintConfig", utils)
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
		diagnostics.markdownlint, -- markdown linter
		require("none-ls.diagnostics.eslint_d").with({ condition = Has_eslint_rules }),
		require("none-ls.code_actions.eslint_d").with({ condition = Has_eslint_rules }),
		-- require("none-ls.formatting.eslint_d").with({ condition = Has_eslint_rules }),
	},
})

null_ls.register(code_actions.no_undef)

function Format_Null_ls()
	--get lsp clients attached to current buffer
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	local is_diff_mode = vim.o.diff

	local filter = function(client)
		if client.name == "null-ls" then
			Notification("File formatted", vim.log.levels.INFO)
			return true
		else
			return false
		end
	end

	if #clients > 0 and not is_diff_mode then
		vim.lsp.buf.format({ filter = filter, bufnr = bufnr })
		return
	end
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
