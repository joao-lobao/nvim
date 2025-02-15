-- general highlights
vim.api.nvim_set_hl(0, "MsgArea", { bg = Dark_gray, fg = Green })
--Info
vim.api.nvim_set_hl(0, "NotificationInfo", { bold = true, bg = Green, fg = Medium_gray })
vim.api.nvim_set_hl(0, "NotificationInfoInv", { bold = true, bg = Medium_gray, fg = Green })
--Warn
vim.api.nvim_set_hl(0, "NotificationWarn", { bold = true, bg = Bright_orange, fg = Medium_gray })
vim.api.nvim_set_hl(0, "NotificationWarnInv", { bold = true, bg = Medium_gray, fg = Bright_orange })
--Error
vim.api.nvim_set_hl(0, "NotificationError", { bold = true, bg = Red, fg = Medium_gray })
vim.api.nvim_set_hl(0, "NotificationErrorInv", { bold = true, bg = Medium_gray, fg = Red })

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
local filename = "%#StatusC# %f "
local modified = "%#StatusModified#%{&filetype!='TelescopePrompt' && &modified ? ' 󰆓 ' : ''}"
local readonly = "%#StatusModified#%r%*%="
local session_listed_buffers = "%#MsgArea# %{len(getcompletion('', 'buffer'))} "
local session = "%#StatusD#%{fnamemodify(v:this_session, ':t')} "
local lines = "%#StatusE#l:%l "
local cols = "%#StatusA#c:%c "
local total_lines = "%#StatusF#L:%L"
-- tabline components
local bufnr = "%#StatusA#:%{bufnr('%')} "
local bufname = "%#TablineFill#%t%*%="
local get_buf_size = "%#StatusD#%{printf('%.2f', str2float(getfsize(expand('%')))/1024)}kb "
local encoding = "%#StatusE#%{&fileencoding} "
local last_modified = "%#StatusA#%{strftime('%d %b %Y %H:%M:%S', getftime(expand('%')))} "
local format = "%#StatusF#%{&fileformat}"
vim.o.showtabline = 2
vim.o.tabline = bufnr .. bufname .. get_buf_size .. encoding .. last_modified .. format
vim.o.statusline = ft
	.. pwd
	.. filename
	.. modified
	.. readonly
	.. session_listed_buffers
	.. session
	.. lines
	.. cols
	.. total_lines
