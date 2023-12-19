-- Function to check if any Quickfix list window is open
local function is_any_quickfix_open()
	-- Iterate over all open windows
	for _, winid in ipairs(vim.fn.getwininfo()) do
		-- Check if the window is a Quickfix window
		if vim.fn.getwinvar(winid.winid, "&buftype") == "quickfix" then
			return true
		end
	end
	return false
end
-- Toggle Quickfix window
BufferName = function()
  local buf_name = vim.fn.expand("%:f")
	if is_any_quickfix_open() then
		vim.cmd("cclose")
		return
	end
	local opened_bufs = vim.fn.getbufinfo({ buflisted = 1 })
	vim.fn.setqflist(opened_bufs)
	vim.cmd("top copen " .. #opened_bufs)
  vim.fn.search(buf_name)
end
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>lua BufferName()<CR>", opts)
