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

	local alternate_file = fname_no_ext .. "." .. alternate_type

	-- ask with a prompt in case user wants to create alternate file
	local is_create_file = vim.fn.input("Create " .. alternate_type .. " file? (y/n) ")
	if is_create_file == "y" then
		local create_alternate_file = vim.fn.input("File name: ", alternate_file)
		-- if user doesn't provide any file name or leaves operation, return
		if create_alternate_file == "" then
			return
		end
		vim.cmd("edit " .. directory .. "/" .. create_alternate_file)
	end
end

SwitchToAlternate = function(main_alter_patt, sec_alter_patt, new_file_type)
	local file = vim.fn.expand("%:t")
	local pattern = sec_alter_patt

	-- file name different from secondary alternate pattern, set pattern to find main file
	if file:match(sec_alter_patt) then
		pattern = main_alter_patt
	end

	local source_file = find_alternate_file(pattern)
	if #source_file > 0 then
		vim.cmd("edit " .. source_file[1])
	else
		create_alternate_file(new_file_type)
	end
end

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap(
	"n",
	"<leader>A",
	"<cmd>lua SwitchToAlternate('.[j|t]s.*', '.*[t|s][e|p][s|e][t|c].*', 'test.ts')<CR>",
	opts
)
vim.api.nvim_set_keymap("n", "<leader>C", "<cmd>lua SwitchToAlternate('.[j|t]s.*','.*css', 'css')<CR>", opts)
