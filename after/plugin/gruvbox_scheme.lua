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
