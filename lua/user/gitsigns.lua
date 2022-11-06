-- import gitsigns plugin safely
local setup, gitsigns = pcall(require, "gitsigns")
if not setup then
	return
end

-- configure/enable gitsigns
gitsigns.setup()
vim.api.nvim_set_keymap('n', '<leader>gs', ':Gitsigns stage_hunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gu', ':Gitsigns reset_hunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gp', ':Gitsigns prev_hunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gn', ':Gitsigns next_hunk<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gk', ':Gitsigns preview_hunk_inline<CR>', { noremap = true })
