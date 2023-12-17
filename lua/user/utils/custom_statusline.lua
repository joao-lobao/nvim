--command line highlights
vim.api.nvim_set_hl(0, "MsgArea", { bg = Dark_gray, fg = Green })
vim.api.nvim_set_hl(0, "ErrorMsg", { bg = Dark_gray, fg = Red })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = Bright_orange })

-- statusline highlights
vim.api.nvim_set_hl(0, "StatusType", { bg = Dark_gray, fg = Dark_purple })
vim.api.nvim_set_hl(0, "StatusFile", { bg = Dark_gray, fg = Light_purple })
vim.api.nvim_set_hl(0, "StatusModified", { bg = Green, fg = Dark_gray })
vim.api.nvim_set_hl(0, "StatusNorm", { bg = Dark_gray, fg = Green })
vim.api.nvim_set_hl(0, "StatusEncoding", { bg = Dark_gray, fg = Pink })
vim.api.nvim_set_hl(0, "StatusBuffer", { bg = Dark_gray, fg = Orange })
vim.api.nvim_set_hl(0, "StatusLocation", { bg = Dark_gray, fg = Dark_purple })
vim.api.nvim_set_hl(0, "StatusPercent", { bg = Dark_gray, fg = Cyan })

-- statusline
vim.o.laststatus = 3 -- show only one status line even if there are multiple splits
vim.o.statusline = "%#StatusModified#"
	.. "%m"
	.. "%#StatusType#"
	.. " 󰉺 "
	.. "%y"
	.. "%#StatusFile#"
	.. " "
	.. ""
	.. " "
	.. "%f"
	.. " "
	.. "%#StatusModified#"
	.. "%m"
	.. "%#StatusNorm#"
	.. "%="
	.. "%{fugitive#statusline()}"
	.. "%#StatusEncoding#"
	.. " "
	.. "%{&fileencoding?&fileencoding:&encoding}"
	.. " "
	.. "%#StatusBuffer#"
	.. " "
	.. " %n "
	.. "%#StatusLocation#"
	.. " "
	.. "%ll,%cc"
	.. " "
	.. "%#StatusPercent#"
	.. " "
	.. "%Ll | %p%%  |"
	.. " "
	.. "%{fnamemodify(v:this_session, ':t')}"
	.. " "
