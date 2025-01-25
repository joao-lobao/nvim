local map_to = {
	class = "1. to_class",
	func = "2. to_function",
	file_as_class = "3. to_file_as_class",
	file_as_func = "4. to_file_as_function",
	method = "5. to_method",
}

local common_all = function(extract_to)
	vim.cmd("normal! G")
	vim.cmd("normal! o")
	vim.api.nvim_feedkeys("o" .. extract_to, "i", false)
	vim.api.nvim_feedkeys("", "x", false)
	vim.api.nvim_feedkeys("i\n", "n", false)
	vim.api.nvim_feedkeys("", "x", false)
	vim.api.nvim_feedkeys("P", "n", false)
end

local common_file = function()
	local fname = vim.fn.input("Enter file name: ", vim.fn.expand("%:p:h"), "file")
	if fname == "" then
		return
	end
	vim.cmd("e " .. fname)
	return fname
end

local extract_choose = function(to)
	local extraction_list = {
		[map_to.class] = function()
			vim.cmd("normal! d")
			common_all("class ClassName {\n}")
		end,
		[map_to.func] = function()
			vim.cmd("normal! d")
			common_all("function name() {\n}")
		end,
		[map_to.file_as_class] = function()
			vim.cmd("normal! d")
			if common_file() == nil then
				return
			end
			common_all("class ClassName {\n}")
		end,
		[map_to.file_as_func] = function()
			vim.cmd("normal! d")
			if common_file() == nil then
				return
			end
			common_all("function name() {\n}")
		end,
		[map_to.method] = function()
			vim.cmd("normal! d")
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
