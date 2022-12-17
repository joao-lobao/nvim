vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-j>", '<Plug>(copilot-next)', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<C-k>", '<Plug>(copilot-previous)', { silent = true, expr = true })
