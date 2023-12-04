local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "gs", ":G<CR>", opts)

vim.api.nvim_set_keymap("n", "gl", ":Gclog<CR><C-w>j", opts)
vim.api.nvim_set_keymap("n", "g%", ":Gclog -- %<CR><C-w>j", opts)

vim.api.nvim_set_keymap("n", "<leader>gd", ":Git diff<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gh", ":diffget //2<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gl", ":diffget //3<CR>", opts)

vim.api.nvim_set_keymap("n", "gb", ":Git blame<CR>", opts)

-- get last commit message
vim.api.nvim_create_user_command("GitLastCommit", "Git show -1", {})

