--statusline highlights
vim.api.nvim_set_hl(0, "StatusType", { bg = "#458588", fg = "#1d2021" })
vim.api.nvim_set_hl(0, "StatusFile", { bg = "#98971a", fg = "#1d2021" })
vim.api.nvim_set_hl(0, "StatusModified", { bg = "teal", fg = "white" })
vim.api.nvim_set_hl(0, "StatusBuffer", { bg = "#98971a", fg = "#1d2021" })
vim.api.nvim_set_hl(0, "StatusLocation", { bg = "#458588", fg = "#1d2021" })
vim.api.nvim_set_hl(0, "StatusPercent", { bg = "#1d2021", fg = "#ebdbb2" })
vim.api.nvim_set_hl(0, "StatusNorm", { bg = "none", fg = "white" })

-- statusline
vim.o.statusline = "%#StatusType#"
	.. " 󰉺 "
	.. "%y"
	.. " "
	.. "%#StatusFile#"
	.. "  "
	.. "%F"
	.. " "
	.. "%#StatusModified#"
	.. "%m"
	.. "%#StatusNorm#"
	.. " "
	.. "%{fugitive#statusline()}"
	.. "%#StatusNorm#"
	.. "%="
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
