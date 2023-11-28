local gruvbox = require("gruvbox")
gruvbox.setup({
	contrast = "hard", -- can be "hard", "soft" or empty string
	transparent_mode = false,
})

vim.cmd("colorscheme gruvbox")

ToggleTransparent = function()
  gruvbox.config.transparent_mode = not gruvbox.config.transparent_mode
  vim.cmd("colorscheme gruvbox")
end

-- mapping to transparent mode
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "g<Space>", "<cmd>lua ToggleTransparent()<CR>", opts)
