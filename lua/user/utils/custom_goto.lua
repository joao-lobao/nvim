local M = {}

M.get_current = function(text_object)
	local txt_obj_type = "class_declaration"
	local txt_obj_identifier = txt_obj_type .. " name: (type_identifier)"
	if text_object == "method" then
		txt_obj_type = "method_definition"
		txt_obj_identifier = txt_obj_type .. " name: (property_identifier)"
	end

	local ts_utils = require("nvim-treesitter.ts_utils")
	local expr = ts_utils.get_node_at_cursor()

	while expr do
		if expr:type() == txt_obj_type then
			break
		end
		expr = expr:parent()
	end

	if not expr then
		return ""
	end

	local node_name = vim.treesitter.get_node_text(expr:child(1), 0)
	local query_string = "(" .. txt_obj_identifier .. " @name (#match? @name " .. node_name .. "))"
	local parser = vim.treesitter.get_parser()
	local ok, query = pcall(vim.treesitter.query.parse_query, parser:lang(), query_string)
	if not ok then
		return
	end
	local tree = parser:parse()[1]

	for _, n in query:iter_captures(tree:root(), 0) do
		local lnum, col = n:range()
		vim.api.nvim_win_set_cursor(0, { lnum + 1, col })
	end
end

return M
