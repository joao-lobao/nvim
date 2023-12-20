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
-- tabline
local dark_gray = "#282a36"
local green = "#50fa7b"
local red = "#ff5555"
local light_purple = "#bd93f9"
local bright_orange = "#fe8019"
vim.api.nvim_set_hl(0, "MsgArea", { bg = dark_gray, fg = green })
vim.api.nvim_set_hl(0, "QuickfixLine", { bg = "none", fg = "none" })
vim.api.nvim_set_hl(0, "qfFileName", { bg = "none", fg = green })
vim.api.nvim_set_hl(0, "ErrorMsg", { bg = dark_gray, fg = red })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = bright_orange })
vim.api.nvim_set_hl(0, "StatusLine", { bg = dark_gray, fg = bright_orange })
vim.api.nvim_set_hl(0, "WinBar", { bg = dark_gray, fg = bright_orange })
vim.api.nvim_set_hl(0, "TabLineFill", { bg = dark_gray, fg = light_purple })
vim.api.nvim_set_hl(0, "CustomMod", { bg = green, fg = dark_gray })
local is_git_repo = "system('git -C  . rev-parse --is-inside-work-tree') == 'true\n'"
local modified = "%#CustomMod#%{&modified ? '  󰆓 ' : ''}%*"
local pwd = "%{fnamemodify('', ':p:h')}"
local file = "%#StatusLine#/%f"
local session = "%=%#WinBar# %{fnamemodify(v:this_session, ':t')} "
local git_branch = "%#MsgArea#%{" .. is_git_repo .. " ? system('git -C . branch --show-current')[0:-2] : '-'} "
local git_message = "%#TabLineFill#%{"
	.. is_git_repo
	.. " ? substitute(system('git -C . show -s --format=%s'), '\n', '', '')[0:50] : 'Not a git repo'}"
vim.o.showtabline = 2
vim.o.tabline = modified

-- Toggle Quickfix window
function Close_qf()
	vim.o.tabline = modified
	vim.cmd("cclose")
end
BufferName = function()
	local buf_name = vim.fn.expand("%:f")
	if is_any_quickfix_open() then
		Close_qf()
		return
	end
	local opened_bufs = vim.fn.getbufinfo({ buflisted = 1 })
	vim.fn.setqflist(opened_bufs)
	vim.cmd("top copen " .. #opened_bufs)
	vim.o.tabline = pwd .. file .. session .. git_branch .. git_message
	vim.fn.search(buf_name)
end
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>n", "<cmd>lua BufferName()<CR>", opts)
