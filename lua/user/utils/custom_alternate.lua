local find_alternate_file = function(pattern)
	-- file name before any "." eg: filename.test.js will return filename
	local fname_no_ext = string.gsub(vim.fn.expand("%:t"), "%..*$", "")
	local directory = vim.fn.expand("%:p:h")

	return vim.fs.find(function(name)
		return name:match(fname_no_ext .. pattern)
	end, {
		path = directory,
		stop = "../..",
		upward = true,
		type = "file",
	})
end

local create_alternate_file = function(alternate_type)
	-- show message with error hl in case there is no alternate file
	vim.cmd("echohl ErrorMsg | echo 'No alternate file found' | echohl None")

	local fname_no_ext = string.gsub(vim.fn.expand("%:t"), "%..*$", "")
	local directory = vim.fn.expand("%:p:h")
	local ext = vim.fn.expand("%:e")

	local alternate_file = fname_no_ext .. "." .. alternate_type
	if alternate_type == "test" then
		alternate_file = fname_no_ext .. "." .. alternate_type .. "." .. ext
	end

	-- ask with a prompt in case user wants to create alternate file
	local is_create_file = vim.fn.input("Create " .. alternate_type .. " file? (y/n) ")
	if is_create_file == "y" then
		local create_alternate_file = vim.fn.input("File name: ", alternate_file)
		vim.cmd("edit " .. directory .. "/" .. create_alternate_file)
	end
end

local goto_alternate = function(alternate_type)
	local file = vim.fn.expand("%:t")
	local ext = vim.fn.expand("%:e")
	local source_file = {}

	if alternate_type:match("css") then
		if file:match(".*test.*") or file:match(".*spec.*") or ext:match(".*[j|t]s.*") then
			-- find css/scss file
			source_file = find_alternate_file(".*css")
		else
			-- find js/ts/jsx/tsx file
			source_file = find_alternate_file(".[j|t]s.*")
		end
	elseif alternate_type:match("test") then
		if file:match(".*test.*") or file:match(".*spec.*") or ext:match(".*css") then
			-- find js/ts/jsx/tsx file
			source_file = find_alternate_file(".[j|t]s.*")
		else
			-- find test/spec file. Pattern could also be .*[t|s][e|p][s|e][t|c].[j|t]s.* to match specifically ts, js, jsx, tsx extensions
			source_file = find_alternate_file(".*[t|s][e|p][s|e][t|c].*")
		end
	end

	if #source_file > 0 then
		vim.cmd("edit " .. source_file[1])
	else
		create_alternate_file(alternate_type)
	end
end

SwitchToAlternate = function(alternate_type)
	goto_alternate(alternate_type)
end

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>A", "<cmd>lua SwitchToAlternate('test')<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>C", "<cmd>lua SwitchToAlternate('css')<CR>", opts)
