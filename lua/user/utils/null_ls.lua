-- undefined variable for typescript/javascript
local no_undef_code_action_var = function(context, diagn)
	local custom_icon = "🔨"
	return {
		title = custom_icon .. " Define const '" .. diagn.var_name .. "'",
		action = function()
			local lines = {
				"const " .. diagn.var_name .. " = ",
				context.content[diagn.lnum + 1],
			}
			vim.api.nvim_buf_set_lines(context.bufnr, diagn.lnum, diagn.lnum + 1, false, lines)
			vim.api.nvim_feedkeys(tostring(diagn.lnum + 1) .. "G==A", "n", false)
		end,
	}
end

-- undefined variable/class for jsx
local no_undef_jsx_code_action = function(context, diagn, type)
	local custom_icon = "🧰"
	local parentheses = ""
	if type == "function" then
		custom_icon = "🔨"
		parentheses = "()"
	end
	return {
		title = custom_icon .. " Define " .. type .. " '" .. diagn.var_name .. "'",
		action = function()
			local lines = {
				type .. " " .. diagn.var_name .. parentheses .. " {",
				"",
				"}",
			}
			local last_line = vim.api.nvim_buf_line_count(0)
			vim.api.nvim_buf_set_lines(context.bufnr, last_line, last_line + 1, false, lines)
			vim.api.nvim_feedkeys("G=kS", "n", false)
		end,
	}
end

-- undefined class for typescript/javascript
local no_undef_code_action_class = function(context, diagn)
	local custom_icon = "🧰"
	return {
		title = custom_icon .. " Define class '" .. diagn.var_name .. "'",
		action = function()
			local lines = {
				"class " .. diagn.var_name .. " {",
				"",
				"}",
				context.content[diagn.lnum + 1],
			}
			vim.api.nvim_buf_set_lines(context.bufnr, diagn.lnum, diagn.lnum + 1, false, lines)
			vim.api.nvim_feedkeys(tostring(diagn.lnum + 1) .. "G=2jjS", "n", false)
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
						local ts_code_1 = 2304
						local ts_code_2 = 2552
						local eslint_d_js_code = "no-undef"
						local eslint_d_react_code = "react/jsx-no-undef"
						local NO_UNDEF_CODES = { ts_code_1, ts_code_2, eslint_d_js_code, eslint_d_react_code }
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
						for _, diagn in pairs(qf) do
							-- if code is from jsx not defined should be a function or a class
							if diagn.code == eslint_d_react_code then
								table.insert(actions, no_undef_jsx_code_action(context, diagn, "function"))
								table.insert(actions, no_undef_jsx_code_action(context, diagn, "class"))
							-- if first letter is uppercase should be a class
							elseif string.match(diagn.var_name, "^[A-Z]") then
								table.insert(actions, no_undef_code_action_class(context, diagn))
								-- else should be a constant
							else
								table.insert(actions, no_undef_code_action_var(context, diagn))
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
