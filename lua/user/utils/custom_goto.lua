local get_current = function(obj_type, obj_identifier, word_index)
	local ts_utils = require("nvim-treesitter.ts_utils")
	local expr = ts_utils.get_node_at_cursor()

	while expr do
		if expr:type() == obj_type then
			break
		end
		expr = expr:parent()
	end

	if not expr then
		return ""
	end

	local node_name = vim.treesitter.get_node_text(expr:child(word_index), 0)
	local query_string = "(" .. obj_type .. " name: (".. obj_identifier .. ") @name (#match? @name " .. node_name .. "))"
	local parser = vim.treesitter.get_parser()
	local ok, query = pcall(vim.treesitter.query.parse, parser:lang(), query_string)
	if not ok then
		return
	end
	local tree = parser:parse()[1]

	for _, n in query:iter_captures(tree:root(), 0) do
		local lnum, col = n:range()
		vim.api.nvim_win_set_cursor(0, { lnum + 1, col })
	end
end

-- goto class and method definitions
vim.api.nvim_create_user_command("GotoClass", function()
  -- typescript class
	get_current("class_declaration", "type_identifier", 1)
  -- javascript class
	get_current("class_declaration", "identifier", 1)
end, {})

vim.api.nvim_create_user_command("GotoFunction", function()
  -- typescript and javascript class method
	get_current("method_definition", "property_identifier", 0)
  -- typescript and javascript function
	get_current("function_declaration", "identifier", 1)
end, {})
-- custom goto mappings
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gtm", ":GotoFunction<CR>", opts)
vim.api.nvim_set_keymap("n", "gtc", ":GotoClass<CR>", opts)

