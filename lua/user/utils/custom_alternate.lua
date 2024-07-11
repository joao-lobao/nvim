-- alternate between source and test files
local goto_source_file = function(current_file, current_file_dir)
	local source_file1 = string.gsub(current_file, ".test", "")
	local source_file2 = string.gsub(source_file1, ".spec", "")

	-- finds recursively up in current directory
	local find_source_file = vim.fs.find(function(name)
		return name:match(source_file2)
	end, {
		path = current_file_dir,
		stop = "../..",
		upward = true,
		type = "file",
	})

	if #find_source_file > 0 then
		vim.cmd("edit " .. find_source_file[1])
	else
		vim.cmd("edit index.js")
	end
end

-- I believe Lua's pattern matching doesn't directly support alternation (|)
-- for this purpose calling match twice
local has_test_match = function(name)
	-- get current file name without the file extension
	local fname_without_ext = string.gsub(vim.fn.expand("%:t"), "%..*$", "")
	return name:match(fname_without_ext .. ".*test.*") or name:match(fname_without_ext .. ".*spec.*")
end

local goto_test_file = function(current_file, current_file_dir)
	-- finds recursively down in current directory
	local find_test_file = vim.fs.find(has_test_match, {
		path = current_file_dir,
		type = "file",
	})

	if #find_test_file > 0 then
		vim.cmd("edit " .. find_test_file[1])
	else
		-- show message with error hl in case there is no test file
		vim.cmd("echohl ErrorMsg | echo 'No test file found' | echohl None")

		local test_file = string.gsub(current_file, "[.]", ".test.")
		-- ask with a prompt in case user wants to create a test file
		local is_create_file = vim.fn.input("Create test file? (y/n) ")
		if is_create_file == "y" then
			local create_test_file = vim.fn.input("File name: ", test_file)
			vim.cmd("edit " .. current_file_dir .. "/" .. create_test_file)
		end
	end
end

SwitchAlternate = function()
	local file = vim.fn.expand("%:t")
	local directory = vim.fn.expand("%:p:h")
	if has_test_match(file) then
		goto_source_file(file, directory)
		return
	end

	goto_test_file(file, directory)
end

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>A", "<cmd>lua SwitchAlternate()<CR>", opts)
