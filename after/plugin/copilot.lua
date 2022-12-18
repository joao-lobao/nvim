vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<c-a>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
vim.api.nvim_set_keymap("i", "<c-j>", "<Plug>(copilot-next)", { noremap = false })
vim.api.nvim_set_keymap("i", "<c-k>", "<Plug>(copilot-previous)", { noremap = false })
vim.api.nvim_set_keymap("i", "<c-e>", "<Plug>(copilot-dismiss)", { noremap = false })
vim.api.nvim_set_keymap("i", "<c-s>", "<Plug>(copilot-suggest)", { noremap = false })
