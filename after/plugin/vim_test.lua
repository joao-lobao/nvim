local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>tt", ":TestNearest<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>tf", ":TestFile<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>ts", ":TestSuite<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>t$", ":TestLast<CR>", opts)

vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vertical"
