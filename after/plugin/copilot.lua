vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-a>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<M-j>", "<Plug>(copilot-next)", { noremap = false })
vim.api.nvim_set_keymap("i", "<M-k>", "<Plug>(copilot-previous)", { noremap = false })
vim.api.nvim_set_keymap("i", "<C-e>", "<Plug>(copilot-dismiss)", { noremap = false })
vim.api.nvim_set_keymap("i", "<C-s>", "<Plug>(copilot-suggest)", { noremap = false })
