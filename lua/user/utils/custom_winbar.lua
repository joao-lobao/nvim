List_opened_buffers = function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
	local current_buffer_path = vim.fn.expand("%:p")
	local buffer_names = {}
	for _, buffer in ipairs(buffers) do
		local buffer_path = buffer.name
		local buffer_name = vim.fn.fnamemodify(buffer_path, ":t")
		-- buffer name is different from empty string
		if buffer_name ~= "" then
			local is_modified = buffer.changed == 1 and " + " or " "

			-- buffer name is current buffer
			if buffer_path == current_buffer_path then
				table.insert(buffer_names, "%#StatusTypeInverseLight#" .. " %t" .. "%M " .. "%#StatusType#")
			else
				table.insert(buffer_names, " " .. buffer_name .. is_modified)
			end
		end
	end
	return "%#StatusType#" .. table.concat(buffer_names, " ") .. "%="
end

local dark_gray = "#282a36"
local dark_purple = "#6272a4"
vim.api.nvim_set_hl(0, "StatusTypeInverse", { bg = dark_purple, fg = dark_gray })
vim.api.nvim_set_hl(0, "StatusTypeInverseLight", { bg = dark_purple })

Get_git_info = function()
	local current_cwd = " " .. vim.fn.getcwd() .. " "
	local file_dir = vim.fn.expand("%:p:h")
	local is_file_in_git_project = vim.fn.system("git -C " .. file_dir .. " rev-parse --is-inside-work-tree")
		== "true\n"
	local git_info = " No git repo "
	if is_file_in_git_project then
		git_info = " " .. string.sub(vim.fn.system("git -C " .. file_dir .. " show -s --format=%s"), 0, 50) .. " "
	end
	return "%#StatusTypeInverse# " .. current_cwd .. "| " .. git_info
end

-- on BufEnter update winbar
local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		vim.cmd("lua vim.o.winbar = List_opened_buffers() .. Get_git_info()")
	end,
	group = group,
})
