vim.api.nvim_set_keymap('n', 'gs', ':G<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', 'gl', ':Gclog<CR><C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gc', ':Git commit<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>gd', ':Git diff<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gh', ':diffget //2<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gl', ':diffget //3<CR>', { noremap = true })

vim.api.nvim_set_keymap('n', 'gb', ':Git blame<CR>', { noremap = true })

