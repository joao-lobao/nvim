vim.api.nvim_set_keymap("n", "<leader>tt", ":TestNearest<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>tf", ":TestFile<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ts", ":TestSuite<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>t$", ":TestLast<CR>", { noremap = true, silent = true })

vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vertical"
