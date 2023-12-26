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
-- general highlights
vim.api.nvim_set_hl(0, "MsgArea", { bg = Dark_gray, fg = Green })
vim.api.nvim_set_hl(0, "QuickfixLine", { bg = "none", fg = "none" })
vim.api.nvim_set_hl(0, "qfFileName", { bg = "none", fg = Bright_orange })
vim.api.nvim_set_hl(0, "ErrorMsg", { bg = Dark_gray, fg = Red })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = Bright_orange })
vim.api.nvim_set_hl(0, "StatusLine", { bg = Dark_gray, fg = Light_purple })
-- statusline highlights
vim.api.nvim_set_hl(0, "StatusA", { bg = Dark_gray, fg = Dark_purple })
vim.api.nvim_set_hl(0, "StatusB", { bg = Dark_gray, fg = Light_purple })
vim.api.nvim_set_hl(0, "StatusC", { bg = Dark_gray, fg = Bright_orange })
vim.api.nvim_set_hl(0, "StatusModified", { bg = Green, fg = Dark_gray })
vim.api.nvim_set_hl(0, "StatusD", { bg = Dark_gray, fg = Pink })
vim.api.nvim_set_hl(0, "StatusE", { bg = Dark_gray, fg = Orange })
vim.api.nvim_set_hl(0, "StatusF", { bg = Dark_gray, fg = Cyan })
vim.api.nvim_set_hl(0, "TablineFill", { bg = Dark_gray, fg = Green })
-- statusline components
local ft = "%#StatusA#%y "
local pwd = "%#StatusB#%{fnamemodify('', ':p:h')}"
local file = "%#StatusC#/%f "
local modified = "%#StatusModified#%{&modified ? ' 󰆓 ' : ''}"
local readonly = "%#StatusModified#%{&readonly ? ' readonly ' : ''}%*%="
local session = "%#StatusD# %{fnamemodify(v:this_session, ':t')} "
local lines = "%#StatusE#l:%l "
local cols = "%#StatusA#c:%c "
local total_lines = "%#StatusF#L:%L"
vim.o.showtabline = 2
vim.o.tabline = "%#TablineFill#%t"
vim.o.statusline = ft .. pwd .. file .. modified .. readonly .. session .. lines .. cols .. total_lines

-- Toggle Quickfix window
ToggleListedBuffers = function()
	local buf_name = vim.fn.expand("%:f")
	if is_any_quickfix_open() then
		vim.cmd("cclose")
		return
	end
	local buffers = {}
	local opened_bufs = vim.fn.getbufinfo({ buflisted = 1 })
	for _, buf in ipairs(opened_bufs) do
		-- display buffer number on quickfix list item
		buf.text = buf.bufnr
		table.insert(buffers, buf)
	end
	vim.fn.setqflist(buffers)
	vim.cmd("copen " .. #opened_bufs)
	vim.fn.search(buf_name)
end
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>lua ToggleListedBuffers()<CR>", opts)
