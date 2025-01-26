local map_to = {
	class = "1. to_class",
	func = "2. to_function",
	file_as_class = "3. to_file_as_class",
	file_as_func = "4. to_file_as_function",
	method = "5. to_method",
}

local common_all = function(extract_to)
	vim.cmd("normal! d")
	vim.api.nvim_feedkeys("O" .. extract_to, "i", false)
	vim.api.nvim_feedkeys("", "x", false)
	vim.api.nvim_feedkeys("i\n", "n", false)
	vim.api.nvim_feedkeys("", "x", false)
	vim.api.nvim_feedkeys("Pk_wve", "n", false)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-g>", true, true, true), "n", true)
end

local common_file = function(to)
	local fname = vim.fn.input("Enter file name: ", vim.fn.expand("%:p:h"), "file")
	vim.cmd("e " .. fname)
	common_all(to)
end

local extract_choose = function(to)
	local extraction_list = {
		[map_to.class] = function()
			common_all("class Name {}")
		end,
		[map_to.func] = function()
			common_all("function name() {\n}")
		end,
		[map_to.file_as_class] = function()
			common_file("class Name {\n}")
		end,
		[map_to.file_as_func] = function()
			common_file("function name() {\n}")
		end,
		[map_to.method] = function()
			common_all("name() {\n}")
		end,
	}

	return extraction_list[to]()
end

Extract = function()
	local to_map = { map_to.class, map_to.func, map_to.file_as_class, map_to.file_as_func, map_to.method }
	local to = vim.fn.inputlist({
		"Extract to: ",
		map_to.class,
		map_to.func,
		map_to.file_as_class,
		map_to.file_as_func,
		map_to.method,
	})
	if to ~= nil and to > 0 then
		extract_choose(to_map[to])
	end
end

vim.api.nvim_set_keymap("v", "<leader>e", "<cmd>lua Extract()<CR>", {})
