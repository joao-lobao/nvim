local dark_gray = "#282a36"
local light_purple = "#bd93f9"
local dark_purple = "#6272a4"
local cyan = "#8be9fd"
local green = "#50fa7b"
local orange = "#ffb86c"
local pink = "#ff79c6"
local red = "#ff5555"
local bright_orange = "#fe8019"

--command line highlights
vim.api.nvim_set_hl(0, "MsgArea", { bg = dark_gray, fg = green })
vim.api.nvim_set_hl(0, "ErrorMsg", { bg = dark_gray, fg = red })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = bright_orange })

-- statusline highlights
vim.api.nvim_set_hl(0, "StatusType", { bg = dark_gray, fg = dark_purple })
vim.api.nvim_set_hl(0, "StatusFile", { bg = dark_gray, fg = light_purple })
vim.api.nvim_set_hl(0, "StatusModified", { bg = green, fg = dark_gray })
vim.api.nvim_set_hl(0, "StatusNorm", { bg = dark_gray, fg = green })
vim.api.nvim_set_hl(0, "StatusEncoding", { bg = dark_gray, fg = pink })
vim.api.nvim_set_hl(0, "StatusBuffer", { bg = dark_gray, fg = orange })
vim.api.nvim_set_hl(0, "StatusLocation", { bg = dark_gray, fg = dark_purple })
vim.api.nvim_set_hl(0, "StatusPercent", { bg = dark_gray, fg = cyan })

-- statusline
vim.o.statusline = "%#StatusModified#"
	.. "%m"
	.. "%#StatusType#"
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
