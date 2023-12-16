-- other possible color combinations on winbar with white, light_purple, dark_purple
List_opened_buffers = function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
	local current_buffer_path = vim.fn.expand("%:p")
	local buffer_names = {}
	for _, buffer in ipairs(buffers) do
		local buffer_path = buffer.name
		local buffer_name = vim.fn.fnamemodify(buffer_path, ":t")
		-- buffer name is different from empty string
		if buffer_name == "" then
			buffer_name = "[No Name]"
		end
		local is_modified = buffer.changed == 1 and " + " or " "

		-- buffer name is current buffer
		if buffer_path == current_buffer_path then
			table.insert(buffer_names, "%#StatusFile# 󰉺" .. " %t" .. "%M " .. "%#StatusType#")
		else
			table.insert(buffer_names, " " .. buffer_name .. is_modified)
		end
	end
	return "%#StatusType#" .. table.concat(buffer_names, " ") .. "%="
end

Get_git_info = function()
	local file_dir = vim.fn.expand("%:p:h")
	local is_file_in_git_project = vim.fn.system("git -C " .. file_dir .. " rev-parse --is-inside-work-tree")
		== "true\n"
	local git_info = " No git repo "
	if is_file_in_git_project then
		git_info = " " .. string.sub(vim.fn.system("git -C " .. file_dir .. " show -s --format=%s"), 0, 50) .. " "
		git_info = string.gsub(git_info, "\n", "")
	end
	return "%#StatusNorm#" .. git_info
end

Get_cwd_info = function()
	local session = vim.fn.fnamemodify(vim.v.this_session, ":t")
	if session ~= "" then
		session = " " .. session .. " "
	end
	local current_cwd = " " .. vim.fn.getcwd() .. " "
	return "%#StatusEncoding#" .. session .. "%#StatusBuffer#" .. current_cwd
end

-- on BufEnter update winbar
local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		vim.cmd("lua vim.o.winbar = List_opened_buffers() .. Get_git_info() .. Get_cwd_info()")
	end,
	group = group,
})
