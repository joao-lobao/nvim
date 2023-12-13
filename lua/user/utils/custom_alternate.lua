-- alternate between source and test files
local goto_source_file = function(file)
	local source_file1 = string.gsub(file, ".test", "")
	local source_file2 = string.gsub(source_file1, ".spec", "")

	local find_source_file = vim.fs.find(function(name)
		return name:match(source_file2)
	end, {
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
		stop = vim.loop.os_homedir(),
		upward = true,
		type = "file",
	})

	vim.cmd("edit " .. find_source_file[1])
end

local goto_test_file = function()
	local find_test_file = vim.fs.find(function(name)
		return name:match(".*test*") or name:match(".*spec*")
	end, {
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
		type = "file",
	})

	if #find_test_file > 0 then
		vim.cmd("edit " .. find_test_file[1])
	else
		-- show message with error hl if no test file
		vim.cmd("echohl ErrorMsg | echo 'No test file found' | echohl None")

		local current_file_dir = vim.fn.expand("%:p:h")
		local current_file = vim.fn.expand("%:t")
		local test_file = vim.split(current_file, "[.]")[1] .. ".test." .. vim.split(current_file, "[.]")[2]
		-- ask with a prompt if user wants to create a test file
		local is_create_file = vim.fn.input("Create test file? (y/n) ")
		if is_create_file == "y" then
			local create_test_file = vim.fn.input("File name: ", test_file)
			vim.cmd("edit " .. current_file_dir .. "/" .. create_test_file)
		end
	end
end

--TODO: add support for multiple test files
--TODO: add better regex
SwitchAlternate = function()
	local current_file = vim.fn.expand("%:t")
	if current_file:match(".*test*") or current_file:match(".*spec*") then
		goto_source_file(current_file)
		return
	end

	goto_test_file()
end

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>A", "<cmd>lua SwitchAlternate()<CR>", opts)
