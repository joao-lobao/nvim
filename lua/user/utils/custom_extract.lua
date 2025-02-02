local map_as = {
	class = "1. as_class",
	func = "2. as_function",
	file_as_class = "3. to_file_as_class",
	file_as_func = "4. to_file_as_function",
	method = "5. as_method",
}

local feedkeys = function(extract_as)
	vim.api.nvim_feedkeys("O" .. extract_as, "i", false)
	vim.api.nvim_feedkeys("", "x", false)
	vim.api.nvim_feedkeys("i\n", "n", false)
	vim.api.nvim_feedkeys("", "x", false)
	vim.api.nvim_feedkeys("Pk$B", "n", false)
	vim.api.nvim_feedkeys(
		vim.api.nvim_replace_termcodes(":lua vim.lsp.buf.format()<CR>ve<C-g>", true, true, true),
		"n",
		true
	)
end

local extract = function(as, to)
	vim.cmd("normal! d")
	if to == "file" then
		local fname = vim.fn.input("Enter file name: ", vim.fn.expand("%:p:h"), "file")
		vim.cmd("e " .. fname)
	end
	feedkeys(as)
end

local choose_extract = function(as)
	local extraction_list = {
		[map_as.class] = function()
			extract("class Name {}")
		end,
		[map_as.func] = function()
			extract("function name() {\n}")
		end,
		[map_as.file_as_class] = function()
			extract("class Name {\n}", "file")
		end,
		[map_as.file_as_func] = function()
			extract("function name() {\n}", "file")
		end,
		[map_as.method] = function()
			extract("name() {\n}")
		end,
	}

	return extraction_list[as]()
end

Extract = function()
	local as_map = { map_as.class, map_as.func, map_as.file_as_class, map_as.file_as_func, map_as.method }
	local as = vim.fn.inputlist({
		"Extract as: ",
		map_as.class,
		map_as.func,
		map_as.file_as_class,
		map_as.file_as_func,
		map_as.method,
	})
	if as ~= nil and as > 0 then
		choose_extract(as_map[as])
	end
end

vim.api.nvim_set_keymap("v", "<leader>e", "<cmd>lua Extract()<CR>", {})
