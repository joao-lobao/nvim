local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gs", ":G<CR>", opts)

vim.api.nvim_set_keymap("n", "gl", ":Gclog<CR><C-w>j", opts)
vim.api.nvim_set_keymap("n", "g%", ":Gclog -- %<CR><C-w>j", opts)

vim.api.nvim_set_keymap("n", "<leader>gd", ":Git diff<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gl", ":diffget //3<CR>", opts)

vim.api.nvim_set_keymap("n", "gb", ":Git blame<CR>", opts)

-- use fugitive autocmds to a better goto Git status
vim.cmd([[:autocmd User FugitiveIndex silent! /un]])
vim.cmd([[:autocmd User FugitiveChanged silent! /un]])
