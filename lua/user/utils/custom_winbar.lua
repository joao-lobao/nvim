vim.api.nvim_set_hl(0, "StatusTypeLight", { bg = Dark_gray, fg = Gray })
vim.api.nvim_set_hl(0, "StatusFileInverseLight", { bg = Dark_purple, fg = White })

Buffers = function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
	local current_buffer_path = vim.fn.expand("%:p")
	local buffer_names = {}
	for _, buffer in ipairs(buffers) do
		local buffer_path = buffer.name
		local buffer_name = vim.fn.fnamemodify(buffer_path, ":t")
		-- buffer name is different from empty string and is selected
		if buffer_name == "" and buffer_path == current_buffer_path then
			buffer_name = "[No Name]"
		end
		local is_modified = buffer.changed == 1 and " + " or " "

		if buffer_name ~= "" then
			-- buffer name is current buffer
			if buffer_path == current_buffer_path then
				table.insert(buffer_names, "%#StatusFileInverseLight#" .. " %t" .. "%M " .. "%#StatusTypeLight#")
			else
				table.insert(buffer_names, " " .. buffer_name .. is_modified)
			end
		end
	end
	return "%#StatusTypeLight#" .. table.concat(buffer_names, " ")
end

Session = function()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session ~= "" then
		session = "  " .. session
	end
	return "%#StatusType#" .. session
end

Cwd = function()
	local current_cwd = " " .. vim.fn.getcwd()
	return "%#StatusFile#" .. current_cwd
end

Git_message = function()
	local file_dir = vim.fn.expand("%:p:h")
	local is_file_in_git_project = vim.fn.system("git -C " .. file_dir .. " rev-parse --is-inside-work-tree")
		== "true\n"
	local git_info = " No git repo "
	if is_file_in_git_project then
		git_info = " " .. vim.fn.system("git -C " .. file_dir .. " show -s --format=%s")
		git_info = string.gsub(git_info, "\n", "")
	end
	return "%#StatusNorm#" .. git_info
end

vim.o.showtabline = 2
