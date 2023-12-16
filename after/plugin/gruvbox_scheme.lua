local gruvbox = require("gruvbox")
gruvbox.setup({
	contrast = "hard", -- can be "hard", "soft" or empty string
	transparent_mode = false,
})

vim.cmd("colorscheme gruvbox")

ToggleTransparent = function()
	local background = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
	if background == nil then
		vim.api.nvim_set_hl(0, "Normal", { bg = "#1d2021" })
	else
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	end
end

-- mapping to transparent mode
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "g<Space>", "<cmd>lua ToggleTransparent()<CR>", opts)

local dark_gray = "#282a36"
local dark_purple = "#6272a4"
local green = "#50fa7b"
local red = "#ff5555"
local bright_orange = "#fe8019"
--command line highlights
vim.api.nvim_set_hl(0, "MsgArea", { bg = dark_gray, fg = green })
vim.api.nvim_set_hl(0, "ErrorMsg", { bg = dark_gray, fg = red })
vim.api.nvim_set_hl(0, "WinSeparator", { bg = "none", fg = bright_orange })
vim.api.nvim_set_hl(0, "StatusLine", { bg = dark_gray, fg = dark_purple })
