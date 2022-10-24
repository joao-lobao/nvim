-- import gitsigns plugin safely
local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
	return
end

-- configure/enable gitsigns
gitsigns.setup()
vim.api.nvim_set_keymap('n', '<leader>gu', ':Gitsigns reset_hunk<CR>', { noremap = true })
