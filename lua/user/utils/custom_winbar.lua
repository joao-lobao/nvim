List_opened_buffers = function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
  local current_cwd = vim.fn.getcwd()
	local current_buffer_path = vim.fn.expand("%:p")
	local buffer_names = {}
	for _, buffer in ipairs(buffers) do
		local buffer_path = buffer.name
		local buffer_name = vim.fn.fnamemodify(buffer_path, ":t")
		-- buffer name is different from empty string
		if buffer_name ~= "" then
			local is_modified = buffer.changed == 1 and "+" or ""
			-- buffer name is current buffer
			if buffer_path == current_buffer_path then
				table.insert(buffer_names, "%#StatusNorm#" .. "%t" .. " %M" .. "%#StatusFile#")
			else
				table.insert(buffer_names, buffer_name .. " " .. is_modified)
			end
		end
	end
	return "%#StatusBuffer#" .. current_cwd .. " %#StatusFile#  " .. table.concat(buffer_names, " ")
end

local group = vim.api.nvim_create_augroup("CustomWinBar", { clear = true })
-- on BufEnter update winbar
vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		vim.cmd("lua vim.o.winbar = List_opened_buffers()")
	end,
	group = group,
})
