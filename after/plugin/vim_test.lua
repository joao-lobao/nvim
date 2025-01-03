local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<leader>tt", ":TestNearest<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>tf", ":TestFile<CR>", opts)

vim.g["test#strategy"] = "neovim"
vim.g["test#neovim#term_position"] = "vertical"
