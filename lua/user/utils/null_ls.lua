local no_undef_code_action_var = function(context, diagn)
	local custom_icon_var = "🔨"
	return {
		title = custom_icon_var .. " Define const '" .. diagn.var_name .. "'",
		action = function()
			local lines = {
				"const " .. diagn.var_name .. " = ",
				context.content[diagn.lnum + 1],
			}
			vim.api.nvim_buf_set_lines(context.bufnr, diagn.lnum, diagn.lnum + 1, false, lines)
			vim.api.nvim_feedkeys(tostring(diagn.lnum + 1) .. "G", "n", false)
			vim.api.nvim_feedkeys("==", "n", false)
			vim.api.nvim_feedkeys("A", "n", false)
		end,
	}
end

local no_undef_code_action_class = function(context, diagn)
	local custom_icon_class = "🧰"
	return {
		title = custom_icon_class .. " Define class '" .. diagn.var_name .. "'",
		action = function()
			local lines = {
				"class " .. diagn.var_name .. " {",
				"",
				"}",
				context.content[diagn.lnum + 1],
			}
			vim.api.nvim_buf_set_lines(context.bufnr, diagn.lnum, diagn.lnum + 1, false, lines)
			vim.api.nvim_feedkeys(tostring(diagn.lnum + 1) .. "G", "n", false)
			vim.api.nvim_feedkeys("=2j", "n", false)
			vim.api.nvim_feedkeys("j", "n", false)
			vim.api.nvim_feedkeys("S", "n", false)
		end,
	}
end

local custom_utils = {
	code_actions = function(null_ls)
		return {
			no_undef = {
				method = null_ls.methods.CODE_ACTION,
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
				},
				generator = {
					fn = function(context)
						local NO_UNDEF_CODES = { 2304, "no-undef" }
						local diagnostic =
							vim.diagnostic.get(context.bufnr, { severity = vim.diagnostic.severity.ERROR })

						local qf = {}
						for _, value in pairs(diagnostic) do
							for _, CODE in pairs(NO_UNDEF_CODES) do
								if value.code == CODE then
									table.insert(qf, {
										code = value.code,
										lnum = value.lnum,
										var_name = string.match(value.message, "'([^']*)'"),
									})
									break
								end
							end
						end

						-- creates list of available actions
						local actions = {}
						if next(qf) ~= nil then
							for _, diagn in pairs(qf) do
								-- if first letter is uppercase should be a class
								if string.match(diagn.var_name, "^[A-Z]") then
									table.insert(actions, no_undef_code_action_class(context, diagn))
								-- else should be a constant
								else
									table.insert(actions, no_undef_code_action_var(context, diagn))
								end
							end
						end

						return actions
					end,
				},
			},
		}
	end,
}

return custom_utils
