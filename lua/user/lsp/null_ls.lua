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

-- configure null_ls
null_ls.setup({
	-- setup formatters & linters
	sources = {
		--  to disable file types use
		--  "formatting.prettier.with({disabled_filetypes: {}})" (see null-ls docs)
		formatting.prettier, -- js/ts formatter
		formatting.stylua, -- lua formatter
		formatting.shfmt, -- bash formatter
		diagnostics.markdownlint,
		diagnostics.eslint_d.with({ -- js/ts linter
			-- only enable eslint if root has .eslintrc.js (not in youtube nvim video)
			condition = function(utils)
				return utils.root_has_file_matches("eslintrc") or json_has_eslint_config("eslintConfig", utils)
			end,
		}),
	},
})
null_ls.register(code_actions.no_undef)
